# Lab 03: Configuration Basics

**Level**: Beginner | **Time**: 15 minutes | **Prerequisites**: [Lab 01](../01-getting-started/beginner/getting-started.md)

## ⚡ Pre-requisite Check

```bash
cat ~/.hermes/config.yaml  # Should exist with at least model/provider settings
```

If `config.yaml` does not exist, run `hermes setup` first.

## 🎯 What You'll Build

You'll configure `config.yaml` to customize Hermes behavior — model selection, display settings, tool preferences, and session management.

## ⚡ Quick Win (2 minutes)

```bash
# View your current config
cat ~/.hermes/config.yaml
```

You'll see a YAML file with model, display, and tool settings. This is the heart of Hermes customization.

### 🎉 Success!
- [ ] `config.yaml` exists at `~/.hermes/config.yaml`
- [ ] Model and provider settings visible
- [ ] No syntax errors in the file

## 📊 Progress Checkpoint

▓▓░░░░░░░░ 20% complete

---

## Exercise 3.1: Model Configuration (5 minutes)

### Goal

Configure model selection, provider, and API settings.

### Steps

1. **Edit your config:**

```bash
nano ~/.hermes/config.yaml
```

2. **Set up model configuration:**

```yaml
# Primary model settings
model: "claude-sonnet-4-20250514"
provider: "anthropic"
base_url: null  # Use default for each provider

# Agent behavior
agent:
  max_iterations: 90        # Tool-calling iterations
  quiet_mode: false         # Show tool output
  save_trajectories: true   # Save conversation data
```

3. **Add API key to `.env` (SECRETS ONLY):**

```bash
# Only keys go in .env — never passwords or tokens in config.yaml
nano ~/.hermes/.env
```

```env
ANTHROPIC_API_KEY=sk-ant-your-key-here
```

4. **Verify with Hermes:**

```bash
hermes
# Type: What model are you running on?
```

### Expected Output

```
┊ Response:
╭─────────────────────────────────────────────────────────╮
│  I'm running on claude-sonnet-4-20250514 via the       │
│  Anthropic provider.                                    │
╰─────────────────────────────────────────────────────────╯
```

### 🎉 Success!
- [ ] Model name matches your config
- [ ] Provider recognized correctly
- [ ] No API key errors

## 📊 Progress Checkpoint

▓▓▓▓░░░░░░ 40% complete

---

## Exercise 3.2: Display Customization (5 minutes)

### Goal

Customize the Hermes visual appearance — skin, spinner, and branding.

### Steps

1. **Add display settings to config:**

```yaml
display:
  skin: default          # default | ares | mono | slate
  tool_progress: true    # Show tool execution progress
  background_process_notifications: all  # all | result | error | off
```

2. **Try a different skin:**

```bash
hermes
# Type: /skin ares
```

3. **Verify the skin change:**

The banner should now use crimson/bronze colors instead of gold.

### Expected Output

```
╭─────────────────────────────────────────────────────────╮
│  ████████╗██╗██╗   ██╗███████╗     [Crimson border]    │
│  ╚══██╔══╝██║██║   ██║██╔════╝    [Bronze text]        │
│     ██║   ██║██║   ██║█████╗      ARES SKIN ACTIVE     │
│     ██║   ██║╚██─ ██╔╝██╔══╝                          │
│     ██║   ██║ ╚████╔╝ ███████╗                          │
│     ╚═╝   ╚═╝  ╚═══╝  ╚══════╝                          │
╰─────────────────────────────────────────────────────────╯
```

### 🎉 Success!
- [ ] Skin changed from default to ares
- [ ] Colors updated (crimson/bronze)
- [ ] `/skin default` restores original look

## 📊 Progress Checkpoint

▓▓▓▓▓▓░░░░ 60% complete

---

## Exercise 3.3: Tool Configuration (3 minutes)

### Goal

Configure which tools are enabled and their behavior.

### Steps

1. **Add tool settings:**

```yaml
tools:
  enabled:
    - terminal
    - file
    - web
    - search
    - memory
  disabled: []
  # Platform-specific overrides
  cli:
    enabled:
      - terminal
      - file
```

2. **Configure terminal backend:**

```yaml
terminal:
  backend: local         # local | docker | ssh
  cwd: null              # Working directory (null = current dir)
  timeout: 300           # Command timeout in seconds
```

3. **Verify tool access:**

```bash
hermes
# Type: List all the tools you can use right now.
```

### Expected Output

```
┊ Response:
╭─────────────────────────────────────────────────────────╮
│  Available tools:                                      │
│                                                         │
│  Terminal: terminal, execute_code                      │
│  File: read_file, write_file, patch                    │
│  Web: web_search, web_extract                          │
│  Search: search_files, codebase_search                 │
│  Memory: memory_search, memory_add                     │
╰─────────────────────────────────────────────────────────╯
```

### 🎉 Success!
- [ ] Tools match enabled list in config
- [ ] Terminal backend set correctly
- [ ] No disabled tools appearing

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓░░ 80% complete

---

## Exercise 3.4: Session Configuration (2 minutes)

### Goal

Configure session management and logging.

### Steps

1. **Add session settings:**

```yaml
logging:
  level: INFO            # DEBUG | INFO | WARNING | ERROR
  file: agent.log        # Log file name

# Session settings (handled by hermes_state.py)
agent:
  save_trajectories: true  # Save to SQLite
  skip_context_files: false # Load AGENTS.md etc.
  skip_memory: false        # Enable memory providers
```

2. **Check logs:**

```bash
ls -la ~/.hermes/logs/
cat ~/.hermes/logs/agent.log | tail -5
```

### Expected Output

```
-rw-r--r-- 1 user user  4096 May 26 12:00 agent.log
-rw-r--r-- 1 user user  2048 May 26 12:00 errors.log

2026-05-26 12:00:00 INFO  Agent started with model=claude-sonnet-4
2026-05-26 12:00:01 INFO  Tools loaded: 42 tools in 8 toolsets
```

### 🎉 Success!
- [ ] Log files created in `~/.hermes/logs/`
- [ ] Log level matches config
- [ ] Trajectories saved to SQLite

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓▓▓ 100% complete

---

## 🏆 Lab Complete!

You've configured Hermes' model, display, tools, and session management. You now understand how `config.yaml` controls Hermes behavior.

## 🚀 Next Steps

- **[Lab 03 Intermediate: Profiles](../intermediate/profiles.md)** — Multi-instance Hermes with isolated profiles
- **[Lab 04: Gateway Setup](../04-gateway/intermediate/gateway-setup.md)** — Connect Hermes to messaging platforms

## 💡 Pro Tips

- `.env` is for SECRETS ONLY (API keys, tokens, passwords)
- `config.yaml` is for everything else (timeouts, thresholds, paths, display)
- Three config loaders exist: `load_cli_config()`, `load_config()`, and direct YAML — know which one your code uses
- Use `hermes setup` to re-run the setup wizard if config gets corrupted
- Backup your `~/.hermes/` directory before major config changes

## 🔗 Resources

- [Configuration Reference](../../configuration/CONFIG_YAML.md)
- [Environment Variables](../../configuration/ENV_VARS.md)
- [Profiles Documentation](../../configuration/PROFILES.md)
- [AGENTS.md - Configuration](../../../AGENTS.md)
