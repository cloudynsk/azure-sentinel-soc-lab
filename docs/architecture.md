# Architecture

## Logical flow

```text
Azure subscription
      |
      v
Azure Activity Log
      |
      | diagnostic setting
      | soc-activity-to-loganalytics
      v
Log Analytics workspace
rg-soc-lab
Israel Central
      |
      +--> KQL investigations
      |
      +--> Microsoft Sentinel
             |
             +--> analytics rules (planned)
             +--> incidents (planned)
             +--> investigation workflow (planned)
```

## Resource layout

```text
Subscription
└── Resource group: rg-soc-lab
    ├── Log Analytics workspace: rg-soc-lab
    └── Microsoft Sentinel / SecurityInsights solution
```

The resource group and workspace currently share the same name. This is slightly confusing operationally but harmless, so the lab keeps the existing resource instead of deleting and recreating it solely for cosmetic naming.

## Telemetry source

The first data source is the Azure subscription **Activity Log**. This is control-plane telemetry describing operations against Azure resources and the subscription.

Configured export categories:

- Administrative
- Security
- ServiceHealth
- Alert
- Policy
- ResourceHealth

Recommendation and Autoscale were intentionally left out of the initial lab scope.

## Destination

The Activity Log diagnostic setting sends selected categories to the Log Analytics workspace in Israel Central.

The diagnostic setting is named:

```text
soc-activity-to-loganalytics
```

## Analyst workflow target

```text
Azure control-plane action
        ↓
Activity Log event
        ↓
Diagnostic export
        ↓
AzureActivity table
        ↓
KQL filter / summarize / pivot
        ↓
Analyst interpretation
        ↓
Detection validation
```

The project will not treat this full path as validated until real `AzureActivity` rows are observed after the diagnostic setting was enabled.
