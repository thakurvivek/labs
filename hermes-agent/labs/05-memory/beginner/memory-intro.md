# Lab 05: Memory Introduction

**Level**: Beginner | **Time**: 20 minutes | **Prerequisites**: [Lab 01](../01-getting-started/beginner/getting-started.md), [Lab 03](../03-configuration/beginner/config-basics.md)

## ⚡ Pre-requisite Check

```bash
hermes --version  # Hermes should be installed
hermes memory --help  # Memory command should be available
```

If Hermes is not installed, complete Lab 01 first.

## 🎯 What You'll Build

You'll enable Hermes' memory system, which allows the agent to remember information across sessions. You'll understand the memory provider architecture and basic configuration.

## ⚡ Quick Win (2 minutes)

```bash
hermes memory --help
```

You'll see all available memory commands and providers.

### 🎉 Success!
- [ ] Memory help displayed
- [ ] Available providers listed
- [ ] Command options visible

## 📊 Progress Checkpoint

▓▓░░░░░░░░ 20% complete

---

## Exercise 5.1: Memory Architecture (5 minutes)

### Goal

Understand the memory system architecture and provider pattern.

### Steps

1. **Review the memory architecture:**

The memory system consists of:
- **Memory Manager** (`agent/memory_manager.py`): Orchestrates memory operations
- **Memory Providers** (`plugins/memory/`): Pluggable backends (honcho, mem0, supermemory, etc.)
- **Memory Provider ABC** (`agent/memory_provider.py`): Interface all providers implement
- **Session Integration**: Memory is automatically synced during conversations

2. **List available memory providers:**

```bash
hermes memory --help | grep -A 20 "Providers"
```

3. **Understand the provider pattern:**
   - Each provider implements the same interface
   - Providers are discovered automatically
   - Switch providers without changing agent code

### Expected Output

```
Available Memory Providers:
  honcho        - Honcho memory backend
  mem0          - Mem0 memory backend
  supermemory   - Supermemory backend
  byterover     - Byterover backend
  hindsight     - Hindsight backend
  holographic   - Holographic backend
  retaindb      - RetainDB backend
```

### 🔗 Evolution Reference

The memory provider system is documented in **ARCH-653**: Context Engine ABC. The abstract base class ensures consistent behavior across all providers.

### 🎉 Success!
- [ ] Memory architecture understood
- [ ] Available providers listed
- [ ] Provider pattern clear

## 📊 Progress Checkpoint

▓▓▓▓░░░░░░ 40% complete

---

## Exercise 5.2: Configure Memory Provider (5 minutes)

### Goal

Configure Hermes to use a memory provider.

### Steps

1. **Edit your config file:**

```bash
nano ~/.hermes/config.yaml
```

2. **Add memory configuration:**

```yaml
memory:
  enabled: true
  provider: "honcho"
  honcho:
    api_key: "YOUR_HONCHO_API_KEY"
```

3. **Add your API key to `.env`:**

```bash
echo 'HONCHO_API_KEY=your-key-here' >> ~/.hermes/.env
```

4. **Verify the configuration:**

```bash
hermes memory --check-config
```

### Expected Output

```
✓ Memory configuration valid
✓ Honcho provider selected
✓ API key found
```

### 🎉 Success!
- [ ] Memory configuration added
- [ ] Provider configured
- [ ] Configuration validation passed

## 📊 Progress Checkpoint

▓▓▓▓▓▓░░░░ 60% complete

---

## Exercise 5.3: Test Memory in Conversation (5 minutes)

### Goal

Verify that memory works during a conversation.

### Steps

1. **Launch Hermes:**

```bash
hermes
```

2. **Tell Hermes something to remember:**

```
My name is Alice and I work as a software engineer.
```

3. **Start a new session:**

```
/new
```

4. **Ask Hermes to recall:**

```
What is my name and what do I do?
```

5. **Observe the memory retrieval:**
   - Hermes should recall your name and job
   - Memory is synced automatically
   - Cross-session persistence works

### Expected Output

```
┊ Memory sync: Storing "My name is Alice..."
┊ Response: Got it! I'll remember that.

/new
┊ New session started

What is my name and what do I do?
┊ Memory prefetch: Searching for "name job"
┊ Memory found: "My name is Alice and I work as a software engineer."
┊ Response: Your name is Alice and you work as a software engineer.
```

### 🔗 Evolution Reference

Memory synchronization is documented in **DES-282**: Memory sync patterns. The system automatically syncs memory during conversations.

### 🎉 Success!
- [ ] Memory stored during conversation
- [ ] New session started
- [ ] Memory retrieved across sessions
- [ ] Cross-session persistence verified

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓░░ 80% complete

---

## Exercise 5.4: Memory CLI Commands (3 minutes)

### Goal

Use memory CLI commands to manage memory directly.

### Steps

1. **Check memory status:**

```bash
hermes memory status
```

2. **Search memory:**

```bash
hermes memory search "software engineer"
```

3. **Clear memory (optional):**

```bash
hermes memory clear
```

4. **Understand the CLI interface:**
   - Direct memory management outside conversations
   - Search and query capabilities
   - Memory provider operations

### Expected Output

```
hermes memory status
Memory Provider: honcho
Total Memories: 15
Last Sync: 2026-06-02 02:00:00

hermes memory search "software engineer"
Found 2 memories:
1. "My name is Alice and I work as a software engineer."
2. "Alice is a software engineer who likes Python."
```

### 🎉 Success!
- [ ] Memory status displayed
- [ ] Memory search returned results
- [ ] CLI commands working
- [ ] Memory management understood

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓▓▓ 100% complete

---

## 🏆 Lab Complete!

You've learned about Hermes' memory system:

- **Architecture**: Pluggable memory providers with unified interface
- **Configuration**: Provider selection and API key setup
- **Conversation Integration**: Automatic memory sync during conversations
- **CLI Commands**: Direct memory management and search

## 🚀 Next Steps

- [Lab 05 Intermediate: Memory Providers](../05-memory/intermediate/memory-providers.md) - Advanced memory configuration
- [Lab 06: Subagent Delegation](../06-delegation/intermediate/subagent-delegation.md) - Use memory with subagents

## 💡 Pro Tips

- **Choose the right provider** - Honcho for general use, mem0 for RAG, supermemory for web
- **Test memory sync** - Verify cross-session persistence before relying on it
- **Use memory search** - Query memory directly to understand what's stored
- **Profile isolation** - Each profile has its own memory, no cross-profile leakage

## 🔗 Resources

- [Memory Manager](../../agent/memory_manager.py) - Memory orchestration
- [Memory Providers](../../plugins/memory/) - Provider implementations
- [Memory Provider ABC](../../agent/memory_provider.py) - Provider interface
- [AGENTS.md](../../AGENTS.md) - Memory system section

## 🔗 Evolution Decisions Covered

| Decision | Date | Topic |
|----------|------|-------|
| ARCH-653 | 2026-04-11 | Context Engine ABC |
| DES-282 | 2026-04-XX | Memory sync patterns |
| Multiple | Various | Memory provider decisions |