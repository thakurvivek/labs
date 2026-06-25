# Lab 12: Security Basics

**Level**: Intermediate | **Time**: 25 minutes | **Prerequisites**: [Lab 01](../01-getting-started/beginner/getting-started.md), [Lab 02](../02-tools-and-skills/beginner/tools-basics.md)

## ⚡ Pre-requisite Check

```bash
hermes --version  # Hermes should be installed
ls ~/.hermes/     # Config directory should exist
```

If Hermes is not installed, complete Lab 01 first.

## 🎯 What You'll Build

You'll understand Hermes' security model, including file safety checks, symlink protection, and path traversal prevention. You'll learn how recent security hardening (SEC-416 to SEC-422) protects against common attacks.

## ⚡ Quick Win (2 minutes)

```bash
# Check Hermes security configuration
cat ~/.hermes/config.yaml | grep -A 5 security
```

You'll see the security section with file safety settings.

### 🎉 Success!
- [ ] Security section visible in config
- [ ] File safety settings displayed
- [ ] No configuration errors

## 📊 Progress Checkpoint

▓▓░░░░░░░░ 20% complete

---

## Exercise 12.1: File Safety System (5 minutes)

### Goal

Understand how Hermes protects against malicious file access through the file safety system.

### Steps

1. **Launch Hermes:**

```bash
hermes
```

2. **Test file safety with a safe path:**

```
Read the file at /tmp/test.txt
```

3. **Test file safety with a sensitive path:**

```
Read the file at /etc/shadow
```

4. **Observe the security response:**
   - Safe paths are allowed
   - Sensitive paths are blocked with clear error messages

### Expected Output

```
┊ read_file(path="/tmp/test.txt")
┊ Result: {"success": true, "content": "..."}

┊ read_file(path="/etc/shadow")
┊ Result: {"error": "Access denied: sensitive system path"}
```

### 🔗 Evolution Reference

This behavior is documented in **SEC-422**: Reject read_file symlinks to blocking devices. The file safety system prevents access to sensitive paths and blocking devices.

### 🎉 Success!
- [ ] Safe file read succeeded
- [ ] Sensitive path was blocked
- [ ] Clear error message displayed

## 📊 Progress Checkpoint

▓▓▓▓░░░░░░ 40% complete

---

## Exercise 12.2: Symlink Protection (5 minutes)

### Goal

Learn how Hermes protects against symlink-based attacks in various subsystems.

### Steps

1. **Create a test symlink:**

```bash
cd /tmp
echo "safe content" > safe_file.txt
ln -s safe_file.txt safe_link.txt
```

2. **Test symlink handling in Hermes:**

```
Read the file at /tmp/safe_link.txt
```

3. **Create a symlink to a sensitive path:**

```bash
ln -s /etc/passwd dangerous_link.txt
```

4. **Test dangerous symlink:**

```
Read the file at /tmp/dangerous_link.txt
```

### Expected Output

```
┊ read_file(path="/tmp/safe_link.txt")
┊ Result: {"success": true, "content": "safe content"}

┊ read_file(path="/tmp/dangerous_link.txt")
┊ Result: {"error": "Access denied: symlink to sensitive path"}
```

### 🔗 Evolution References

Multiple evolution decisions address symlink protection:
- **SEC-417**: Reject symlink members in update ZIP
- **SEC-419**: Reject symlinks in profile distributions
- **SEC-420**: Skip symlinked files in backup zip archives
- **SEC-421**: Reject symlinked audio inputs in transcription
- **SEC-422**: Reject read_file symlinks to blocking devices

### 🎉 Success!
- [ ] Safe symlink was allowed
- [ ] Dangerous symlink was blocked
- [ ] Security error message displayed

## 📊 Progress Checkpoint

▓▓▓▓▓▓░░░░ 60% complete

---

## Exercise 12.3: Path Traversal Prevention (5 minutes)

### Goal

Understand how Hermes prevents path traversal attacks in tool parameters.

### Steps

1. **Test path traversal in TTS output:**

```
Generate speech for "Hello" and save it to ../../tmp/test.wav
```

2. **Observe the security response:**
   - Path traversal attempts are blocked
   - Only safe paths within allowed directories are permitted

3. **Test with a safe path:**

```
Generate speech for "Hello" and save it to /tmp/test.wav
```

### Expected Output

```
┊ tts(text="Hello", output_path="../../tmp/test.wav")
┊ Result: {"error": "Invalid path: path traversal detected"}

┊ tts(text="Hello", output_path="/tmp/test.wav")
┊ Result: {"success": true, "file": "/tmp/test.wav"}
```

### 🔗 Evolution Reference

This behavior is documented in **SEC-418**: Reject '..' traversal in TTS output_path. The TTS tool validates output paths to prevent writing outside intended directories.

### 🎉 Success!
- [ ] Path traversal was blocked
- [ ] Safe path was accepted
- [ ] Clear error message for invalid path

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓░░ 80% complete

---

## Exercise 12.4: Gateway Media Trust Model (3 minutes)

### Goal

Learn how the gateway uses recency-based trust for media delivery.

### Steps

1. **Review gateway security configuration:**

```bash
cat ~/.hermes/config.yaml | grep -A 10 gateway
```

2. **Understand the trust model:**
   - Fresh agent-produced files are trusted
   - Sensitive system paths are blocked
   - Recency checks prevent stale file access

3. **Test media delivery in gateway context:**
   - Agent-generated files are delivered immediately
   - System files are blocked regardless of permissions

### Expected Output

```
gateway:
  media_trust:
    max_age_seconds: 300
    allowed_paths:
      - /tmp/hermes_*
    blocked_paths:
      - /etc/*
      - /sys/*
      - /proc/*
```

### 🔗 Evolution Reference

This behavior is documented in **SEC-416**: Gateway media delivery recency-based trust model. The layered trust model allows fresh agent-produced files while blocking sensitive paths.

### 🎉 Success!
- [ ] Gateway media trust configuration visible
- [ ] Trust model understood
- [ ] Security boundaries clear

## 📊 Progress Checkpoint

▓▓▓▓▓▓▓▓▓▓ 100% complete

---

## 🏆 Lab Complete!

You've learned about Hermes' security model:

- **File Safety System**: Prevents access to sensitive paths and blocking devices
- **Symlink Protection**: Blocks symlink-based attacks across multiple subsystems
- **Path Traversal Prevention**: Validates tool parameters to prevent directory traversal
- **Gateway Media Trust**: Recency-based trust model for media delivery

## 🚀 Next Steps

- [Lab 07: Plugin Development](../07-plugins/advanced/plugin-development.md) - Learn to extend Hermes securely
- [Lab 10: Performance Tuning](../10-performance/advanced/performance-tuning.md) - Optimize without compromising security

## 💡 Pro Tips

- **Always validate file paths** before passing them to tools
- **Use temporary directories** for agent-generated content
- **Review security settings** in config.yaml regularly
- **Test security boundaries** in development before production

## 🔗 Resources

- [Security Documentation](../../SECURITY.md) - Full security policy
- [Evolution Decisions](../evolve/DECISION_TRACE_INDEX.md) - Security decisions (SEC-*)
- [AGENTS.md](../../AGENTS.md) - Development security guidelines

## 🔗 Evolution Decisions Covered

| Decision | Date | Topic |
|----------|------|-------|
| SEC-416 | 2026-05-27 | Gateway media delivery trust model |
| SEC-417 | 2026-05-27 | Reject symlink members in update ZIP |
| SEC-418 | 2026-05-27 | Reject '..' traversal in TTS output_path |
| SEC-419 | 2026-05-27 | Reject symlinks in profile distributions |
| SEC-420 | 2026-05-27 | Skip symlinked files in backup zip archives |
| SEC-421 | 2026-05-27 | Reject symlinked audio inputs in transcription |
| SEC-422 | 2026-05-27 | Reject read_file symlinks to blocking devices |