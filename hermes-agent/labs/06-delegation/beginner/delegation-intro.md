# Lab 06: Delegation Introduction

**Level**: Beginner | **Time**: 20 minutes | **Prerequisites**: [Lab 01](../01-getting-started/beginner/getting-started.md), [Lab 02](../02-tools-and-skills/beginner/tools-basics.md)

## ⚡ Pre-requisite Check

```bash
hermes --version  # Hermes should be installed
hermes --help | grep delegate  # Delegation should be available
```

If Hermes is not installed, complete Lab 01 first.

## 🎯 What You'll Build

You'll use Hermes' delegation system to spawn subagents for complex tasks. You'll understand the delegation architecture and how subagents work with isolated context.

## ⚡ Quick Win (2 minutes)

```bash
hermes
```

Then ask:
```
Delegate a task to summarize the current directory structure.
```

### 🎉 Success!
- [ ] Delegation command recognized
- [ ] Subagent spawned
- [ ] Summary returned

## 📊 Progress Checkpoint

▓▓░░░░░░░░ 20% complete

---

## Exercise 6.1: Delegation Architecture (5 minutes)

### Goal

Understand the delegation system architecture and subagent model.

### Steps

1. **Review the delegation architecture:**

The delegation system consists of:
- **Delegate Tool** (`tools/delegate_tool.py`): Spawns and manages subagents
- **Subagent Isolation**: Each subagent has isolated context and terminal session
- **Synchronous Execution**: Parent waits for child to complete
- **Role System**: `leaf` (worker) and `orchestrator` (can spawn more subagents)

2. **Understand the delegation flow:**
   - Parent agent receives a task
   - Parent spawns a subagent with isolated context
   - Subagent executes the task independently
   - Subagent returns a summary to parent
   - Parent continues with the summary

3. **Key configuration options:**
   - `max_concurrent_children`: Maximum parallel subagents (default: 3)
   - `max_spawn_depth`: Maximum nesting depth (default: 2)
   - `child_timeout_seconds`: Timeout per subagent
   - `orchestrator_enabled`: Allow subagents to spawn more subagents

### Expected Output

```
Delegation Flow:
Parent Agent
  ↓ spawn_subagent(goal="...")
Subagent (isolated context)
  ↓ execute task
  ↓ return summary
Parent Agent
  ↓ continue with summary
```

### 🔗 Evolution Reference

The delegation system is documented in **DES-264**: Delegation patterns. The synchronous model ensures predictable behavior.

### 🎉 Success!
- [ ] Delegation architecture understood
- [ ] Flow clear
- [ ] Configuration options known

## 📊 Progress Checkpoint

▓▓▓▓░░░░░░ 40% complete

---

## Exercise 6.2: Single Task Delegation (5 minutes)

### Goal

Delegate a single task to a subagent.

### Steps

1. **Launch Hermes:**

```bash
hermes
```

2. **Delegate a simple task:**

```
Delegate a task to list all Python files in the current directory.
```

3. **Observe the delegation process:**
   - Parent spawns subagent
   - Subagent executes independently
   - Subagent returns summary
   - Parent displays results

4. **Understand the isolation:**
   - Subagent has its own terminal session
   - Subagent cannot access parent's context
   - Only summary is shared back

### Expected Output

```
┊ delegate_task(goal="List all Python files in current directory")
┊ Spawning subagent...
┊ Subagent executing...
┊ Subagent summary: "Found 15 Python files: cli.py, run_agent.py, ..."
┊ Result: Found 15 Python files in current directory
```

### 🎉 Success!
- [ ] Subagent spawned successfully
- [ ] Task executed independently
- [ ] Summary returned to parent
- [ ] Isolation understood

## 📊 Progress Checkpoint

▓▓▓▓▓▓░░░░ 60% complete

---

## Exercise 6.3: Batch Delegation (5 minutes)

### Goal

Delegate multiple tasks in parallel using batch mode.

### Steps

1. **Launch Hermes:**

```bash
hermes
```

2. **Delegate multiple tasks:**

```
Delegate these tasks in parallel:
1. List all Python files in the current directory
2. List all Markdown files in the current directory
3. Count the total number of files
```

3. **Observe parallel execution:**
   - Multiple subagents spawned
   - Tasks execute concurrently
   - Results collected and combined
   - Parent displays combined summary

4. **Understand concurrency limits:**
   - Default: 3 concurrent subagents
   - Configurable via `delegation.max_concurrent_children`
   - Additional tasks queue until a slot is available

### Expected Output

```
┊ delegate_task(tasks=[...])
┊ Spawning 3 subagents in parallel...
┊ Subagent 1: Listing Python files...
┊ Subagent 2: Listing Markdown files...
┊ Subagent 3: Counting files...
┊ All subagents completed
┊ Combined summary: "Found 15 Python files, 8 Markdown files, 23 total files"
```

### 🔗 Evolution Reference

Batch delegation is documented in **DES-264**: Delegation patterns. The parallel execution model maximizes throughput.

### 🎉 Success!
- [ ] Multiple subagents spawned
- [ ] Tasks executed in parallel
- [ ] Results combined correctly
- [ ] Concurrency limits understood

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓░░ 80% complete

---

## Exercise 6.4: Delegation Configuration (3 minutes)

### Goal

Configure delegation behavior in config.yaml.

### Steps

1. **Edit your config file:**

```bash
nano ~/.hermes/config.yaml
```

2. **Add delegation configuration:**

```yaml
delegation:
  max_concurrent_children: 5
  max_spawn_depth: 3
  child_timeout_seconds: 300
  orchestrator_enabled: true
  subagent_auto_approve: false
```

3. **Understand each setting:**
   - `max_concurrent_children`: Maximum parallel subagents
   - `max_spawn_depth`: Maximum nesting depth (orchestrator mode)
   - `child_timeout_seconds`: Timeout per subagent
   - `orchestrator_enabled`: Allow subagents to spawn more subagents
   - `subagent_auto_approve`: Auto-approve subagent tasks

4. **Verify the configuration:**

```bash
hermes --check-config
```

### Expected Output

```
✓ Delegation configuration valid
✓ Max concurrent children: 5
✓ Max spawn depth: 3
✓ Child timeout: 300s
✓ Orchestrator enabled: true
```

### 🎉 Success!
- [ ] Delegation configuration added
- [ ] Each setting understood
- [ ] Configuration validated

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓▓▓ 100% complete

---

## 🏆 Lab Complete!

You've learned about Hermes' delegation system:

- **Architecture**: Subagent spawning with isolated context
- **Single Task**: Delegate one task to a subagent
- **Batch Delegation**: Parallel execution of multiple tasks
- **Configuration**: Control delegation behavior via config.yaml

## 🚀 Next Steps

- [Lab 06 Intermediate: Subagent Delegation](../06-delegation/intermediate/subagent-delegation.md) - Advanced delegation patterns
- [Lab 08: Kanban Workflows](../08-kanban/advanced/kanban-workflows.md) - Multi-agent work queues

## 💡 Pro Tips

- **Use batch delegation** for independent tasks to maximize parallelism
- **Set appropriate timeouts** to prevent runaway subagents
- **Enable orchestrator mode** for complex multi-level task decomposition
- **Monitor subagent output** to understand what's happening

## 🔗 Resources

- [Delegate Tool](../../tools/delegate_tool.py) - Delegation implementation
- [AGENTS.md](../../AGENTS.md) - Delegation section
- [Evolution Decisions](../evolve/DECISION_TRACE_INDEX.md) - Delegation decisions (DES-264)

## 🔗 Evolution Decisions Covered

| Decision | Date | Topic |
|----------|------|-------|
| DES-264 | 2026-04-XX | Delegation patterns |
| Multiple | Various | Subagent isolation decisions |