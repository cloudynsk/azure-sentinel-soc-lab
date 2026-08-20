# Current Validation Status

Status after the completed Azure Monitor / Log Analytics detection exercise.

| Area | State | Evidence / note |
|---|---|---|
| Azure subscription | Configured | Azure portal accessible with active free subscription |
| Entra tenant | Configured | Default Directory visible in Azure |
| Log Analytics workspace | Validated | Workspace active and receiving `AzureActivity` data |
| Sentinel solution | Observed | `SecurityInsights` solution resource visible in Azure |
| Defender / Sentinel portal | Bounded | Tenant/authentication errors remain unresolved; not used as evidence for the completed detection |
| Activity Log diagnostic setting | Validated | `soc-activity-to-loganalytics` targets the lab workspace |
| KQL editor | Validated | Queries executed against real telemetry |
| `AzureActivity` rows | Validated | Controlled administrative events observed after ingestion delay |
| Controlled test event | Validated | Successful resource-tag write observed with matching start/success correlation |
| Administrative hunt | Validated | Write/delete activity filtered and correlated with caller, status, resource group, and `CorrelationId` |
| IAM hunt | Validated query / no matching event | Role-assignment write/delete query executed; no IAM change existed in the dataset |
| Failed-operation hunt | Validated query / no matching event | Query executed correctly; no failed operations existed in the dataset |
| Detection rule | Validated | Azure Monitor scheduled log-search alert fired on controlled successful tag modification |
| Email notification | Validated | Action Group delivered alert email |
| Notification deduplication | Observed limitation | One controlled event generated two email notifications during the validation window |
| Alert rule after test | Disabled | Disabled after proof to avoid unnecessary recurring evaluation cost |
| Investigation write-up | Validated | Evidence chain and disposition documented in repository |

## Portfolio-ready boundary

The Azure Monitor / Log Analytics / KQL portion of the lab is complete enough for portfolio and interview use.

The following claims are supported:

1. Subscription Activity Log export to Log Analytics was configured and validated end-to-end.
2. `AzureActivity` telemetry was investigated with KQL.
3. Administrative operations were filtered, summarized, and correlated.
4. A controlled Azure Monitor log-search alert fired on a known benign action.
5. The Action Group delivered email notification.
6. The rule was disabled after validation for cost control.

## Deliberate non-claims

The lab does **not** claim completed Microsoft Sentinel incident handling or a Sentinel analytics-rule investigation. Azure showed a Sentinel `SecurityInsights` solution resource, but Defender / Sentinel portal access remained separately blocked by tenant/authentication behavior during the build.

That follow-up does not invalidate the completed Azure Monitor / Log Analytics monitoring and detection exercise.
