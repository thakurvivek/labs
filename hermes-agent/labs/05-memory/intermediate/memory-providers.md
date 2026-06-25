# Lab 05: Memory Providers

**Level**: Intermediate | **Time**: 25 minutes | **Prerequisites**: [Lab 03 Beginner](../03-configuration/beginner/config-basics.md)

## ⚡ Pre-requisite Check

```bash
hermes memory status  # Should display memory status (even if disabled)
ls plugins/memory/    # Should list memory provider directories
```

If memory commands are unavailable, verify your Hermes installation includes memory plugins.

## 🎯 What You'll Build

You'll enable cross-session memory so Hermes remembers facts, preferences, and context across conversations.

## ⚡ Quick Win (2 minutes)

```bash
# Check current memory status
hermes memory status
```

You'll see which memory provider is active (if any) and how many memories are stored.

### 🎉 Success!
- [ ] Memory status command works
- [ ] Current provider displayed
- [ ] Memory count shown

## 📊 Progress Checkpoint

▓▓░░░░░░░░ 20% complete

---

## Exercise 5.1: Enable Honcho Memory (5 minutes)

### Goal

Set up Honcho — the dialectic user modeling memory provider.

### Steps

1. **Configure Honcho in config.yaml:**

```bash
nano ~/.hermes/config.yaml
```

```yaml
memory:
  enabled: true
  provider: honcho
  # Honcho-specific settings
  honcho:
    sync_interval: 30      # Sync every 30 turns
    max_memories: 1000     # Cap stored memories
```

2. **Run the memory setup wizard:**

```bash
hermes memory setup
```

3. **Verify memory is active:**

```bash
hermes
# Type: Remember that my favorite programming language is Python
```

### Expected Output

```
$ hermes memory status
Memory: Enabled
Provider: honcho
Memories stored: 0
Last sync: Never

$ hermes
# Remember that my favorite programming language is Python
┊ memory_add(fact="favorite programming language is Python")
┊ Response: Got it! I'll remember that Python is your favorite language.
```

### 🎉 Success!
- [ ] Honcho provider configured
- [ ] Memory setup completed
- [ ] First fact stored successfully

## 📊 Progress Checkpoint

▓▓▓▓░░░░░░ 40% complete

---

## Exercise 5.2: Memory Search and Recall (5 minutes)

### Goal

Test memory retrieval across sessions.

### Steps

1. **Store some facts:**

```bash
hermes
# Type: I work as a software engineer at a startup. I prefer dark mode. My timezone is UTC+5:30.
```

2. **Start a new session:**

```bash
hermes /new
# Type: What do you know about me?
```

3. **Search memories:**

```bash
hermes memory search "programming"
```

### Expected Output

```
$ hermes /new
# What do you know about me?
┊ memory_search(query="user profile")
┊ Response:
╭─────────────────────────────────────────────────────────╮
│  Based on my memory, I know:                           │
│                                                         │
│  - Your favorite programming language is Python        │
│  - You work as a software engineer at a startup        │
│  - You prefer dark mode                                │
│  - Your timezone is UTC+5:30                           │
╰─────────────────────────────────────────────────────────╯

$ hermes memory search "programming"
Found 1 memory:
  - favorite programming language is Python (confidence: 0.95)
```

### 🎉 Success!
- [ ] Facts persisted across sessions
- [ ] Memory search returned relevant results
- [ ] Hermes recalled stored information

## 📊 Progress Checkpoint

▓▓▓▓▓▓░░░░ 60% complete

---

## Exercise 5.3: Session Search with FTS5 (5 minutes)

### Goal

Use FTS5-powered session search to find past conversations.

### Steps

1. **List recent sessions:**

```bash
hermes sessions list
```

2. **Browse sessions with filters:**

```bash
hermes sessions browse --source telegram --limit 10
```

3. **FTS5 session search (via agent tool):**

> Note: FTS5 session search is available as the `session_search` agent tool, not as a CLI subcommand. Use it in conversation:

```
# In a Hermes conversation, the agent can use:
session_search(query="memory configuration")
```

### Expected Output

```
$ hermes sessions list
Preview                                            Last Active   Src    ID
───────────────────────────────────────────────────────────────────────────────────────────────
What do you know about me?                         2h ago        cli    20260528_101228_865b0b
Today I'll perform some exercises...               3h ago        cli    20260528_060550_4fee8c
```

### 🎉 Success!
- [ ] `hermes sessions list` shows recent sessions
- [ ] `hermes sessions browse` filters by source
- [ ] FTS5 search works via the `session_search` agent tool in conversations

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓░░ 80% complete

---

## Exercise 5.4: Switch Memory Providers (3 minutes)

### Goal

Understand how to switch between memory providers.

### Steps

1. **List available providers:**

```bash
ls plugins/memory/
```

You'll see: `honcho/`, `mem0/`, `supermemory/`, `byterover/`, `hindsight/`, `holographic/`, `openviking/`, `retaindb/`

2. **Switch to Mem0:**

```yaml
memory:
  enabled: true
  provider: mem0
```

3. **Run setup for the new provider:**

```bash
hermes memory setup
```

### Expected Output

```
$ ls plugins/memory/
honcho/  mem0/  supermemory/  byterover/  hindsight/
holographic/  openviking/  retaindb/

$ hermes memory setup
Setting up mem0 memory provider...
✅ Mem0 configured successfully
Memories migrated: 0 (new provider)
```

### 🎉 Success!
- [ ] All 8 memory providers listed
- [ ] Provider switched in config
- [ ] New provider setup completed

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓▓▓ 100% complete

---

## 🏆 Lab Complete!

You've enabled cross-session memory with Honcho, tested memory recall, used FTS5 session search, and learned to switch providers. Hermes now remembers across conversations.

## 🚀 Next Steps

- **[Lab 06: Subagent Delegation](../06-delegation/intermediate/subagent-delegation.md)** — Spawn parallel subagents
- **[Lab 07: Plugin Development](../07-plugins/advanced/plugin-development.md)** — Build custom plugins

## 💡 Pro Tips

- Memory providers implement the `MemoryProvider` ABC in `agent/memory_provider.py`
- `agent/memory_manager.py` orchestrates all memory providers
- CLI commands per provider live in `plugins/memory/<name>/cli.py`
- Only the **active** provider's CLI commands are exposed in `hermes --help`
- No new in-tree memory providers are accepted — publish as standalone repos

## 🔗 Resources

- [Memory Documentation](../../capabilities/MEMORY.md)
- [Plugin System](../../capabilities/PLUGINS.md)
- [AGENTS.md - Memory Providers](../../../AGENTS.md)
