# Git Helper

Git workflow automation skill, letting you avoid manually handling tedious Git operations.

## Features

| Feature | Description |
|------|------|
| Smart Commit | Automatically analyze changes and generate natural‑language commit messages and commit |
| PR Management | Generate structured PR descriptions (summary + change list + testing plan), push code and create PRs with one click |
| Branch Management| Create, switch, delete and list branches |
| Conflict Resolution |Guided merge conflict resolution without automatically overwriting your code |
|Changelog Generation| Generate markdown‑formatted changelogs by date |

## Installation

Place `SKILL.md` into the specified directory.

```bash
mkdir -p ~/git-helper
cp SKILL.md ~/git-helper/
```

>[GitHub CLI](https://cli.github.com/) is required to use PR‑related features.


## Usage

After installation, Claude Code will automatically trigger this skill when you mention Git operations:


```
#  Commit code
"Help me commit these changes"

# Create PR
"Create a PR for team review"

# Manage branches
"Create a fix/xxx branch"

# Resolve conflicts
"I have merge conflicts, help me check"

#  Generate changelog
"Generate a changelog for the past week"
```

## Directory Structure

```
git-helper/
├── SKILL.md      # Skill definition and instructions
├── scripts/      #  Helper scripts
│   └── generate_changelog.sh  #  Changelog generator
└── README.md
```
