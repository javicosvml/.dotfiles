# OpenCode Configuration for Dotfiles

This directory contains OpenCode configuration for managing macOS dotfiles with AI assistance.

## Structure

```
.opencode/
├── opencode.json              # Main configuration (model-agnostic, no specific LLM set)
├── agents/
│   └── dot/
│       └── AGENT.md           # Single specialist agent for dotfiles work
├── skills/                    # Reusable knowledge modules
│   ├── validate-dotfiles/
│   ├── tmux-config/
│   ├── zsh-modules/
│   ├── neovim-setup/
│   ├── makefile-targets/
│   ├── shell-best-practices/
│   └── env-setup/
└── prompts/
    └── base.txt               # Base system prompt for all interactions
```

## Usage

### Invoke the Dotfiles Specialist

```bash
@dot help me validate these config changes
@dot I want to add a new ZSH module. What should I check?
@dot Walk me through updating Tmux for the new binding
```

### Load Specific Skills

The `@dot` agent automatically loads skills as needed. You can also manually request them:

```bash
@dot /skill load validate-dotfiles
@dot /skill load tmux-config
@dot /skill load zsh-modules
```

## Configuration

### opencode.json

- **Model-agnostic:** No specific model set. OpenCode will use whatever's configured globally
- **Permissions:** Limited bash (safe commands only), ask for edits
- **Agent:** Single `dot` subagent with 15 max steps
- **Instructions:** Loads `AGENTS.md` + `base.txt` automatically

### Agent: @dot

- **Type:** Subagent (call via `@dot <task>`)
- **Temperature:** 0.2 (focused, not too creative)
- **Max Steps:** 15 (enough for complex workflows)
- **Permissions:**
  - ✅ Read, grep, find, git operations
  - ✅ Safe bash: `make`, `zsh -n`, `tmux source-file -v`, validation scripts
  - ❌ Dangerous bash: No `rm`, `mv`, or unbounded shell
  - ❌ Web access: No `webfetch` or `websearch`

### Skills

Each skill is a `.md` file with YAML frontmatter + content:

1. **validate-dotfiles** — Syntax checking, architecture compliance
2. **tmux-config** — Prefix quirks, pbcopy bindings, key bindings
3. **zsh-modules** — Loading order (11 modules), module responsibilities
4. **neovim-setup** — lazy.nvim configuration, plugin management
5. **makefile-targets** — All targets reference and when to use
6. **shell-best-practices** — Shell scripting patterns
7. **env-setup** — Installation order, prerequisites, troubleshooting

## Model Agnostic Design

This configuration does **not** specify a model in `opencode.json`. Instead:

- The global OpenCode config determines the model
- You can use haiku for fast tasks, sonnet for complex work, opus for reasoning
- Switch models at any time without touching this config
- Optimal for personal workflows where you change providers/models frequently

**Example workflow:**
```bash
# Fast validation (might use haiku)
@dot validate this change quickly

# Complex refactoring (might use sonnet/opus)
@dot design a new module for X and walk me through implementation
```

## Getting Started

1. **Read AGENTS.md first** — It's the source of truth for constraints
2. **Invoke @dot** — Start with simple validation tasks
3. **Load skills as needed** — The agent will suggest relevant skills
4. **Validate before committing** — Use `@dot /skill load validate-dotfiles` workflow

## Example Interaction

```
You: @dot I want to add a new ZSH module for a tool. What's the checklist?

@dot:
- Load skill: zsh-modules (to understand loading order)
- Load skill: validate-dotfiles (for validation steps)
- Checklist:
  1. Determine which module should own this (alias.zsh, tools.zsh, etc.)
  2. Create the configuration
  3. Test syntax: zsh -n
  4. Validate order not broken
  5. Run make verify and bash scripts/validate-configs.sh
  6. Ready to commit

You: Great, let's add it to tools.zsh. Here's what I want...

@dot:
[Makes changes]
[Validates with scripts]
[Suggests commit message]
```

## Maintenance

- **Update skills** when project structure changes
- **Update AGENTS.md** when critical quirks change (agent will notify)
- **Keep opencode.json minimal** — rely on skills for details
- **Test workflows** after major changes

## Reference

- **AGENTS.md** — Agent guidance (critical reading)
- **README.md** — Project overview
- **docs/*.dotfiles.md** — Per-technology reference
- **Makefile** — All installation/config targets
