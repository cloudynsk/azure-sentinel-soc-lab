# Build Evidence Log

This log records the lab build in sanitized form. Exact account, tenant, subscription, workspace identifiers, and personal email addresses are deliberately omitted.

## 2026-08-19 / 2026-08-20

### Public demo attempt

- Opened Microsoft Log Analytics demo environment.
- Authentication failed with `AADSTS16000` against the `Microsoft Services` tenant.
- Browser privacy controls were ruled out as the primary cause by retrying with shields disabled and a private/incognito session.
- Decision: stop retry loop and create a dedicated Azure lab environment.

### Azure lab environment

- Azure free subscription created.
- Microsoft Entra tenant created and visible in Azure.
- Resource group `rg-soc-lab` created.
- Log Analytics workspace `rg-soc-lab` created in Israel Central.
- Workspace reported Active with no operational issue shown in Azure.

### Sentinel

- Sentinel onboarding initiated against the existing Log Analytics workspace.
- Azure later displayed a `SecurityInsights` solution resource associated with the workspace.
- Defender / Sentinel portal authentication remained unavailable during the build.
- Generic Defender sign-in produced `AADSTS16000`.
- Tenant-scoped Defender sign-in produced `AADSTS90002`.
- Decision: keep Sentinel provisioning evidence separate from Defender portal authentication state; do not create duplicate resources.

### Azure Activity telemetry configuration

- Subscription diagnostic setting `soc-activity-to-loganalytics` created.
- Export categories enabled: Administrative, Security, ServiceHealth, Alert, Policy, ResourceHealth.
- Destination set to the existing Log Analytics workspace.
- No Storage Account, Event Hub, or partner destination configured.

### Initial ingestion result

Initial query:

```kusto
AzureActivity
| top 20 by TimeGenerated desc
```

Observed result immediately after configuration:

```text
Query executed successfully.
No results found from the selected time range.
```

The source Activity Log still contained real control-plane events, so the lab treated this as an export/ingestion-path question rather than proof that Azure had generated no events.

### Controlled ingestion validation

A harmless resource-tag modification was generated after the diagnostic setting was active.

The subscription Activity Log showed the expected `Write tags` operation with `Started` and `Succeeded` lifecycle records.

After ingestion delay, `AzureActivity` contained the same operation. The matching lifecycle events shared the same `CorrelationId`.

This established the end-to-end path:

```text
controlled Azure action
    -> subscription Activity Log
    -> diagnostic setting
    -> Log Analytics workspace
    -> AzureActivity
```

### KQL investigation

Validated queries included:

- recent Activity Log records;
- count and daily summaries;
- operation/status aggregation;
- failed-operation hunting;
- IAM role-assignment write/delete hunting;
- administrative `WRITE` / `DELETE` hunting;
- correlation using `CorrelationId`;
- `arg_max(TimeGenerated, *)` to collapse lifecycle duplicates to the latest state per operation.

The failed-operation and IAM hunts returned no matching records because the small lab dataset contained no failed control-plane actions or role-assignment changes. Those empty results were treated as correct query results, not ingestion failures.

### Detection validation

A scheduled Azure Monitor log-search alert was created for successful tag writes in the lab resource group.

Detection query:

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

Rule logic:

```text
Table rows > 0
Evaluation frequency: 5 minutes
Severity: Informational
```

A harmless tag-value change was then generated as the positive test.

Observed result:

- the new tag write appeared in `AzureActivity`;
- the alert rule fired;
- Azure recorded the threshold crossing at a count of 1;
- the Action Group sent an email notification;
- the same controlled event produced two email notifications during the validation period.

The duplicate email is retained as an operational finding: scheduled-rule evaluation windows and notification behavior can produce repeated notifications for one underlying event if the event remains inside the query window across evaluations.

The alert rule was disabled after validation to avoid unnecessary recurring cost.

### Final analyst disposition

The detected tag modification was **expected authorized lab activity**.

The detection was still a true positive for the rule because the configured behavior occurred. The benign disposition came from known test context, not from ignoring the alert.

## Evidence policy

- Preserve the difference between source events, ingested events, detections, and analyst conclusions.
- Do not treat an empty query as proof of telemetry failure without checking the source and pipeline.
- Do not describe Sentinel incident handling as completed; the validated detection used Azure Monitor scheduled log search.
- Do not commit account identifiers or unredacted portal screenshots.
