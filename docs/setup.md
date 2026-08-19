# Setup

This document records the configuration actually performed during the lab build. It is not yet a clean-room automation guide.

## 1. Azure account and directory

A new Azure free subscription and Microsoft Entra tenant were created for the lab.

Public documentation deliberately omits personal account identifiers, tenant IDs, subscription IDs, and billing metadata.

## 2. Log Analytics workspace

A Log Analytics workspace was created with:

```text
Resource group: rg-soc-lab
Workspace:      rg-soc-lab
Region:         Israel Central
```

The duplicate resource-group/workspace name is retained because it is functionally harmless and recreating the workspace solely for naming would add risk without improving the security exercise.

## 3. Microsoft Sentinel

Microsoft Sentinel onboarding was started against the existing Log Analytics workspace.

Azure later showed a `SecurityInsights` solution resource associated with the workspace, which is evidence that the Sentinel solution was provisioned in Azure.

Defender portal access is tracked separately because authentication to `security.microsoft.com` was not yet successful.

## 4. Activity Log export

A subscription-level diagnostic setting was created:

```text
soc-activity-to-loganalytics
```

Enabled categories:

- Administrative
- Security
- ServiceHealth
- Alert
- Policy
- ResourceHealth

Destination:

```text
Log Analytics workspace: rg-soc-lab
```

No Storage Account, Event Hub, or partner destination was configured.

## 5. Controlled ingestion event

After the diagnostic setting was saved, a harmless resource tag change was used as a controlled post-configuration Azure action:

```text
Tag name:  purpose
Tag value: soc-lab
```

The purpose of this change is to create a fresh administrative Activity Log event after export was enabled.

## 6. Initial KQL validation

The Log Analytics query editor was opened in KQL mode and the following query executed successfully:

```kusto
AzureActivity
| top 20 by TimeGenerated desc
```

The query returned no rows immediately after configuration. This is currently treated as expected ingestion delay, not as a successful end-to-end telemetry validation and not as a failure.

## Next validation checkpoint

Re-run the same query after allowing time for Activity Log export and confirm whether the controlled tag-change event is visible.
