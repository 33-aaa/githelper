--
name: git-helper
description: Automate Git workflows for vibe coding. Use this skill whenever the user needs to commit changes, create a PR, manage branches, handle merge conflicts, or generate changelogs. Handles commit message generation (free-form), GitHub PR creation with auto-generated summaries and change lists, branch operations (create/switch/delete), conflict resolution guidance, and changelog generation by date. Works with any project, no special conventions needed.
compatibility: requires git CLI, GitHub CLI (gh) for PR operations
---

# Git Helper

Streamline your Git workflow while vibe coding. This skill automates the repetitive parts of committing, PR creation, branch management, conflict handling, and changelog generation — letting you stay in the flow.

## Quick Start

The skill adapts to what you're doing:
- **Just finished coding?** → "Commit my changes" (generates message + commits)
- **Ready to share?** → "Create a PR" (generates description + pushes)
- **Branches to manage?** → "Create a branch for X" / "Delete branch Y"
- **Conflict issues?** → "Help me resolve conflicts" (guides you through, then commits)
- **Need release notes?** → "Generate changelog from [date]" 

## Workflow: Commit Changes

When the user wants to commit their work:

1. **Review staged/unstaged changes** — Run `git status` and `git diff` to understand what changed
2. **Generate a commit message** — Based on the changes, write a clear, descriptive message in free format (not conventional commits, just natural language describing the "why" and "what")
3. **Stage and commit** — Add relevant files and commit with the generated message
4. **Verify** — Run `git status` to confirm

Example flow:
```
User: Commit my changes
→ Claude: [reads diff, notices new validation logic and refactored parser]
→ Generated message: "Add email validation and simplify parser logic"
→ Commits and reports success
```

## Workflow: Create PR

When the user wants to create a pull request:

1. **Gather context** — Run `git log` and `git diff` to see commits since base branch
2. **Generate PR description** — Structured with:
   - **Summary** — 1-3 bullet points of what changed and why
   - **Changes checklist** — Bulleted list of modifications (files, features, fixes)
   - **Test plan** — Brief guidance on how to test the changes
3. **Push branch** — If not already pushed, push with `-u` flag
4. **Create PR on GitHub** — Use `gh pr create` with the generated description
5. **Return PR URL** — So user can review/share

## Workflow: Branch Management

Support these operations:

- **Create branch** — `git checkout -b <branch-name>` (ask user for name if needed)
- **Switch branch** — `git checkout <branch>`
- **Delete branch** — `git branch -d <branch>` (local only by default; ask before deleting remote)
- **List branches** — Show local and remote branches with current branch highlighted

Keep branch names simple and descriptive.

## Workflow: Handle Merge Conflicts

When the user encounters conflicts:

1. **Show conflict markers** — Display the conflicted files and their merge markers (`<<<<<<<`, `=======`, `>>>>>>>`)
2. **Explain the conflict** — What each side changed and why the conflict occurred
3. **Guide resolution** — Ask user which changes to keep; don't auto-resolve
4. **Edit files** — Once user decides, remove conflict markers and keep their choice
5. **Complete merge** — Stage changes, commit the merge, push (if applicable)

For simple conflicts (non-overlapping changes), provide a clear explanation. For complex ones, ask the user to review and decide.

## Workflow: Generate Changelog

When the user asks for a changelog, use the bundled script at `scripts/generate_changelog.sh`:

```bash
bash scripts/generate_changelog.sh --since "<start>" [--until "<end>"] [--output CHANGELOG.md]
```

1. **Ask for parameters** — Start date (e.g., "yesterday", "v1.0", "last week"), end date (defaults to today)
2. **Run the script** — Pass resolved dates to `scripts/generate_changelog.sh`
3. **Present output** — Show the generated markdown to the user (save to file with `--output` if requested)

Example:
```bash
# Generate and print to stdout
bash scripts/generate_changelog.sh --since "2026-05-10"

# Generate and save to file
bash scripts/generate_changelog.sh --since "last monday" --output CHANGELOG.md
```

## Key Behaviors

**Always:**
- Run `git status` first to see what's staged
- Read commit history/diffs to understand context before writing messages
- Confirm before destructive operations (force push, hard reset, branch deletion)
- Use the GitHub CLI (`gh`) for PR operations, not web UI

**Never:**
- Skip hooks or bypass signing unless user explicitly asks
- Force-push to main/master without warning
- Auto-resolve merge conflicts (always involve the user)
- Commit without showing the user the message first

**When in doubt:**
- Ask the user before proceeding (e.g., "Want me to create a PR from this branch?")
- Show what you're about to do
- Explain non-obvious choices

## Triggering

This skill triggers whenever the user mentions:
- Committing, pushing, or staging changes
- Creating or updating a PR
- Branch operations (create, switch, merge, delete)
- Merge conflicts
- Generating changelogs or release notes
- Git workflow automation in vibe coding context
