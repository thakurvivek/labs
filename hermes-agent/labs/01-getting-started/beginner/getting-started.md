# Lab 01: Getting Started

**Level**: Beginner | **Time**: 15 minutes | **Prerequisites**: Python 3.11+, pip/uv

## ⚡ Pre-requisite Check

```bash
python3 --version  # Should be 3.11+
pip --version || uv --version  # One of these should work
```

If Python 3.11+ is not available, install it first before proceeding.

## 🎯 What You'll Build

You'll install Hermes Agent and have your first AI-powered conversation in under 5 minutes.

## ⚡ Quick Win (2 minutes)

```bash
# Install Hermes Agent
pip install hermes-agent

# Run the setup wizard
hermes setup
```

The setup wizard will guide you through API key configuration. Once done, you'll see the Hermes banner.

### 🎉 Success!
- [ ] Hermes banner displayed with gold kawaii theme
- [ ] Setup wizard completed without errors
- [ ] You see the Hermes prompt ready for input

## 📊 Progress Checkpoint

▓▓░░░░░░░░ 20% complete

---

## Exercise 1.1: Configure Your First Model (5 minutes)

### Goal

Set up Hermes to use an LLM provider for conversations.

### Steps

1. **Edit your config file:**

```bash
nano ~/.hermes/config.yaml
```

2. **Set your model configuration:**

```yaml
model: "claude-sonnet-4-20250514"
provider: "anthropic"
```

3. **Add your API key to `.env`:**

```bash
echo 'ANTHROPIC_API_KEY=your-key-here' >> ~/.hermes/.env
```

4. **Verify the configuration:**

```bash
hermes tools
```

### Expected Output

```
╭─────────────────────────────────────────────────────────╮
│  ████████╗██╗██╗   ██╗███████╗                          │
│  ╚══██╔══╝██║██║   ██║██╔════╝                          │
│     ██║   ██║██║   ██║█████╗              Hermes Agent  │
│     ██║   ██║╚██─ ██╔╝██╔══╝              v0.14.0       │
│     ██║   ██║ ╚████╔╝ ███████╗                          │
│     ╚═╝   ╚═╝  ╚═══╝  ╚══════╝                          │
╰─────────────────────────────────────────────────────────╯
```

### 🎉 Success!
- [ ] `hermes tools` shows available toolsets
- [ ] No configuration errors displayed
- [ ] Model provider recognized

## 📊 Progress Checkpoint

▓▓▓▓░░░░░░ 40% complete

---

## Exercise 1.2: Have Your First Conversation (5 minutes)

### Goal

Start a conversation with Hermes Agent and verify it responds correctly.

### Steps

1. **Launch Hermes:**

```bash
hermes
```

2. **Send a test message:**

```
What is 2 + 2? Explain your reasoning.
```

3. **Observe the response:**
   - Hermes should respond with the answer
   - You'll see the KawaiiSpinner animated faces during processing
   - The response appears in a gold-bordered panel

### Expected Output

```
┊ Thinking... 🤔
┊ Response:
╭─────────────────────────────────────────────────────────╮
│  2 + 2 = 4.                                             │
│                                                         │
│  This is basic arithmetic: when you add two and two,    │
│  you get four. This holds true in standard base-10      │
│  arithmetic.                                            │
╰─────────────────────────────────────────────────────────╯
```

### 🎉 Success!
- [ ] Hermes responded to your message
- [ ] Spinner animation showed during processing
- [ ] Response displayed in a formatted panel

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓░░ 80% complete

---

## Exercise 1.3: Use a Built-in Tool (3 minutes)

### Goal

Have Hermes use a built-in tool to read a file.

### Steps

1. **Create a test file:**

```bash
echo "Hello from Hermes Agent!" > ~/test_hermes.txt
```

2. **Ask Hermes to read it:**

```
Read the file at ~/test_hermes.txt and tell me what it says.
```

3. **Observe tool usage:**
   - Hermes will use the `read_file` tool
   - You'll see tool execution in the activity feed
   - The response includes the file contents

### Expected Output

```
┊ read_file(path="~/test_hermes.txt")
┊ Result: "Hello from Hermes Agent!"
┊ Response:
╭─────────────────────────────────────────────────────────╮
│  The file at ~/test_hermes.txt contains:               │
│                                                         │
│  "Hello from Hermes Agent!"                            │
╰─────────────────────────────────────────────────────────╯
```

### 🎉 Success!
- [ ] Hermes used `read_file` tool automatically
- [ ] Tool execution visible in activity feed
- [ ] File contents returned correctly

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓▓▓ 100% complete

---

## 🏆 Lab Complete!

You've installed Hermes Agent, configured a model, had your first conversation, and watched Hermes use a built-in tool. You now have a working Hermes Agent installation.

## 🚀 Challenge (Optional)

Try asking Hermes to perform a multi-step task: *"Search the web for the latest Python release notes, summarize the top 3 features, and save the summary to ~/python_summary.md."* This exercises web search, summarization, and file writing in one turn.

## 🚀 Next Steps

- **[Lab 02: Tools & Skills](../02-tools-and-skills/beginner/tools-basics.md)** — Explore the 40+ built-in tools and the skills system
- **[Lab 03: Configuration](../03-configuration/beginner/config-basics.md)** — Customize Hermes for your workflow

## 💡 Pro Tips

- Press `Ctrl+C` to interrupt a running conversation
- Use `/help` to see all slash commands
- Use `/quit` or `Ctrl+D` to exit Hermes
- Logs live in `~/.hermes/logs/` — check `agent.log` for details

## 🔗 Resources

- [Overview Documentation](../../overview/OVERVIEW.md)
- [Quick Start Guide](../../overview/QUICKSTART.md)
- [Configuration Reference](../../configuration/CONFIG_YAML.md)
- [AGENTS.md](../../../AGENTS.md) — Full development guide

## 🔗 Evolution Decisions Covered

| Decision | Date | Topic |
|----------|------|-------|
| ARCH-1496 | 2025-11-15 | Tool call logging |
| Multiple | Various | Agent loop and tool orchestration |
