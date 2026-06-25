# Lab 02: Tools & Skills

**Level**: Beginner | **Time**: 20 minutes | **Prerequisites**: [Lab 01](../01-getting-started/beginner/getting-started.md)

## ⚡ Pre-requisite Check

```bash
hermes --version  # Hermes should be installed and running
hermes tools      # Should display the toolsets UI
```

If `hermes` is not found, complete Lab 01 first.

## 🎯 What You'll Build

You'll explore Hermes' 40+ built-in tools organized into toolsets, and learn how the skills system extends agent capabilities on-demand.

## ⚡ Quick Win (2 minutes)

```bash
hermes tools
```

You'll see a curses-based UI listing all available toolsets with enable/disable toggles. Press `q` to exit.

### 🎉 Success!
- [ ] Toolsets UI displayed with checkboxes
- [ ] Core toolsets visible (`terminal`, `file`, `web`, `memory`)
- [ ] You can navigate with arrow keys

## 📊 Progress Checkpoint

▓▓░░░░░░░░ 20% complete

---

## Exercise 2.1: Core Tools in Action (5 minutes)

### Goal

Use the core toolsets: `terminal`, `file`, `search`, and `web`.

### Steps

1. **Launch Hermes:**

```bash
hermes
```

2. **Test the terminal tool:**

```
Run the command: echo "Hermes tools work!" && date
```

3. **Test the file tool:**

```
Write a file at /tmp/hermes_test.md with the content: "# Test\n\nCreated by Hermes Agent"
```

4. **Test the search tool:**

```
Search for files matching *.py in the current directory
```

### Expected Output

```
┊ terminal(command="echo 'Hermes tools work!' && date")
┊ Result: "Hermes tools work!\n2026-05-26 12:00:00"

┊ write_file(path="/tmp/hermes_test.md", content="# Test...")
┊ Result: {"success": true}

┊ search_files(path=".", regex=".*", file_pattern="*.py")
┊ Result: Found 15 files matching *.py
```

### 🎉 Success!
- [ ] Terminal command executed and returned output
- [ ] File written successfully
- [ ] File search returned results

## 📊 Progress Checkpoint

▓▓▓▓░░░░░░ 40% complete

---

## Exercise 2.2: Toolsets Management (5 minutes)

### Goal

Enable and disable toolsets to control which tools Hermes can access.

### Steps

1. **Check current toolsets:**

```bash
hermes tools
```

2. **Enable a toolset via config:**

```bash
nano ~/.hermes/config.yaml
```

Add or modify:

```yaml
tools:
  enabled:
    - terminal
    - file
    - web
    - search
    - memory
```

3. **Verify toolsets are active:**

```bash
hermes
# Then type:
List the tools you have access to right now.
```

### Expected Output

```
┊ Response:
╭─────────────────────────────────────────────────────────╮
│  I have access to the following toolsets:              │
│                                                         │
│  - terminal: Shell execution and code execution        │
│  - file: File read/write/patch operations              │
│  - web: Web search and extraction                      │
│  - search: File and code search                        │
│  - memory: Memory search and storage                    │
╰─────────────────────────────────────────────────────────╯
```

### 🎉 Success!
- [ ] Hermes listed available toolsets
- [ ] Toolsets match your config.yaml settings
- [ ] No errors when accessing tools

## 📊 Progress Checkpoint

▓▓▓▓▓▓░░░░ 60% complete

---

## Exercise 2.3: Skills System Basics (5 minutes)

### Goal

Explore the skills system — how Hermes loads specialized knowledge on-demand.

### Steps

1. **List installed skills:**

```bash
hermes skills list
```

2. **Check built-in skills directory:**

```bash
ls ~/.hermes/skills/
```

3. **Ask Hermes about skills:**

```bash
hermes
# Then type:
What skills do you have available?
```

### Expected Output

```
┊ Response:
╭─────────────────────────────────────────────────────────╮
│  I have access to several built-in skills:             │
│                                                         │
│  - GitHub workflows (code review, PR analysis)         │
│  - MLOps (model training, deployment)                  │
│  - Research (paper analysis, literature review)        │
│  - Productivity (task management, note-taking)         │
│                                                         │
│  Skills are loaded on-demand based on conversation     │
│  context. I can also create new skills from experience.│
╰─────────────────────────────────────────────────────────╯
```

### 🎉 Success!
- [ ] `hermes skills list` shows available skills
- [ ] Built-in skills directory exists
- [ ] Hermes can describe its skills

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓░░ 80% complete

---

## Exercise 2.4: Install an Optional Skill (3 minutes)

### Goal

Install an optional skill from the Hermes skills hub.

### Steps

1. **Browse optional skills:**

```bash
hermes skills browse
```

2. **Install a skill:**

```bash
hermes skills install official/productivity/task-manager
```

3. **Verify installation:**

```bash
hermes skills list
```

### Expected Output

```
Installing task-manager skill...
✅ Skill installed: ~/.hermes/skills/productivity/task-manager/SKILL.md

$ hermes skills list
Installed skills:
  - productivity/task-manager (v1.0.0)
  - github/code-review (built-in)
  - mlops/training (built-in)
```

### 🎉 Success!
- [ ] Skill installed to `~/.hermes/skills/`
- [ ] Skill appears in `hermes skills list`
- [ ] SKILL.md file created with instructions

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓▓▓ 100% complete

---

## 🏆 Lab Complete!

You've explored Hermes' core tools, managed toolsets, and worked with the skills system. You now understand how Hermes extends its capabilities through tools and skills.

## 🚀 Next Steps

- **[Lab 03: Configuration](../03-configuration/beginner/config-basics.md)** — Customize Hermes for your workflow
- **[Lab 02 Intermediate: Skills System](../intermediate/skills-system.md)** — Deep dive into skill creation and management

## 💡 Pro Tips

- Use `hermes tools` (curses UI) to toggle toolsets without editing config
- Skills are loaded contextually — mention the skill domain and Hermes loads it
- Custom skills go in `~/.hermes/skills/<category>/<name>/SKILL.md`
- The `_HERMES_CORE_TOOLS` list in `toolsets.py` defines default tool bundles

## 🔗 Resources

- [Tools Documentation](../../capabilities/TOOLS.md)
- [Skills Documentation](../../capabilities/SKILLS.md)
- [Tool Orchestration](../../architecture/TOOL_ORCHESTRATION.md)
- [AGENTS.md - Adding New Tools](../../../AGENTS.md)

## 🔗 Evolution Decisions Covered

| Decision | Date | Topic |
|----------|------|-------|
| ARCH-001 | 2025-12-01 | Plugin hooks introduced |
| Multiple | Various | Tool orchestration and toolset decisions |
