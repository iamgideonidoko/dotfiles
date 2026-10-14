# Codex

Setup links the Rose Pine syntax theme into `~/.codex/themes`. Select it with
`/theme`, or set this in `~/.codex/config.toml`:

```toml
[tui]
theme = "rose-pine"
```

The custom theme colors code blocks and diffs, not the full interface. Select it
with `/theme` in an existing session, or restart Codex after changing the config.
Terminal colors come from Ghostty's Rose Pine theme. Agent directives are generated
from `AGENTS.md` with `make agent-config`.
