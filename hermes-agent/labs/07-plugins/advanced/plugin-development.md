# Lab 07: Plugin Development

**Level**: Advanced | **Time**: 35 minutes | **Prerequisites**: [Lab 02 Intermediate](../02-tools-and-skills/intermediate/skills-system.md), [Lab 05](../05-memory/intermediate/memory-providers.md)

## ⚡ Pre-requisite Check

```bash
python3 --version  # Python 3.11+ required for plugin development
mkdir -p ~/.hermes/plugins/  # Plugin directory should exist
hermes plugins list  # Should display current plugins (may be empty)
```

## 🎯 What You'll Build

You'll create a custom Hermes plugin that registers tools, lifecycle hooks, and CLI subcommands — extending Hermes without modifying core files.

## ⚡ Quick Win (2 minutes)

```bash
# Create a plugin directory
mkdir -p ~/.hermes/plugins/hello-world

# Create plugin manifest
cat > ~/.hermes/plugins/hello-world/plugin.yaml << 'EOF'
name: hello-world
version: 1.0.0
description: A simple greeting plugin
author: You
EOF

# Create plugin entry point
cat > ~/.hermes/plugins/hello-world/__init__.py << 'EOF'
def register(ctx):
    ctx.register_tool(
        name="hello_greet",
        handler=lambda args, **kw: f"Hello, {args.get('name', 'World')}!",
        schema={
            "name": "hello_greet",
            "description": "Greet someone by name",
            "parameters": {
                "type": "object",
                "properties": {
                    "name": {"type": "string", "description": "Name to greet"}
                }
            }
        }
    )
EOF

hermes
# Type: Use hello_greet to say hello to Alice
```

### 🎉 Success!
- [ ] Plugin directory created
- [ ] Tool registered via `ctx.register_tool()`
- [ ] `hello_greet` tool callable in conversation

## 📊 Progress Checkpoint

▓▓░░░░░░░░ 20% complete

---

## Exercise 7.1: Lifecycle Hooks (5 minutes)

### Goal

Add lifecycle hooks to observe agent behavior.

### Steps

1. **Extend the plugin with hooks:**

```python
# ~/.hermes/plugins/hello-world/__init__.py
import time, json

def register(ctx):
    # Register tool
    ctx.register_tool(
        name="hello_greet",
        handler=lambda args, **kw: f"Hello, {args.get('name', 'World')}!",
        schema={
            "name": "hello_greet",
            "description": "Greet someone by name",
            "parameters": {
                "type": "object",
                "properties": {
                    "name": {"type": "string", "description": "Name to greet"}
                }
            }
        }
    )

    # Pre-tool-call hook — log before each tool execution
    def on_pre_tool_call(tool_name, args, **kw):
        print(f"[HOOK] Pre-tool: {tool_name} with args={json.dumps(args)}")

    # Post-tool-call hook — log after each tool execution
    def on_post_tool_call(tool_name, result, **kw):
        print(f"[HOOK] Post-tool: {tool_name} result_len={len(str(result))}")

    # Session lifecycle hooks
    def on_session_start(session_id, **kw):
        print(f"[HOOK] Session started: {session_id}")

    def on_session_end(session_id, **kw):
        print(f"[HOOK] Session ended: {session_id}")

    ctx.register_hook("pre_tool_call", on_pre_tool_call)
    ctx.register_hook("post_tool_call", on_post_tool_call)
    ctx.register_hook("on_session_start", on_session_start)
    ctx.register_hook("on_session_end", on_session_end)
```

2. **Restart Hermes and test:**

```bash
hermes
# Type: Read the file README.md
```

3. **Observe hook output in the activity feed:**

```
[HOOK] Session started: sess_abc123
[HOOK] Pre-tool: read_file with args={"path": "README.md"}
┊ read_file(path="README.md")
[HOOK] Post-tool: read_file result_len=4523
```

### Expected Output

```
[HOOK] Session started: sess_abc123
[HOOK] Pre-tool: read_file with args={"path": "README.md"}
┊ read_file(path="README.md")
┊ Result: (file contents)
[HOOK] Post-tool: read_file result_len=4523
┊ Response:
╭─────────────────────────────────────────────────────────╮
│  The README.md file contains documentation for Hermes   │
│  Agent, including installation, features, and usage.   │
╰─────────────────────────────────────────────────────────╯
```

### 🎉 Success!
- [ ] Pre-tool hook fired before tool execution
- [ ] Post-tool hook fired after tool execution
- [ ] Session hooks fired at start/end

## 📊 Progress Checkpoint

▓▓▓▓░░░░░░ 40% complete

---

## Exercise 7.2: CLI Subcommand Registration (5 minutes)

### Goal

Add a CLI subcommand via the plugin system.

### Steps

1. **Register a CLI subcommand:**

```python
# ~/.hermes/plugins/hello-world/__init__.py
import argparse

def register(ctx):
    # ... (existing tool and hook registration)

    # Register CLI subcommand
    def cli_greet(args):
        print(f"Hello, {args.name}! From the hello-world plugin.")

    ctx.register_cli_command(
        name="greet",
        description="Greet someone from the CLI",
        func=cli_greet,
        args=[
            argparse.Argument(["name"], help="Name to greet")
        ]
    )
```

2. **Test the subcommand:**

```bash
hermes greet World
```

3. **Verify it appears in help:**

```bash
hermes --help
```

### Expected Output

```
$ hermes greet World
Hello, World! From the hello-world plugin.

$ hermes --help
usage: hermes [-h] [--version] {setup,tools,gateway,greet,...} ...

positional arguments:
  setup       Run setup wizard
  tools       Manage toolsets
  gateway     Manage messaging gateway
  greet       Greet someone from the CLI  ← Your plugin!
  ...
```

### 🎉 Success!
- [ ] `hermes greet World` works
- [ ] Subcommand appears in `hermes --help`
- [ ] No changes to `main.py` required

## 📊 Progress Checkpoint

▓▓▓▓▓▓░░░░ 60% complete

---

## Exercise 7.3: Multi-Tool Plugin (5 minutes)

### Goal

Create a plugin with multiple related tools.

### Steps

1. **Create a weather plugin:**

```bash
mkdir -p ~/.hermes/plugins/weather
```

2. **Create the plugin:**

```python
# ~/.hermes/plugins/weather/__init__.py
import json

def register(ctx):
    ctx.register_tool(
        name="weather_current",
        handler=lambda args, **kw: json.dumps({
            "location": args.get("city", "Unknown"),
            "temperature": 22,
            "condition": "Sunny",
            "humidity": 45
        }),
        schema={
            "name": "weather_current",
            "description": "Get current weather for a city",
            "parameters": {
                "type": "object",
                "properties": {
                    "city": {"type": "string", "description": "City name"}
                },
                "required": ["city"]
            }
        }
    )

    ctx.register_tool(
        name="weather_forecast",
        handler=lambda args, **kw: json.dumps({
            "location": args.get("city", "Unknown"),
            "days": [
                {"day": "Today", "high": 25, "low": 18, "condition": "Sunny"},
                {"day": "Tomorrow", "high": 23, "low": 16, "condition": "Cloudy"},
                {"day": "Wednesday", "high": 20, "low": 14, "condition": "Rainy"}
            ]
        }),
        schema={
            "name": "weather_forecast",
            "description": "Get 3-day weather forecast for a city",
            "parameters": {
                "type": "object",
                "properties": {
                    "city": {"type": "string", "description": "City name"}
                },
                "required": ["city"]
            }
        }
    )
```

3. **Test both tools:**

```bash
hermes
# Type: What's the weather in Tokyo? Also give me a 3-day forecast.
```

### Expected Output

```
┊ weather_current(city="Tokyo")
┊ Result: {"location": "Tokyo", "temperature": 22, "condition": "Sunny"}
┊ weather_forecast(city="Tokyo")
┊ Result: {"location": "Tokyo", "days": [...]}
┊ Response:
╭─────────────────────────────────────────────────────────╮
│  Current weather in Tokyo: 22°C, Sunny, 45% humidity.  │
│                                                         │
│  3-Day Forecast:                                       │
│  - Today: High 25°C, Low 18°C, Sunny                   │
│  - Tomorrow: High 23°C, Low 16°C, Cloudy              │
│  - Wednesday: High 20°C, Low 14°C, Rainy              │
╰─────────────────────────────────────────────────────────╯
```

### 🎉 Success!
- [ ] Both tools registered in one plugin
- [ ] Tools called sequentially by Hermes
- [ ] Results formatted in response

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓░░ 80% complete

---

## Exercise 7.4: Plugin Discovery and Management (3 minutes)

### Goal

Understand how plugins are discovered and managed.

### Steps

1. **List installed plugins:**

```bash
hermes plugins list
```

2. **Check plugin discovery paths:**

Plugins are discovered from:
- `~/.hermes/plugins/` — User plugins
- `./.hermes/plugins/` — Local project plugins
- `plugins/` in repo — Bundled plugins
- pip entry points — Installed packages

3. **Disable a plugin:**

```bash
# Rename to disable (discovery skips non-__init__.py dirs)
mv ~/.hermes/plugins/weather ~/.hermes/plugins/weather.disabled
hermes plugins list
```

### Expected Output

```
$ hermes plugins list
Installed plugins:
  - hello-world (v1.0.0) — ~/.hermes/plugins/hello-world/
    Tools: hello_greet
    Hooks: pre_tool_call, post_tool_call, on_session_start, on_session_end
    CLI: greet

$ mv ~/.hermes/plugins/weather ~/.hermes/plugins/weather.disabled
$ hermes plugins list
Installed plugins:
  - hello-world (v1.0.0) — ~/.hermes/plugins/hello-world/
```

### 🎉 Success!
- [ ] Plugins listed with tools/hooks/CLI
- [ ] Discovery paths understood
- [ ] Plugin disabled by renaming

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓▓▓ 100% complete

---

## 🏆 Lab Complete!

You've created a full Hermes plugin with tools, lifecycle hooks, and CLI subcommands. You understand the plugin discovery system and how to extend Hermes without touching core files.

## 🚀 Next Steps

- **[Lab 08: Kanban Workflows](../08-kanban/advanced/kanban-workflows.md)** — Multi-agent work queues
- **[Lab 09: Cron Jobs](../09-cron/advanced/cron-jobs.md)** — Scheduled automation

## 💡 Pro Tips

- **Plugins MUST NOT modify core files** — this is the Teknium policy (May 2026)
- If a plugin needs a capability the framework doesn't expose, expand the plugin surface (new hook, new ctx method)
- `discover_plugins()` runs as a side effect of importing `model_tools.py`
- Code paths that read plugin state without importing `model_tools.py` must call `discover_plugins()` explicitly
- Plugin toolsets are discovered automatically — no `toolsets.py` changes needed

## 🔗 Resources

- [Plugin Documentation](../../capabilities/PLUGINS.md)
- [System Design](../../architecture/SYSTEM_DESIGN.md)
- [AGENTS.md - Plugins](../../../AGENTS.md)
