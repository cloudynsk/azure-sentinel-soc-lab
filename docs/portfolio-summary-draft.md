# Portfolio Summary

## Project title

```text
Azure SOC Lab - Azure Monitor, Log Analytics, KQL & Detection Validation
```

## Defensible project description

```text
Built a hands-on Azure security-monitoring lab using Azure Monitor, Log Analytics, KQL, Microsoft Entra ID, and Microsoft Sentinel onboarding. Routed subscription Activity Log telemetry into Log Analytics, investigated control-plane activity with KQL, validated a scheduled log-search detection with a controlled tag modification, and confirmed email notification through an Azure Monitor Action Group.
```

## Resume bullets

```text
- Built an Azure Monitor / Log Analytics SOC lab and validated end-to-end Activity Log ingestion using a controlled administrative tag change.
- Wrote KQL hunts for administrative writes/deletes, failed operations, IAM role changes, caller/status analysis, and correlation using CorrelationId.
- Created and positive-tested an Azure Monitor scheduled log-search alert for tag modifications; confirmed alert firing and email delivery, documented duplicate-notification behavior, and disabled the rule after validation for cost control.
```

## LinkedIn skills supported by the completed evidence

- Microsoft Azure
- Azure Monitor
- Log Analytics
- Kusto Query Language (KQL)
- Microsoft Sentinel - onboarding / solution-resource exposure only; do not imply completed Sentinel incident handling
- Cloud Security Monitoring
- Detection Validation

## Boundary

The completed detection proof used an Azure Monitor scheduled log-search alert, not a Microsoft Sentinel analytics rule.

Microsoft Sentinel onboarding is supported by the observed `SecurityInsights` solution resource, but Defender / Sentinel portal authentication remained separately bounded during the build. Public wording should preserve that distinction.
