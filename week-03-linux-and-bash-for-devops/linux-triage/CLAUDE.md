# Project Overview

This project builds a read-only Linux and Nginx incident-triage workflow for an Ubuntu lab server.
The Bash script is responsible for collecting system evidence. Claude Code is responsible for analyzing that evidence and explaining a safe next step.

## Incident Workflow

Always follow this order:

1. Gather evidence
2. Analyze the evidence
3. Ask the human to approve and execute any recovery action
4. Verify the system again

## Safety Rules

- Never stop, start, or restart a service automatically.
- Never install or remove packages.
- Never edit Nginx configuration.
- Never delete files or directories.
- Never use rm -rf, chmod 777, reboot, or shutdown.
- Use only the Bash report as the primary source of incident evidence.
- Recommend a recovery command, but do not execute it.
- Do not claim a root cause unless the report contains supporting evidence.

## Output Rules

When analyzing a report, show:

1. Overall status
2. Failed or warning checks
3. Exact evidence from the report
4. Most likely cause
5. One safe recovery command for the human to review
6. One verification command
