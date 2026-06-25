# Lab 11: Capstone — Build a Code Review Monitoring System

**Level**: Capstone | **Time**: 45 minutes | **Prerequisites**: Labs 04 (Gateway), 06 (Delegation), 07 (Plugins), 08 (Kanban), 09 (Cron)

## 🎯 What You'll Build

You'll build a complete code review monitoring system that combines Hermes' gateway, cron, kanban, and plugin systems into a single production-grade workflow. The system will automatically detect new PRs, dispatch review agents, track progress on a Kanban board, and deliver results via Telegram.

## ⚡ Pre-requisite Check (2 minutes)

```bash
# Verify all required components are available
echo "=== Pre-requisite Check ==="
hermes --version && echo "✅ Hermes installed" || echo "❌ Hermes not installed"
hermes gateway status && echo "✅ Gateway configured" || echo "⚠️  Gateway not configured (optional for this lab)"
hermes kanban list 2>/dev/null && echo "✅ Kanban available" || echo "❌ Kanban not available"
hermes cron list 2>/dev/null && echo "✅ Cron available" || echo "❌ Cron not available"
ls ~/.hermes/plugins/ 2>/dev/null && echo "✅ Plugin directory exists" || echo "❌ No plugins directory"
```

### 🎉 Success!
- [ ] Hermes version displayed
- [ ] Kanban and cron commands work
- [ ] Plugin directory exists at `~/.hermes/plugins/`

> **Note:** If gateway is not configured, you can still complete this lab using the CLI. Gateway integration is covered in Exercise 11.4 as an optional enhancement.

## 📊 Progress Checkpoint

▓▓░░░░░░░░ 20% complete

---

## Exercise 11.1: Create the Code Review Plugin (8 minutes)

### Goal

Build a plugin that provides `pr_scan` and `pr_review` tools for the monitoring system.

### Steps

1. **Create the plugin structure:**

```bash
mkdir -p ~/.hermes/plugins/code-review-monitor/scripts
```

2. **Create the plugin manifest:**

```bash
cat > ~/.hermes/plugins/code-review-monitor/plugin.yaml << 'EOF'
name: code-review-monitor
version: 1.0.0
description: Automated PR scanning and review monitoring
author: You
kind: general
EOF
```

3. **Create the plugin entry point:**

```python
# ~/.hermes/plugins/code-review-monitor/__init__.py
import json, subprocess, os

def register(ctx):
    ctx.register_tool(
        name="pr_scan",
        handler=lambda args, **kw: scan_prs(args.get("repo", "."), args.get("max_prs", 5)),
        schema={
            "name": "pr_scan",
            "description": "Scan a git repo for open pull requests",
            "parameters": {
                "type": "object",
                "properties": {
                    "repo": {"type": "string", "description": "Repo path or URL"},
                    "max_prs": {"type": "integer", "description": "Max PRs to scan"}
                }
            }
        }
    )

    ctx.register_tool(
        name="pr_review",
        handler=lambda args, **kw: review_pr(args.get("pr_number", ""), args.get("repo", ".")),
        schema={
            "name": "pr_review",
            "description": "Review a specific pull request",
            "parameters": {
                "type": "object",
                "properties": {
                    "pr_number": {"type": "string", "description": "PR number"},
                    "repo": {"type": "string", "description": "Repo path"}
                },
                "required": ["pr_number"]
            }
        }
    )

def scan_prs(repo: str, max_prs: int) -> str:
    """Scan for open PRs using git."""
    try:
        result = subprocess.run(
            ["git", "fetch", "origin"], capture_output=True, text=True, cwd=repo
        )
        # In a real system, this would query GitHub/GitLab API
        # For this lab, we simulate with local branch analysis
        branches = subprocess.run(
            ["git", "branch", "-r"], capture_output=True, text=True, cwd=repo
        )
        return json.dumps({
            "status": "success",
            "repo": repo,
            "pr_count": min(len(branches.stdout.strip().split("\n")), max_prs),
            "message": f"Found {min(len(branches.stdout.strip().split('\\n')), max_prs)} potential PRs"
        })
    except Exception as e:
        return json.dumps({"status": "error", "message": str(e)})

def review_pr(pr_number: str, repo: str) -> str:
    """Review a PR by analyzing diff."""
    try:
        diff = subprocess.run(
            ["git", "diff", f"origin/main...origin/pull/{pr_number}/head"],
            capture_output=True, text=True, cwd=repo
        )
        lines_changed = len(diff.stdout.split("\n"))
        return json.dumps({
            "status": "success",
            "pr_number": pr_number,
            "lines_changed": lines_changed,
            "review": f"PR #{pr_number} changes {lines_changed} lines"
        })
    except Exception as e:
        return json.dumps({"status": "error", "message": str(e)})
```

4. **Verify the plugin loads:**

```bash
hermes plugins list
```

### Expected Output

```
$ hermes plugins list
Installed plugins:
  - code-review-monitor (v1.0.0) — ~/.hermes/plugins/code-review-monitor/
    Tools: pr_scan, pr_review
```

### 🎉 Success!
- [ ] Plugin created with `pr_scan` and `pr_review` tools
- [ ] Plugin appears in `hermes plugins list`
- [ ] Tools registered successfully

## 📊 Progress Checkpoint

▓▓▓▓░░░░░░ 40% complete

---

## Exercise 11.2: Set Up the Kanban Board (7 minutes)

### Goal

Create a Kanban board to track PR review tasks.

### Steps

1. **Initialize the board:**

```bash
hermes kanban init pr-reviews
```

2. **Create sample tasks:**

```bash
hermes kanban create --board pr-reviews --title "Review PR #2847: Add Kanban support" --priority high
hermes kanban create --board pr-reviews --title "Review PR #2901: Implement cron scheduler" --priority high
hermes kanban create --board pr-reviews --title "Review PR #3575: Fix profile paths" --priority medium
```

3. **Assign to coder profile:**

```bash
hermes kanban assign task_001 coder --board pr-reviews
hermes kanban assign task_002 coder --board pr-reviews
hermes kanban assign task_003 coder --board pr-reviews
```

4. **View the board:**

```bash
hermes kanban list --board pr-reviews
```

### Expected Output

```
$ hermes kanban list --board pr-reviews
Board: pr-reviews
┌──────────────────────────────────────────────────────────────────────┐
│ Task ID | Title                                  | Priority | Status │
├──────────────────────────────────────────────────────────────────────┤
│ task_001| Review PR #2847: Add Kanban support    | 🔴 High  | Open   │
│ task_002| Review PR #2901: Implement cron        | 🔴 High  | Open   │
│ task_003| Review PR #3575: Fix profile paths     | 🟡 Med   | Open   │
└──────────────────────────────────────────────────────────────────────┘
Total: 3 | Open: 3 | In Progress: 0 | Done: 0
```

### 🎉 Success!
- [ ] Board `pr-reviews` initialized
- [ ] Three PR review tasks created
- [ ] Tasks assigned to `coder` profile

## 📊 Progress Checkpoint

▓▓▓▓▓▓░░░░ 60% complete

---

## Exercise 11.3: Schedule Automated PR Scanning (8 minutes)

### Goal

Create a cron job that scans for new PRs and creates Kanban tasks automatically.

### Steps

1. **Create the PR scan cron job:**

```bash
hermes cron add --name "pr-scan" \
  --schedule "every 30m" \
  --prompt "Scan the hermes-agent repository for new pull requests. For each new PR found, create a corresponding task on the 'pr-reviews' Kanban board with appropriate priority based on the number of files changed." \
  --skills "github/code-review"
```

2. **Create a review dispatch job:**

```bash
hermes cron add --name "pr-review-dispatch" \
  --schedule "every 1h" \
  --prompt "Check the 'pr-reviews' Kanban board for open tasks. For each open task, use delegate_task to spawn a subagent that performs the code review. Update the task status based on the review results."
```

3. **Verify the schedule:**

```bash
hermes cron list
```

### Expected Output

```
$ hermes cron list
Scheduled Jobs:
┌────────────────────────────────────────────────────────────────────┐
│ Name             | Schedule      | Skills              | Status │
├────────────────────────────────────────────────────────────────────┤
│ pr-scan          | Every 30 min  | github/code-review  | ⏰ Ready │
│ pr-review-dispatch| Every 1 hour | (none)              | ⏰ Ready │
└────────────────────────────────────────────────────────────────────┘
```

### 🎉 Success!
- [ ] PR scan job created with 30-minute interval
- [ ] Review dispatch job created with 1-hour interval
- [ ] Both jobs appear in cron list

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓░░ 80% complete

---

## Exercise 11.4: Gateway Integration (Optional, 5 minutes)

### Goal

Connect the monitoring system to Telegram for real-time notifications.

### Steps

1. **Configure Telegram notifications:**

```yaml
# Add to ~/.hermes/config.yaml
gateway:
  platforms:
    telegram:
      enabled: true
      notify_on:
        - pr_scanned
        - review_complete
        - task_blocked
```

2. **Add notification hooks to the plugin:**

```python
# Append to ~/.hermes/plugins/code-review-monitor/__init__.py

def on_post_tool_call(tool_name, result, **kw):
    if tool_name in ("pr_scan", "pr_review"):
        # In production, this would emit a gateway event
        print(f"[MONITOR] {tool_name}: {result[:100]}...")
```

3. **Test the end-to-end flow:**

```bash
# Run the PR scan manually
hermes cron run pr-scan

# Check Kanban board for new tasks
hermes kanban list --board pr-reviews

# Check cron logs
tail -20 ~/.hermes/logs/agent.log | grep -i "pr\|kanban\|cron"
```

### Expected Output

```
$ hermes cron run pr-scan
Running job: pr-scan
[MONITOR] pr_scan: {"status": "success", "repo": ".", "pr_count": 3}...
✅ Job completed: pr-scan (12s)

$ hermes kanban list --board pr-reviews
Board: pr-reviews
Total: 3 | Open: 2 | In Progress: 1 | Done: 0
```

### 🎉 Success!
- [ ] Cron job triggered PR scan
- [ ] Kanban board updated with results
- [ ] Logs show end-to-end flow

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓▓▓ 100% complete

---

## 🏆 Capstone Complete!

You've built a complete code review monitoring system that integrates:

| Component | Role in System |
|-----------|---------------|
| **Plugin** (`code-review-monitor`) | Provides `pr_scan` and `pr_review` tools |
| **Kanban** (`pr-reviews` board) | Tracks PR review tasks and lifecycle |
| **Cron** (`pr-scan`, `pr-review-dispatch`) | Automates scanning and review dispatch |
| **Delegation** | Spawns subagents for individual PR reviews |
| **Gateway** (optional) | Delivers notifications via Telegram |

## 🚀 Challenge Exercises (Optional)

1. **Add Slack Integration:** Configure the gateway to send notifications to Slack instead of (or in addition to) Telegram.

2. **Implement Review Scoring:** Extend the `pr_review` tool to produce a numerical quality score (0-100) based on code complexity, test coverage, and style compliance.

3. **Add Failure Recovery:** Configure `kanban.failure_limit` to auto-block PRs that fail review 3+ times, and create a cron job to unblock them after 24 hours for retry.

4. **Multi-Repo Support:** Extend the plugin to scan multiple repositories and route PRs to different Kanban boards based on repo ownership.

## 💡 Pro Tips

- The capstone demonstrates the **closed-loop pattern**: cron → scan → kanban → delegate → review → notify
- Use `hermes kanban tail <task_id>` to stream real-time progress during dispatch
- Cron sessions use `skip_memory=True` — don't rely on memory persistence in cron jobs
- The 3-minute hard interrupt on cron sessions prevents runaway review loops
- Plugin hooks (`pre_tool_call`, `post_tool_call`) are the extension point for observability

## 🔗 Resources

- [Plugin Documentation](../../capabilities/PLUGINS.md)
- [Kanban Documentation](../../capabilities/KANBAN.md)
- [Cron Documentation](../../capabilities/CRON.md)
- [Delegation Documentation](../../capabilities/DELEGATION.md)
- [Gateway Documentation](../../capabilities/GATEWAY.md)
- [AGENTS.md](../../../AGENTS.md) — Full development guide
