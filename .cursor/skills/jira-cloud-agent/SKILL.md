---
name: jira-cloud-agent
description: >-
  Operates Jira Cloud via the repo PowerShell toolkit (module JiraToolkit, scripts under scripts/jira/, orchestrator jira-orchestrator.ps1). Use when the user mentions Jira, issues, sprints, boards, workload, syncing git commits to tickets, project context, or asks to create/update/search Jira tasks from Cursor.
---

# Jira Cloud Agent (this repo)

## Preconditions

- Repo root contains `modules/JiraToolkit/` and `scripts/jira/`.
- User must have credentials in `.env` at repo root (never commit). Load before running scripts:

```powershell
Get-Content .env | Where-Object { $_ -match '^[^#]' -and $_ -match '=' } | ForEach-Object {
  $n, $v = $_ -split '=', 2
  $val = $v.Trim()
  if ($val.StartsWith('"') -and $val.EndsWith('"')) { $val = $val.Substring(1, $val.Length - 2) }
  Set-Item -Path ("Env:{0}" -f $n.Trim()) -Value $val
}
```

- Run PowerShell from repo root: `Set-Location <repo-root>`.

## Prefer orchestration for multi-step or AI-driven flows

- Central entry: `scripts/jira/orchestrator/jira-orchestrator.ps1`
- Request shape:

```json
{
  "intent": "create_issue",
  "context": {},
  "data": { "BodyJson": "{\"fields\":{...}}" }
}
```

- `intent` matches keys in `scripts/jira/orchestrator/intent-mapper.json` (script basename with `-` replaced by `_`, e.g. `get_my_user`, `search_issues`).
- Built-in aliases in the orchestrator include: `sync_code`, `analyze_project`, `create_task`, `update_task`, `list_open_by_status`, `project_health`.
- Destructive intents require `-Force` on the orchestrator or `"confirmToken": "CONFIRM_DESTRUCTIVE"` in the JSON body.
- Dry run: `jira-orchestrator.ps1 -RequestJson '...' -DryRun`

## Direct scripts (single action)

Bootstrap is already inside each script (dot-sources `scripts/jira/_Bootstrap.ps1`). Examples (paths from repo root):

- Connection: `scripts/jira/connection/test-jira-connection.ps1`
- Issues: `scripts/jira/issues/search-issues.ps1`, `create-issue.ps1`, `update-issue.ps1`
- Projects: `scripts/jira/projects/get-projects.ps1`
- Context (JSON for AI): `scripts/jira/context/get-project-context.ps1`, `get-user-context.ps1`, `get-recent-activity.ps1`
- Git helpers: `scripts/jira/git/parse-branch-name.ps1`, `detect-issue-from-code.ps1`
- Safety gates: `scripts/jira/safety/validate-action.ps1`

## Intent selection (for Rules / chat)

Map user language to `intent` or alias:

| User goal | intent or alias |
|-----------|-------------------|
| Create task / issue | `create_task` or `create_issue` |
| Update issue | `update_task` or `update_issue` |
| Search / JQL | `search_issues` |
| Sync git change to tickets | `sync_code` |
| Project summary / health | `analyze_project` or `project_health` |
| My open work | use context `get-user-context.ps1` or JQL via `search_issues` |
| Boards / sprints | scripts under `scripts/jira/agile/` |

## Technical notes

- Jira Cloud search uses `POST /rest/api/3/search/jql` (implemented in `JiraRestClient.SearchJql`).
- Do not paste API tokens into chat or commit `.env`.

## Optional: reference

For full script list and folders, list `scripts/jira/` subdirectories: `connection`, `projects`, `users`, `issues`, `meta`, `agile`, `epic`, `reports`, `sync`, `labels`, `automation`, `context`, `git`, `memory`, `safety`, `orchestrator`.
