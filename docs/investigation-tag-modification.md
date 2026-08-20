# Investigation: Controlled Azure Tag Modification

## Alert / hypothesis

Validate whether a harmless Azure resource-tag change can be observed end-to-end and turned into a useful SOC detection without confusing source events, ingestion state, and analyst disposition.

## Source evidence

The controlled tag modification appeared in the subscription Activity Log as a `Write tags` operation with lifecycle records for `Start` and `Success`.

The matching records shared a `CorrelationId`, allowing the lifecycle entries to be associated with the same operation.

## Ingestion evidence

The first `AzureActivity` queries returned zero rows immediately after the diagnostic setting was created.

Because the source Activity Log still showed real control-plane activity, the initial zero-row result was treated as an export/ingestion-timing problem rather than absence of source telemetry.

After a fresh post-configuration tag write and propagation delay, `AzureActivity` contained the expected event.

## Investigation query

```kusto
AzureActivity
| where TimeGenerated > ago(24h)
| where OperationNameValue has_any ("/WRITE", "/DELETE")
| summarize arg_max(TimeGenerated, *) by CorrelationId, OperationNameValue
| extend Action = case(
    OperationNameValue has "/DELETE", "Delete",
    OperationNameValue has "/WRITE", "Write",
    "Other"
)
| project
    TimeGenerated,
    Action,
    OperationNameValue,
    ActivityStatusValue,
    ResourceGroup,
    Caller,
    CorrelationId
| order by TimeGenerated desc
```

## Detection query

```kusto
AzureActivity
| where TimeGenerated > ago(5m)
| where OperationNameValue =~ "MICROSOFT.RESOURCES/TAGS/WRITE"
| where ActivityStatusValue =~ "Success"
| where ResourceGroup =~ "RG-SOC-LAB"
| project
    TimeGenerated,
    OperationNameValue,
    ActivityStatusValue,
    ResourceGroup,
    Caller,
    CorrelationId
```

## Controlled positive test

The tag value was changed after the scheduled log-search rule was enabled.

Observed result:

- new tag-write telemetry reached `AzureActivity`;
- the detection crossed the configured threshold of `Table rows > 0`;
- Azure Monitor recorded the rule as `Fired`;
- the associated Action Group sent email notification.

## Negative / non-matching control

An unrelated Log Analytics workspace write existed in the dataset. The narrow tag-write rule did not treat that separate administrative operation as a tag-modification match.

The failed-operation and IAM role-assignment hunts also returned no matching records because those behaviors were not present in the dataset.

## Operational observation

The same controlled event generated two alert emails during the validation window. This is retained as evidence that rule lookback windows, repeated evaluations, and notification configuration matter for alert-noise control.

## Conclusion

The telemetry and detection pipeline behaved as intended for the controlled action.

## Disposition

**True positive detection, benign / authorized activity.**

The rule correctly detected the behavior it was designed to detect. The benign disposition comes from the known controlled-test context, not from dismissing the alert based on severity alone.

## Follow-up

The alert rule was disabled after validation to avoid unnecessary recurring evaluation cost.
