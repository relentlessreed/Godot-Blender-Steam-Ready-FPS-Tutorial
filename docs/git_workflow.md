# Git Workflow

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

Use short, behavior-focused messages:

```text
Add FPS player controller
Create target range scene
Add Blender export notes
Fix target score counting
```

Avoid vague commits:

```text
updates
stuff
changes
```

## Branches

For now, work on `main` because the project is tiny and tutorial-focused. When the game becomes larger, use feature branches:

```bash
git switch -c feature/main-menu
```

Then merge only after the feature runs cleanly.
