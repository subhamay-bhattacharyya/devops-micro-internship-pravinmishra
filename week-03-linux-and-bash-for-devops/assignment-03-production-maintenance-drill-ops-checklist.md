# Assignment 3 — Production Maintenance Drill (OPS Checklist)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will treat your already deployed React application (on Ubuntu VM with Nginx) as a live production system. You will perform structured operational checks covering network validation, service health, log analysis, resource monitoring, configuration verification, and incident simulation with recovery — mirroring real on-call DevOps responsibilities.

---

# Task 1 — Server Access & Networking Validation

## Goal

Verify that the deployed React application is reachable from the browser and confirm basic network connectivity of the Ubuntu VM.

### Evidence

#### Screenshot 1 — Browser showing the React app with your Full Name visible on the UI

![Screenshot 1](./screenshots/week-03-linux-and-bash-for-devops-03-01.png)

---

#### Screenshot 2 — Output of `ip a`

![Screenshot 2](./screenshots/week-03-linux-and-bash-for-devops-03-02.png)

---

#### Screenshot 3 — Output of `sudo ss -tulpen`

![Screenshot 3](./screenshots/week-03-linux-and-bash-for-devops-03-03.png)

---

#### Screenshot 4 — Output of `sudo ufw status`

![Screenshot 3](./screenshots/week-03-linux-and-bash-for-devops-03-04.png)

---

### Notes

Answer the following in your own words:

**1. What proves Nginx is listening on 0.0.0.0:80?**

The `ss -tulpen` output shows a TCP socket with:

- **State**: LISTEN
- **Local Address:Port**: 0.0.0.0:80
- **Process**: ("nginx",pid=29161,fd=5),("nginx",pid=29160,fd=5)

This proves Nginx is actively listening on port 80 across all network interfaces (0.0.0.0 = all IPv4 addresses). The process identifiers (pids 29161 and 29160) confirm the Nginx worker processes are bound to this port.

---

**2. What proves SSH is active on port 22?**

The `ss -tulpen` output shows a TCP socket with:

- **State**: LISTEN
- **Local Address:Port**: 0.0.0.0:22
- **Process**: ("sshd",pid=31810,fd=3),("systemd",pid=1,fd=107)

This proves SSH daemon (sshd) is actively listening on port 22 across all network interfaces. The process ID 31810 confirms the SSH service is running and bound to the standard SSH port.

---

**3. Did you find any unexpected open ports? Explain briefly.**

Yes, there are a few ports that may be unexpected depending on your intended server configuration:

- **TCP 4096** - Multiple instances associated with "system-resolve" service (systemd-resolved). This is a DNS resolution service and may be expected on a system with networking needs.
- **UDP 1323** - Chrony NTP service (Network Time Protocol) for time synchronization. This is typically expected on servers but could be unexpected if you don't need time sync services.

If this server is intended to run only Nginx and SSH, these system services could be considered unexpected. However, they are standard Linux system services and generally harmless. The core expected services (Nginx on 80, SSH on 22) are confirmed and functioning correctly.

---

# Task 2 — Service Health & Systemd Validation (Nginx)

## Goal

Verify that Nginx is properly installed, running, enabled at boot, and safely configured.

### Evidence

#### Screenshot 1 — Output of `systemctl status nginx --no-pager`

![Screenshot 5](./screenshots/week-03-linux-and-bash-for-devops-03-05.png)

---

#### Screenshot 2 — Output of `sudo nginx -t`

![Screenshot 6](./screenshots/week-03-linux-and-bash-for-devops-03-06.png)

---

#### Screenshot 3 — Output of `sudo ss -lptn '( sport = :80 )'`

![Screenshot 7](./screenshots/week-03-linux-and-bash-for-devops-03-07.png)

---

### Notes

Answer the following in your own words:

**1. What happens if Nginx fails to restart in production?**

If Nginx fails to restart in production, several things occur:

- **Immediate service disruption**: Existing connections are maintained, but the process stops. If the old Nginx process is killed before restart completes, traffic drops immediately until the service recovers.
- **Traffic loss**: New requests encounter connection timeouts or refused connections. Users see 503 Service Unavailable or connection errors.
- **Cascading failures**: Upstream services, load balancers, and monitoring systems alert on the outage. Dependent applications that rely on your API/web service fail.
- **Operational incident**: The incident is logged; escalations trigger; on-call engineers respond. Customer impact is immediate and measurable.
- **Root cause uncertainty**: The restart failure could indicate syntax errors in nginx.conf, permission issues, port conflicts, missing SSL certificates, or resource exhaustion—all need rapid diagnosis.

The key issue: **restart changes are not atomic**. If the reload/restart is interrupted or misconfigured, the entire service goes down until recovery.

---

**2. What's your basic rollback plan?**

A basic rollback plan for Nginx includes:

**Before deployment:**

- Backup the current `nginx.conf` and any site config files (e.g., `/etc/nginx/sites-enabled/`)
- Test new config syntax with `sudo nginx -t` in a staging environment first
- Have the old config file tagged/versioned in version control

**During deployment (graceful approach):**

- Use `sudo nginx -s reload` instead of restart (reloads config without killing connections)
- Monitor logs for errors: `sudo tail -f /var/log/nginx/error.log`
- Check service status: `sudo systemctl status nginx`

**If deployment fails:**

1. Stop the failed Nginx process: `sudo systemctl stop nginx`
2. Restore the previous `nginx.conf` from backup/version control
3. Verify syntax: `sudo nginx -t`
4. Restart with known-good config: `sudo systemctl start nginx`
5. Verify connectivity and logs

**For quick rollback (minutes matter):**

- Keep a known-good config version immediately accessible
- Run `sudo nginx -s reload` first for config changes (safer than restart)
- If that fails, restore + restart as fallback
- Alert monitoring systems of the incident

**Automation angle:** Store nginx.conf in version control (Git), use Infrastructure-as-Code (Terraform/Ansible) to manage deployments, and implement a pre-flight check (syntax test + staging validation) before touching production.

**Key principle**: Always have a way to get back to the last known-good state within seconds, not hours.

---

# Task 3 — Logs & Request Trace

## Goal

Verify real traffic flow and analyze logs to understand system behavior and errors.

### Evidence

#### Screenshot 1 — Output of `sudo tail -n 30 /var/log/nginx/access.log`

![Screenshot 8](./screenshots/week-03-linux-and-bash-for-devops-03-08.png)

---

#### Screenshot 2 — Output of `sudo tail -n 30 /var/log/nginx/error.log`

![Screenshot 9](./screenshots/week-03-linux-and-bash-for-devops-03-09.png)

---

#### Screenshot 3 — Output of `sudo journalctl -u nginx --no-pager -n 50`

![Screenshot 10](./screenshots/week-03-linux-and-bash-for-devops-03-10.png)

---

### Notes

Answer the following in your own words:

**1. Were there any errors in the logs?**

- If yes, mention 1–2 example error lines from the logs and explain what each one means in simple terms.
- If no, explain what it means if the error log is empty or shows no recent errors during your check.

No, there were no errors. The error log contains only one line:

`2026/08/12 19:33:46 [notice] 28455#28455: using inherited sockets from "5;6;"`

This is a **[notice]** level message, not an error. It's informational and means Nginx successfully inherited socket file descriptors (5 and 6) from the systemd service manager during startup. This is normal and expected when Nginx starts via systemctl. A notice is just Nginx reporting routine operational information—not a problem.

---

**2. If there were no errors, what does that indicate about the system?**

An empty/clean error log with no errors, warnings, or critical messages indicates the system is **healthy and functioning normally**. Specifically:

- Nginx is running without issues—no configuration problems, no crashes, no permission errors
- Requests are being processed successfully without conflicts or resource problems
- No SSL/TLS certificate errors, port binding issues, or worker process failures
- The application is stable and not generating warnings

This is a **good sign** for production. Your Nginx deployment is operationally sound.

---

**3. Based on the access logs, were your curl requests visible in the log entries? What does that prove about traffic flow?**

No, the curl requests are **not visible** in the access log. Instead, the logs show **real browser traffic** from two external IP addresses:

- `83.229.26.237` (accessed on Aug 12 at 19:50:45)
- `187.14.48.90` (accessed on Aug 13 at 21:15:53 and 21:16:52)

The user agents show `Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)` with Chrome and Safari browsers—these are actual users accessing your React app, not curl requests.

This proves:

- **Traffic is flowing correctly** from external sources to your Nginx server
- **The application is reachable** on the public internet (IP 3.144.191.181)
- **Static assets are being served** (CSS, JavaScript, manifest, favicon) with HTTP 200 responses
- **Caching is working** (304 Not Modified responses on subsequent requests)
- **Your deployment is live and accessible** to real users

The absence of curl commands is expected—curl is typically used for local testing or scripted requests, not for logging real user traffic.

---

# Task 4 — System Resource Health Check (Capacity Red Flags)

## Goal

Assess server capacity and detect potential performance or failure risks.

### Evidence

#### Screenshot 1 — Output of `uptime`

![Screenshot 11](./screenshots/week-03-linux-and-bash-for-devops-03-11.png)

---

#### Screenshot 2 — Output of `free -h`

![Screenshot 12](./screenshots/week-03-linux-and-bash-for-devops-03-12.png)

---

#### Screenshot 3 — Output of `df -h`

![Screenshot 13](./screenshots/week-03-linux-and-bash-for-devops-03-13.png)

---

#### Screenshot 4 — Output of `sudo du -sh /var/* | sort -h`

![Screenshot 14](./screenshots/week-03-linux-and-bash-for-devops-03-14.png)

---

### Notes

Answer the following in your own words:

**1. Which resource looks most critical right now? (CPU/load, memory, or disk) Explain why.**

Based on the `top` output, **none of the visible resources are critical right now—the system is very healthy**. Here's the breakdown:

**CPU**: 0.7% utilization

- Extremely low. The system is barely working.

**Memory**: 223M/1.91G (≈11.6% utilized)

- Very comfortable. Plenty of headroom. No memory pressure.

**Load Average**: 0.07, 0.11, 0.09 (all under 1.0)

- Excellent. Load average below 1.0 means the system has spare processing capacity.
- On a single-core system, load <1.0 is ideal.

**Uptime**: 1 day, 02:27:52

- System has been stable for over a day with no restarts.

**What's least critical:** Disk usage is not shown in this `top` output, so I cannot assess disk utilization. However, AWS Free Tier instances typically have 30GB of storage, which should be sufficient for a basic Nginx/React app unless you're storing large log files or media.

**Conclusion**: If I had to pick the one to monitor most closely going forward, it would be **disk**—because disk fills unexpectedly (log rotation issues, media uploads, etc.), while CPU and memory are currently negligible.

---

**2. What happens if disk becomes 100% full in a production server?**

If disk reaches 100% in production, several critical failures cascade:

**Immediate impacts:**

- **Nginx cannot write logs** → error.log and access.log stop updating
- **New files cannot be created** → write operations fail with "No space left on device" errors
- **Temporary files fail** → /tmp fills up, breaking application functionality
- **Database writes fail** (if running database) → data corruption risk

**Application failures:**

- Session data can't be saved → users get logged out unexpectedly
- Uploaded files cannot be processed
- Caching mechanisms break
- Any background jobs writing files crash

**System-level breakdown:**

- SSH connections may fail (system can't write auth logs)
- Systemd services cannot write state files → random service failures
- Kernel panic risk if critical system partitions are full
- Recovery becomes extremely difficult

**How to recover:**

1. SSH in (if still accessible) and identify large files/directories: `du -sh /*`
2. Delete old logs, temp files, or cache: `rm -rf /var/log/nginx/*.log*`
3. Clear package cache: `apt clean`
4. Delete old application data or uploads
5. Implement automated log rotation (logrotate)

**Prevention:**

- Monitor disk usage proactively with CloudWatch
- Set up log rotation with daily/weekly limits
- Use `df -h` regularly to track growth
- Set alerts at 80% disk usage
- Consider EBS volume expansion before hitting 100%

**Bottom line**: A full disk isn't just inconvenient—it's a critical production outage. Always monitor and alert at 80–85% utilization.

---

# Task 5 — Configuration & Deployment Verification

## Goal

Ensure the correct React build is deployed and Nginx is serving it properly.

### Evidence

#### Screenshot 1 — Output of `ls -lah /var/www/html | head -n 20`

![Screenshot 15](./screenshots/week-03-linux-and-bash-for-devops-03-15.png)

---

#### Screenshot 2 — Output of `grep -R "Deployed by" -n /var/www/html 2>/dev/null | head`

![Screenshot 16](./screenshots/week-03-linux-and-bash-for-devops-03-16.png)

---

#### Screenshot 3 — Output of `grep -n "try_files" /etc/nginx/sites-available/default`

![Screenshot 17](./screenshots/week-03-linux-and-bash-for-devops-03-17.png)

---

### Notes

Answer the following in your own words:

**1. How do you confirm that the correct version of the application is deployed?**

To confirm the correct version of your React app is deployed on your Ubuntu/Nginx server, you can use several verification methods:

Analyzed system performance metrics and identified healthy resource utilization
markdown
**1. Which resource looks most critical right now? (CPU/load, memory, or disk) Explain why.**

Based on the `top` output, **none of the visible resources are critical right now—the system is very healthy**. Here's the breakdown:

**CPU**: 0.7% utilization

- Extremely low. The system is barely working.

**Memory**: 223M/1.91G (≈11.6% utilized)

- Very comfortable. Plenty of headroom. No memory pressure.

**Load Average**: 0.07, 0.11, 0.09 (all under 1.0)

- Excellent. Load average below 1.0 means the system has spare processing capacity.
- On a single-core system, load <1.0 is ideal.

**Uptime**: 1 day, 02:27:52

- System has been stable for over a day with no restarts.

**What's least critical:** Disk usage is not shown in this `top` output, so I cannot assess disk utilization. However, AWS Free Tier instances typically have 30GB of storage, which should be sufficient for a basic Nginx/React app unless you're storing large log files or media.

**Conclusion**: If I had to pick the one to monitor most closely going forward, it would be **disk**—because disk fills unexpectedly (log rotation issues, media uploads, etc.), while CPU and memory are currently negligible.

---

**2. What happens if disk becomes 100% full in a production server?**

If disk reaches 100% in production, several critical failures cascade:

**Immediate impacts:**

- **Nginx cannot write logs** → error.log and access.log stop updating
- **New files cannot be created** → write operations fail with "No space left on device" errors
- **Temporary files fail** → /tmp fills up, breaking application functionality
- **Database writes fail** (if running database) → data corruption risk

**Application failures:**

- Session data can't be saved → users get logged out unexpectedly
- Uploaded files cannot be processed
- Caching mechanisms break
- Any background jobs writing files crash

**System-level breakdown:**

- SSH connections may fail (system can't write auth logs)
- Systemd services cannot write state files → random service failures
- Kernel panic risk if critical system partitions are full
- Recovery becomes extremely difficult

**How to recover:**

1. SSH in (if still accessible) and identify large files/directories: `du -sh /*`
2. Delete old logs, temp files, or cache: `rm -rf /var/log/nginx/*.log*`
3. Clear package cache: `apt clean`
4. Delete old application data or uploads
5. Implement automated log rotation (logrotate)

**Prevention:**

- Monitor disk usage proactively with CloudWatch
- Set up log rotation with daily/weekly limits
- Use `df -h` regularly to track growth
- Set alerts at 80% disk usage
- Consider EBS volume expansion before hitting 100%

**Bottom line**: A full disk isn't just inconvenient—it's a critical production outage. Always monitor and alert at 80–85% utilization.

Recommendation for your setup: Run df -h and check disk usage. On an AWS Free Tier instance, 30GB is standard, but log files (especially Nginx access logs) can grow quickly. Consider setting up logrotate to compress/archive old logs daily.

Answer the following in your own words:

**1. How do you confirm that the correct version of the application is deployed?**

Write your answer here.
Synthesized deployment verification strategies for React applications
markdown
**1. How do you confirm that the correct version of the application is deployed?**

Compare the commit hash or tag with what you *intended* to deploy. This proves the right code is on disk.

### Inspect Nginx Build Output

```bash
# Check the /static directory where React builds are served
ls -lah /var/www/html/static/
ls -lah /var/www/html/static/js/
```

React build filenames include content hashes (e.g., `main.1f16a03e.js`). The hash changes with each build. If you know the expected hash from your build process, you can verify it matches.

---

# Task 6 — Nginx Configuration Failure Simulation

## Goal

Simulate a real-world Nginx misconfiguration and recover the service safely.

### Evidence

#### Screenshot 1 — Output of `sudo nginx -t` showing the syntax error (broken config)

![Screenshot 18](./screenshots/week-03-linux-and-bash-for-devops-03-19.png)

---

#### Screenshot 2 — Output of `sudo nginx -t` showing syntax ok (fixed config)

![Screenshot 19](./screenshots/week-03-linux-and-bash-for-devops-03-19.png)

---

#### Screenshot 3 — Output of `curl -I http://<public-ip>` confirming recovery (200 OK)

![Screenshot 20](./screenshots/week-03-linux-and-bash-for-devops-03-20.png)

---

### Notes

Answer the following in your own words:

**1. What caused the configuration failure?**

The source code lived in `~/my-react-app/src/` but you searched in `/var/www/html/`, which only contains minified production builds. Grep found "Deployed by" but displayed it as garbled minified code with literal `\n` characters.

---

**2. How did you fix the issue?**

Search the source code directory instead of the deployment directory:

```bash
grep -R "Deployed by" ~/my-react-app/src -n
```

---

**3. How can you avoid this kind of issue in real production systems?**

- Use Git to version control source code separately from deployments
- Implement CI/CD to track which commit produced which deployment
- Use environment variables instead of hardcoding deployment info
- Keep clear documentation of where source code and built artifacts live
- Maintain deployment logs tracking who deployed what and when

---

# Task 7 — Web Application Failure Simulation

## Goal

Simulate missing deployment content and recover the application safely.

### Evidence

#### Screenshot 1 — Output of `curl -I http://<public-ip>` showing failure (non-200 response)

![Screenshot 21](./screenshots/week-03-linux-and-bash-for-devops-03-21.png)

---

#### Screenshot 2 — Output of `curl -I http://<public-ip>` confirming recovery (200 OK)

![Screenshot 22](./screenshots/week-03-linux-and-bash-for-devops-03-22.png)

---

### Notes

Answer the following in your own words:

**1. What caused the application to break in this scenario?**

Deleting the `/var/www/html` directory removed the entire production deployment, taking down the React application. Without the compiled files, static assets, and index.html, the web server had nothing to serve to users.

---

**2. How did you fix the issue and restore the application?**

You restored the `/var/www/html` directory from a backup, which recovered all the compiled React bundles, assets, and configuration files. This brought the application back online immediately without needing to rebuild or redeploy from source.

---

**3. What steps would you take to prevent this kind of issue in real production systems?**

- **Implement automated backups** — Daily/hourly backups with versioning
- **Use infrastructure-as-code** — Terraform/CloudFormation to quickly redeploy if needed
- **Set directory permissions** — Restrict write access to `/var/www` (prevent accidental deletion)
- **Enable audit logging** — Log all file deletions to detect accidents
- **Use container deployments** — Docker/Kubernetes make redeployment faster than restoring backups
- **Automated testing & CI/CD** — Catch issues before they reach production
- **Disaster recovery plan** — Document RTO/RPO and test recovery procedures regularly
- **Read-only filesystems** — Use immutable deployments where possible

---

# Task 8 — Security & Reliability Review

## Goal

Review and reflect on the security and reliability practices applied during this assignment.

### Security & Reliability Notes

Answer the following in your own words:

**1. Why is SSH key-based authentication more secure than sharing passwords?**

SSH keys use public-key cryptography where only the private key (kept secret) can decrypt the public key's challenge. Passwords can be brute-forced, intercepted, or guessed. Keys are mathematically stronger, cannot be reused by attackers if compromised, and don't require transmitting secrets over the network.

---

**2. Why should only required ports be open on a production server?**

Every open port is a potential attack surface. Unnecessary open ports increase the risk of unauthorized access, exploitation of unknown vulnerabilities, and lateral movement by attackers. Following the principle of least privilege minimizes the attack surface and limits what an attacker can target.

---

**3. Why is it important for Nginx to be enabled on boot?**

Enabling Nginx to auto-start on boot ensures the web application automatically comes back online after server restarts (planned maintenance or unexpected crashes). Without this, manual intervention is needed after every reboot, causing downtime and service disruption.

---

**4. What are the risks of sharing secrets, keys, or credentials publicly?**

Publicly shared credentials allow anyone to impersonate you, access your cloud resources, steal data, deploy malicious code, incur unexpected costs, or use your infrastructure for attacks. Leaked keys/passwords are extremely difficult to revoke completely and compromise your entire system's security.

---

**5. Why should cloud resources be stopped or terminated when they are no longer needed?**

Running unused cloud resources (EC2, databases, storage) continuously incurs charges even if not in use. Terminating them reduces infrastructure costs, minimizes the attack surface, and prevents orphaned resources from becoming security liabilities or compliance risks.

---

# LinkedIn Post (Required)

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

[LinkedIn Post](https://www.linkedin.com/posts/subhamay-bhattacharyya-67753329_dmibypravinmishra-ugcPost-7493847843539968000-7jd8/?utm_source=share&utm_medium=member_desktop&rcm=ACoAAAXzlvsBLGMTn7whkbpl6JdhO70ZuveqIQY)

---

#### Screenshot — Published LinkedIn post

![Screenshot 23](./screenshots/week-03-linux-and-bash-for-devops-03-23.png)

---

# Submission Instructions

- Add all required screenshots in your submission
- Full name must be visible in required screenshots
- Do not expose sensitive information (keys, passwords, account IDs)

---

# Completion Checklist

- [x] Task 1: Screenshots (browser, ip a, ss -tulpen, ufw status) + Notes answered
- [x] Task 2: Screenshots (nginx status, nginx -t, ss port 80) + Notes answered
- [x] Task 3: Screenshots (access log, error log, journalctl) + Notes answered
- [x] Task 4: Screenshots (uptime, free -h, df -h, du -sh) + Notes answered
- [x] Task 5: Screenshots (ls html, grep deployed by, grep try_files) + Notes answered
- [x] Task 6: Screenshots (nginx -t fail, nginx -t pass, curl recovery) + Notes answered
- [x] Task 7: Screenshots (curl failure, curl recovery) + Notes answered
- [x] Task 8: Security & Reliability Notes answered
- [x] LinkedIn post published and URL submitted
- [x] Full Name visible in all required screenshots
- [x] No sensitive data exposed

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## 📌 Resources

- 🌐 DMI Official Website: https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme  
- 🎓 University: https://university.pravinmishra.com?utm_source=github&utm_medium=readme  
- 💬 Discord Community: https://discord.pravinmishra.com?utm_source=github&utm_medium=readme  
- 📝 Blog: https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme  
- ▶️ YouTube Playlist: https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 Pravin Mishra (LinkedIn): https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 CloudAdvisory (LinkedIn): https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*