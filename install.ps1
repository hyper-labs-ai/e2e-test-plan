#!/usr/bin/env pwsh
# Install e2e-test-plan skill for OpenCode / Claude Code on Windows
# Usage: .\install.ps1 [-TargetDir <path>]
#   or:  irm https://raw.githubusercontent.com/hyper-labs-ai/e2e-test-plan/main/install.ps1 | iex

param(
    [string]$TargetDir = "$HOME\.agents\skills\e2e-test-plan"
)

$Repo = "hyper-labs-ai/e2e-test-plan"
$Branch = "main"
$TmpDir = "$env:TEMP\e2e-test-plan-install"

Write-Host "Downloading from GitHub ($Repo)..." -ForegroundColor Cyan

# Clean and recreate temp dir
if (Test-Path $TmpDir) { Remove-Item -Recurse -Force $TmpDir }
New-Item -ItemType Directory -Path $TmpDir -Force | Out-Null

# Download tarball
$Tarball = "$TmpDir\skill.tar.gz"
Invoke-WebRequest -Uri "https://api.github.com/repos/$Repo/tarball/$Branch" -OutFile $Tarball

# Extract (tar is available on Windows 10 1803+ / PowerShell Core)
$ExtractDir = "$TmpDir\extracted"
New-Item -ItemType Directory -Path $ExtractDir -Force | Out-Null
tar -xzf $Tarball -C $ExtractDir

# Find the extracted repo directory (name includes commit SHA)
$RepoDir = Get-ChildItem -Path $ExtractDir | Select-Object -First 1 -ExpandProperty FullName

# Create target directories
New-Item -ItemType Directory -Path "$TargetDir\references" -Force | Out-Null
New-Item -ItemType Directory -Path "$TargetDir\evals" -Force | Out-Null

# Copy skill files
Copy-Item "$RepoDir\SKILL.md" "$TargetDir\SKILL.md" -Force
Copy-Item "$RepoDir\references\plan-template.md" "$TargetDir\references\plan-template.md" -Force
Copy-Item "$RepoDir\references\plan-formats.md" "$TargetDir\references\plan-formats.md" -Force
if (Test-Path "$RepoDir\evals\evals.json") {
    Copy-Item "$RepoDir\evals\evals.json" "$TargetDir\evals\evals.json" -Force
}

# Clean up
Remove-Item -Recurse -Force $TmpDir

Write-Host "✓ Installed to $TargetDir" -ForegroundColor Green
Write-Host ""
Write-Host "To verify:" -ForegroundColor Gray
Write-Host "  ls $TargetDir/" -ForegroundColor Gray
