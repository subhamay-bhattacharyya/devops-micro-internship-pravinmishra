# Assignment 1 — CodeTrack: Initial Git Setup (Local Only)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will set up Git correctly on your local machine before starting the CodeTrack project. You will create a local repository and configure your Git identity at both the repository level (local) and the machine level (global). This assignment is local only — you will not push anything to GitHub yet.

---

# Task 1 — Create the CodeTrack Project and Initialize Git

## Goal

Create a `CodeTrack` project folder and initialize it as a Git repository.

### Evidence

#### Screenshot 1 — Output of `git init` inside `CodeTrack` showing "Initialized empty Git repository"

![Screenshot 1](./screenshots/week-04-git-and-github-for-devops-envineers-01-01.png)

---

#### Screenshot 2 — Output of `ls -a` showing the `.git` folder

![Screenshot 2](./screenshots/week-04-git-and-github-for-devops-envineers-01-02.png)

---

### Notes

**1. What is the `.git` folder, and why does it matter?**

The `.git` folder is a hidden directory that Git creates in the root of a repository when you run `git init`. It contains all the version control metadata and history for your project — every commit, branch, tag, configuration setting, and object database that Git needs to track changes and manage versions. The `.git` folder essentially *is* your repository; without it, your project is just a regular directory with no version control.

**Why it matters:**

- **Complete Project History:** The `.git` folder stores every version of every file that's ever been committed, allowing you to view history, compare versions, and revert to any previous state.
- **Branching & Merging:** Git uses the `.git` folder to track branches, manage merge history, and handle complex workflows across teams.
- **Collaboration:** When you push to a remote repository (like GitHub), you're sending the contents of `.git` so other developers can access the same history and versions.
- **Recovery:** If you accidentally delete files or make mistakes, the `.git` folder contains the backup — you can restore anything that was committed.
- **Integrity:** Git uses cryptographic hashing (SHA-1) stored in `.git` to ensure file integrity and detect corruption.

In DevOps, the `.git` folder is critical because infrastructure-as-code (Terraform, Ansible, Docker configurations) must be version-controlled. The `.git` folder tracks every change, who made it, when, and why (via commit messages). This enables auditability, reproducibility, and the ability to roll back to known-good configurations if something breaks. Without `.git`, you lose the entire history of your infrastructure changes.

---

# Task 2 — Configure Git Identity Locally (Repository-Only)

## Goal

Set your Git username and email for the `CodeTrack` repository only, using `git config --local`.

### Evidence

#### Screenshot 3 — Output of `git config --local --list` showing your `user.name` and `user.email`

![Screenshot 3](./screenshots/week-04-git-and-github-for-devops-envineers-01-03.png)

---

# Task 3 — Configure Git Identity Globally

## Goal

Set a global Git username and email for this machine using `git config --global`. Note that CodeTrack's local settings still take priority over these.

### Evidence

#### Screenshot 4 — Output of `git config --global --list` showing your `user.name` and `user.email`

![Screenshot 4](./screenshots/week-04-git-and-github-for-devops-envineers-01-04.png)

---

# Submission Instructions

- Add all required screenshots in your submission
- Full Name must be visible in required screenshots
- Do not expose passwords, access tokens, or private keys

---

# Completion Checklist

- [x] `CodeTrack` folder created and initialized as a Git repository (Screenshots 1–2)
- [x] Explanation of the `.git` folder written in your own words
- [x] Local `user.name` and `user.email` configured and verified (Screenshot 3)
- [x] Global `user.name` and `user.email` configured and verified (Screenshot 4)
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
