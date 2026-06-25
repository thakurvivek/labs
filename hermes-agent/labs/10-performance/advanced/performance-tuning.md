# Lab 10: Performance Tuning

**Level**: Advanced | **Time**: 35 minutes | **Prerequisites**: [Lab 03 Beginner](../03-configuration/beginner/config-basics.md), [Lab 06](../06-delegation/intermediate/subagent-delegation.md)

## ⚡ Pre-requisite Check

```bash
hermes --version  # Hermes should be installed and configured
grep -E "smart_model_routing|compression|delegation:" ~/.hermes/config.yaml || echo "No performance config yet (will add in this lab)"
```

## 🎯 What You'll Build

You'll optimize Hermes Agent for speed and cost — tuning model selection, compression, iteration budgets, and parallel execution.

## ⚡ Quick Win (2 minutes)

```bash
# Check current performance settings
hermes
# Type: What are my current performance settings? Show max_iterations, compression, and delegation config.
```

You'll see your current configuration and baseline metrics to optimize from.

### 🎉 Success!
- [ ] Current settings displayed
- [ ] Baseline metrics captured
- [ ] Optimization targets identified

## 📊 Progress Checkpoint

▓▓░░░░░░░░ 20% complete

---

## Exercise 10.1: Model Selection for Cost/Speed (5 minutes)

### Goal

Use smart model routing to balance cost and speed.

### Steps

1. **Configure smart model routing:**

```bash
nano ~/.hermes/config.yaml
```

```yaml
# Primary model for complex tasks
model: "claude-sonnet-4-20250514"
provider: "anthropic"

# Smart routing — use cheaper models for simple tasks
smart_model_routing:
  enabled: true
  rules:
    - condition: "simple"        # Short, straightforward queries
      model: "claude-haiku"
      provider: "anthropic"
    - condition: "coding"        # Code generation and review
      model: "claude-sonnet-4-20250514"
      provider: "anthropic"
    - condition: "reasoning"     # Complex analysis
      model: "claude-opus-4-20250514"
      provider: "anthropic"
```

2. **Configure auxiliary models for side tasks:**

```yaml
auxiliary:
  curator:
    model: "claude-haiku"
    provider: "anthropic"
  vision:
    model: "claude-sonnet-4-20250514"
    provider: "anthropic"
  embedding:
    model: "text-embedding-3-small"
    provider: "openai"
  title_generation:
    model: "claude-haiku"
    provider: "anthropic"
  session_search:
    model: "claude-haiku"
    provider: "anthropic"
```

3. **Test routing:**

```bash
hermes
# Type: What is 2+2? (should route to haiku)
# Type: Write a Python function to parse YAML (should route to sonnet)
# Type: Analyze the architectural trade-offs of microservices vs monolith (should route to opus)
```

### Expected Output

```
┊ [Routing: simple → claude-haiku]
┊ Response: 2 + 2 = 4

┊ [Routing: coding → claude-sonnet-4-20250514]
┊ Response:
def parse_yaml(content: str) -> dict:
    import yaml
    return yaml.safe_load(content)

┊ [Routing: reasoning → claude-opus-4-20250514]
┊ Response:
The architectural trade-offs between microservices and monoliths...
[detailed analysis]
```

### 🎉 Success!
- [ ] Simple queries routed to cheap model
- [ ] Coding tasks routed to capable model
- [ ] Complex reasoning routed to premium model

## 📊 Progress Checkpoint

▓▓▓▓░░░░░░ 40% complete

---

## Exercise 10.2: Context Compression (5 minutes)

### Goal

Enable and tune context compression to reduce token usage.

### Steps

1. **Configure compression:**

```yaml
compression:
  enabled: true
  trigger_threshold: 0.7        # Compress when context > 70% of limit
  max_compressed_tokens: 4096   # Cap compressed context size
  strategy: "summary"           # summary | truncate | hybrid
```

2. **Test compression in a long conversation:**

```bash
hermes
# Type a series of messages to build up context:
# 1. "Explain the history of Python programming language in detail"
# 2. "Now explain the history of JavaScript"
# 3. "Now explain the history of Rust"
# 4. "Summarize the key differences between Python, JavaScript, and Rust"
```

3. **Check compression in logs:**

```bash
grep -i "compress" ~/.hermes/logs/agent.log | tail -5
```

### Expected Output

```
2026-05-26 12:00:00 INFO  Context size: 35,420 / 50,000 tokens (70.8%)
2026-05-26 12:00:00 INFO  Compression triggered — strategy: summary
2026-05-26 12:00:01 INFO  Compressed context: 35,420 → 3,847 tokens (89.1% reduction)
2026-05-26 12:00:01 INFO  Compression feasibility: OK (deferred check passed)
```

### 🎉 Success!
- [ ] Compression triggered at threshold
- [ ] Context reduced significantly
- [ ] Conversation continuity maintained

## 📊 Progress Checkpoint

▓▓▓▓▓▓░░░░ 60% complete

---

## Exercise 10.3: Iteration Budget Tuning (5 minutes)

### Goal

Optimize iteration budgets for different task types.

### Steps

1. **Configure iteration budgets:**

```yaml
agent:
  max_iterations: 90            # Default iterations
  iteration_budget:
    enabled: true
    default: 90
    per_task:
      simple: 10                # Quick answers
      coding: 60                # Code generation
      research: 120             # Deep research
      debugging: 80             # Debugging sessions
```

2. **Test with different task types:**

```bash
hermes
# Simple task (should complete in 1-2 iterations)
# Type: What is the capital of France?

# Coding task (should use multiple iterations for tools)
# Type: Create a Python script that scrapes a website and extracts links

# Research task (should use many iterations)
# Type: Research the history of AI agents and write a comprehensive report
```

3. **Monitor iteration usage:**

```bash
grep "iteration" ~/.hermes/logs/agent.log | tail -10
```

### Expected Output

```
2026-05-26 12:00:00 INFO  Task type: simple → budget: 10 iterations
2026-05-26 12:00:00 INFO  Completed in 1 iteration (90% budget remaining)

2026-05-26 12:00:01 INFO  Task type: coding → budget: 60 iterations
2026-05-26 12:00:05 INFO  Completed in 12 iterations (80% budget remaining)

2026-05-26 12:00:06 INFO  Task type: research → budget: 120 iterations
2026-05-26 12:02:00 INFO  Completed in 45 iterations (62.5% budget remaining)
```

### 🎉 Success!
- [ ] Simple tasks used minimal iterations
- [ ] Coding tasks used moderate iterations
- [ ] Research tasks used full budget

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓░░ 80% complete

---

## Exercise 10.4: Parallel Execution Optimization (3 minutes)

### Goal

Maximize throughput with parallel delegation and batch processing.

### Steps

1. **Configure parallel execution:**

```yaml
delegation:
  max_concurrent_children: 5    # Increase from default 3
  child_timeout_seconds: 120    # Reduce timeout for faster failover
  max_spawn_depth: 2            # Allow one level of nesting

batch:
  max_workers: 4                # Parallel batch workers
  chunk_size: 10                # Items per batch chunk
```

2. **Test parallel delegation:**

```bash
hermes
# Type: I need 5 independent code reviews done in parallel:
# 1. Review run_agent.py
# 2. Review cli.py
# 3. Review model_tools.py
# 4. Review toolsets.py
# 5. Review hermes_state.py
# Use batch delegation to run all 5 simultaneously.
```

3. **Compare execution time:**

Note the time difference between sequential and parallel execution.

### Expected Output

```
┊ delegate_task(tasks=[...5 tasks...])
┊ [5 subagents spawned — running in parallel]
┊ [Worker 1: run_agent.py — 12s]
┊ [Worker 2: cli.py — 10s]
┊ [Worker 3: model_tools.py — 8s]
┊ [Worker 4: toolsets.py — 6s]
┊ [Worker 5: hermes_state.py — 7s]
┊ [All 5 complete — total: 12s (vs ~43s sequential)]
┊ Response:
╭─────────────────────────────────────────────────────────╮
│  # Parallel Code Review Results                        │
│                                                         │
│  ⚡ 71% faster than sequential execution               │
│  (12s parallel vs 43s sequential)                      │
╰─────────────────────────────────────────────────────────╯
```

### 🎉 Success!
- [ ] 5 subagents ran in parallel
- [ ] Execution time reduced significantly
- [ ] Concurrency limit respected

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓▓▓ 100% complete

---

## 🏆 Lab Complete!

You've optimized Hermes for speed and cost through smart model routing, context compression, iteration budgets, and parallel execution. You now understand the full performance tuning surface.

## 🚀 All Labs Complete!

Congratulations! You've worked through all 10 labs covering:
- 🟢 **Beginner:** Getting Started, Tools & Skills, Configuration
- 🔵 **Intermediate:** Skills System, Profiles, Gateway, Memory, Delegation
- 🔴 **Advanced:** Plugins, Kanban, Cron, Performance

## 💡 Pro Tips

- **Compression feasibility** is deferred to first use — not checked in `__init__` to reduce cold-start latency
- **Parallel tool calls** use unique stream indices to prevent chunk overwrites
- **SSRF protection** validates URLs in browser tools — can be monkeypatched for testing
- **Pickle guards** protect skill script execution — use `allow_safe_only=True`
- **Dependency pinning** requires upper bounds — `>=floor,<next_major` — to limit supply-chain attacks
- **3 config loaders** exist — know which one your code path uses

## 🔗 Resources

- [Performance Guide](../../guides/PERFORMANCE.md)
- [System Design](../../architecture/SYSTEM_DESIGN.md)
- [AGENTS.md](../../../AGENTS.md) — Full development guide
- [Knowledge Base](../../INDEX.md) — Complete documentation
