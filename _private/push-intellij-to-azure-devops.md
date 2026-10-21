# How to Push an IntelliJ IDEA Project to a New Azure DevOps Git Repository

## 1. Purpose

This procedure explains how to upload an existing IntelliJ IDEA project to a newly created, empty Azure DevOps Git repository using the IntelliJ Terminal and Git commands.

**Example configuration:**

| Item | Example value |
|---|---|
| IntelliJ project name | ABC_Login |
| Local project directory | `C:\Users\User\IdeaProjects\ABC_Login` |
| Azure DevOps organization | `carolineshewchuk0317` |
| Azure DevOps project | `ABC_Login` |
| Azure DevOps Git repository | `ABC_Login` |
| Git branch | `main` |

Replace these values with your own when applying the procedure to another project.

## 2. Prerequisites

Before proceeding, ensure that:

1. IntelliJ IDEA is installed and your project opens successfully.
2. Git for Windows is installed and configured in IntelliJ IDEA.
3. You can sign in to your Azure DevOps organization.
4. You have permission to push code to the destination Azure DevOps repository.
5. You have created an empty Git repository in Azure DevOps, preferably without initializing it with a README or other files.

**Important:** The instructions below assume you want to publish the current IntelliJ project as the initial version of a new repository. If your local project is already connected to a Git repository whose history you want to preserve, do not delete its `.git` directory.

## 3. Create an Empty Repository in Azure DevOps

1. Open [Azure DevOps](https://dev.azure.com) and sign in.
2. Select your organization.
3. Create or open the Azure DevOps project where the repository will reside.
4. Select **Repos → Files**.
5. From the repository dropdown, select **New repository**.
6. Enter the repository name, for example `ABC_Login`.
7. Select **Git** as the repository type.
8. Leave the README initialization option unchecked, if offered, so the repository is empty.
9. Click **Create**.

The new repository should display a message similar to:

`ABC_Login is empty. Add some code!`

Copy the HTTPS clone URL from the Azure DevOps repository page.

For this example, the URL copied from Azure DevOps is:

```text
https://carolineshewchuk0317@dev.azure.com/carolineshewchuk0317/ABC_Login/_git/ABC_Login
```

The username prefix before `@dev.azure.com` is optional. The equivalent repository URL without it is:

```text
https://dev.azure.com/carolineshewchuk0317/ABC_Login/_git/ABC_Login
```

Both URLs refer to the same Git repository.

## 4. Open the IntelliJ Terminal

1. Open the `ABC_Login` project in IntelliJ IDEA.
2. Select **View → Tool Windows → Terminal**.
3. Verify that the Terminal is using the project's root directory.

For this example, the PowerShell prompt should be:

```powershell
PS C:\Users\User\IdeaProjects\ABC_Login>
```

Enter:

```powershell
pwd
```

**Expected result:**

```text
Path
----
C:\Users\User\IdeaProjects\ABC_Login
```

If the Terminal is in a different directory, enter:

```powershell
cd C:\Users\User\IdeaProjects\ABC_Login
```

## 5. Check for an Existing Git Repository

Enter:

```powershell
Test-Path .git
```

**Expected result:**

- `False` — No Git repository currently exists in the project directory.
- `True` — The directory already contains Git repository metadata.

If the result is `False`, proceed to Step 6.

If the result is `True`, determine whether the existing Git history should be retained.

**Optional — Delete existing Git history only when intentionally starting over:**

```powershell
Remove-Item -Recurse -Force .git
```

This deletes the local Git metadata, including commit history, branch references, and repository configuration. It does not delete the IntelliJ project's working files. However, local history and unpushed commits may become unrecoverable.

Verify:

```powershell
Test-Path .git
```

Expected result:

```text
False
```

**Do not run this deletion command routinely.** If the existing repository history needs to be preserved, keep `.git` and configure the remote instead.

## 6. Initialize the Local Git Repository

If the project does not already have a Git repository, enter:

```powershell
git init
```

Create or rename the current branch to `main`:

```powershell
git branch -M main
```

Verify the status:

```powershell
git status --short
```

Files not yet tracked by Git will normally appear with `??` beside their filenames or directories.

## 7. Add the IntelliJ Project Files

Before staging files, verify that the project contains an appropriate `.gitignore` file.

The `.gitignore` should exclude unnecessary local files, temporary build files, and sensitive information, such as passwords, tokens, and private keys.

Once verified, stage the project files:

```powershell
git add .
```

Check the status:

```powershell
git status
```

**Expected result:**

```text
Changes to be committed:
    new file:   ...
    new file:   ...
```

This confirms that project files have been staged for the initial Git commit.

## 8. Commit the IntelliJ Project Files

Enter:

```powershell
git commit -m "Initial ABC_Login project"
```

This creates the first local Git commit containing the staged project files.

Verify:

```powershell
git status
```

If everything was committed successfully, Git should indicate that the working tree is clean.

## 9. Connect the IntelliJ Project to Azure DevOps

Use the HTTPS URL copied directly from the destination Azure DevOps repository.

For the ABC_Login example:

```powershell
git remote add origin https://carolineshewchuk0317@dev.azure.com/carolineshewchuk0317/ABC_Login/_git/ABC_Login
```

Verify the remote configuration:

```powershell
git remote -v
```

**Expected result:**

```text
origin  https://carolineshewchuk0317@dev.azure.com/carolineshewchuk0317/ABC_Login/_git/ABC_Login (fetch)
origin  https://carolineshewchuk0317@dev.azure.com/carolineshewchuk0317/ABC_Login/_git/ABC_Login (push)
```

**Important:** If `origin` already exists, do not use `git remote add origin` again.

Instead, update the existing remote:

```powershell
git remote set-url origin https://carolineshewchuk0317@dev.azure.com/carolineshewchuk0317/ABC_Login/_git/ABC_Login
```

Run `git remote -v` again to confirm the correction.

## 10. Configure Git Credential Manager for Azure DevOps Authentication

Git Credential Manager allows Git to authenticate with Azure DevOps using your Microsoft account.

First, verify that Git Credential Manager is installed:

```powershell
git credential-manager --version
```

If installed correctly, the command displays a version number.

Configure Git to use Git Credential Manager:

```powershell
git config --global credential.helper manager
```

Configure Azure Repos authentication to use OAuth:

```powershell
git config --global credential.azreposCredentialType oauth
```

These global configuration commands generally need to be performed only once for your Windows user profile, not for every IntelliJ project.

**Important:** Git Credential Manager should be installed before executing these configuration steps. A current Git for Windows installation commonly includes it.

## 11. Push the IntelliJ Project to Azure DevOps

Enter:

```powershell
git push -u origin main
```

If a Microsoft sign-in window appears:

1. Sign in with the Microsoft account that has access to the Azure DevOps organization.
2. Complete any required verification.
3. Allow authentication to complete.

Git should then upload the local commits to the remote Azure DevOps repository.

**Example successful output:**

```text
[new branch]      main -> main
branch 'main' set up to track 'origin/main'.
```

The `-u` option establishes the upstream tracking relationship between the local `main` branch and the Azure DevOps `main` branch.

For subsequent pushes, you can normally use:

```powershell
git push
```

## 12. Verify the IntelliJ Project in Azure DevOps

1. Open Azure DevOps in Chrome.
2. Navigate to the correct organization and project.
3. Select **Repos → Files**.
4. Select the `ABC_Login` repository.
5. Confirm that the IntelliJ project files are displayed.
6. Select **Commits** and verify that the initial commit is present.

You can also open the repository directly using:

```text
https://dev.azure.com/carolineshewchuk0317/ABC_Login/_git/ABC_Login
```

This URL should display the Azure DevOps repository page when accessed with an authorized account.

## 13. Common Errors and Solutions

### Error A: Authentication failed

Example:

```text
fatal: Authentication failed for 'https://dev.azure.com/...'
```

**Possible causes:**

- Git Credential Manager is not installed or configured correctly.
- Git has stored outdated authentication credentials.
- The Microsoft account does not have access to the repository.
- The repository URL points to a different organization or project.

**Suggested solution:**

Verify the repository URL and execute:

```powershell
git credential-manager --version
git config --global credential.helper manager
git config --global credential.azreposCredentialType oauth
```

Then retry:

```powershell
git push -u origin main
```

If authentication still fails, inspect **Windows Credential Manager → Windows Credentials** for outdated Azure DevOps credentials. Remove only the relevant stale credentials and try again.

### Error B: Remote origin already exists

Example:

```text
error: remote origin already exists.
```

**Solution:**

```powershell
git remote set-url origin https://carolineshewchuk0317@dev.azure.com/carolineshewchuk0317/ABC_Login/_git/ABC_Login
```

Verify:

```powershell
git remote -v
```

### Error C: Push rejected — fetch first

Example:

```text
! [rejected] main -> main (fetch first)
error: failed to push some refs
```

**Possible cause:**

The remote Git branch already contains commits that are not in your local branch.

**Solution:**

First verify the correct repository is configured:

```powershell
git remote -v
```

Then check the remote branches:

```powershell
git ls-remote --heads origin
```

If the remote contains commits, examine its history before deciding whether to fetch and merge or rebase.

Do not force-push or delete remote history without first confirming that those changes can safely be replaced.

### Error D: Repository not found

**Possible causes:**

- Incorrect organization, project, or repository name.
- Missing repository permissions.
- Authentication to the wrong Azure DevOps account.

**Solution:**

Return to Azure DevOps, open **Repos → Files**, copy the HTTPS clone URL, and update `origin` using `git remote set-url`.

## 14. Quick Reference — Git Commands

For a new local project with no existing `.git` directory, an empty Azure DevOps repository, and Git Credential Manager already configured:

```powershell
# Navigate to the IntelliJ project
cd C:\Users\User\IdeaProjects\ABC_Login

# Initialize Git
git init

# Set the main branch
git branch -M main

# Verify project status
git status --short

# Add project files after checking .gitignore
git add .

# Verify staged files
git status

# Commit project files
git commit -m "Initial ABC_Login project"

# Connect to Azure DevOps
git remote add origin https://carolineshewchuk0317@dev.azure.com/carolineshewchuk0317/ABC_Login/_git/ABC_Login

# Verify remote
git remote -v

# Push to Azure DevOps
git push -u origin main
```

**Result:** The IntelliJ IDEA project files and initial Git commit are uploaded to the Azure DevOps repository, and the local `main` branch is configured to track `origin/main`.
