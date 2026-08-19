# SPL to KQL Analyst Cheat Sheet

This project follows directly from a Splunk/Sysmon SOC lab, so this note maps familiar investigation motions to KQL.

## Start from a dataset

Splunk:

```spl
index=main
```

KQL:

```kusto
AzureActivity
```

KQL normally begins with a table rather than an `index=` search term.

## Filter events

Splunk:

```spl
| search EventCode=1
```

KQL:

```kusto
| where CategoryValue == "Administrative"
```

## Select fields

Splunk:

```spl
| table _time User Image CommandLine
```

KQL:

```kusto
| project TimeGenerated, Caller, OperationNameValue, ResourceId
```

## Sort newest first

Splunk:

```spl
| sort - _time
```

KQL:

```kusto
| sort by TimeGenerated desc
```

## Count by a field

Splunk:

```spl
| stats count by EventCode
```

KQL:

```kusto
| summarize Events=count() by OperationNameValue
```

## Time buckets

Splunk:

```spl
| timechart span=1h count
```

KQL:

```kusto
| summarize Events=count() by bin(TimeGenerated, 1h)
| sort by TimeGenerated asc
```

## Case-insensitive matching

KQL supports case-insensitive operators such as `=~` and `in~`.

Example:

```kusto
AzureActivity
| where ActivityStatusValue in~ ("Failed", "Failure")
```

## Investigation mindset

The syntax changes, but the analyst questions stay familiar:

1. What happened?
2. When did it happen?
3. Who initiated it?
4. Which resource was affected?
5. Did the operation succeed or fail?
6. What happened immediately before and after it?
7. Is the event expected in context?

The goal is not memorizing operators. It is learning how to express those questions against Azure telemetry.
