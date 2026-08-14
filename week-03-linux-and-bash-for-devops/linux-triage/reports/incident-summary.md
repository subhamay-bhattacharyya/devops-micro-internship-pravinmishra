# Nginx Incident Summary

**Full Name:** Subhamay Bhattacharyya
**Date:** 08/14/2026

## 1. Reported Symptom

Our health check script reported that Nginx was unavailable and the web application was not serving traffic. We observed that when we attempted to access the website via curl, the connection was refused. This indicated that the HTTP server that was running in our baseline was no longer operational.

## 2. Evidence Collected

Our Bash health checks revealed three critical failures:

- **Process Check Failed:** When we ran `ps aux | grep nginx`, the Nginx process did not appear in the output — no Nginx processes were running.
- **Port 80 Listening Check Failed:** When we ran `netstat -tuln | grep :80` (or `ss -tuln | grep :80`), port 80 was not in a LISTEN state — no service was bound to accept HTTP traffic on port 80.
- **HTTP Response Check Failed:** When we ran `curl http://localhost`, we received a "Connection refused" error instead of the HTML content from our website.
- **Service Status Check Failed:** When we ran `systemctl status nginx`, the service showed as "inactive (dead)" — the Nginx service was not running.

All four pieces of evidence pointed to the same conclusion: Nginx was completely unavailable.

## 3. Most Likely Cause

Based solely on the evidence we collected, the most likely cause was that the Nginx service had been intentionally stopped or disabled. We reached this conclusion because:

- The Nginx process was completely absent from the system (not just crashed or hung)
- Port 80 was not bound to any process, indicating the service had been cleanly stopped, not killed unexpectedly
- The service status explicitly showed "inactive," which is the state a service enters after being stopped via `systemctl stop`
- There were no error messages or crash indicators in the available logs

We did not detect evidence of a system crash, resource exhaustion, or configuration error. The evidence supported a deliberate service stop rather than an unexpected failure.

## 4. Human-Approved Recovery Action

After reviewing Claude's analysis and understanding the cause, we manually executed the recovery command:

```bash
sudo systemctl start nginx
```

We reviewed this command before execution to confirm it would restart the Nginx service without causing unintended side effects. We understood that restarting the service would make the website available again to users.

## 5. Verification

After we executed the recovery command, we re-ran our health checks and observed the following verification outputs:

- **Process Check Passed:** When we ran `ps aux | grep nginx`, we now saw Nginx master and worker processes running.
- **Port 80 Listening Check Passed:** When we ran `netstat -tuln | grep :80` or `ss -tuln | grep :80`, we saw port 80 in a LISTEN state bound to the Nginx process.
- **HTTP Response Check Passed:** When we ran `curl http://localhost`, the server responded with the HTML content of our website, proving it was serving traffic again.
- **Service Status Check Passed:** When we ran `systemctl status nginx`, the service showed as "active (running)" — the Nginx service was operational.

Our health check script now returned exit code 0 and reported overall status as HEALTHY, confirming that Nginx and the application had fully recovered.

## 6. Safety Decision

We allowed the AI health check skill to gather and analyze evidence but did not allow it to restart the service because human judgment and accountability are essential for production system changes. Here's why this decision was important:

**Why Gathering and Analysis Were Safe:**

- Gathering evidence (read-only bash commands like `ps`, `netstat`, `curl`) poses no risk — these commands only observe system state without modifying anything.
- Analysis of the evidence by Claude is also safe — it interprets facts and provides recommendations but takes no actions.
- The skill was configured with `disable-model-invocation: true` and had only Bash/Read/Grep permissions (no Write), preventing any system modifications.

**Why Service Restart Required Human Approval:**

- Restarting Nginx is a change that affects production traffic and user experience — it requires human judgment about timing and coordination with other teams.
- We (humans) understand the business context, know if there are dependent services or active deployments, and can ensure the restart happens at an appropriate time.
- Only we can be held accountable for the consequences of restarting a service — this maintains responsibility and prevents unauthorized changes.
- Humans must retain final control over critical infrastructure actions to prevent unintended cascading failures or service disruptions.

This separation of responsibilities — AI
