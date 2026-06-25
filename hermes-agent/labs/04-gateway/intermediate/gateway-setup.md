# Lab 04: Gateway Setup

**Level**: Intermediate | **Time**: 25 minutes | **Prerequisites**: [Lab 03 Beginner](../03-configuration/beginner/config-basics.md)

## ⚡ Pre-requisite Check

```bash
hermes gateway status  # Should display gateway status (even if stopped)
ls gateway/platforms/  # Should list platform adapter files
```

If `hermes gateway` is not available, verify your Hermes installation.

## 🎯 What You'll Build

You'll connect Hermes Agent to a messaging platform (Telegram) through the gateway, enabling conversations from any chat app.

## ⚡ Quick Win (2 minutes)

```bash
# Check gateway status
hermes gateway status
```

You'll see the gateway status — whether it's running, which platforms are connected, and any errors.

### 🎉 Success!
- [ ] Gateway status command works
- [ ] No connection errors
- [ ] Platform adapters listed

## 📊 Progress Checkpoint

▓▓░░░░░░░░ 20% complete

---

## Exercise 4.1: Telegram Bot Setup (5 minutes)

### Goal

Create a Telegram bot and configure Hermes to connect to it.

### Steps

1. **Create a Telegram bot:**
   - Open Telegram and search for `@BotFather`
   - Send `/newbot`
   - Follow prompts to name your bot
   - Save the bot token (looks like `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`)

2. **Add the bot token to Hermes:**

```bash
nano ~/.hermes/.env
```

```env
TELEGRAM_BOT_TOKEN=123456789:ABCdefGHIjklMNOpqrsTUVwxyz
```

3. **Configure the gateway:**

```bash
nano ~/.hermes/config.yaml
```

```yaml
gateway:
  platforms:
    telegram:
      enabled: true
      # Bot token read from TELEGRAM_BOT_TOKEN env var
```

### Expected Output

```
$ hermes gateway status
Gateway: Stopped
Platforms configured:
  - telegram: ✅ Token found
```

### 🎉 Success!
- [ ] Telegram bot created via @BotFather
- [ ] Bot token stored in `.env`
- [ ] Gateway config updated

## 📊 Progress Checkpoint

▓▓▓▓░░░░░░ 40% complete

---

## Exercise 4.2: Start the Gateway (5 minutes)

### Goal

Launch the Hermes gateway and connect to Telegram.

### Steps

1. **Start the gateway:**

```bash
hermes gateway start
```

2. **Check the gateway log:**

```bash
tail -f ~/.hermes/logs/gateway.log
```

3. **Test from Telegram:**
   - Open Telegram and find your bot
   - Send `/start`
   - Send a test message: "Hello Hermes!"

### Expected Output

```
$ tail -f ~/.hermes/logs/gateway.log
2026-05-26 12:00:00 INFO  Gateway starting...
2026-05-26 12:00:00 INFO  Loading platform: telegram
2026-05-26 12:00:01 INFO  Telegram bot connected (ID: 123456789)
2026-05-26 12:00:01 INFO  Gateway ready — listening for messages

# In Telegram:
You: Hello Hermes!
Hermes: Hello! How can I help you today?
```

### 🎉 Success!
- [ ] Gateway started without errors
- [ ] Telegram bot connected
- [ ] Message exchanged via Telegram

## 📊 Progress Checkpoint

▓▓▓▓▓▓░░░░ 60% complete

---

## Exercise 4.3: Gateway Commands (5 minutes)

### Goal

Use gateway slash commands to manage the agent.

### Steps

1. **Test gateway commands in Telegram:**

```
/help     # Show available commands
/status   # Check agent status
/stop     # Stop a running agent turn
/new      # Start a new conversation
/queue    # View message queue
```

2. **Test agent interruption:**

```
# Send a long task
Analyze the entire Python standard library and write a summary.

# Then interrupt
/stop
```

3. **Check command routing:**

The gateway has two message guards:
- Base adapter queues messages when agent is running
- Gateway runner intercepts `/stop`, `/new`, `/queue`, `/status`, `/approve`, `/deny`

### Expected Output

```
# In Telegram:
You: /help
Hermes: Available commands:
  /start    - Start the bot
  /help     - Show this help
  /stop     - Stop current task
  /new      - New conversation
  /queue    - View message queue
  /status   - Check agent status
  /approve  - Approve pending action
  /deny     - Deny pending action

You: /status
Hermes: Agent: Idle | Queue: 0 messages
```

### 🎉 Success!
- [ ] `/help` shows command list
- [ ] `/stop` interrupts running agent
- [ ] `/status` shows agent state

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓░░ 80% complete

---

## Exercise 4.4: Multi-Platform Gateway (3 minutes)

### Goal

Understand how to add a second platform to the same gateway.

### Steps

1. **Review available platforms:**

```bash
ls gateway/platforms/
```

You'll see: `telegram.py`, `discord.py`, `slack.py`, `whatsapp.py`, `signal.py`, `matrix.py`, `email.py`, `webhook.py`, and more.

2. **Add Discord configuration:**

```yaml
gateway:
  platforms:
    telegram:
      enabled: true
    discord:
      enabled: true
      # Token read from DISCORD_BOT_TOKEN env var
```

3. **Add Discord token:**

```bash
echo 'DISCORD_BOT_TOKEN=your-discord-token' >> ~/.hermes/.env
```

4. **Restart gateway:**

```bash
hermes gateway restart
```

### Expected Output

```
$ hermes gateway status
Gateway: Running
Platforms connected:
  - telegram: ✅ Connected
  - discord:  ✅ Connected
Sessions active: 0
```

### 🎉 Success!
- [ ] Platform files listed in `gateway/platforms/`
- [ ] Discord config added
- [ ] Gateway supports multiple platforms

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓▓▓ 100% complete

---

## 🏆 Lab Complete!

You've connected Hermes to Telegram through the gateway, used gateway commands, and configured multi-platform support. You now understand the gateway architecture.

## 🚀 Next Steps

- **[Lab 05: Memory Providers](../05-memory/intermediate/memory-providers.md)** — Enable cross-session memory
- **[Lab 06: Subagent Delegation](../06-delegation/intermediate/subagent-delegation.md)** — Spawn parallel subagents

## 💡 Pro Tips

- The gateway runs inside `gateway/run.py` — session management in `gateway/session.py`
- Platform adapters follow a common interface — see `gateway/platforms/base.py`
- Use `acquire_scoped_lock()` in adapters to prevent credential conflicts between profiles
- Cron deliveries go to their own session — not mirrored into target gateway session
- The `/help` command output is generated from `COMMAND_REGISTRY` in `hermes_cli/commands.py`

## 🔗 Resources

- [Gateway Documentation](../../capabilities/GATEWAY.md)
- [Gateway Architecture](../../architecture/GATEWAY_ARCHITECTURE.md)
- [AGENTS.md - Gateway](../../../AGENTS.md)
