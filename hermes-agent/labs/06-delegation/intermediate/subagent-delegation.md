# Lab 06: Subagent Delegation

**Level**: Intermediate | **Time**: 25 minutes | **Prerequisites**: [Lab 02 Beginner](../02-tools-and-skills/beginner/tools-basics.md)

## ⚡ Pre-requisite Check

```bash
hermes --version  # Hermes should be installed
# Verify delegation is enabled in config
grep -A5 "delegation:" ~/.hermes/config.yaml || echo "No delegation config (will use defaults)"
```

## 🎯 What You'll Build

You'll spawn isolated subagents to handle parallel workstreams — delegating complex tasks while maintaining control.

## ⚡ Quick Win (2 minutes)

```bash
hermes
# Type: Delegate a task to summarize the README.md file in the current directory
```

Hermes will spawn a subagent with an isolated context, read the file, and return a summary.

### 🎉 Success!
- [ ] Subagent spawned automatically
- [ ] Task delegated and executed
- [ ] Summary returned to parent agent

## 📊 Progress Checkpoint

▓▓░░░░░░░░ 20% complete

---

## Exercise 6.1: Single Delegation (5 minutes)

### Goal

Delegate a focused task to a leaf subagent.

### Steps

1. **Launch Hermes:**

```bash
hermes
```

2. **Delegate a task:**

```
Use delegate_task to create a summary of all Python files in the tools/ directory. The subagent should list each file and its purpose.
```

3. **Observe the delegation flow:**
   - Parent agent spawns a child with `role="leaf"`
   - Child has isolated context and terminal session
   - Child cannot call `delegate_task`, `clarify`, `memory`, or `send_message`
   - Parent waits for child's summary synchronously

### Expected Output

```
┊ delegate_task(
┊   goal="Summarize all Python files in tools/ directory",
┊   role="leaf"
┊ )
┊ [Subagent spawned — isolated context]
┊ [Subagent: read_file(tools/registry.py)]
┊ [Subagent: search_files(path="tools/", file_pattern="*.py")]
┊ [Subagent complete — returning summary]
┊ Response:
╭─────────────────────────────────────────────────────────╮
│  # Tools Directory Summary                             │
│                                                         │
│  - registry.py: Central tool registry for registration  │
│  - terminal_tool.py: Shell execution backend           │
│  - file_tool.py: File read/write/patch operations      │
│  - search_tool.py: File and code search               │
│  - web_tool.py: Web search and extraction              │
│  - delegate_tool.py: Subagent delegation system        │
╰─────────────────────────────────────────────────────────╯
```

### 🎉 Success!
- [ ] Subagent spawned with `role="leaf"`
- [ ] Child executed task in isolation
- [ ] Summary returned to parent

## 📊 Progress Checkpoint

▓▓▓▓░░░░░░ 40% complete

---

## Exercise 6.2: Parallel Batch Delegation (5 minutes)

### Goal

Delegate multiple tasks to run in parallel.

### Steps

1. **Request parallel delegation:**

```
I need three things done in parallel:
1. Count lines of code in agent/ directory
2. Count lines of code in tools/ directory
3. Count lines of code in gateway/ directory

Use batch delegation to run these simultaneously.
```

2. **Observe parallel execution:**
   - Three subagents spawned concurrently
   - Concurrency capped by `delegation.max_concurrent_children` (default: 3)
   - All three run in parallel and return results

### Expected Output

```
┊ delegate_task(
┊   tasks=[
┊     {"goal": "Count LOC in agent/"},
┊     {"goal": "Count LOC in tools/"},
┊     {"goal": "Count LOC in gateway/"}
┊   ]
┊ )
┊ [3 subagents spawned — running in parallel]
┊ [Subagent 1: agent/ — 25,430 lines]
┊ [Subagent 2: tools/ — 12,850 lines]
┊ [Subagent 3: gateway/ — 18,200 lines]
┊ Response:
╭─────────────────────────────────────────────────────────╮
│  # Lines of Code by Directory                          │
│                                                         │
│  | Directory | Lines of Code |                         │
│  |-----------|---------------|                         │
│  | agent/    | 25,430        | Core agent internals    │
│  | tools/    | 12,850        | Tool implementations    │
│  | gateway/  | 18,200        | Messaging gateway       │
│  | TOTAL     | 56,480        |                         │
╰─────────────────────────────────────────────────────────╯
```

### 🎉 Success!
- [ ] Three subagents ran in parallel
- [ ] Concurrency limit respected (max 3)
- [ ] All results aggregated

## 📊 Progress Checkpoint

▓▓▓▓▓▓░░░░ 60% complete

---

## Exercise 6.3: Delegation Configuration (5 minutes)

### Goal

Configure delegation behavior through `config.yaml`.

### Steps

1. **Add delegation settings:**

```bash
nano ~/.hermes/config.yaml
```

```yaml
delegation:
  max_concurrent_children: 3      # Parallel subagent limit
  max_spawn_depth: 2              # Nesting depth limit
  child_timeout_seconds: 300      # 5 min timeout per child
  orchestrator_enabled: true      # Allow orchestrator role
  subagent_auto_approve: false    # Require approval for subagents
  inherit_mcp_toolsets: true      # Share MCP tools with children
  max_iterations: 50              # Per-subagent iteration limit
```

2. **Test with orchestrator role:**

```bash
hermes
# Type: Use an orchestrator subagent to plan and execute a code review of cli.py
```

3. **Observe orchestrator behavior:**
   - Orchestrator CAN call `delegate_task` (spawns its own workers)
   - Gated by `delegation.orchestrator_enabled`
   - Bounded by `delegation.max_spawn_depth` (default: 2)

### Expected Output

```
┊ delegate_task(
┊   goal="Plan and execute code review of cli.py",
┊   role="orchestrator"
┊ )
┊ [Orchestrator spawned — can delegate further]
┊ [Orchestrator: delegating to worker 1 — analyze imports]
┊ [Orchestrator: delegating to worker 2 — check error handling]
┊ [Worker 1 complete]
┊ [Worker 2 complete]
┊ [Orchestrator: compiling review]
┊ Response:
╭─────────────────────────────────────────────────────────╮
│  # Code Review: cli.py                                 │
│                                                         │
│  ## Imports                                            │
│  ✅ All imports properly organized                     │
│  ⚠️  Consider lazy-loading heavy dependencies          │
│                                                         │
│  ## Error Handling                                      │
│  ✅ Try/except blocks cover external calls             │
│  ⚠️  Some exceptions swallowed without logging         │
╰─────────────────────────────────────────────────────────╯
```

### 🎉 Success!
- [ ] Delegation config applied
- [ ] Orchestrator spawned and delegated further
- [ ] Spawn depth respected

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓░░ 80% complete

---

## Exercise 6.4: Delegation Limitations (3 minutes)

### Goal

Understand when NOT to use delegation.

### Steps

1. **Review the synchronicity rule:**

`delegate_task` is **synchronous** — the parent waits for the child. If the parent is interrupted, the child is cancelled.

2. **Test interruption:**

```bash
hermes
# Type: Delegate a task to count all files in /usr/share/doc (this will take a while)
# Wait for subagent to start, then press Ctrl+C
```

3. **Compare with durable alternatives:**

For long-running work that must outlive the current turn:
- Use `cronjob` for scheduled tasks
- Use `terminal(background=True, notify_on_complete=True)` for background processes

### Expected Output

```
┊ delegate_task(goal="Count files in /usr/share/doc")
┊ [Subagent spawned...]
^C
┊ Interrupt received — cancelling subagent
┊ Subagent cancelled. No results returned.
```

### 🎉 Success!
- [ ] Subagent cancelled on parent interrupt
- [ ] Synchronous behavior confirmed
- [ ] Durable alternatives identified

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓▓▓ 100% complete

---

## 🏆 Lab Complete!

You've mastered subagent delegation — single tasks, parallel batches, orchestrator patterns, and configuration. You understand when to delegate and when to use durable alternatives.

## 🚀 Next Steps

- **[Lab 07: Plugin Development](../07-plugins/advanced/plugin-development.md)** — Build custom plugins
- **[Lab 08: Kanban Workflows](../08-kanban/advanced/kanban-workflows.md)** — Multi-agent work queues

## 💡 Pro Tips

- `delegate_task` is synchronous — parent waits, child cancelled on interrupt
- For durable work, use `cronjob` or `terminal(background=True)` instead
- Leaf role cannot call `delegate_task`, `clarify`, `memory`, or `send_message`
- Orchestrator role CAN delegate further (bounded by `max_spawn_depth`)
- `_last_resolved_tool_names` is process-global — save/restore around subagent execution

## 🔗 Resources

- [Delegation Documentation](../../../capabilities/DELEGATION.md)
- [System Design](../../../architecture/SYSTEM_DESIGN.md)
- [AGENTS.md - Delegation](../../../../AGENTS.md)
