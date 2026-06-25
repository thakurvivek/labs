# Lab 09: Cron Jobs

**Level**: Advanced | **Time**: 30 minutes | **Prerequisites**: [Lab 04](../04-gateway/intermediate/gateway-setup.md), [Lab 06](../06-delegation/intermediate/subagent-delegation.md)

## ⚡ Pre-requisite Check

```bash
hermes cron list  # Should display cron job list (may be empty)
```

## 🎯 What You'll Build

You'll schedule automated agent tasks using Hermes' cron system — from simple recurring jobs to AI-powered scheduled workflows.

## ⚡ Quick Win (2 minutes)

```bash
# List existing cron jobs
hermes cron list
```

You'll see any existing scheduled jobs (or an empty list if this is a fresh install).

### 🎉 Success!
- [ ] Cron list command works
- [ ] Job store accessible
- [ ] No errors displayed

## 📊 Progress Checkpoint

▓▓░░░░░░░░ 20% complete

---

## Exercise 9.1: Create a Simple Cron Job (5 minutes)

### Goal

Schedule a recurring job that runs every hour.

### Steps

1. **Create a cron job via CLI:**

```bash
hermes cron add --name "hourly-summary" \
  --schedule "every 1h" \
  --prompt "Summarize the changes in the git repository since the last run. Focus on new features and bug fixes."
```

2. **Verify the job:**

```bash
hermes cron list
```

3. **Run the job immediately (for testing):**

```bash
hermes cron run hourly-summary
```

### Expected Output

```
$ hermes cron add --name "hourly-summary" \
  --schedule "every 1h" \
  --prompt "Summarize git changes since last run"
✅ Job created: hourly-summary
   Schedule: Every 1 hour
   Next run: 2026-05-26 13:00:00

$ hermes cron list
Scheduled Jobs:
┌────────────────────────────────────────────────────────────────┐
│ Name           | Schedule      | Next Run          | Status │
├────────────────────────────────────────────────────────────────┤
│ hourly-summary | Every 1 hour  | 2026-05-26 13:00  | ⏰ Ready │
└────────────────────────────────────────────────────────────────┘

$ hermes cron run hourly-summary
Running job: hourly-summary
[Agent processing...]
┊ Response:
╭─────────────────────────────────────────────────────────╮
│  # Git Changes Summary                                  │
│                                                         │
│  ## New Features                                        │
│  - Added Kanban board support (PR #2847)               │
│  - Implemented cron scheduler (PR #2901)               │
│                                                         │
│  ## Bug Fixes                                           │
│  - Fixed profile path resolution (PR #3575)            │
╰─────────────────────────────────────────────────────────╯
```

### 🎉 Success!
- [ ] Job created with hourly schedule
- [ ] Job appears in cron list
- [ ] Manual run produced output

## 📊 Progress Checkpoint

▓▓▓▓░░░░░░ 40% complete

---

## Exercise 9.2: Schedule Formats (5 minutes)

### Goal

Understand the supported schedule formats.

### Steps

1. **Create jobs with different schedule formats:**

```bash
# Duration format
hermes cron add --name "check-every-30m" \
  --schedule "30m" \
  --prompt "Check for new GitHub issues"

# ISO timestamp (one-shot)
hermes cron add --name "daily-report" \
  --schedule "2026-05-27T09:00:00Z" \
  --prompt "Generate a daily status report"

# Cron expression
hermes cron add --name "weekly-review" \
  --schedule "0 9 * * 1" \
  --prompt "Review all tasks completed this week"

# "every" phrase
hermes cron add --name "morning-brief" \
  --schedule "every monday 9am" \
  --prompt "Prepare a Monday morning briefing"
```

2. **Verify all jobs:**

```bash
hermes cron list
```

### Expected Output

```
$ hermes cron list
Scheduled Jobs:
┌──────────────────────────────────────────────────────────────────────┐
│ Name           | Schedule           | Next Run           | Status │
├──────────────────────────────────────────────────────────────────────┤
│ check-every-30m| 30m                | 2026-05-26 12:30   | ⏰ Ready │
│ daily-report   | 2026-05-27T09:00Z  | 2026-05-27 09:00   | ⏰ Ready │
│ weekly-review  | 0 9 * * 1          | 2026-06-01 09:00   | ⏰ Ready │
│ morning-brief  | every monday 9am   | 2026-06-01 09:00   | ⏰ Ready │
│ hourly-summary | Every 1 hour       | 2026-05-26 13:00   | ⏰ Ready │
└──────────────────────────────────────────────────────────────────────┘
```

### 🎉 Success!
- [ ] All four schedule formats accepted
- [ ] Next run times calculated correctly
- [ ] One-shot job shows single execution time

## 📊 Progress Checkpoint

▓▓▓▓▓▓░░░░ 60% complete

---

## Exercise 9.3: Advanced Job Configuration (5 minutes)

### Goal

Configure jobs with skills, model overrides, and scripts.

### Steps

1. **Create a job with skill loading:**

```bash
hermes cron add --name "code-review" \
  --schedule "every 2h" \
  --prompt "Review open pull requests and provide feedback" \
  --skills "github/code-review"
```

2. **Create a job with model override:**

```bash
hermes cron add --name "deep-analysis" \
  --schedule "0 6 * * *" \
  --prompt "Perform deep code analysis on the agent/ directory" \
  --model "claude-opus-4-20250514" \
  --provider "anthropic"
```

3. **Create a script-only job (no agent):**

```bash
hermes cron add --name "disk-check" \
  --schedule "every 6h" \
  --script "df -h / && du -sh ~/.hermes/ 2>/dev/null" \
  --no-agent
```

4. **View job details:**

```bash
hermes cron list
```

### Expected Output

```
$ hermes cron list
Scheduled Jobs:
┌──────────────────────────────────────────────────────────────────────────┐
│ Name         | Schedule     | Skills              | Model          │
├──────────────────────────────────────────────────────────────────────────┤
│ code-review  | Every 2 hours | github/code-review  | (default)      │
│ deep-analysis| 0 6 * * *    | (none)              | claude-opus-4  │
│ disk-check   | Every 6 hours | (none)              | N/A (script)   │
└──────────────────────────────────────────────────────────────────────────┘
```

### 🎉 Success!
- [ ] Job with skill loading created
- [ ] Job with model override created
- [ ] Script-only job created

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓░░ 80% complete

---

## Exercise 9.4: Job Management (3 minutes)

### Goal

Manage jobs — pause, resume, edit, and remove.

### Steps

1. **Pause a job:**

```bash
hermes cron pause disk-check
```

2. **Resume a job:**

```bash
hermes cron resume disk-check
```

3. **Edit a job:**

```bash
hermes cron edit hourly-summary \
  --prompt "Summarize ALL changes in the repository, including documentation updates"
```

4. **Remove a job:**

```bash
hermes cron remove check-every-30m
```

5. **View final state:**

```bash
hermes cron list
```

### Expected Output

```
$ hermes cron pause disk-check
⏸️  Job paused: disk-check

$ hermes cron resume disk-check
▶️  Job resumed: disk-check

$ hermes cron edit hourly-summary --prompt "..."
✏️  Job updated: hourly-summary

$ hermes cron remove check-every-30m
🗑️  Job removed: check-every-30m

$ hermes cron list
Scheduled Jobs:
┌────────────────────────────────────────────────────────────────┐
│ Name           | Schedule      | Next Run          | Status │
├────────────────────────────────────────────────────────────────┤
│ hourly-summary | Every 1 hour  | 2026-05-26 13:00  | ⏰ Ready │
│ daily-report   | 2026-05-27T09:00Z | 2026-05-27 09:00 | ⏰ Ready │
│ weekly-review  | 0 9 * * 1     | 2026-06-01 09:00  | ⏰ Ready │
│ morning-brief  | every monday 9am| 2026-06-01 09:00 | ⏰ Ready │
│ code-review    | Every 2 hours | 2026-05-26 14:00  | ⏰ Ready │
│ deep-analysis  | 0 6 * * *     | 2026-05-27 06:00  | ⏰ Ready │
│ disk-check     | Every 6 hours | 2026-05-26 18:00  | ⏰ Ready │
└────────────────────────────────────────────────────────────────┘
```

### 🎉 Success!
- [ ] Job paused and resumed
- [ ] Job prompt edited
- [ ] Job removed from schedule

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓▓▓ 100% complete

---

## 🏆 Lab Complete!

You've created cron jobs with multiple schedule formats, configured advanced options, and managed the full job lifecycle. You now understand Hermes' scheduling system.

## 🚀 Next Steps

- **[Lab 10: Performance Tuning](../10-performance/advanced/performance-tuning.md)** — Optimize agent speed and cost

## 💡 Pro Tips

- **3-minute hard interrupt** on cron sessions — runaway agents can't monopolize the scheduler
- **Catchup window:** half the job's period, clamped to 120s–2h
- **Grace window:** 120s for one-shot jobs whose fire time was missed
- **File lock** at `~/.hermes/cron/.tick.lock` prevents duplicate ticks
- Cron sessions pass `skip_memory=True` — memory providers don't run during cron
- Cron deliveries are **not** mirrored into target gateway sessions
- Use `context_from` to chain job A's output into job B's prompt
- Use `workdir` to run in a specific directory with its `AGENTS.md` loaded

## 🔗 Resources

- [Cron Documentation](../../capabilities/CRON.md)
- [System Design](../../architecture/SYSTEM_DESIGN.md)
- [AGENTS.md - Cron](../../../AGENTS.md)
