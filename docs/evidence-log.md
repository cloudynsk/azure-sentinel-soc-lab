# Build Evidence Log

This log records the initial build in a sanitized form. Exact account, tenant, subscription, and workspace identifiers are deliberately omitted.

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
- Defender portal authentication remained unavailable.
- Generic Defender sign-in produced `AADSTS16000`.
- Tenant-scoped Defender sign-in produced `AADSTS90002`.
- Decision: keep Sentinel provisioning evidence separate from Defender portal authentication state; do not create duplicate resources.

### Azure Activity telemetry

- Subscription diagnostic setting `soc-activity-to-loganalytics` created.
- Export categories enabled: Administrative, Security, ServiceHealth, Alert, Policy, ResourceHealth.
- Destination set to the existing Log Analytics workspace.
- No Storage Account, Event Hub, or partner destination configured.

### KQL

Initial query:

```kusto
AzureActivity
| top 20 by TimeGenerated desc
```

Observed result immediately after configuration:

```text
Query executed successfully.
No results found from the last 24 hours.
```

A controlled Azure change was then used to create fresh post-configuration Activity Log telemetry. End-to-end ingestion remained pending at the time of this log entry.

## Evidence policy

Do not retroactively rewrite a pending state as successful. When ingestion is confirmed, append a new entry with the actual observed rows/query result and update the status documents separately.
