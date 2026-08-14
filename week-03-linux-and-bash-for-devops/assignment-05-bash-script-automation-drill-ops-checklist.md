# Assignment 5 — Bash Script Automation Drill (OPS Checklist)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, we will practice Bash scripting by building a series of small automation scripts covering environment setup, variables, arrays, loops, file conditionals, if-else logic, and functions. These scripts form the foundation of real-world Linux automation used in DevOps, cloud, and production support environments.

---

# Task 1 — Bash Environment & Workspace Setup

## Goal

Verify that Bash is available on wer system and create a clean workspace for this assignment.

### Evidence

#### Screenshot 1 — Output of `echo $SHELL` and `bash --version`

![Screenshot 1](./screenshots/week-03-linux-and-bash-for-devops-05-01.png)

---

#### Screenshot 2 — Output of `pwd` and `ls -lah` showing the scripts directory

![Screenshot 2](./screenshots/week-03-linux-and-bash-for-devops-05-02.png)

---

### Notes

Answer the following in wer own words:

**1. What is Bash?**

Bash (Bourne Again Shell) is a command-line interpreter and scripting language used to interact with the operating system. It reads commands entered at the terminal or from script files, interprets them, and executes them through the kernel. Bash allows users to run programs, manage files, automate tasks through scripts, and perform system administration. It's the default shell on most Linux distributions and macOS, making it fundamental for DevOps engineers and system administrators who need to automate infrastructure tasks and manage cloud environments.

---

**2. What is the difference between shell and Bash?**

A shell is a generic umbrella term for any command interpreter that provides a user interface to the operating system. There are many types of shells, including sh (Bourne Shell), csh (C Shell), ksh (Korn Shell), zsh, and fish. Bash is a specific implementation — it stands for Bourne Again Shell and is an enhanced version of the original Bourne Shell (sh). Bash includes advanced features that older shells don't have, such as command history, tab completion, arrays, associative arrays, and better string manipulation. While Bash is a shell, not every shell is Bash. Understanding this distinction is important because scripts written in Bash syntax may not work in other shells, and portability across different systems depends on knowing which shell features we're using.

---

**3. Why is it important to confirm the Bash version before writing scripts?**

Different versions of Bash support different features and syntax. Bash 4.x and later versions introduced features like associative arrays, extended globbing, and improved variable expansion that don't exist in Bash 3.x. If we write a script using Bash 4.x features and run it on a system with Bash 3.x (common on macOS and older Linux systems), the script will fail or produce errors. In DevOps and infrastructure automation, scripts need to run reliably across multiple servers and environments. By confirming the Bash version available on wer target systems, we can either adjust wer script to use compatible syntax or add version checks to handle different environments. This ensures wer automation code is reproducible, predictable, and won't break unexpectedly in production.

---

# Task 2 — wer First Bash Script

## Goal

Create wer first Bash script, make it executable, and run it from the terminal.

### Evidence

#### Screenshot 1 — Content of `first-script.sh`

![Screenshot 3](./screenshots/week-03-linux-and-bash-for-devops-05-03.png)

---

#### Screenshot 2 — Output of `./first-script.sh`

![Screenshot 4](./screenshots/week-03-linux-and-bash-for-devops-05-04.png)

---

#### Screenshot 3 — Output of `ls -l first-script.sh` showing executable permission

![Screenshot 5](./screenshots/week-03-linux-and-bash-for-devops-05-05.png)

---

### Notes

Answer the following in wer own words:

**1. What is the purpose of `#!/bin/bash`?**

The `#!/bin/bash` line is called a shebang (or hashbang). It's placed at the very beginning of a script file and tells the operating system which interpreter should execute the script. When we run a script as an executable (using `./script.sh`), the system reads this first line and knows to use the Bash interpreter located at `/bin/bash` to run the commands in the file. Without this shebang line, the system won't know which interpreter to use and the script will likely fail. This is especially important in DevOps automation where scripts may run on different systems or be called from various contexts.

---

**2. Why do we use `chmod +x` before running a script?**

`chmod +x` adds execute permissions to a script file, marking it as executable. By default, files we create on Linux don't have execute permissions — they're readable and writable but not runnable. When we run a script using `./script.sh`, the system needs execute permission to treat the file as a program and invoke the interpreter specified in the shebang line. Without `chmod +x`, we'll get a "Permission denied" error even if the script is syntactically correct. In DevOps workflows, this is a critical step when deploying automation scripts to servers or CI/CD pipelines — we must ensure the scripts have proper execute permissions before they can run.

---

**3. What is the difference between running a script using `./script.sh` and `bash script.sh`?**

When we run `./script.sh`, we're executing the script as an executable file. The system reads the shebang line (`#!/bin/bash`) to determine which interpreter to use, then runs the script with that interpreter. This requires the file to have execute permissions (set via `chmod +x`). When we we `bash script.sh`, we're explicitly calling the Bash interpreter and telling it to execute the script as an argument. In this case, the shebang line is ignored because we're explicitly specifying the interpreter. Both methods work, but `./script.sh` is preferred in production and automation environments because it makes the script portable — if we change the shebang to use a different interpreter (like `#!/bin/sh`), the behavior changes automatically without modifying how the script is called.

---

# Task 3 — Variables: User Information Script

## Goal

Use variables to store and display user-related information.

### Evidence

#### Screenshot 1 — Content of `user-info.sh`

![Screenshot 6](./screenshots/week-03-linux-and-bash-for-devops-05-06.png)

---

#### Screenshot 2 — Output of `./user-info.sh`

![Screenshot 7](./screenshots/week-03-linux-and-bash-for-devops-05-07.png)

---

### Notes

Answer the following in wer own words:

**1. What is a variable in Bash?**

Add wer answer here.

---

**2. Why should we avoid spaces around the `=` sign when creating variables?**

Add wer answer here.

---

**3. How do we access the value stored inside a Bash variable?**

Add wer answer here.

---

# Task 4 — Arrays & Loops: Tools Checklist Script

## Goal

Use arrays and loops to print a checklist of tools used in Bash scripting.

### Evidence

#### Screenshot 1 — Content of `tools-checklist.sh`

Add wer screenshot here.

---

#### Screenshot 2 — Output of `./tools-checklist.sh`

Add wer screenshot here.

---

### Notes

Answer the following in wer own words:

**1. What is an array in Bash?**

Add wer answer here.

---

**2. Why are arrays useful in scripts?**

Add wer answer here.

---

**3. What does `"${tools[@]}"` mean?**

Add wer answer here.

---

**4. What is the purpose of the `for` loop in this script?**

Add wer answer here.

---

# Task 5 — Loops: Number Counter Script

## Goal

Use loops to repeat a task multiple times.

### Evidence

#### Screenshot 1 — Content of `counter.sh`

Add wer screenshot here.

---

#### Screenshot 2 — Output of `./counter.sh`

Add wer screenshot here.

---

### Notes

Answer the following in wer own words:

**1. What is a loop?**

Add wer answer here.

---

**2. Why do we use loops in Bash scripting?**

Add wer answer here.

---

**3. How many times did the loop run in wer script?**

Add wer answer here.

---

**4. What would we change if we wanted the loop to run 10 times?**

Add wer answer here.

---

# Task 6 — Files & Conditionals: File Validation Script

## Goal

Use file checks and conditionals to verify whether files and directories exist.

### Evidence

#### Screenshot 1 — Output of `ls -lah ../test-folder`

Add wer screenshot here.

---

#### Screenshot 2 — Content of `file-check.sh`

Add wer screenshot here.

---

#### Screenshot 3 — Output of `./file-check.sh`

Add wer screenshot here.

---

### Notes

Answer the following in wer own words:

**1. What does `-d` check in Bash?**

Add wer answer here.

---

**2. What does `-f` check in Bash?**

Add wer answer here.

---

**3. Why should file and directory paths be stored in variables?**

Add wer answer here.

---

**4. What happens if the file does not exist?**

Add wer answer here.

---

# Task 7 — Conditionals: Pass or Retry Script

## Goal

Use if-else conditionals to make decisions based on a variable value.

### Evidence

#### Screenshot 1 — Content of `score-check.sh` with `score=85`

Add wer screenshot here.

---

#### Screenshot 2 — Output showing `Result: Pass`

Add wer screenshot here.

---

#### Screenshot 3 — Content of `score-check.sh` with `score=55`

Add wer screenshot here.

---

#### Screenshot 4 — Output showing `Result: Retry`

Add wer screenshot here.

---

### Notes

Answer the following in wer own words:

**1. What is the purpose of if-else in Bash?**

Add wer answer here.

---

**2. What does `-ge` mean?**

Add wer answer here.

---

**3. Why should conditions be tested with different values?**

Add wer answer here.

---

**4. How can conditionals help in automation scripts?**

Add wer answer here.

---

# Task 8 — Functions: Final Bash Automation Script

## Goal

Create a final Bash script using functions to organize reusable code.

### Evidence

#### Screenshot 1 — Content of `final-automation.sh`

Add wer screenshot here.

---

#### Screenshot 2 — Output of `./final-automation.sh`

Add wer screenshot here.

---

#### Screenshot 3 — Output of `ls -lah` showing all created scripts

Add wer screenshot here.

---

### Notes

Answer the following in wer own words:

**1. What is a function in Bash?**

Add wer answer here.

---

**2. Why are functions useful in scripts?**

Add wer answer here.

---

**3. Which functions did we create in this script?**

Add wer answer here.

---

**4. How does this final script combine variables, arrays, loops, conditionals, files, and functions?**

Add wer answer here.

---

# LinkedIn Post (Required)

## Evidence

#### LinkedIn Post URL

Paste wer LinkedIn post URL here:

`Add wer URL here`

---

#### Screenshot — Published LinkedIn post

Add wer screenshot here.

---

# Submission Instructions

- Add all required screenshots in wer submission
- Full name must be visible in required screenshots
- All script files must be created and run successfully
- Required notes must be answered clearly for every task
- Do not expose sensitive information (keys, passwords, credentials)

---

# Completion Checklist

- [ ] Task 1: Environment setup verified, workspace created (Screenshots 1–2, Notes answered)
- [ ] Task 2: First script created, executed, permissions verified (Screenshots 1–3, Notes answered)
- [ ] Task 3: Variables script created and run (Screenshots 1–2, Notes answered)
- [ ] Task 4: Arrays and loops script created and run (Screenshots 1–2, Notes answered)
- [ ] Task 5: Counter loop script created and run (Screenshots 1–2, Notes answered)
- [ ] Task 6: File validation script created and run (Screenshots 1–3, Notes answered)
- [ ] Task 7: Pass/Retry conditional script tested with both values (Screenshots 1–4, Notes answered)
- [ ] Task 8: Final automation script created and run (Screenshots 1–3, Notes answered)
- [ ] All scripts run without errors
- [ ] Full Name visible in all required screenshots
- [ ] LinkedIn post published and URL submitted
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