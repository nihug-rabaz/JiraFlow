---
name: jira-flow
description: Handles Jira Cloud workflows in this repository using the PowerShell JiraToolkit and orchestrator. Use when the user asks to create, update, search, or sync Jira issues, projects, boards, sprints, or code changes.
---

# Jira Flow Agent

Use this repository's Jira toolkit from the repo root.

## Required runtime behavior

1. Load `.env` before Jira commands.
2. Never expose `.env` values.
3. Prefer `scripts/jira/orchestrator/jira-orchestrator.ps1` for multi-step flows.
4. Use direct scripts under `scripts/jira/` only for single explicit actions.

## Environment loading

```powershell
Get-Content .env | Where-Object { $_ -match '^[^#]' -and $_ -match '=' } | ForEach-Object {
  $n, $v = $_ -split '=', 2
  $val = $v.Trim()
  if ($val.StartsWith('"') -and $val.EndsWith('"')) { $val = $val.Substring(1, $val.Length - 2) }
  Set-Item -Path ("Env:{0}" -f $n.Trim()) -Value $val
}
```

## Safety

- Destructive actions require explicit confirmation.
- For ambiguous actions, ask first.
- Do not auto-transition issue status unless user explicitly asks.

## Duplicate prevention

Before creating issues, check:
- Issue key in branch name
- Issue key in recent commits
- Similar summary/title
- Related changed files

Prefer update over create when a related issue already exists.

## Sync behavior

After meaningful code changes, run `sync_code`.

When running sync, verify git repository and include:
- Branch
- Recent commits
- Git status
- Git diff
- Changed files
