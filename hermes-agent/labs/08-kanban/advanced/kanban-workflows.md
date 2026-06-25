# Lab 08: Kanban Workflows

**Level**: Advanced | **Time**: 35 minutes | **Prerequisites**: [Lab 06](../06-delegation/intermediate/subagent-delegation.md)

## Pre-requisite Check

```bash
# Ensure the default kanban board is initialized (idempotent — safe to run anytime)
hermes kanban init

# Verify it lists (empty) tasks
hermes kanban list
```

## What You'll Build

You'll set up a Kanban board for multi-agent collaboration — creating tasks, assigning specialist profiles, and running the dispatcher.

## Quick Win (2 minutes)

```bash
# Create a new board for your project
hermes kanban boards create my-project

# Switch to it as your active board
hermes kanban boards switch my-project

# List the board (will be empty)
hermes kanban list
```

You'll see an empty board ready for tasks.

### Success!
- [ ] Board `my-project` created
- [ ] `hermes kanban list` shows `(no matching tasks)`
- [ ] Board directory created at `~/.hermes/kanban/boards/my-project/`

## Progress Checkpoint

20% complete

---

## Exercise 8.1: Create and Manage Tasks (5 minutes)

### Goal

Create tasks on the Kanban board and manage their lifecycle.

### Steps

1. **Create tasks** (title is positional; priority is an integer — higher = more urgent):

```bash
hermes kanban create "Refactor CLI input handling" --priority 10
hermes kanban create "Add Discord gateway adapter" --priority 5
hermes kanban create "Write unit tests for memory module" --priority 1
```

Note the task IDs returned — they use the format `t_` + 4 hex chars (e.g. `t_a3f7`). Save them for the next exercises.

2. **View the board:**

```bash
hermes kanban list
```

3. **Get task details** (replace `t_xxxx` with an actual task ID from step 1):

```bash
hermes kanban show t_xxxx
```

### Expected Output

```
$ hermes kanban create "Refactor CLI input handling" --priority 10
Created t_a3f7  (ready, assignee=-)

$ hermes kanban create "Add Discord gateway adapter" --priority 5
Created t_b2c8  (ready, assignee=-)

$ hermes kanban create "Write unit tests for memory module" --priority 1
Created t_d4e1  (ready, assignee=-)

$ hermes kanban list
▶ t_a3f7    ready     (unassigned)          Refactor CLI input handling
▶ t_b2c8    ready     (unassigned)          Add Discord gateway adapter
▶ t_d4e1    ready     (unassigned)          Write unit tests for memory module
```

Status icons: `◻ todo` | `▶ ready` | `● running` | `⏱ scheduled` | `⊘ blocked` | `✓ done` | `— archived`

### Success!
- [ ] Three tasks created with different priorities
- [ ] `hermes kanban list` shows all tasks (sorted by priority, highest first)
- [ ] Task details accessible via `show`

## Progress Checkpoint

40% complete

---

## Exercise 8.2: Assign Profiles to Tasks (5 minutes)

### Goal

Assign specialist profiles to handle specific tasks.

### Steps

1. **Create specialist profiles** (if they don't already exist):

```bash
hermes profile create coder
hermes profile create tester
```

2. **Assign tasks to profiles** (task_id and profile are both positional):

```bash
hermes kanban assign t_a3f7 coder
hermes kanban assign t_b2c8 coder
hermes kanban assign t_d4e1 tester
```

3. **View assignments:**

```bash
hermes kanban list
hermes kanban assignees
```

### Expected Output

```
$ hermes kanban assign t_a3f7 coder
Assigned t_a3f7 -> coder

$ hermes kanban list
▶ t_a3f7    ready     coder                 Refactor CLI input handling
▶ t_b2c8    ready     coder                 Add Discord gateway adapter
▶ t_d4e1    ready     tester                Write unit tests for memory module

$ hermes kanban assignees
NAME                ON DISK   COUNTS
coder               yes       ready=2
tester              yes       ready=1
```

### Success!
- [ ] Tasks assigned to profiles
- [ ] Assignments visible in board list
- [ ] `kanban assignees` shows per-profile task counts

## Progress Checkpoint

60% complete

---

## Exercise 8.3: Run the Dispatcher (5 minutes)

### Goal

Run the Kanban dispatcher to claim ready tasks and spawn worker agents.

### Background

The dispatcher runs inside the gateway by default (`kanban.dispatch_in_gateway: true`). It performs these steps each tick:

1. Reclaims stale claims (workers that died or timed out)
2. Promotes `todo` tasks to `ready` when their parent dependencies are done
3. Atomically claims `ready` tasks for their assigned profiles
4. Spawns worker agents: `hermes -p <profile> ...`

You can run a one-shot dispatch pass from the CLI:

```bash
hermes kanban dispatch
```

Or use `--dry-run` to preview what would happen without spawning:

```bash
hermes kanban dispatch --dry-run
```

### Steps

1. **Preview dispatch** (safe — doesn't modify state):

```bash
hermes kanban dispatch --dry-run
```

2. **Run an actual dispatch pass** (spawns workers for ready+assigned tasks):

```bash
hermes kanban dispatch
```

3. **Monitor task progress in another terminal:**

```bash
hermes kanban list
```

### Expected Output

```
$ hermes kanban dispatch --dry-run
Reclaimed:    0
Crashed:      0
Timed out:    0
Stale:        0
Auto-blocked: 0
Promoted:     0
Spawned:      3
  - t_a3f7  ->  coder  @ scratch (dry)
  - t_b2c8  ->  coder  @ scratch (dry)
  - t_d4e1  ->  tester  @ scratch (dry)

$ hermes kanban dispatch
Reclaimed:    0
Crashed:      0
Timed out:    0
Stale:        0
Auto-blocked: 0
Promoted:     0
Spawned:      3
  - t_a3f7  ->  coder  @ scratch
  - t_b2c8  ->  coder  @ scratch
  - t_d4e1  ->  tester  @ scratch

$ hermes kanban list
● t_a3f7    running   coder                 Refactor CLI input handling
● t_b2c8    running   coder                 Add Discord gateway adapter
● t_d4e1    running   tester                Write unit tests for memory module
```

### Dispatcher config (optional)

Key config options in `~/.hermes/config.yaml`:

```yaml
kanban:
  dispatch_in_gateway: true     # default — dispatcher runs in gateway
  failure_limit: 2              # auto-block after N consecutive failures
  default_assignee: coder       # fallback for unassigned ready tasks
  max_in_progress: 10           # global concurrency cap
  max_in_progress_per_profile: 3  # per-profile concurrency cap
```

### Success!
- [ ] `dispatch --dry-run` previews actions
- [ ] `dispatch` spawns workers for ready+assigned tasks
- [ ] Task status changes from `ready` to `running`

## Progress Checkpoint

80% complete

---

## Exercise 8.4: Task Lifecycle Management (3 minutes)

### Goal

Manage task states — block, complete, comment, and link tasks.

### Steps

1. **Block a task** (task_id positional, reason is positional text):

```bash
hermes kanban block t_b2c8 Waiting on Discord API docs
```

2. **Complete a task:**

```bash
hermes kanban complete t_a3f7 --result "Refactored input handling with argparse subcommands"
```

3. **Add a comment** (task_id positional, text is positional):

```bash
hermes kanban comment t_b2c8 Discord API v10 now available
```

4. **Link related tasks** (parent_id and child_id are positional — no --relation flag):

```bash
hermes kanban link t_b2c8 t_d4e1
```

5. **View final board state:**

```bash
hermes kanban list
hermes kanban stats
```

### Expected Output

```
$ hermes kanban block t_b2c8 Waiting on Discord API docs
Blocked t_b2c8 (reason: Waiting on Discord API docs)

$ hermes kanban complete t_a3f7 --result "Refactored input handling"
Completed t_a3f7

$ hermes kanban comment t_b2c8 Discord API v10 now available
Comment added to t_b2c8

$ hermes kanban link t_b2c8 t_d4e1
Linked t_b2c8 (parent) -> t_d4e1 (child)

$ hermes kanban list
✓ t_a3f7    done      coder                 Refactor CLI input handling
⊘ t_b2c8    blocked   coder                 Add Discord gateway adapter
▶ t_d4e1    todo      tester                Write unit tests for memory module

$ hermes kanban stats
By status:
  triage     0
  todo       1
  scheduled  0
  ready      0
  running    0
  blocked    1
  done       1

By assignee:
  coder              done=1, blocked=1
  tester             todo=1
```

Note: `t_d4e1` becomes `todo` after linking because its parent `t_b2c8` is not yet `done` — it's blocked. Once unblocked and completed, the next dispatch pass will promote it to `ready`.

### Success!
- [ ] Task blocked with reason text
- [ ] Task completed with result summary
- [ ] Comment appended
- [ ] Parent-child dependency created (child moves to `todo` until parent is `done`)

## Progress Checkpoint

100% complete

---

## Lab Complete!

You've created a Kanban board, added tasks, assigned profiles, run the dispatcher, and managed the full task lifecycle. You now understand multi-agent work queues in Hermes.

## Next Steps

- **[Lab 09: Cron Jobs](../09-cron/advanced/cron-jobs.md)** — Scheduled automation
- **[Lab 10: Performance Tuning](../10-performance/advanced/performance-tuning.md)** — Optimize agent speed and cost

## Pro Tips

- **Board** is the hard isolation boundary — workers on one board cannot see tasks on another
- **Tenant** is a soft namespace within a board for multi-workspace isolation
- Task IDs are auto-generated: `t_` + 8 hex chars (4 bytes)
- After `kanban.failure_limit` consecutive failures, tasks are auto-blocked
- Dispatcher runs inside the gateway by default — `hermes kanban daemon` is deprecated
- Dashboard at `plugins/kanban/dashboard/` provides a web UI for boards
- Use `hermes kanban tail <task_id>` to stream a task's event log
- Use `hermes kanban watch` to live-stream all board events to the terminal
- Use `hermes kanban unblock <task_ids>` to return blocked/scheduled tasks to `ready`
- Tasks with `--workspace worktree` get git worktrees; `--workspace scratch` gets a temp dir
- The `--goal` flag on `kanban create` runs the worker in a judge loop until complete

## Resources

- [Kanban Documentation](../../capabilities/KANBAN.md)
- [Delegation Documentation](../../capabilities/DELEGATION.md)
- [AGENTS.md - Kanban](../../../AGENTS.md)
