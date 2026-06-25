# Lab 13: TUI Basics

**Level**: Beginner | **Time**: 20 minutes | **Prerequisites**: [Lab 01](../01-getting-started/beginner/getting-started.md)

## ⚡ Pre-requisite Check

```bash
hermes --version  # Hermes should be installed
node --version    # Node.js 18+ required for TUI
```

If Hermes is not installed, complete Lab 01 first.

## 🎯 What You'll Build

You'll launch the Hermes Terminal UI (TUI), a full replacement for the classic CLI built with Ink (React). You'll learn the JSON-RPC transport model and key TUI features.

## ⚡ Quick Win (2 minutes)

```bash
hermes --tui
```

You'll see the modern TUI interface with transcript, composer, and activity panels.

### 🎉 Success!
- [ ] TUI launched successfully
- [ ] Transcript panel visible
- [ ] Composer input ready
- [ ] Activity feed showing

## 📊 Progress Checkpoint

▓▓░░░░░░░░ 20% complete

---

## Exercise 13.1: TUI Architecture (5 minutes)

### Goal

Understand the TUI's process model and JSON-RPC transport.

### Steps

1. **Review the TUI architecture:**

The TUI uses a split-process model:
- **Node (Ink)**: Renders the screen, handles user input
- **Python (tui_gateway)**: Manages sessions, tools, model calls
- **Transport**: Newline-delimited JSON-RPC over stdio

2. **Launch TUI and observe the startup:**

```bash
hermes --tui
```

3. **Check the process tree in another terminal:**

```bash
ps aux | grep hermes
```

You'll see both the Node process and Python gateway process.

### Expected Output

```
user  12345  hermes --tui              # Node (Ink)
user  12346  python tui_gateway/entry.py  # Python gateway
```

### 🔗 Evolution Reference

The TUI architecture is documented in **ARCH-576**: TUI State. Proper state management ensures the TUI and gateway stay synchronized.

### 🎉 Success!
- [ ] TUI launched with both processes
- [ ] Process tree visible
- [ ] Architecture understood

## 📊 Progress Checkpoint

▓▓▓▓░░░░░░ 40% complete

---

## Exercise 13.2: Core TUI Features (5 minutes)

### Goal

Explore the main TUI panels and their functions.

### Steps

1. **Launch TUI:**

```bash
hermes --tui
```

2. **Explore the transcript panel:**
   - Shows conversation history
   - Displays tool activity with visual indicators
   - Scroll through past messages

3. **Use the composer:**
   - Type a message in the input area
   - Press Enter to send
   - Observe the response in the transcript

4. **Watch the activity feed:**
   - See tool calls in real-time
   - Observe spinner animations
   - Track progress indicators

### Expected Output

```
┌─────────────────────────────────────────────────────────┐
│ Transcript Panel                                        │
│ ┊ Thinking... 🤔                                        │
│ ┊ Response:                                             │
│ ╭─────────────────────────────────────────────────────╮ │
│ │ 2 + 2 = 4                                           │ │
│ ╰─────────────────────────────────────────────────────╯ │
├─────────────────────────────────────────────────────────┤
│ Activity Feed                                          │
│ ┊ terminal(command="echo test")                        │
│ ┊ Result: "test"                                       │
├─────────────────────────────────────────────────────────┤
│ Composer: [Type your message here...]                  │
└─────────────────────────────────────────────────────────┘
```

### 🎉 Success!
- [ ] Transcript panel working
- [ ] Composer accepts input
- [ ] Activity feed shows tool calls
- [ ] Responses displayed correctly

## 📊 Progress Checkpoint

▓▓▓▓▓▓░░░░ 60% complete

---

## Exercise 13.3: Slash Commands in TUI (5 minutes)

### Goal

Use slash commands directly in the TUI composer.

### Steps

1. **Launch TUI:**

```bash
hermes --tui
```

2. **Try built-in TUI commands:**

```
/help
```

3. **Try session management:**

```
/resume
```

4. **Try clearing the transcript:**

```
/clear
```

5. **Try quitting:**

```
/quit
```

### Expected Output

```
/help
┌─────────────────────────────────────────────────────────┐
│ Available Commands:                                     │
│ /help - Show this help                                 │
│ /clear - Clear transcript                              │
│ /resume - Resume a session                             │
│ /quit - Exit TUI                                       │
└─────────────────────────────────────────────────────────┘
```

### 🎉 Success!
- [ ] /help displayed command list
- [ ] /resume showed session picker
- [ ] /clear cleared the transcript
- [ ] /quit exited TUI cleanly

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓░░ 80% complete

---

## Exercise 13.4: TUI in Dashboard (3 minutes)

### Goal

Understand how the TUI integrates with the web dashboard.

### Steps

1. **Start the dashboard:**

```bash
hermes dashboard
```

2. **Navigate to the Chat page:**
   - Open browser to `http://localhost:8000`
   - Click on "Chat" in the sidebar
   - Observe the embedded TUI via xterm.js

3. **Understand the integration:**
   - Dashboard embeds the real `hermes --tui` (not a rewrite)
   - Uses PTY (pseudo-terminal) for terminal emulation
   - WebSocket connection for real-time updates

### Expected Output

```
Browser shows:
┌─────────────────────────────────────────────────────────┐
│ [Sidebar] Chat                                          │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ [xterm.js terminal with hermes --tui running]      │ │
│ │ ╭─────────────────────────────────────────────────╮ │ │
│ │ │  ████████╗██╗██╗   ██╗███████╗                  │ │ │
│ │ │  ╚══██╔══╝██║██║   ██║██╔════╝                  │ │ │
│ │ │     ██║   ██║██║   ██║█████╗  Hermes Agent      │ │ │
│ │ │     ██║   ██║╚██─ ██╔╝██╔══╝  v0.14.0           │ │ │
│ │ │     ██║   ██║ ╚████╔╝ ███████╗                  │ │ │
│ │ │     ╚═╝   ╚═╝  ╚═══╝  ╚══════╝                  │ │ │
│ │ ╰─────────────────────────────────────────────────╯ │ │
│ │ hermes> _                                          │ │ │
│ └─────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

### 🔗 Evolution Reference

The dashboard TUI integration is documented in **ARCH-385**: Dashboard Sidebar. The TUI is embedded, not reimplemented, ensuring feature parity.

### 🎉 Success!
- [ ] Dashboard launched
- [ ] Chat page displayed embedded TUI
- [ ] TUI interactive in browser
- [ ] Integration understood

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓▓▓ 100% complete

---

## 🏆 Lab Complete!

You've learned about the Hermes TUI:

- **Architecture**: Split-process model with JSON-RPC transport
- **Core Features**: Transcript, composer, activity feed
- **Slash Commands**: Built-in commands for session management
- **Dashboard Integration**: Embedded TUI via xterm.js and PTY

## 🚀 Next Steps

- [Lab 04: Gateway Setup](../04-gateway/intermediate/gateway-setup.md) - Connect Hermes to messaging platforms
- [Lab 10: Performance Tuning](../10-performance/advanced/performance-tuning.md) - Optimize TUI performance

## 💡 Pro Tips

- **Use TUI for daily work** - It's more visual than the classic CLI
- **Keyboard shortcuts** - Use arrow keys for navigation, Enter to send
- **Session management** - Use `/resume` to pick up where you left off
- **Dashboard TUI** - Same experience in browser for remote access

## 🔗 Resources

- [TUI Source Code](../../ui-tui/) - React/Ink implementation
- [TUI Gateway](../../tui_gateway/) - Python JSON-RPC backend
- [AGENTS.md](../../AGENTS.md) - TUI architecture section
- [Evolution Decisions](../evolve/DECISION_TRACE_INDEX.md) - TUI decisions (ARCH-576, ARCH-385)

## 🔗 Evolution Decisions Covered

| Decision | Date | Topic |
|----------|------|-------|
| ARCH-576 | 2026-04-28 | TUI State management |
| ARCH-385 | 2026-04-22 | Dashboard Sidebar navigation |