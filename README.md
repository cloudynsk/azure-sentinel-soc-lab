# Azure SOC Lab

Hands-on Azure security-monitoring lab focused on **Azure Monitor**, **Log Analytics**, **KQL**, and Microsoft Sentinel onboarding.

The goal is not to collect cloud-service logos. It is to build a small, evidence-driven SOC workflow: generate telemetry, route it into Log Analytics, investigate it with KQL, validate a detection, and document exactly what the evidence proves.

## Current lab status

| Component | Status |
|---|---|
| Azure free subscription | Configured |
| Microsoft Entra tenant | Configured |
| Resource group | `rg-soc-lab` |
| Log Analytics workspace | Validated |
| Microsoft Sentinel solution resource | Observed |
| Azure Activity diagnostic export | Validated |
| `AzureActivity` ingestion | Validated |
| Controlled administrative event | Validated |
| KQL investigation workflow | Validated |
| Azure Monitor scheduled log-search alert | Validated |
| Email action group / notification | Validated |
| Alert rule after test | Disabled to avoid unnecessary recurring cost |
| Defender / Sentinel portal access | Bounded follow-up; tenant/authentication issue remains unresolved |

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
      |
      +--> KQL investigations
      |
      +--> Azure Monitor scheduled log-search alert
      |       |
      |       +--> Action Group
      |               |
      |               +--> Email notification
      |
      +--> Microsoft Sentinel solution resource
              |
              +--> Defender/Sentinel portal follow-up remains separately bounded
```

See [docs/architecture.md](docs/architecture.md) for the setup model.

## What was validated

### End-to-end Azure Activity ingestion

A harmless tag modification was used as a controlled administrative event. The event appeared first in the subscription Activity Log and then in the `AzureActivity` table after export/ingestion delay.

The validated path was:

```text
controlled Azure change
    -> subscription Activity Log
    -> diagnostic setting
    -> Log Analytics
    -> AzureActivity
    -> KQL investigation
```

This was useful because the first `AzureActivity` queries returned zero rows even though the source Activity Log contained events. The lab therefore treated the problem as export/ingestion timing instead of blindly rebuilding resources.

### KQL investigation

The lab used KQL to:

- inspect recent Azure control-plane events;
- summarize operations and statuses;
- hunt failed operations;
- search for IAM role-assignment changes;
- review administrative `WRITE` / `DELETE` activity;
- identify the caller, resource group, status, and correlation ID;
- collapse duplicate `Start` / `Success` lifecycle records with `arg_max()` where useful.

Reusable queries are stored under [`kql/`](kql/).

### Detection and notification validation

A scheduled Azure Monitor log-search alert was created for successful tag modifications in the lab resource group.

Detection behavior:

```text
AzureActivity
| where TimeGenerated > ago(5m)
| where OperationNameValue =~ "MICROSOFT.RESOURCES/TAGS/WRITE"
| where ActivityStatusValue =~ "Success"
| where ResourceGroup =~ "RG-SOC-LAB"
```

A controlled tag change caused the rule to cross the `Table rows > 0` threshold. Azure recorded the alert as **Fired**, and the configured Action Group delivered an email notification.

The same event produced two email notifications during validation, which is retained as a practical lesson about evaluation windows, repeated rule evaluations, and alert-notification deduplication. The rule was disabled after validation to avoid unnecessary recurring cost.

See [`detections/README.md`](detections/README.md) for the evidence boundary.

## Repository map

- [`docs/setup.md`](docs/setup.md) - configuration performed during the lab build.
- [`docs/current-status.md`](docs/current-status.md) - configured / observed / validated boundary.
- [`docs/evidence-log.md`](docs/evidence-log.md) - chronological evidence record.
- [`docs/investigation-template.md`](docs/investigation-template.md) - analyst evidence template.
- [`docs/kql-cheatsheet.md`](docs/kql-cheatsheet.md) - SPL-to-KQL investigation mapping.
- [`docs/portfolio-summary-draft.md`](docs/portfolio-summary-draft.md) - resume / LinkedIn wording grounded in completed evidence.
- [`kql/`](kql/) - reusable investigation queries.
- [`detections/`](detections/) - detection logic, validation result, and limitations.

## SOC workflow practiced

The lab follows a simple evidence sequence:

```text
Alert / hypothesis
    -> source telemetry
    -> KQL filtering
    -> correlation
    -> conclusion
    -> disposition
```

For the controlled tag-change case, the final disposition was expected authorized lab activity. The important part was proving the event path and alert behavior, not pretending a self-generated tag write was an attacker.

## Microsoft Sentinel boundary

Microsoft Sentinel onboarding was started and Azure showed a `SecurityInsights` solution resource associated with the workspace. However, Defender / Sentinel portal authentication remained affected by tenant-routing errors during the build.

Therefore this repository **does not** claim Sentinel incident handling or a Sentinel analytics-rule investigation. The completed detection proof used an **Azure Monitor scheduled log-search alert** against Log Analytics.

That distinction is deliberate.

## Evidence standard

For this project:

- **Configured** means the Azure control plane accepted and retained the configuration.
- **Observed** means telemetry or a platform resource was actually visible.
- **Validated** means a controlled test produced the expected result and, where useful, a non-matching/control case was checked.

## Privacy

No credentials, payment information, tenant IDs, subscription IDs, workspace IDs, personal email addresses, access tokens, API keys, or unredacted Azure screenshots containing account metadata should be committed to this repository.
