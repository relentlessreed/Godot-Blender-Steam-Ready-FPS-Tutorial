# Git And GitHub Workflow

This guide explains the version-control workflow for the tutorial project. The goal is to learn the same habits used in professional software and game development: make small changes, save clean checkpoints, push work to a remote backup, and avoid risky history changes.

## Create A GitHub Account

1. Go to `https://github.com`.
2. Create an account.
3. Verify your email address.
4. Keep your username, email, and password manager entry somewhere safe.
5. Enable two-factor authentication when GitHub asks for it.

GitHub is the remote copy of the project. Your local Git repo lives on your computer. GitHub stores a backed-up version online and makes it easier to collaborate later.

## Install Git

On Ubuntu or WSL Ubuntu:

```bash
sudo apt update
sudo apt install git
```

Check that Git is installed:

```bash
git --version
```

Set your author identity. Use the same email address you want attached to your commits:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

Git stores this information in commits so other people can see who made each change.

## Set Up SSH Keys For GitHub

SSH lets your computer push to GitHub without typing a username and password every time.

Check whether you already have an SSH key:

```bash
ls ~/.ssh
```

If you do not already have an `id_ed25519.pub` file, create a new key:

```bash
ssh-keygen -t ed25519 -C "you@example.com"
```

When asked where to save it, press Enter to accept the default path. When asked for a passphrase, use one if you want extra security.

Print the public key:

```bash
cat ~/.ssh/id_ed25519.pub
```

Copy the full output. Then in GitHub:

1. Open **Settings**.
2. Open **SSH and GPG keys**.
3. Click **New SSH key**.
4. Give it a clear title, such as `Linux development machine`.
5. Paste the public key.
6. Save it.

Test GitHub SSH access:

```bash
ssh -T git@github.com
```

If GitHub says you successfully authenticated, SSH is working. GitHub may also say it does not provide shell access. That is normal.

## Create The Local Project Folder

Create a place for Godot projects:

```bash
mkdir -p ~/godot
cd ~/godot
```

Create or open the project folder:

```bash
mkdir -p untitled
cd untitled
```

At this point, create the initial Godot project files in Godot. The most important file is:

```text
project.godot
```

Once `project.godot` exists, the folder is ready to become a Git repository.

## Initialize The Git Repo

Run this inside the project folder:

```bash
git init
```

Set the main branch name:

```bash
git branch -M main
```

Create a `.gitignore` before the first commit. For Godot, this should ignore generated folders and build output:

```text
.godot/
*.import
export/
build/
*.pck
*.exe
*.x86_64
*.app/
.DS_Store
Thumbs.db
```

The purpose of `.gitignore` is to keep generated files, local cache files, and build artifacts out of the repo. Source files should be committed. Temporary output should usually not be committed.

## Connect The GitHub Remote

Create an empty repository on GitHub. Do not add a README, license, or `.gitignore` there if you already created those locally.

Use the SSH remote URL from GitHub. It usually looks like this:

```text
git@github.com:<github-username>/<repo-name>.git
```

Add it as `origin`:

```bash
git remote add origin git@github.com:<github-username>/<repo-name>.git
```

Check the remote:

```bash
git remote -v
```

`origin` is the standard name for the main remote copy of the repo.

## Make The Initial Commit

Check what Git sees:

```bash
git status
```

Stage the files you want in the first checkpoint:

```bash
git add .gitignore project.godot
```

Commit the checkpoint:

```bash
git commit -m "Initial Godot project"
```

A commit is a saved snapshot of the project. The message should describe what changed and why the checkpoint matters. `Initial Godot project` is clear because it tells readers this commit creates the baseline Godot project.

## Push To Main On Origin

Push the local `main` branch to GitHub:

```bash
git push -u origin main
```

This uploads your local commits to the remote repository. The `-u` connects your local `main` branch to `origin/main`, so later you can usually run:

```bash
git push
```

We push to GitHub because it creates an off-computer backup, makes the project visible from another machine, and prepares the repo for collaboration. If the computer breaks, the pushed commits still exist on GitHub.

## Add A Trusted Collaborator

A collaborator is another GitHub user who can contribute to the repository. For a personal GitHub repository, GitHub lets you invite collaborators from the repository settings. Only invite someone you trust, because collaborators can usually push code, open pull requests, manage issues, and affect the project history depending on the permissions GitHub gives them.

Before inviting someone:

- Make sure they have their own GitHub account.
- Ask for their GitHub username.
- Ask them to enable two-factor authentication.
- Agree that feature work should happen on branches.
- Agree that `main` should stay playable and stable.
- Do not share your password, SSH private key, personal access tokens, or GitHub recovery codes.

To invite a collaborator on GitHub:

1. Open the repository page on GitHub.
2. Click **Settings**.
3. In the access area, click **Collaborators** or **Collaborators and teams**.
4. Click **Add people**.
5. Search for the person's GitHub username or email.
6. Select the correct person.
7. Click the button to add that person to the repository.
8. Wait for them to accept the invitation.

After they accept, have them clone the repo with SSH:

```bash
git clone git@github.com:<github-username>/<repo-name>.git
```

For a small tutorial repo, the simplest rule is:

```text
Do not push unfinished experiments directly to main.
```

Instead, collaborators should create a branch:

```bash
git switch -c feature/example-feature
```

Then they commit and push that branch:

```bash
git push -u origin feature/example-feature
```

On GitHub, they can open a pull request. The project owner reviews the changes, checks that the game still runs, then merges into `main`.

If a collaborator no longer needs access, remove them from the same collaborator settings area. Removing old access is normal project maintenance, not a personal statement.

## Daily Commands

Check what changed:

```bash
git status
```

Stage intentional changes:

```bash
git add path/to/file
```

Commit a working checkpoint:

```bash
git commit -m "Add player movement"
```

Push to GitHub:

```bash
git push
```

## Commit Style

Use short, behavior-focused messages. A good commit message says what the commit does:

```text
Add FPS player controller
Create target range scene
Add Blender export notes
Fix target score counting
```

Each commit should be a working checkpoint. Before committing, ask:

- Does the project still open?
- Did I stage only the files I meant to stage?
- Does the commit message describe the change clearly?
- Did I avoid committing generated files or personal local paths?

Avoid vague commits:

```text
updates
stuff
changes
```

Vague messages make it hard to understand the project history later.

## Branches

For a tiny solo tutorial, it is acceptable to work directly on `main`. In business and team environments, developers usually create branches for focused work:

```bash
git switch -c feature/main-menu
```

Make changes, commit them, and push the branch:

```bash
git push -u origin feature/main-menu
```

Then open a pull request on GitHub. A pull request lets the team review the changes before they enter `main`.

Use branch names that explain the work:

```text
feature/player-health
feature/main-menu
fix/target-score
docs/blender-export-notes
```

When the feature is reviewed and tested, merge it into `main`.

## Professional Git Habits

Developers in professional teams usually push work often, but not randomly. A good rhythm is:

- Commit after a small working checkpoint.
- Push at least at the end of a work session.
- Push before switching machines.
- Push before asking someone else to review the work.
- Push a branch when the work is useful to share, even if it is not ready for `main`.

For solo learning, commit whenever you finish a meaningful step. Examples:

```text
Add target hit reaction
Create first arena layout
Add player jump tuning
Document WSL import path
```

Be careful with these habits:

- Run `git status` before every commit.
- Read `git diff` when you are unsure what changed.
- Do not commit passwords, tokens, private keys, or personal machine paths.
- Do not force push shared branches unless the team explicitly agrees.
- Do not rewrite `main` history in a shared project.
- Pull before starting work if other people may have pushed changes.
- Keep generated build files out of Git unless the project has a specific reason to track them.

## Common Safe Commands

See changed files:

```bash
git status
```

See the exact text changes:

```bash
git diff
```

See recent commits:

```bash
git log --oneline --max-count=10
```

Download remote changes:

```bash
git pull
```

Push local commits:

```bash
git push
```

These commands are normal daily tools. Slow down before using commands that rewrite or discard history, such as `reset`, `rebase`, or force push.
