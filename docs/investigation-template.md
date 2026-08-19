# Investigation Template

## Investigation title

Short description of the activity being investigated.

## Question

What analyst question are we trying to answer?

## Trigger / starting point

- Detection, query, or observed event:
- Time window:
- Relevant resource:

## Initial KQL

```kusto
// paste the starting query here
```

## Evidence

Record only evidence actually observed in Azure / Log Analytics.

| Field | Value / observation |
|---|---|
| TimeGenerated | |
| Operation | |
| Status | |
| Caller | |
| Resource group | |
| Resource | |
| Correlation ID | |

## Pivots

Document any follow-up KQL and why each pivot was performed.

## Context

What activity was expected in the lab at this time? Was the event generated deliberately as a controlled test?

## Assessment

Choose one and explain why:

- Expected / benign
- Suspicious, needs more evidence
- True positive controlled detection
- True positive unauthorized activity
- Inconclusive

## Detection implications

- Did the rule/query match what it was supposed to match?
- What false positives are plausible?
- What additional context would improve the detection?

## Final disposition

Concise analyst conclusion supported by the evidence above.
