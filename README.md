# Install

```bash
git clone https://github.com/pitchaya-s/agent-kit.git
cd agent-kit
```

```bash
# Codex
bash scripts/install.sh --agent codex

# Claude Code
bash scripts/install.sh --agent claude

# OpenCode
bash scripts/install.sh --agent opencode

# Gemini CLI
bash scripts/install.sh --agent gemini

# GitHub Copilot
bash scripts/install.sh --agent copilot

# Cursor
bash scripts/install.sh --agent cursor

# All agent-specific locations
bash scripts/install.sh --agent all

# Shared Agent Skills location
bash scripts/install.sh --agent shared
```

# Uninstall

```bash
# Replace <agent> with codex, claude, opencode, gemini, copilot, cursor, shared, or all
bash scripts/uninstall.sh --agent <agent>
```
