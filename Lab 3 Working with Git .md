# Practice Lab 0301: Working with Git

## Summary

::: secondary
In this lab you will install and configure Git on a Windows Server lab machine, create a local repository, make and track changes, work with branches, merge a feature branch into the master branch, move HEAD to earlier commits, visualise repository history with Gitk, and clone a public repository.
:::

### Prerequisites

::: secondary
The following must be in place before starting this lab:

- You are signed in to **LON-SRV1** as `contoso\Administrator`
:::

::: warning
**Note**: All commands in this lab are run in PowerShell. Open PowerShell as Administrator unless stated otherwise.
:::

---

## Exercise 1: Install and Configure Git

::: secondary
**Scenario**

Before using Git, you need to install it on LON-SRV1 and configure your identity. Git tags every commit with the author name and email address, so this configuration must be completed before your first commit.
:::

### Task 1: Install Git using Winget

1. [ ] On **LON-SRV1**, open **Windows PowerShell** as Administrator.

2. [ ] Run the following command to install Git:

```powershell
winget install --id Git.Git -e
```

3. [ ] When prompted, accept the licence agreement.

4. [ ] After installation completes, close and reopen PowerShell to reload the PATH environment variable.

5. [ ] Verify the installation by running:

```powershell
git --version
```

6. [ ] Confirm that the output shows a version number, for example:

```
git version 2.47.0.windows.2
```

### Task 2: Configure Git identity

1. [ ] Run the following command, replacing the name and email with your own details:

```powershell
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

2. [ ] Verify the configuration was saved:

```powershell
git config --list
```

3. [ ] Confirm that `user.name` and `user.email` appear in the output.

::: warning
**Note**: The `--global` flag saves this configuration to your user profile. It applies to all repositories on this machine. If you are working on a shared machine, use `--local` inside a specific repository instead.
:::

::: success
**Results**: After completing this exercise, you will have successfully installed Git on LON-SRV1 and configured your identity for commit tracking.
:::

---

## Exercise 2: Create a Local Repository and Make Commits

::: secondary
**Scenario**

You will create a new folder, initialise it as a Git repository, create some files, and make your first commits. This exercise establishes the foundational Git workflow: edit, stage, commit.
:::

### Task 1: Initialise a repository

1. [ ] In PowerShell, navigate to a working directory:

```powershell
cd C:\
```

2. [ ] Create a new project folder and move into it:

```powershell
mkdir git-demo
cd git-demo
```

3. [ ] Initialise Git in the folder:

```powershell
git init
```

4. [ ] Check the repository status:

```powershell
git status
```

5. [ ] Confirm the output reads:

```
On branch master

No commits yet

nothing to commit (create/copy files and use "git add" to track)
```

::: warning
**Note**: Run `dir -Force` to see the hidden `.git` folder that Git creates. This folder contains the entire repository history. Do not delete or modify it manually.
:::

### Task 2: Create files and make the first commit

1. [ ] Create a README file:

```powershell
"# Git Demo" | Out-File README.md
```

2. [ ] Create a PowerShell script file:

```powershell
"Write-Host 'Hello from Git'" | Out-File server-info.ps1
```

3. [ ] Check what Git sees:

```powershell
git status
```

4. [ ] Confirm both files appear under **Untracked files**.

5. [ ] Stage both files for commit:

```powershell
git add README.md server-info.ps1
```

6. [ ] Commit the staged files with a descriptive message:

```powershell
git commit -m "Initial commit: add README and server-info script"
```

7. [ ] View the commit history:

```powershell
git log --oneline
```

8. [ ] Confirm one commit entry appears with your message.

### Task 3: Make a change and commit it

1. [ ] Append a new line to the script:

```powershell
"Write-Host 'Server: LON-SRV1'" | Out-File server-info.ps1 -Append
```

2. [ ] Review the change before staging:

```powershell
git diff
```

3. [ ] Confirm the new line appears prefixed with `+` in the diff output.

4. [ ] Stage and commit the change:

```powershell
git add server-info.ps1
git commit -m "Add server name output to script"
```

5. [ ] View the updated commit history:

```powershell
git log --oneline
```

6. [ ] Confirm two commits are listed.

::: success
**Results**: After completing this exercise, you will have successfully created a local Git repository, added files, and made two commits with descriptive messages.
:::

---

## Exercise 3: Create and Work with a Branch

::: secondary
**Scenario**

Your team wants to add a configuration section to the server script without affecting the stable master branch. You will create a feature branch, make changes on it, and verify that the master branch is unaffected.
:::

### Task 1: Create a feature branch

1. [ ] Create a new branch named `feature/add-config`:

```powershell
git branch feature/add-config
```

2. [ ] Switch to the new branch:

```powershell
git switch feature/add-config
```

3. [ ] Confirm you are on the correct branch:

```powershell
git branch
```

4. [ ] Verify that `* feature/add-config` appears in the output, indicating the active branch.

### Task 2: Make changes on the branch

1. [ ] Create a new configuration file:

```powershell
"# Server Configuration" | Out-File config.md
"Domain: contoso.com" | Out-File config.md -Append
"Primary DC: LON-DC1" | Out-File config.md -Append
```

2. [ ] Stage and commit the new file:

```powershell
git add config.md
git commit -m "Add server configuration notes"
```

3. [ ] List the files in the current directory:

```powershell
dir
```

4. [ ] Confirm `config.md` is present.

### Task 3: Observe branch isolation

1. [ ] Switch back to the master branch:

```powershell
git switch master
```

2. [ ] List the files again:

```powershell
dir
```

3. [ ] Confirm that `config.md` is **not** present — it exists only on the feature branch.

4. [ ] Switch back to the feature branch to continue:

```powershell
git switch feature/add-config
```

::: warning
**Note**: Git manages the actual file system state when you switch branches. Files that only exist on a branch will appear and disappear as you switch. This is expected behaviour.
:::

::: success
**Results**: After completing this exercise, you will have successfully created a feature branch, committed changes to it, and verified that the master branch remains unaffected.
:::

---

## Exercise 4: Merge a Feature Branch

::: secondary
**Scenario**

The configuration change on `feature/add-config` is complete and ready to become part of the stable codebase. You will merge the feature branch into `master` and verify that the configuration file is now available on the master branch.
:::

### Task 1: Merge feature/add-config into master

1. [ ] Switch to the master branch:

```powershell
git switch master
```

2. [ ] Merge the `feature/add-config` branch into `master`:

```powershell
git merge feature/add-config
```

3. [ ] Confirm that the merge completes successfully.

4. [ ] List the files in the current directory:

```powershell
dir
```

5. [ ] Confirm that `config.md` is now present on the master branch.

6. [ ] View the commit history:

```powershell
git log --oneline
```

7. [ ] Confirm that the commit named `Add server configuration notes` appears in the history.

::: success
**Results**: After completing this exercise, you will have successfully merged the `feature/add-config` branch into master.
:::

---

## Exercise 5: Move HEAD to View Earlier Versions

::: secondary
**Scenario**

You need to understand how Git stores changes over time. You will create another commit, move HEAD to earlier commits, compare file contents at different points in history, and then return to the current master branch.
:::

### Task 1: Add another commit

1. [ ] Confirm that you are on the master branch:

```powershell
git branch
```

2. [ ] Verify that `* master` appears in the output.

3. [ ] Add another line to `config.md`:

```powershell
"Backup DC: LON-SRV2" | Out-File config.md -Append
```

4. [ ] Review the change before staging:

```powershell
git diff
```

5. [ ] Stage and commit the change:

```powershell
git add config.md
git commit -m "Add backup domain controller note"
```

6. [ ] View the commit history:

```powershell
git log --oneline --decorate
```

7. [ ] Confirm that the newest commit is named `Add backup domain controller note`.

### Task 2: Move HEAD to the previous commit

1. [ ] View the current contents of `config.md`:

```powershell
Get-Content config.md
```

2. [ ] Confirm that the file includes `Backup DC: LON-SRV2`.

3. [ ] Move HEAD to the previous commit:

```powershell
git switch --detach HEAD~1
```

4. [ ] View the contents of `config.md` again:

```powershell
Get-Content config.md
```

5. [ ] Confirm that `Backup DC: LON-SRV2` is no longer shown.

::: warning
**Note**: You are now in detached HEAD state. This is useful for viewing an earlier version, but do not make new commits in this state during this lab.
:::

### Task 3: Move HEAD farther back in history

1. [ ] Move HEAD back one more commit:

```powershell
git switch --detach HEAD~1
```

2. [ ] List the files in the current directory:

```powershell
dir
```

3. [ ] Confirm that `config.md` is not present at this point in history.

4. [ ] View the commit history from the current point:

```powershell
git log --oneline --decorate
```

5. [ ] Return to the current master branch:

```powershell
git switch master
```

6. [ ] Confirm that `config.md` is present again:

```powershell
dir
```

7. [ ] View the current contents of `config.md`:

```powershell
Get-Content config.md
```

8. [ ] Confirm that `Backup DC: LON-SRV2` is shown again.

::: success
**Results**: After completing this exercise, you will have successfully moved HEAD to earlier commits, inspected older file states, and returned to the master branch.
:::

---

## Exercise 6: Visualise Changes with Gitk

::: secondary
**Scenario**

Command-line history is useful, but a visual graph can make commit order and file changes easier to understand. You will open Gitk, inspect the commit graph, and compare how `config.md` changed over time.
:::

### Task 1: Open Gitk

1. [ ] Confirm that you are in the `C:\git-demo` folder:

```powershell
cd C:\git-demo
```

2. [ ] Open Gitk:

```powershell
gitk --all
```

3. [ ] Confirm that the Gitk window opens.

4. [ ] In the upper pane, locate the following commits:
   - `Initial commit: add README and server-info script`
   - `Add server name output to script`
   - `Add server configuration notes`
   - `Add backup domain controller note`

### Task 2: Review file changes in Gitk

1. [ ] Select the commit named **Add server configuration notes**.

2. [ ] In the lower pane, confirm that `config.md` was added in that commit.

3. [ ] Select the commit named **Add backup domain controller note**.

4. [ ] Confirm that Gitk shows the added `Backup DC: LON-SRV2` line.

5. [ ] Select the `master` branch label in the history graph.

6. [ ] Confirm that `master` points to the newest commit.

7. [ ] Close Gitk.

::: success
**Results**: After completing this exercise, you will have successfully used Gitk to visualise the commit graph and review file changes over time.
:::

---

## Exercise 7: Clone a Public Repository

::: secondary
**Scenario**

You often need to work with repositories that already exist. You will clone the public [chrislgarry/Apollo-11](https://github.com/chrislgarry/Apollo-11) repository, which contains the original Apollo 11 Guidance Computer source code for the command and lunar modules.
:::

### Task 1: Clone the Apollo 11 repository

1. [ ] In PowerShell, move back to the root of the C drive:

```powershell
cd C:\
```

2. [ ] Clone the public Apollo 11 repository:

```powershell
git clone https://github.com/chrislgarry/Apollo-11.git
```

3. [ ] Move into the cloned repository:

```powershell
cd Apollo-11
```

4. [ ] List the files and folders in the repository:

```powershell
dir
```

5. [ ] Confirm that folders such as `Comanche055` and `Luminary099` are present.

### Task 2: Inspect the cloned repository

1. [ ] View the repository status:

```powershell
git status
```

2. [ ] Confirm that Git reports there is nothing to commit.

3. [ ] View the repository history:

```powershell
git log --oneline -5
```

4. [ ] Confirm that recent commits are displayed.

5. [ ] View the configured remote:

```powershell
git remote -v
```

6. [ ] Confirm that `origin` points to `https://github.com/chrislgarry/Apollo-11.git`.

7. [ ] Open the project page in Microsoft Edge:

```powershell
Start-Process "https://github.com/chrislgarry/Apollo-11"
```

8. [ ] Review the repository description and file list on GitHub.

::: success
**Results**: After completing this exercise, you will have successfully cloned a public GitHub repository and inspected its files, history, and remote configuration.
:::
