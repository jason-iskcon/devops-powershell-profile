# Installation script for PowerShell Profile
# Automates the setup process

param(
    [switch]$SkipModules,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

Write-Host "`n=== PowerShell Profile Installation ===" -ForegroundColor Cyan
Write-Host "This script will install the DevOps-focused PowerShell profile.`n" -ForegroundColor Yellow

# Check if running as admin (needed for module installation)
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $SkipModules -and -not $isAdmin) {
    Write-Host "⚠️  Warning: Not running as administrator." -ForegroundColor Yellow
    Write-Host "   Module installation requires admin privileges." -ForegroundColor Yellow
    Write-Host "   You can:" -ForegroundColor Yellow
    Write-Host "   1. Run this script as administrator, OR" -ForegroundColor White
    Write-Host "   2. Use -SkipModules and install modules manually later" -ForegroundColor White
    $continue = Read-Host "`nContinue anyway? (y/N)"
    if ($continue -ne "y" -and $continue -ne "Y") {
        exit 0
    }
}

# Step 1: Install PowerShell modules
if (-not $SkipModules) {
    Write-Host "`n[1/3] Installing PowerShell modules..." -ForegroundColor Cyan
    
    $modules = @("posh-git", "git-aliases", "PSKubectlCompletion")
    
    foreach ($module in $modules) {
        Write-Host "  Installing $module..." -ForegroundColor Gray
        try {
            Install-Module -Name $module -Scope CurrentUser -Force:$Force -ErrorAction Stop
            Write-Host "  ✓ $module installed" -ForegroundColor Green
        } catch {
            Write-Host "  ✗ Failed to install $module : $_" -ForegroundColor Red
            Write-Host "    You may need to run as administrator or use -SkipModules" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "`n[1/3] Skipping module installation (use -SkipModules)" -ForegroundColor Yellow
    Write-Host "  Remember to install manually:" -ForegroundColor Gray
    Write-Host "    Install-Module posh-git" -ForegroundColor White
    Write-Host "    Install-Module git-aliases" -ForegroundColor White
    Write-Host "    Install-Module PSKubectlCompletion" -ForegroundColor White
}

# Step 2: Determine profile path
Write-Host "`n[2/3] Locating PowerShell profile..." -ForegroundColor Cyan

$profilePath = $PROFILE
$profileDir = Split-Path -Path $profilePath -Parent

if (-not (Test-Path $profileDir)) {
    Write-Host "  Creating profile directory: $profileDir" -ForegroundColor Gray
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

Write-Host "  Profile path: $profilePath" -ForegroundColor Gray

# Step 3: Copy profile file
Write-Host "`n[3/3] Installing profile..." -ForegroundColor Cyan

$sourceProfile = Join-Path $PSScriptRoot "Microsoft.Powershell_profile.ps1"
# The profile dot-sources the generated kubectl aliases from its own directory.
$sourceAliases = Join-Path $PSScriptRoot "k-aliases.ps1"

foreach ($source in @($sourceProfile, $sourceAliases)) {
    if (-not (Test-Path $source)) {
        Write-Host "  ✗ Source file not found: $source" -ForegroundColor Red
        Write-Host "    Make sure you're running this script from the profile directory" -ForegroundColor Yellow
        exit 1
    }
}

if (Test-Path $profilePath) {
    if ($Force) {
        Write-Host "  Backing up existing profile..." -ForegroundColor Gray
        $backupPath = "$profilePath.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Copy-Item -Path $profilePath -Destination $backupPath -Force
        Write-Host "  ✓ Backup created: $backupPath" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  Profile already exists at: $profilePath" -ForegroundColor Yellow
        $overwrite = Read-Host "  Overwrite? (y/N)"
        if ($overwrite -ne "y" -and $overwrite -ne "Y") {
            Write-Host "  Installation cancelled." -ForegroundColor Yellow
            exit 0
        }
    }
}

try {
    Copy-Item -Path $sourceProfile -Destination $profilePath -Force
    Copy-Item -Path $sourceAliases -Destination (Join-Path $profileDir "k-aliases.ps1") -Force
    Write-Host "  ✓ Profile installed successfully!" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Failed to install profile: $_" -ForegroundColor Red
    exit 1
}

# Final instructions
Write-Host "`n=== Installation Complete! ===" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "1. Restart your PowerShell session (or run: . `$PROFILE)" -ForegroundColor White
Write-Host "2. Test the installation: .\Test-Profile.ps1" -ForegroundColor White
Write-Host "3. Try the quiz: .\Test-Profile.ps1 -Quiz" -ForegroundColor White
Write-Host "4. Read the README.md for learning resources" -ForegroundColor White
Write-Host "`nEnjoy your new aliases! 🚀" -ForegroundColor Green

