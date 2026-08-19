# Detection Validation

No detection is claimed as completed yet.

The first detection should be deliberately small and testable against telemetry already available in the lab.

## Candidate v1 detection

Detect a controlled administrative change to a lab resource and verify that:

1. the change appears in `AzureActivity`;
2. the KQL filter selects the intended event;
3. an unrelated administrative event does not match the rule if the rule is meant to be narrow;
4. the analyst can pivot from the detection back to the underlying activity record;
5. the final write-up distinguishes the controlled test from real malicious activity.

## Validation standard

A detection is only marked validated when the repository records:

- query / rule logic;
- controlled positive test;
- at least one negative or non-matching control where practical;
- observed result;
- limitations and likely false positives;
- analyst interpretation.

This mirrors the evidence-first approach used in the earlier Splunk lab: a string or rule match is the start of an investigation, not the conclusion.
