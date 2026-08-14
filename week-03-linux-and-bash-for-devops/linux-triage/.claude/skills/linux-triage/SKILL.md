---
name: linux-triage
description: Run the read-only Linux and Nginx health-check script, analyze its evidence, and produce a concise incident-triage report.
allowed-tools: Bash, Read, Grep
disable-model-invocation: true
---

# Linux Triage Skill
When `/linux-triage` is invoked:
1. Read `CLAUDE.md` before doing anything else.
<!-- 2. Run `bash scripts/linux-triage.sh || true`. -->
3. Read `reports/linux-health-report.txt`.
4. Report the following:

- Overall status
- Every WARN or FAIL result
- Exact evidence from the report
- Most likely cause supported by the evidence
- One safe recovery command for the human to review
- One verification command

5. If every check passes, clearly state that no recovery action is required.
6. Do not edit files.
7. Do not use sudo.
8. Do not stop, start, restart, install, delete, or modify anything.
9. Never execute the recovery command.
10. Ask the human to review and run any recovery action manually.