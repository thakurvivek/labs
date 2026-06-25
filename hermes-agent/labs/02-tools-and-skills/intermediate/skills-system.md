# Lab 02 Intermediate: Skills System Deep Dive

**Level**: Intermediate | **Time**: 25 minutes | **Prerequisites**: [Lab 02 Beginner](../beginner/tools-basics.md)

## 🎯 What You'll Build

You'll create a custom skill from scratch, understand the SKILL.md format, and learn how Hermes loads skills contextually.

## ⚡ Quick Win (2 minutes)

```bash
# Create a skill directory
mkdir -p ~/.hermes/skills/productivity/standup-reporter

# Create a minimal SKILL.md
cat > ~/.hermes/skills/productivity/standup-reporter/SKILL.md << 'EOF'
---
name: standup-reporter
description: Generates daily standup reports.
version: 1.0.0
author: You
---

# Standup Reporter Skill

## When to Use
When the user asks for a standup report or daily summary.

## Procedure
1. Use `search_files` to find recent changes
2. Use `terminal` to run `git log --oneline -10`
3. Format results as a standup report
EOF

hermes skills list
```

### 🎉 Success!
- [ ] New skill appears in `hermes skills list`
- [ ] SKILL.md created with frontmatter
- [ ] No validation errors

## 📊 Progress Checkpoint

▓▓░░░░░░░░ 20% complete

---

## Exercise 2.1: SKILL.md Frontmatter (5 minutes)

### Goal

Understand the required frontmatter fields for skills.

### Steps

1. **Review the frontmatter spec:**

```yaml
---
name: standup-reporter              # Required: skill identifier
description: Generates daily standup reports.  # Required: ≤60 chars, one sentence, ends with period
version: 1.0.0                      # Required: semantic version
author: Your Name                   # Required: credit the human
platforms: [linux, macos]          # Optional: OS gating
metadata:
  hermes:
    tags: [standup, report, daily]
    category: productivity
    related_skills: [git-analyzer]
    config:                        # Optional: config.yaml settings needed
      - standup.max_commits
---
```

2. **Validate your SKILL.md:**

```python
import re, pathlib
m = re.search(r'^description: (.*)$',
    pathlib.Path('~/.hermes/skills/productivity/standup-reporter/SKILL.md').read_text(),
    re.MULTILINE)
assert len(m.group(1)) <= 60, f"Description too long: {len(m.group(1))}"
print(f"✅ Description length: {len(m.group(1))} chars")
```

3. **Test skill loading:**

```bash
hermes
# Type: Create a standup report for today
```

### Expected Output

```
┊ Loading skill: standup-reporter
┊ terminal(command="git log --oneline -10")
┊ Result: a1b2c3d Fix login bug
┊         e5f6g7h Add search feature
┊ Response:
╭─────────────────────────────────────────────────────────╮
│  # Daily Standup Report                                 │
│                                                         │
│  ## What I did today:                                   │
│  - Fix login bug (a1b2c3d)                              │
│  - Add search feature (e5f6g7h)                         │
╰─────────────────────────────────────────────────────────╯
```

### 🎉 Success!
- [ ] Description passes 60-char validation
- [ ] Skill loaded when context matched
- [ ] Hermes followed the skill procedure

## 📊 Progress Checkpoint

▓▓▓▓░░░░░░ 40% complete

---

## Exercise 2.2: Skill with Helper Scripts (5 minutes)

### Goal

Create a skill that uses a helper script for complex logic.

### Steps

1. **Create the skill structure:**

```bash
mkdir -p ~/.hermes/skills/analysis/code-stats/scripts
```

2. **Create the helper script:**

```bash
cat > ~/.hermes/skills/analysis/code-stats/scripts/stats.sh << 'SCRIPT'
#!/bin/bash
# Generate code statistics for a project
DIR="${1:-.}"
echo "=== Code Statistics for $DIR ==="
echo ""
echo "Files by type:"
find "$DIR" -type f | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -10
echo ""
echo "Total lines of code:"
find "$DIR" -name "*.py" -o -name "*.js" -o -name "*.ts" | xargs wc -l 2>/dev/null | tail -1
echo ""
echo "Recent commits:"
cd "$DIR" && git log --oneline -5 2>/dev/null || echo "Not a git repo"
SCRIPT
chmod +x ~/.hermes/skills/analysis/code-stats/scripts/stats.sh
```

3. **Create the SKILL.md:**

```yaml
---
name: code-stats
description: Generates codebase statistics.
version: 1.0.0
author: You
---

# Code Stats Skill

## When to Use
When the user asks for codebase statistics, file counts, or project metrics.

## Procedure
1. Run `scripts/stats.sh <project_dir>` to gather statistics
2. Format the output as a readable report
3. Use `terminal` to execute the script

## Pitfalls
- Script requires bash — not available on native Windows
- Git commands fail if not in a repository
```

4. **Test the skill:**

```bash
hermes
# Type: Show me code statistics for the current directory
```

### Expected Output

```
┊ Loading skill: code-stats
┊ terminal(command="~/.hermes/skills/analysis/code-stats/scripts/stats.sh .")
┊ Result:
┊ === Code Statistics for . ===
┊ Files by type:
┊    142 py
┊     87 md
┊     45 json
┊ Total lines of code:
┊  45230 total
```

### 🎉 Success!
- [ ] Helper script executes correctly
- [ ] Skill references script by relative path
- [ ] Output formatted as a report

## 📊 Progress Checkpoint

▓▓▓▓▓▓░░░░ 60% complete

---

## Exercise 2.3: Skill with Config Settings (5 minutes)

### Goal

Create a skill that reads configuration from `config.yaml`.

### Steps

1. **Create the skill:**

```yaml
---
name: git-summarizer
description: Summarizes git activity with configurable depth.
version: 1.0.0
author: You
metadata:
  hermes:
    config:
      - git_summarizer.max_commits
      - git_summarizer.include_stats
---

# Git Summarizer Skill

## When to Use
When the user asks for a git activity summary or commit analysis.

## Prerequisites
- Git installed and available in PATH
- Current directory is a git repository

## Procedure
1. Read `max_commits` from config (default: 10)
2. Read `include_stats` from config (default: false)
3. Run `git log -n <max_commits> --oneline`
4. If `include_stats`, add `--stat` flag
5. Format results as a summary
```

2. **Add config settings:**

```bash
nano ~/.hermes/config.yaml
```

```yaml
skills:
  config:
    git_summarizer:
      max_commits: 20
      include_stats: true
```

3. **Test with config:**

```bash
hermes
# Type: Summarize recent git activity
```

### Expected Output

```
┊ Loading skill: git-summarizer
┊ Reading config: git_summarizer.max_commits = 20
┊ Reading config: git_summarizer.include_stats = true
┊ terminal(command="git log -n 20 --oneline --stat")
┊ Response:
╭─────────────────────────────────────────────────────────╮
│  # Git Activity Summary (20 commits)                   │
│                                                         │
│  a1b2c3d Fix login bug                                  │
│    cli.py              | 12 +++++++++----               │
│    tests/test_cli.py   |  8 ++++++++                   │
│  e5f6g7h Add search feature                             │
│    tools/search.py     | 45 +++++++++++++++++++++++++++++++++++    │
╰─────────────────────────────────────────────────────────╯
```

### 🎉 Success!
- [ ] Config settings read correctly
- [ ] Skill behavior changes based on config
- [ ] Default values used when config missing

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓░░ 80% complete

---

## Exercise 2.4: Skill Lifecycle (3 minutes)

### Goal

Understand how skills are created, improved, and archived.

### Steps

1. **Check curator status:**

```bash
hermes curator status
```

2. **Pin a skill (prevent auto-archiving):**

```bash
hermes curator pin standup-reporter
```

3. **View skill usage stats:**

```bash
cat ~/.hermes/skills/.usage.json | python -m json.tool
```

### Expected Output

```
$ hermes curator status
Curator: Enabled
Interval: Every 24 hours
Next review: 2026-05-27 12:00:00

Skills tracked:
  - productivity/standup-reporter (active, pinned)
  - analysis/code-stats (active)
  - analysis/git-summarizer (active)

$ cat ~/.hermes/skills/.usage.json | python -m json.tool
{
  "productivity/standup-reporter": {
    "use_count": 3,
    "view_count": 5,
    "last_activity_at": "2026-05-26T12:00:00Z",
    "state": "active",
    "pinned": true
  }
}
```

### 🎉 Success!
- [ ] Curator status displayed
- [ ] Skill pinned successfully
- [ ] Usage stats tracked in `.usage.json`

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓▓▓ 100% complete

---

## 🏆 Lab Complete!

You've created custom skills with frontmatter, helper scripts, and config settings. You understand the full skill lifecycle from creation to archiving.

## 🚀 Next Steps

- **[Lab 04: Gateway Setup](../04-gateway/intermediate/gateway-setup.md)** — Connect Hermes to messaging platforms
- **[Lab 07: Plugin Development](../07-plugins/advanced/plugin-development.md)** — Build custom plugins

## 💡 Pro Tips

- Skill descriptions must be ≤60 characters — long descriptions bloat listings
- Scripts go in `scripts/`, references in `references/`, templates in `templates/`
- The curator auto-archives stale skills — pin important ones
- Skills with `created_by: "agent"` are curator-managed; bundled skills are off-limits
- Use `hermes skills install official/<category>/<name>` for optional skills

## 🔗 Resources

- [Skills Documentation](../../capabilities/SKILLS.md)
- [Curator Documentation](../../architecture/COMPONENTS.md)
- [AGENTS.md - Skills](../../../AGENTS.md)
