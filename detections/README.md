# Detection Validation

The first Azure detection is now validated.

## Detection: successful lab tag modification

The rule watches for successful tag writes in the dedicated lab resource group.

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

### Alert configuration

- Signal: Custom log search
- Query type: Aggregated logs
- Measure: Table rows
- Aggregation: Count
- Aggregation granularity: 5 minutes
- Threshold: Greater than 0
- Evaluation frequency: 5 minutes
- Severity: 3 - Informational
- Notification: Azure Monitor Action Group -> email

## Controlled positive test

A harmless tag value on the lab workspace/resource group was changed after the rule was enabled.

Observed result:

1. the tag-write event appeared in the subscription Activity Log;
2. the event appeared in `AzureActivity`;
3. the KQL rule matched the successful tag write;
4. the scheduled alert entered the **Fired** state;
5. the email Action Group delivered notification.

This is a true positive for the detection rule and benign authorized activity by analyst disposition.

## Negative / non-matching control

The dataset also contained a successful Log Analytics workspace write operation. Because the rule specifically matches `MICROSOFT.RESOURCES/TAGS/WRITE`, that unrelated administrative write did not qualify as the tag-modification detection.

Queries for failed operations and IAM role-assignment modifications also returned no matching events because those behaviors were not present in the dataset.

## Operational finding: duplicate notification

The same controlled tag-write event produced two email notifications during the validation window.

The underlying detection event was not duplicated as two separate tag changes. The observation is retained as a practical reminder that scheduled query windows and repeated evaluations can generate repeated notifications while one matching event remains inside the lookback window.

For a production rule, suppression/stateful behavior, query windows, and notification policy should be tuned to avoid unnecessary alert noise.

## Cost control

After the positive test completed, the scheduled alert rule was disabled. The lab does not leave a paid recurring evaluation enabled merely to preserve a green portal object.

## Evidence boundary

This validation used an **Azure Monitor scheduled log-search alert** against Log Analytics.

It does not claim a completed Microsoft Sentinel analytics-rule or Sentinel incident workflow. Sentinel solution provisioning is documented separately from Defender / Sentinel portal access.
