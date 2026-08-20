# Assignment 5 — Open-Source Collaboration: Fork, Clone, Sync & Pull Request

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will contribute one small documentation change to a shared repository using a standard open-source collaboration workflow: fork, clone, configure remotes, branch, commit, sync with upstream, push, and open a Pull Request. This is a different, separate practice repository from the one you submit your DMI work in.

---

# Task 0 — Fork the Upstream Repository

## Goal

Fork `pravinmishraaws/devops-micro-internship-interviews` into your own GitHub account.

### Evidence

#### Screenshot 1 — Your fork page with your username and `devops-micro-internship-interviews` visible in the browser URL

![Screenshot 1](./screenshots/week-04-git-and-github-for-devops-engineers-05-01.png)

---

# Task 1 — Authenticate GitHub from the Terminal

## Goal

Configure one authentication method — HTTPS with a Personal Access Token, or SSH — so you can push to your fork. Use only one method.

### Evidence

#### Screenshot 2 — Output of `git config --global --get credential.helper` (HTTPS) or `ssh -T git@github.com` (SSH) showing successful authentication — never show your token or private key

![Screenshot 2](./screenshots/week-04-git-and-github-for-devops-engineers-05-02.png)

---

# Task 2 — Clone Your Fork and Configure Remotes

## Goal

Clone your fork locally, then add the original repository as `upstream`.

### Evidence

#### Screenshot 3 — Output of `git remote -v` showing `origin` pointing to your fork and `upstream` pointing to `pravinmishraaws/devops-micro-internship-interviews`

![Screenshot 3](./screenshots/week-04-git-and-github-for-devops-engineers-05-03.png)

---

# Task 3 — Create a Feature Branch and Make Your Change

## Goal

Create the branch `feature-readme-update`, add only your own entry (`Full Name — Group <Group Name/Number>`) to the Student List at the end of `pull_request.md`, and commit it with the message `docs: add my name to student list`.

### Evidence

#### Screenshot 4 — Output of `git status` showing `pull_request.md` modified before staging

![Screenshot 4](./screenshots/week-04-git-and-github-for-devops-engineers-05-04.png)

---

#### Screenshot 5 — Output of `git commit`

![Screenshot 5](./screenshots/week-04-git-and-github-for-devops-engineers-05-05.png)

---

# Task 4 — Synchronize with Upstream and Push to Your Fork

## Goal

Fetch and merge `upstream/main` into your local default branch, rebase your feature branch onto it, then push `feature-readme-update` to your fork.

### Evidence

#### Screenshot 6 — Output of `git push -u origin feature-readme-update` showing a successful push

![Screenshot 6](./screenshots/week-04-git-and-github-for-devops-engineers-05-06.png)

---

#### Screenshot 7 — Your fork on GitHub showing `feature-readme-update` in the branch selector or a "Compare & pull request" banner

![Screenshot 7](./screenshots/week-04-git-and-github-for-devops-engineers-05-07.png)

---

# Task 5 — Create a Pull Request to Upstream

## Goal

Open a Pull Request from `feature-readme-update` on your fork to `main` on the upstream repository, using the title `docs: add my name to student list`.

### Evidence

#### Screenshot 8 — Pull Request creation page showing the correct base repository, base branch, head repository, compare branch, and title

![Screenshot 8](./screenshots/week-04-git-and-github-for-devops-engineers-05-08.png)

---

#### Screenshot 9 — Successfully created Pull Request page with the PR number visible

![Screenshot 9](./screenshots/week-04-git-and-github-for-devops-engineers-05-09.png)

---

#### Pull Request URL

Paste your Pull Request URL here:

[Pull Request URL](https://github.com/pravinmishraaws/devops-micro-internship-interviews/pull/468)

---

# LinkedIn Post (Required)

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

[LinkedIn Post](https://www.linkedin.com/posts/subhamay-bhattacharyya-67753329_dmi-devops-micro-internship-with-agentic-share-7494911045942304768-K6Pj/?utm_source=share&utm_medium=member_desktop&rcm=ACoAAAXzlvsBLGMTn7whkbpl6JdhO70ZuveqIQY)

---

#### Screenshot — LinkedIn post showing your successfully created Pull Request

![Screenshot 10](./screenshots/week-04-git-and-github-for-devops-engineers-05-10.png)

---

# Submission Instructions

- Add all required screenshots in your submission
- Do not expose a Personal Access Token, SSH private key, password, or authentication secret
- Only your own entry in `pull_request.md` may be added — do not edit or delete another student's entry
- Include your fork URL and Pull Request URL

---

## Fork URL

Paste your fork URL here:

[GitHub Forked Repository](https://github.com/subhamay-bhattacharyya/devops-micro-internship-pravinmishra.git)

---

# Completion Checklist

- [x] Upstream repository forked to your GitHub account (Screenshot 1)
- [x] GitHub authentication configured securely (Screenshot 2)
- [x] Fork cloned locally with `origin` and `upstream` configured (Screenshot 3)
- [x] Only `pull_request.md` modified, with your own entry added (Screenshots 4–5)
- [x] Local default branch synchronized with `upstream/main`, feature branch rebased and pushed (Screenshots 6–7)
- [x] Pull Request opened against the correct upstream repository and branch (Screenshots 8–9)
- [x] Fork URL and Pull Request URL included
- [x] LinkedIn post published and URL submitted
- [x] No PAT, password, private key, or authentication secret exposed

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
