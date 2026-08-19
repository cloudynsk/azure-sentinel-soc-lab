# Current Validation Status

Status captured during the initial lab build.

| Area | State | Evidence / note |
|---|---|---|
| Azure subscription | Configured | Azure portal accessible with active free subscription |
| Entra tenant | Configured | Default Directory visible in Azure |
| Log Analytics workspace | Observed | Workspace active in Israel Central |
| Sentinel solution | Observed | `SecurityInsights` solution resource visible in Azure |
| Defender portal | Blocked | Tenant/authentication errors remain unresolved |
| Activity Log diagnostic setting | Configured | `soc-activity-to-loganalytics` visible and points to the workspace |
| KQL editor | Validated | Query parsed and executed successfully |
| `AzureActivity` rows | Pending | Initial query returned no rows immediately after setup |
| Controlled test event | Generated | `purpose=soc-lab` tag change performed after export setup |
| Detection rule | Not started | Wait for ingestion validation first |
| Investigation write-up | Not started | Requires real telemetry |

## Completion criteria for portfolio-ready v1

The lab should not be called complete until all of the following are true:

1. A post-configuration Azure Activity event is visible in `AzureActivity`.
2. At least several KQL queries are run against real telemetry and their purpose is understood.
3. One analyst-style investigation is documented from event to conclusion.
4. One simple detection or Sentinel analytics rule is tested with a controlled positive case.
5. The Defender portal issue is either resolved or clearly bounded with an alternative supported workflow.

This repository can exist publicly before those criteria are met, but the README must continue to label incomplete items honestly.
