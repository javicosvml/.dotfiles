# OpenCode Quick Start for Dotfiles

**TL;DR:** Use `@dot` to help with dotfiles. It knows your quirks and validates against AGENTS.md.

## Installation

The configuration is already in place. Just start using OpenCode in the dotfiles repo:

```bash
cd ~/.dotfiles
opencode
```

## Invoke the Agent

In OpenCode, mention the agent in any message:

```
@dot help me validate this config change
```

That's it. The `@dot` agent will:
1. Load relevant AGENTS.md constraints
2. Invoke skills as needed
3. Validate your changes
4. Suggest improvements
5. Provide commit messages

## Common Tasks

### Validate Before Committing
```
@dot Run the full validation workflow on my zsh changes
```
→ Agent loads `validate-dotfiles` skill, runs all checks

### Ask About Best Practices
```
@dot I want to add AWS CLI support. Where should it go?
```
→ Agent loads `env-setup` and `makefile-targets` skills, explains the process

### Debug Issues
```
@dot My PATH is broken. Help me fix it using the env-setup skill.
```
→ Agent loads `env-setup`, runs diagnostics, shows the fix

### Understand Complex Topics
```
@dot Explain the ZSH module loading order and why it matters
```
→ Agent loads `zsh-modules` skill, explains in detail

### Create a Complex Feature
```
@dot Design a new feature that:
1. Adds a new tool via mise
2. Integrates it into tools.zsh
3. Creates an alias in alias.zsh
4. Validates everything
5. Generates a commit message
```
→ Agent uses multiple skills, orchestrates the workflow

## Skills Available

Type `@dot /skill load <skill-name>` to load a specific skill:

- `validate-dotfiles` — Validation checklist and commands
- `tmux-config` — Tmux bindings, prefix, pbcopy details
- `zsh-modules` — 11-module loading order, module purposes
- `neovim-setup` — lazy.nvim, LSP, Mason reference
- `makefile-targets` — What each Makefile target does
- `shell-best-practices` — Shell scripting patterns
- `env-setup` — Installation order, prerequisites, troubleshooting

## Permissions

The agent can:
✅ Read and analyze files
✅ Run validation (make verify, bash scripts/validate-configs.sh)
✅ Suggest changes
✅ Check syntax (zsh -n, tmux source-file -v)

The agent cannot:
❌ Make changes without asking
❌ Run dangerous bash (rm, mv)
❌ Use web access
❌ Run make all (you should use make profile)

## Examples

### Example 1: Add a ZSH Module

```
You: @dot I want to add a new ZSH module for fzf integration.
     What's the complete checklist?

@dot: I'll load the zsh-modules skill to guide you through this.

      Checklist:
      1. Understand ZSH module loading order (env → options → ... → tools)
      2. Decide which module owns this (probably tools.zsh since it's integration)
      3. Create the config
      4. Test syntax: zsh -n ~/.zsh.d/tools.zsh
      5. Validate with: bash scripts/validate-configs.sh
      6. Reload and test
      7. Create commit message

You: Let's do it. Here's my fzf configuration...

@dot: [Makes the change, validates, suggests commit message]
```

### Example 2: Debug PATH Issue

```
You: @dot My PATH is broken after editing tools.zsh.
     Debug this using the env-setup skill.

@dot: I'll load env-setup to help. Let me check current state...

      Problem found: HOMEBREW_PREFIX not set correctly
      Solution: Check env.zsh first, then tools.zsh initialization

      Run this to verify:
      echo $HOMEBREW_PREFIX
      echo $PATH | tr ':' '\n' | head -10

You: [Runs commands]

@dot: [Shows the issue and fix]
```

### Example 3: Validate Tmux Changes

```
You: @dot Validate my tmux.conf changes against the quirks in AGENTS.md

@dot: Loading validate-dotfiles skill...
      Checking:
      - Tmux syntax: ✅ Valid
      - prefix2 C-a setup: ✅ Present
      - pbcopy bindings: ✅ 3 bindings found
      - No tmux-yank: ✅ Clear
      - Mouse support: ✅ Enabled

      All validations passed!
```

## Tips

1. **Read AGENTS.md first** — It's the source of truth for constraints
2. **Be specific** — "Add AWS CLI" is clearer than "Add support for something"
3. **Load skills explicitly** — `@dot /skill load validate-dotfiles` for deep dives
4. **Validate before committing** — Always ask agent to run validation workflow
5. **Use for learning** — Ask the agent to explain how things work

## When to Use @dot

✅ **Do use @dot for:**
- Validation & syntax checking
- Understanding complex workflows
- Designing new features
- Troubleshooting issues
- Learning project constraints

❌ **Don't use @dot for:**
- Simple file edits (just edit in your editor)
- One-off commands (use terminal directly)
- Things you already know how to do

## Related Docs

- `.opencode/README.md` — Full configuration guide
- `.opencode/IMPLEMENTATION.md` — Design details
- `AGENTS.md` — Agent quirks and constraints
- `.opencode/agents/dot/AGENT.md` — Agent capabilities
- `.opencode/skills/*/` — Individual skill details

## Still Have Questions?

Ask the agent directly in OpenCode:

```
@dot What can you help me with in this dotfiles repo?
@dot Explain the design of this OpenCode setup
@dot Show me example workflows I can try
```

---

**Happy coding with @dot!** 🚀
