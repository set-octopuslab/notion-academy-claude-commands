# Sync notion-academy slash commands to ~/.claude/commands/
# Run from inside the cloned repo dir.

$local = Join-Path $HOME ".claude\commands"
$repoDir = if ($env:REPO_DIR) { $env:REPO_DIR } else { Split-Path -Parent $PSScriptRoot }

New-Item -ItemType Directory -Force -Path $local | Out-Null

$exclude = @('README.md', 'SETUP_FLOW.md', '_DEPRECATED.md')

Get-ChildItem -Path $repoDir -Filter "*.md" -File | Where-Object {
  $exclude -notcontains $_.Name
} | ForEach-Object {
  Copy-Item -Path $_.FullName -Destination $local -Force
}

Write-Host "[sync-commands] Copied .md files from $repoDir to $local"
