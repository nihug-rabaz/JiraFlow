# Jira Flow Agent Pack

This repository now includes a Jira flow agent definition for multiple coding agents:

- Cursor: `.cursor/agents/jira-flow.md`
- Codex: `.codex/agents/jira-flow.md`
- Claude Code: `.claude/agents/jira-flow.md`
- Antigravity: `.antigravity/agents/jira-flow.md`

All versions implement the same operational policy:

- Load `.env` before Jira commands
- Keep secrets out of logs and commits
- Prefer orchestrator for multi-step Jira workflows
- Use direct scripts only for single explicit actions
- Prevent duplicate issue creation
- Run Jira sync after meaningful code changes

## Prerequisites

1. PowerShell 5.1+
2. Jira credentials in `.env`
3. Required folders exist:
   - `modules/JiraToolkit/`
   - `scripts/jira/`

If toolkit folders are missing, clone:

`https://github.com/nihug-rabaz/JiraFlow.git`

## Environment Setup

Fill `.env` with:

```env
JIRA_BASE_URL="https://your-domain.atlassian.net"
JIRA_EMAIL="your-email@example.com"
JIRA_API_TOKEN="your-jira-api-token"
JIRA_EPIC_LINK_FIELD=
OPENAI_API_KEY=
OPENAI_MODEL=
JIRA_CONFIRM_DESTRUCTIVE=
```

Load environment variables in PowerShell:

```powershell
Get-Content .env | Where-Object { $_ -match '^[^#]' -and $_ -match '=' } | ForEach-Object {
  $n, $v = $_ -split '=', 2
  $val = $v.Trim()
  if ($val.StartsWith('"') -and $val.EndsWith('"')) { $val = $val.Substring(1, $val.Length - 2) }
  Set-Item -Path ("Env:{0}" -f $n.Trim()) -Value $val
}
```

## Installation By Agent

### Cursor

1. Keep file at `.cursor/agents/jira-flow.md`.
2. In chat, delegate Jira workflow tasks to `jira-flow`.

### Codex

1. Keep file at `.codex/agents/jira-flow.md`.
2. Ensure your Codex setup reads project-level agent files from `.codex/agents`.

### Claude Code

1. Keep file at `.claude/agents/jira-flow.md`.
2. Ensure your Claude Code setup reads project agent files from `.claude/agents`.

### Antigravity

1. Keep file at `.antigravity/agents/jira-flow.md`.
2. Map this file in Antigravity's agent profile/config if your installation does not auto-discover project agents.

## Quick Verification

Run from repo root:

```powershell
./scripts/jira/connection/test-jira-connection.ps1
```

Optional orchestrator dry run:

```powershell
./scripts/jira/orchestrator/jira-orchestrator.ps1 -RequestJson '{"intent":"sync_code","context":{},"data":{}}' -DryRun
```

## Notes

- `sync_code` requires a valid git repository.
- Destructive actions require explicit confirmation token or force flag.
- Jira is source of truth for task tracking; git diff is source of truth for code changes.
