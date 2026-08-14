# Assignment 6 — Build an AI-Assisted Linux Health Check (AI-Assisted Linux Incident Triage)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, we will build a read-only Bash triage script that checks the health of your Ubuntu server and Nginx application, connect it to Claude Code as a reusable `/linux-triage` skill, simulate a controlled Nginx incident, use the skill to gather and analyze evidence, recover the service manually, and verify recovery. The workflow follows the Agentic Loop: Gather → Analyze → Human Act → Verify.

---

# Task 1 — Confirm the Healthy Baseline and Create the Workspace

## Goal

Confirm that Nginx and the React application are healthy before building the automation.

### Evidence

#### Screenshot 1 — Output of `systemctl is-active nginx`, `ss -ltn | grep ':80'`, and `curl -I http://localhost`

![Screenshot 1](./screenshots/week-03-linux-and-bash-for-devops-06-01.png)

---

#### Screenshot 2 — Output of `pwd` and `find . -maxdepth 4 -type d | sort` showing the workspace folder structure

![Screenshot 2](./screenshots/week-03-linux-and-bash-for-devops-06-02.png)

---

### Notes

Answer the following in your own words:

**1. What proves that Nginx is running?**

Several indicators prove that Nginx is running. First, we can check the process status using commands like `systemctl status nginx` or `ps aux | grep nginx` to see if the Nginx process is active in the system. We can also verify that Nginx is listening on port 80 using `netstat -tuln | grep :80` or `ss -tuln | grep :80`, which should show the Nginx process in a LISTEN state. Additionally, we can test Nginx directly by making an HTTP request using `curl http://localhost` or accessing the server's IP address in a browser. If the server responds with the Nginx default page or your website content, it proves Nginx is running and responding to HTTP requests. In DevOps, checking multiple indicators ensures the service is not just running but also healthy and serving traffic correctly.

---

**2. What proves that the server is listening for HTTP traffic?**

Several proofs demonstrate that the server is listening for HTTP traffic. Using `netstat -tuln` or `ss -tuln`, we can see that port 80 (HTTP) is in a LISTEN state with Nginx bound to it, proving the server is actively listening. We can also use `curl http://localhost` or `curl http://<server-ip>` to make an actual HTTP request — if we receive a response (not a connection refused error), the server is listening and responding. Checking our Security Group rules on AWS confirms that inbound traffic on port 80 is allowed. We can also use tools like `lsof -i :80` to see which process is listening on port 80. In a production environment, all these checks together — network socket status, successful HTTP requests, and firewall rules — conclusively prove the server is listening and accepting HTTP traffic from clients.

---

**3. Why must we capture a healthy baseline before simulating an incident?**

Capturing a healthy baseline is critical for effective incident simulation and learning. A baseline shows what the system looks like under normal, healthy operation — response times, resource usage, error rates, and service behavior. Without this baseline, we cannot accurately identify what "broken" or "abnormal" looks like when we simulate an incident. By comparing the broken state to the healthy baseline, we can clearly see the differences and impacts of the incident. A baseline also helps we practice your incident response and debugging procedures — we learn how to identify problems, investigate root causes, and restore service. In DevOps, this practice is invaluable because it prepares we to recognize and respond to real incidents in production. Understanding the difference between healthy and unhealthy states, and knowing how to restore service, builds confidence and skills that directly prevent downtime in real-world environments.

---

# Task 2 — Create Project Context and Safety Rules in CLAUDE.md

## Goal

Tell Claude exactly what this project does and what it is not allowed to do.

### Evidence

#### Screenshot 3 — CLAUDE.md open in VS Code showing all four sections (Project Overview, Incident Workflow, Safety Rules, Output Rules)

![Screenshot 3](./screenshots/week-03-linux-and-bash-for-devops-06-03.png)

---

### Notes

---
Answer the following in your own words:

**1. Why should Claude receive project-specific operational rules?**

Claude should receive project-specific operational rules to provide accurate, contextual guidance tailored to your specific environment and architecture. General advice might not apply to your particular infrastructure setup, tooling, or constraints. With project-specific rules, Claude understands your system's configuration, naming conventions, security policies, and known limitations. For example, knowing whether your servers use Nginx or Apache, whether you have specific monitoring tools in place, or what your deployment pipeline looks like allows Claude to give more precise troubleshooting steps. Project-specific rules also establish boundaries and expectations — they clarify what Claude should and shouldn't attempt, preventing irrelevant or potentially harmful suggestions. In incident response scenarios, clear operational rules ensure Claude provides guidance that's aligned with your team's procedures, reducing confusion and speeding up resolution. This makes Claude a more effective partner in troubleshooting and automation.

---

**2. Why is the human required to execute the recovery command?**

The human must execute recovery commands because only humans should have the authority and accountability to make changes to production systems. AI assistants like Claude can analyze problems, provide recommendations, and guide troubleshooting, but executing commands that could impact system availability, data, or service requires human judgment and responsibility. Humans understand the full context, consequences, and business impact of their actions. They can make decisions based on factors beyond technical analysis — like coordination with other teams, timing considerations, or organizational policies. Requiring human execution also maintains safety guardrails and prevents unintended consequences from automated actions. In DevOps, this is a critical principle: automation and AI can assist, guide, and recommend, but humans retain control over critical decisions and command execution. This ensures accountability, allows for careful verification before action, and maintains the human oversight necessary for reliable, trustworthy infrastructure management.

---

**3. Which rule prevents Claude from making an unsupported diagnosis?**

The rule that prevents Claude from making an unsupported diagnosis is one that requires Claude to only provide guidance based on observable evidence and documented information provided by the human. Claude should not speculate about root causes, guess at diagnoses, or make assumptions without supporting data. For example, Claude should not claim "the problem is definitely a database connection timeout" without seeing actual error logs or metric data that proves this. The rule typically states that Claude should ask clarifying questions, request specific outputs (like logs, error messages, or system status commands), and base all recommendations on factual evidence. This prevents Claude from giving bad advice that might lead you down the wrong troubleshooting path or waste time chasing false leads. In incident response, unsupported diagnoses can be dangerous — they delay identifying the real problem and waste critical recovery time. By requiring evidence-based guidance, this rule ensures Claude acts as a responsible assistant that helps you think through problems systematically rather than jumping to conclusions.

---

# Task 3 — Use Agentic AI to Plan Before Writing the Script

## Goal

Use Claude Code to inspect the environment and produce a read-only plan before creating any Bash code.

### Evidence

#### Screenshot 4 — Claude Code showing the five-check plan and read-only inspection results

![Screenshot 4](./screenshots/week-03-linux-and-bash-for-devops-06-04.png)

---

### Notes

Answer the following in your own words:

**1. Which part of this task represents the Gather phase?**

Add your answer here.

---

**2. Did Claude follow the instruction not to create files? How did we verify this?**

Add your answer here.

---

**3. Why is planning before coding useful in DevOps automation?**

Add your answer here.

---

# Task 4 — Build the Linux Triage Bash Script

## Goal

Create one Bash script that gathers consistent Linux and Nginx health evidence.

### Evidence

#### Screenshot 5 — Top section of `linux-triage.sh` showing variables, thresholds, and the checks array

Add your screenshot here.

---

#### Screenshot 6 — Middle section showing check functions and conditionals

Add your screenshot here.

---

#### Screenshot 7 — Bottom section showing the loop, summary function, and exit behavior

Add your screenshot here.

---

#### Screenshot 8 — Output of `bash -n scripts/linux-triage.sh` (no syntax errors) and `ls -l scripts/linux-triage.sh` showing executable permission

Add your screenshot here.

---

### Notes

Answer the following in your own words:

**1. What is stored in the checks array?**

Add your answer here.

---

**2. How does the `for` loop use that array?**

Add your answer here.

---

**3. Why are the health checks separated into functions?**

Add your answer here.

---

**4. What is the purpose of `$(...)` in this script?**

Add your answer here.

---

**5. Why does the script use different exit codes for HEALTHY, WARN, and FAIL?**

Add your answer here.

---

# Task 5 — Run and Understand the Healthy-State Report

## Goal

Run the Bash script against the healthy server and verify that it creates a report.

### Evidence

#### Screenshot 9 — Output of `./scripts/linux-triage.sh` showing your Full Name and all five check results

Add your screenshot here.

---

#### Screenshot 10 — Output showing the captured exit code and final summary

Add your screenshot here.

---

### Notes

Answer the following in your own words:

**1. What is the overall status of your healthy baseline?**

Add your answer here.

---

**2. Which exact Linux evidence proves the application is serving traffic?**

Add your answer here.

---

**3. Did your script return exit code 0 or 1? Explain why.**

Add your answer here.

---

**4. What is the difference between a warning and a failure in this script?**

Add your answer here.

---

# Task 6 — Create and Run the /linux-triage Skill

## Goal

Turn the Bash script into a reusable, manually invoked Agentic AI workflow.

### Evidence

#### Screenshot 11 — `SKILL.md` showing the frontmatter, allowed tool restrictions, and safety rules

Add your screenshot here.

---

#### Screenshot 12 — `/linux-triage` output for the healthy server

Add your screenshot here.

---

### Notes

Answer the following in your own words:

**1. Why does this skill have Bash, Read, and Grep, but not Write?**

Add your answer here.

---

**2. Why is `disable-model-invocation: true` useful for this skill?**

Add your answer here.

---

**3. What part is performed by Bash, and what part is performed by Claude?**

Add your answer here.

---

**4. Why is this better than asking Claude "Is my server healthy?" without giving it evidence?**

Add your answer here.

---

# Task 7 — Simulate an Nginx Incident and Let the Skill Diagnose It

## Goal

Create a controlled service failure, gather evidence through Bash, and let Claude analyze the evidence without taking recovery action.

### Evidence

#### Screenshot 13 — Output showing Nginx is inactive and the HTTP request fails

Add your screenshot here.

---

#### Screenshot 14 — `/linux-triage` output showing failed evidence, most likely cause, and a suggested recovery command

Add your screenshot here.

---

#### Screenshot 15 — `incident-failure-report.txt` showing the failed checks and your Full Name

Add your screenshot here.

---

### Notes

Answer the following in your own words:

**1. Which three checks failed?**

Add your answer here.

---

**2. What evidence supports the conclusion that Nginx is unavailable?**

Add your answer here.

---

**3. Did Claude execute the recovery command? Why is that important?**

Add your answer here.

---

**4. Which phase of the Agentic Loop is represented by the Bash report?**

Add your answer here.

---

**5. Which phase is represented by Claude's explanation?**

Add your answer here.

---

# Task 8 — Recover Manually, Verify Again, and Write the Incident Summary

## Goal

Recover the service as the human operator and prove that the system is healthy again.

### Evidence

#### Screenshot 16 — Output showing Nginx is active and `curl -I http://localhost` returns 200 OK

Add your screenshot here.

---

#### Screenshot 17 — Second `/linux-triage` output showing successful recovery with no FAIL results

Add your screenshot here.

---

#### Screenshot 18 — Output of `ls -lah reports` showing both `incident-failure-report.txt` and `recovery-report.txt`

Add your screenshot here.

---

#### Screenshot 19 — `incident-summary.md` showing all required sections and your Full Name

Add your screenshot here.

---

### Notes

Answer the following in your own words:

**1. What action did we execute manually?**

Add your answer here.

---

**2. What evidence proves that the service recovered?**

Add your answer here.

---

**3. Why is the second triage run necessary?**

Add your answer here.

---

**4. What could go wrong if an AI agent automatically restarted every failed service?**

Add your answer here.

---

**5. In one sentence, explain the difference between using AI as a chatbot and using AI in this agentic workflow.**

Add your answer here.

---

# Incident Summary

Fill in all seven sections below in your own words.

**Full Name:** Add your full name here

**Date:** DD/MM/YYYY

---

**1. Reported Symptom**

Add your answer here.

---

**2. Evidence Collected**

Add your answer here.

---

**3. Most Likely Cause**

Add your answer here.

---

**4. Human-Approved Recovery Action**

Add your answer here.

---

**5. Verification**

Add your answer here.

---

**6. Safety Decision**

Add your answer here.

---

**7. Agentic Loop Mapping**

Add your answer here.

---

# LinkedIn Post (Required)

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`Add your URL here`

---

#### Screenshot — Published LinkedIn post

Add your screenshot here.

---

# GitHub Repository URL

Paste the URL of your GitHub folder or repository containing the assignment files here:

`Add your URL here`

---

# Submission Instructions

- Add all required screenshots in your submission
- Full Name must be visible in required screenshots and the Bash report
- All written answers must be in your own words
- Do not expose sensitive information (keys, passwords, AWS account IDs, tokens)
- GitHub URL must be included in this document

---

# Completion Checklist

- [ ] Task 1: Healthy baseline confirmed, workspace created (Screenshots 1–2, Notes answered)
- [ ] Task 2: CLAUDE.md created with all four sections (Screenshot 3, Notes answered)
- [ ] Task 3: Five-check plan produced by Claude using read-only tools (Screenshot 4, Notes answered)
- [ ] Task 4: `linux-triage.sh` created, syntax validated, executable permission set (Screenshots 5–8, Notes answered)
- [ ] Task 5: Healthy-state report generated with no FAIL result (Screenshots 9–10, Notes answered)
- [ ] Task 6: `/linux-triage` skill created and run successfully on healthy server (Screenshots 11–12, Notes answered)
- [ ] Task 7: Nginx incident simulated, failed evidence captured, Claude did not execute recovery (Screenshots 13–15, Notes answered)
- [ ] Task 8: Nginx recovered manually, recovery verified, reports saved, incident summary complete (Screenshots 16–19, Notes answered)
- [ ] Incident summary contains all seven required sections
- [ ] LinkedIn post published and URL submitted
- [ ] Full Name visible in all required screenshots and the Bash report
- [ ] Skill does not have Write permission
- [ ] Skill did not execute any recovery commands
- [ ] No sensitive data exposed

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
- ▶️ weTube Playlist: https://www.wetube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 Pravin Mishra (LinkedIn): https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 CloudAdvisory (LinkedIn): https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*