# AGENTS.md

## Project purpose

This repository documents a small hands-on SOC lab using Azure Monitor, Log Analytics, KQL, and Microsoft Sentinel.

## Working rules

- Prefer evidence over assumptions. Distinguish configured, observed, and validated behavior.
- Do not claim telemetry, Sentinel detections, incidents, or investigations succeeded until a controlled result has been observed.
- Keep the lab small and portfolio-oriented. Avoid unnecessary Azure services, paid resources, or architecture expansion without a concrete security-learning benefit.
- Preserve cost safety. Do not intentionally upgrade the Azure free subscription to pay-as-you-go as part of routine lab work.
- Never commit credentials, payment information, tenant IDs, subscription IDs, workspace IDs, personal email addresses, access tokens, API keys, certificates, or unredacted portal screenshots containing account metadata.
- Use sanitized placeholders in documentation when identifiers are needed.
- Treat authentication and tenant-routing failures as findings to document, not reasons to repeatedly retry the same action without new evidence.
- Prefer reversible configuration changes and controlled test events.
- Keep KQL queries readable and explain what analyst question each query answers.
- Do not represent planned detections or investigations as completed work.

## Portfolio standard

A future reader should be able to understand:

1. what telemetry was collected;
2. how it reached Log Analytics;
3. what KQL was used to investigate it;
4. what controlled validation was performed;
5. what failed and why;
6. what remains incomplete.
