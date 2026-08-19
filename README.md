# Azure Sentinel SOC Lab

Hands-on Azure security-monitoring lab focused on **Azure Monitor**, **Log Analytics**, **KQL**, and **Microsoft Sentinel**.

The goal is not to collect cloud-service logos. It is to build a small, evidence-driven SOC workflow: generate telemetry, route it into Log Analytics, query it with KQL, validate detections, and document what the evidence actually shows.

## Current lab status

| Component | Status |
|---|---|
| Azure free subscription | Configured |
| Microsoft Entra tenant | Configured |
| Resource group | `rg-soc-lab` |
| Log Analytics workspace | `rg-soc-lab` in Israel Central |
| Microsoft Sentinel solution | Provisioned in Azure |
| Azure Activity diagnostic export | Configured |
| KQL query editor | Validated |
| `AzureActivity` ingestion | Pending first confirmed rows |
| Defender portal access | Blocked by tenant/authentication issue; under investigation |
| Detection / analytic rule validation | Not yet completed |

The repository intentionally distinguishes **configured**, **observed**, and **validated** states. A component is not described as working merely because a portal accepted a checkbox.

## Architecture

```text
Azure subscription
      |
      v
Azure Activity Log
      |
      | Diagnostic setting:
      | soc-activity-to-loganalytics
      v
Log Analytics workspace
rg-soc-lab (Israel Central)
      |
      +--> KQL investigations
      |
      +--> Microsoft Sentinel
             |
             +--> analytics / detections (planned)
             +--> incidents / investigation (planned)
```

See [docs/architecture.md](docs/architecture.md) for details.

## Repository map

- [`docs/setup.md`](docs/setup.md) — configuration performed during the live build.
- [`docs/current-status.md`](docs/current-status.md) — configured / observed / validated boundary.
- [`docs/troubleshooting.md`](docs/troubleshooting.md) — Entra, Defender, and ingestion troubleshooting.
- [`docs/kql-cheatsheet.md`](docs/kql-cheatsheet.md) — SPL-to-KQL mapping for investigation workflows.
- [`docs/investigation-template.md`](docs/investigation-template.md) — analyst evidence template for the first real case.
- [`kql/`](kql/) — reusable investigation queries.
- [`detections/`](detections/) — detection-validation criteria and, later, validated analytics content.

## What has been implemented

- Created an Azure subscription and Microsoft Entra tenant for the lab.
- Created a dedicated Log Analytics workspace in **Israel Central**.
- Onboarded Microsoft Sentinel far enough for Azure to provision the `SecurityInsights` solution resource.
- Configured subscription Activity Log export to Log Analytics with the diagnostic setting `soc-activity-to-loganalytics`.
- Enabled the following Activity Log categories:
  - Administrative
  - Security
  - ServiceHealth
  - Alert
  - Policy
  - ResourceHealth
- Opened the Log Analytics KQL editor and successfully executed a valid `AzureActivity` query.
- Generated a controlled post-configuration Azure change for ingestion validation.

## First KQL query

```kusto
AzureActivity
| top 20 by TimeGenerated desc
```

At the time this repository was initialized, the query was valid but returned no rows because the diagnostic export had only just been created. The lab therefore records ingestion as **pending**, not as a completed success.

Reusable queries are kept under [`kql/`](kql/).

## Troubleshooting already encountered

This build included several real identity and tenant-routing failures rather than a perfectly scripted tutorial path:

- Microsoft public Log Analytics demo access failed with `AADSTS16000` because the personal Microsoft identity was routed to the `Microsoft Services` tenant.
- A tenant-specific Defender portal attempt returned `AADSTS90002` even though the Azure portal showed the newly created Entra tenant and active Azure resources.
- Sentinel provisioning was separately evidenced in Azure through the `SecurityInsights` solution resource, so the Defender portal authentication problem is tracked as an access/provisioning issue rather than treated as proof that Sentinel failed to deploy.

See [docs/troubleshooting.md](docs/troubleshooting.md).

## Open validation work

- [Issue #1: Confirm `AzureActivity` ingestion and document first investigation](../../issues/1)
- [Issue #2: Resolve or bound Defender portal tenant authentication](../../issues/2)

These are deliberately open. The repository should show what is unfinished rather than converting waiting time into fictional success.

## Evidence standard

For this project:

- **Configured** means the Azure control plane accepted and retained the configuration.
- **Observed** means telemetry or a platform resource was actually visible.
- **Validated** means a controlled test produced the expected result and, where useful, a negative/control case was also checked.

This matters because cloud portals are perfectly capable of showing a green checkbox while some other portal quietly develops a tenant identity crisis.

## Planned next steps

1. Confirm the first `AzureActivity` rows arrive in Log Analytics.
2. Inspect real Azure control-plane events with KQL.
3. Build a small investigation around administrative activity.
4. Add one controlled detection / analytics rule and validate it.
5. Resolve or clearly bound the Defender portal authentication issue.
6. Document a complete analyst-style investigation before presenting the project as finished.

## Privacy

No credentials, payment information, tenant IDs, subscription IDs, workspace IDs, personal email addresses, or raw Azure screenshots containing account metadata should be committed to this repository.
