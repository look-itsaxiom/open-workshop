# Open Workshop — Codex Edition (Cost Tracker Wrapper)
param(
  [Parameter(Mandatory=$true)]
  [string]$TranscriptPath,
  [string]$SessionId,
  [string]$TeammateName,
  [string]$TeamName,
  [string]$AgentId,
  [string]$AgentType
)

$payload = [ordered]@{
  hook_event_name = "SubagentStop"
  transcript_path = $TranscriptPath
}

if ($SessionId)   { $payload.session_id = $SessionId }
if ($TeammateName){ $payload.teammate_name = $TeammateName }
if ($TeamName)    { $payload.team_name = $TeamName }
if ($AgentId)     { $payload.agent_id = $AgentId }
if ($AgentType)   { $payload.agent_type = $AgentType }

$payload | ConvertTo-Json -Depth 4 | node (Join-Path $PSScriptRoot "..\hooks\scripts\track-cost.js")
