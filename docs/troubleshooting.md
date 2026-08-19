# Troubleshooting

This lab encountered real Microsoft identity and portal-routing problems before any useful KQL work began. They are documented because understanding tenant context is part of operating cloud security tooling.

## Public Log Analytics demo: AADSTS16000

### Symptom

The Microsoft-provided Log Analytics demo environment opened, but authentication failed with an error indicating that the signed-in personal Microsoft account did not exist in the target `Microsoft Services` tenant and needed to be added as an external user.

The same problem persisted with browser privacy controls disabled and in a private/incognito session.

### Interpretation

The failure was treated as a tenant/identity routing problem rather than a browser issue.

### Response

Instead of repeatedly retrying the public demo, the lab moved to a dedicated Azure free subscription and Microsoft Entra tenant.

## Defender portal: AADSTS16000

### Symptom

Opening `security.microsoft.com` with the same personal Microsoft identity again routed authentication toward the `Microsoft Services` tenant and failed.

### Evidence that this did not prove Sentinel deployment failed

The Azure portal independently showed the lab Log Analytics workspace and later a `SecurityInsights` solution resource associated with it.

Therefore the Defender portal failure was separated from the question of whether Sentinel resources existed in Azure.

## Tenant-specific Defender attempt: AADSTS90002

### Symptom

A Defender portal URL scoped to the lab tenant ID returned `AADSTS90002` and reported that the tenant could not be found.

### Why this was unexpected

The Azure portal simultaneously showed:

- the Microsoft Entra tenant;
- an active Azure subscription;
- the Log Analytics workspace;
- the lab resource group;
- the Sentinel `SecurityInsights` solution resource.

### Current disposition

**Open authentication/provisioning issue.**

No additional tenant, workspace, or Sentinel instance was created in response. Repeated login attempts were stopped because they were not producing new evidence.

The lab continued through Azure Monitor and Log Analytics while Defender portal access remained unresolved.

## Empty `AzureActivity` query immediately after export setup

### Query

```kusto
AzureActivity
| top 20 by TimeGenerated desc
```

### Result

The query executed successfully but returned no rows from the last 24 hours immediately after the subscription diagnostic setting was created.

### Response

No configuration was changed. A harmless resource-tag update was generated after the diagnostic setting existed, and the lab moved into a bounded waiting period for ingestion.

### Validation rule

Only after a post-configuration Activity Log event appears in `AzureActivity` will the export path be considered end-to-end validated.

## General lesson

Treat these as separate layers:

```text
Identity / tenant routing
        ≠
Azure resource provisioning
        ≠
Telemetry export
        ≠
Log ingestion
        ≠
Detection validation
```

A failure in one layer should not be used as evidence that all other layers failed.
