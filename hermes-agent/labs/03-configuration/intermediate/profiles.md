# Lab 03 Intermediate: Profiles

**Level**: Intermediate | **Time**: 20 minutes | **Prerequisites**: [Lab 03 Beginner](../beginner/config-basics.md)

## ⚡ Pre-requisite Check

```bash
hermes profile list  # Should display at least the default profile
```

If the command fails, ensure Hermes is installed and `config.yaml` is valid.

## 🎯 What You'll Build

You'll create isolated Hermes profiles for different workflows — a coding profile and a research profile — each with separate config, memory, and sessions.

## ⚡ Quick Win (2 minutes)

```bash
# Create a new profile
hermes profile create coder

# Switch to it
hermes -p coder
```

You'll see Hermes launch with a fresh `~/.hermes/profiles/coder/` directory — completely isolated from your default profile.

### 🎉 Success!
- [ ] Profile `coder` created at `~/.hermes/profiles/coder/`
- [ ] Hermes launched with `-p coder` flag
- [ ] Separate config directory confirmed

## 📊 Progress Checkpoint

▓▓░░░░░░░░ 20% complete

---

## Exercise 3.1: Profile Isolation (5 minutes)

### Goal

Verify that profiles maintain complete state isolation.

### Steps

1. **Create two profiles:**

```bash
hermes profile create coder
hermes profile create researcher
```

2. **Configure each differently:**

```bash
# Coder profile — fast model
HERMES_HOME=~/.hermes/profiles/coder cat > ~/.hermes/profiles/coder/config.yaml << 'EOF'
model: "claude-sonnet-4-20250514"
provider: "anthropic"
agent:
  max_iterations: 90
EOF

# Researcher profile — reasoning model
HERMES_HOME=~/.hermes/profiles/researcher cat > ~/.hermes/profiles/researcher/config.yaml << 'EOF'
model: "claude-opus-4-20250514"
provider: "anthropic"
agent:
  max_iterations: 120
EOF
```

3. **Verify isolation:**

```bash
# Check coder profile
hermes -p coder
# Type: What model are you using?

# Check researcher profile
hermes -p researcher
# Type: What model are you using?
```

### Expected Output

```
$ hermes -p coder
# What model are you using?
┊ I'm using claude-sonnet-4-20250514 via Anthropic.

$ hermes -p researcher
# What model are you using?
┊ I'm using claude-opus-4-20250514 via Anthropic.
```

### 🎉 Success!
- [ ] Each profile uses its own model
- [ ] Config files are profile-scoped
- [ ] `HERMES_HOME` points to profile directory

## 📊 Progress Checkpoint

▓▓▓▓░░░░░░ 40% complete

---

## Exercise 3.2: Profile-Aware Paths (5 minutes)

### Goal

Understand how `get_hermes_home()` ensures profile-safe paths.

### Steps

1. **Check path resolution:**

```bash
# Default profile
hermes
# Type: Where is your config file located?

# Coder profile
hermes -p coder
# Type: Where is your config file located?
```

2. **Verify log isolation:**

```bash
ls -la ~/.hermes/logs/
ls -la ~/.hermes/profiles/coder/logs/
ls -la ~/.hermes/profiles/researcher/logs/
```

3. **Verify session isolation:**

```bash
# Each profile has its own SQLite session store
ls -la ~/.hermes/state.db
ls -la ~/.hermes/profiles/coder/state.db
ls -la ~/.hermes/profiles/researcher/state.db
```

### Expected Output

```
$ ls -la ~/.hermes/profiles/coder/
total 24
drwxr-xr-x 5 user user 4096 May 26 12:00 .
drwxr-xr-x 4 user user 4096 May 26 12:00 ..
-rw-r--r-- 1 user user  128 May 26 12:00 config.yaml
-rw-r--r-- 1 user user    0 May 26 12:00 .env
drwxr-xr-x 2 user user 4096 May 26 12:00 logs
drwxr-xr-x 2 user user 4096 May 26 12:00 skills
-rw-r--r-- 1 user user 8192 May 26 12:00 state.db
```

### 🎉 Success!
- [ ] Each profile has separate `logs/` directory
- [ ] Each profile has separate `state.db`
- [ ] `get_hermes_home()` returns profile-specific path

## 📊 Progress Checkpoint

▓▓▓▓▓▓░░░░ 60% complete

---

## Exercise 3.3: Profile Management (5 minutes)

### Goal

Manage profiles — list, switch, delete, and copy configurations.

### Steps

1. **List all profiles:**

```bash
hermes profile list
```

2. **Set a default profile:**

```bash
hermes profile default coder
```

3. **Copy config between profiles:**

```bash
# Copy coder config to researcher (as starting point)
cp ~/.hermes/profiles/coder/config.yaml ~/.hermes/profiles/researcher/config.yaml.bak
```

4. **Remove a profile:**

```bash
hermes profile remove researcher
```

### Expected Output

```
$ hermes profile list
Profiles:
  * default    (current)    ~/.hermes/
    coder      ~/.hermes/profiles/coder/
    researcher ~/.hermes/profiles/researcher/

$ hermes profile default coder
Default profile set to: coder

$ hermes profile remove researcher
Profile 'researcher' removed.
```

### 🎉 Success!
- [ ] Profiles listed with paths
- [ ] Default profile changed
- [ ] Profile removed cleanly

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓░░ 80% complete

---

## Exercise 3.4: Profile with Gateway (3 minutes)

### Goal

Run the gateway with a specific profile.

### Steps

1. **Start gateway with coder profile:**

```bash
hermes -p coder gateway start --platform telegram
```

2. **Verify profile-aware gateway:**

The gateway log should show the profile-specific config:

```bash
cat ~/.hermes/profiles/coder/logs/gateway.log | tail -5
```

### Expected Output

```
2026-05-26 12:00:00 INFO  Gateway starting with profile=coder
2026-05-26 12:00:00 INFO  HERMES_HOME=~/.hermes/profiles/coder
2026-05-26 12:00:01 INFO  Platform: telegram (token loaded from .env)
2026-05-26 12:00:01 INFO  Model: claude-sonnet-4-20250514
```

### 🎉 Success!
- [ ] Gateway started with profile context
- [ ] Logs written to profile directory
- [ ] Config loaded from profile path

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓▓▓ 100% complete

---

## 🏆 Lab Complete!

You've created isolated Hermes profiles, verified state separation, and managed the profile lifecycle. You now understand multi-instance Hermes.

## 🚀 Next Steps

- **[Lab 04: Gateway Setup](../04-gateway/intermediate/gateway-setup.md)** — Connect Hermes to messaging platforms
- **[Lab 05: Memory Providers](../05-memory/intermediate/memory-providers.md)** — Enable cross-session memory

## 💡 Pro Tips

- Use `get_hermes_home()` in code — NEVER hardcode `~/.hermes`
- Use `display_hermes_home()` for user-facing messages
- `_get_profiles_root()` returns `Path.home() / ".hermes" / "profiles"` — not profile-anchored
- Gateway adapters should use `acquire_scoped_lock()` to prevent credential conflicts
- Each profile can run its own gateway instance with different bot tokens

## 🔗 Resources

- [Profiles Documentation](../../configuration/PROFILES.md)
- [System Design](../../architecture/SYSTEM_DESIGN.md)
- [AGENTS.md - Profiles](../../../AGENTS.md)
