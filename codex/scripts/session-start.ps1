# Open Workshop — Codex Edition (Session Start Helper)
# This script provides parity guidance for Codex since hooks are not automatic.

$DataHome = Join-Path $HOME ".open-workshop"
$Config = Join-Path $DataHome "config.yaml"
$Manifest = Join-Path $DataHome "projects\_manifest.yaml"

if (!(Test-Path $Config)) {
  Write-Host "Open Workshop: first run detected (missing config)."
  Write-Host "Run the setup wizard skill: setup-wizard"
  exit 0
}

Write-Host "Open Workshop config found."
if (Test-Path $Manifest) {
  Write-Host "Project manifest found."
}
Write-Host "Ask Codex to show the dashboard via the workshop-dashboard skill."
