# ============================================================
# Claude Code - AWS Bedrock · Optimized for Sonnet 4.6
# March 2026 · Anthropic official best practices
# ============================================================

if command -v claude &>/dev/null; then

  # --- PLATFORM ---------------------------------------------
  export CLAUDE_CODE_USE_BEDROCK=1
  export AWS_REGION=us-east-1

  # CRITICAL for Bedrock: removes experimental beta headers
  # that Bedrock doesn't recognize (causes "Unexpected anthropic-beta header" error)
  # There's a bug post-2.1.18 where this alone isn't always enough,
  # so we also explicitly disable prompt caching
  export CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1
  export DISABLE_PROMPT_CACHING=1

  # --- MODELS -----------------------------------------------
  # Inference profiles with "global." prefix = higher throughput,
  # automatic routing across AWS regions (~10% cheaper than "us.")
  export ANTHROPIC_MODEL='global.anthropic.claude-sonnet-4-6'
  export ANTHROPIC_SMALL_FAST_MODEL='global.anthropic.claude-haiku-4-5-20251001-v1:0'

  # Pin each alias to the correct model → avoids surprises
  # if Anthropic changes the default when a new version ships
  export ANTHROPIC_DEFAULT_SONNET_MODEL='global.anthropic.claude-sonnet-4-6'
  export ANTHROPIC_DEFAULT_HAIKU_MODEL='global.anthropic.claude-haiku-4-5-20251001-v1:0'

  # Sub-agents (parallel tasks / agentic mode) also use Sonnet
  export CLAUDE_CODE_SUBAGENT_MODEL='global.anthropic.claude-sonnet-4-6'

  # --- PERFORMANCE ------------------------------------------
  # Max output tokens (64k is the real ceiling for Sonnet 4.6)
  export CLAUDE_CODE_MAX_OUTPUT_TOKENS=64000

  # Reasoning depth: "high" = deeper reasoning on complex tasks
  # Options: low | medium | high | max | auto
  export CLAUDE_CODE_EFFORT_LEVEL=high

  # Compact context at 70% (before the default 95%)
  # → less information loss during long sessions
  export CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=70

  # Enables 1M token context window (Sonnet 4.6 supports it)
  # (If Bedrock doesn't support it yet on your account, comment this out)
  # export CLAUDE_CODE_DISABLE_1M_CONTEXT=0   # 0 = enabled (default)

  # --- PRIVACY / TRAFFIC ------------------------------------
  # Disable telemetry, auto-updates and all non-essential traffic
  export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
  export DISABLE_AUTOUPDATER=1
  export DISABLE_TELEMETRY=1
  export DISABLE_ERROR_REPORTING=1

fi
