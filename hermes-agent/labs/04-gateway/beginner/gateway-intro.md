# Lab 04: Gateway Introduction

**Level**: Beginner | **Time**: 20 minutes | **Prerequisites**: [Lab 01](../01-getting-started/beginner/getting-started.md), [Lab 03](../03-configuration/beginner/config-basics.md)

## ⚡ Pre-requisite Check

```bash
hermes --version  # Hermes should be installed
hermes gateway --help  # Gateway command should be available
```

If Hermes is not installed, complete Lab 01 first.

## 🎯 What You'll Build

You'll launch the Hermes Gateway, which connects Hermes Agent to messaging platforms like Telegram, Discord, Slack, and more. You'll understand the gateway architecture and basic configuration.

## ⚡ Quick Win (2 minutes)

```bash
hermes gateway --help
```

You'll see all available gateway commands and options.

### 🎉 Success!
- [ ] Gateway help displayed
- [ ] Available platforms listed
- [ ] Command options visible

## 📊 Progress Checkpoint

▓▓░░░░░░░░ 20% complete

---

## Exercise 4.1: Gateway Architecture (5 minutes)

### Goal

Understand the gateway's role in connecting Hermes to messaging platforms.

### Steps

1. **Review the gateway architecture:**

The gateway consists of:
- **Gateway Runner** (`gateway/run.py`): Main orchestrator
- **Platform Adapters** (`gateway/platforms/`): Per-platform implementations
- **Session Management** (`gateway/session.py`): Conversation state
- **Slash Commands**: Unified command system across platforms

2. **List available platforms:**

```bash
hermes gateway --help | grep -A 20 "Platforms"
```

3. **Understand the platform adapter pattern:**
   - Each platform has its own adapter
   - Adapters handle platform-specific message formats
   - Unified session management across all platforms

### Expected Output

```
Available Platforms:
  telegram    - Telegram bot integration
  discord     - Discord bot integration
  slack       - Slack app integration
  whatsapp    - WhatsApp Business API
  signal      - Signal messaging
  matrix      - Matrix protocol
  email       - Email gateway
  sms         - SMS gateway
  ...and 15+ more
```

### 🔗 Evolution Reference

The gateway architecture is documented in **INT-122**: Vision tool enhancements and multiple platform integration decisions. The adapter pattern ensures consistent behavior across platforms.

### 🎉 Success!
- [ ] Gateway architecture understood
- [ ] Available platforms listed
- [ ] Adapter pattern clear

## 📊 Progress Checkpoint

▓▓▓▓░░░░░░ 40% complete

---

## Exercise 4.2: Gateway Configuration (5 minutes)

### Goal

Configure the gateway for a messaging platform.

### Steps

1. **Edit your config file:**

```bash
nano ~/.hermes/config.yaml
```

2. **Add gateway configuration:**

```yaml
gateway:
  enabled: true
  platforms:
    telegram:
      enabled: true
      bot_token: "YOUR_BOT_TOKEN"
```

3. **Add your bot token to `.env`:**

```bash
echo 'TELEGRAM_BOT_TOKEN=your-token-here' >> ~/.hermes/.env
```

4. **Verify the configuration:**

```bash
hermes gateway --check-config
```

### Expected Output

```
✓ Gateway configuration valid
✓ Telegram platform enabled
✓ Bot token found
```

### 🎉 Success!
- [ ] Gateway configuration added
- [ ] Bot token configured
- [ ] Configuration validation passed

## 📊 Progress Checkpoint

▓▓▓▓▓▓░░░░ 60% complete

---

## Exercise 4.3: Launch the Gateway (5 minutes)

### Goal

Start the Hermes Gateway and verify it's running.

### Steps

1. **Launch the gateway:**

```bash
hermes gateway
```

2. **Observe the startup sequence:**
   - Platform adapters initialize
   - Bot connects to messaging platform
   - Session manager starts
   - Ready to receive messages

3. **Test the gateway:**
   - Send a message to your bot on the platform
   - Observe the gateway log output
   - Verify Hermes responds

### Expected Output

```
[INFO] Starting Hermes Gateway...
[INFO] Loading platform adapters...
[INFO] Telegram adapter initialized
[INFO] Connecting to Telegram API...
[INFO] Bot connected: @your_bot_name
[INFO] Session manager started
[INFO] Gateway ready - listening for messages
```

### 🎉 Success!
- [ ] Gateway launched successfully
- [ ] Platform connected
- [ ] Session manager started
- [ ] Bot responded to test message

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓░░ 80% complete

---

## Exercise 4.4: Gateway Slash Commands (3 minutes)

### Goal

Use slash commands in the gateway context.

### Steps

1. **Send a slash command to your bot:**

```
/help
```

2. **Try session management:**

```
/new
```

3. **Try status check:**

```
/status
```

4. **Observe the unified command system:**
   - Same commands work across all platforms
   - Platform-specific formatting applied
   - Consistent behavior

### Expected Output

```
/help
┌─────────────────────────────────────────────────────────┐
│ Available Commands:                                     │
│ /help - Show this help                                 │
│ /new - Start a new session                             │
│ /status - Show current status                          │
│ /stop - Stop the current agent                         │
└─────────────────────────────────────────────────────────┘
```

### 🔗 Evolution Reference

The unified slash command system is documented in **hermes_cli/commands.py**. The `COMMAND_REGISTRY` provides a single source of truth for all platforms.

### 🎉 Success!
- [ ] /help displayed command list
- [ ] /new started a new session
- [ ] /status showed current state
- [ ] Commands work consistently

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓▓▓ 100% complete

---

## 🏆 Lab Complete!

You've learned about the Hermes Gateway:

- **Architecture**: Platform adapters with unified session management
- **Configuration**: Platform-specific settings in config.yaml
- **Launch**: Starting the gateway and connecting to platforms
- **Slash Commands**: Unified command system across all platforms

## 🚀 Next Steps

- [Lab 04 Intermediate: Gateway Setup](../04-gateway/intermediate/gateway-setup.md) - Advanced gateway configuration
- [Lab 09: Cron Jobs](../09-cron/advanced/cron-jobs.md) - Schedule automated tasks via gateway

## 💡 Pro Tips

- **Use environment variables** for sensitive data (API keys, tokens)
- **Test locally first** before deploying to production
- **Monitor gateway logs** for debugging connection issues
- **Use token locks** when running multiple profiles with the same credential

## 🔗 Resources

- [Gateway Documentation](../../gateway/) - Gateway source code
- [Platform Adapters](../../gateway/platforms/) - Per-platform implementations
- [Adding a Platform](../../ADDING_A_PLATFORM.md) - Create new platform adapters
- [AGENTS.md](../../AGENTS.md) - Gateway architecture section

## 🔗 Evolution Decisions Covered

| Decision | Date | Topic |
|----------|------|-------|
| INT-122 | 2026-02-15 | Platform expansion and integration |
| Multiple | Various | Platform-specific adapter decisions |