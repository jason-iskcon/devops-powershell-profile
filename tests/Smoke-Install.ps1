# Smoke test for Install-Profile.ps1 and the installed kubectl functions.
#
# Installs into a temporary directory (it overrides $PROFILE for this process only, so a
# real profile is never touched), then loads the installed copy and runs Test-Profile.ps1
# against it. Needs the PowerShell modules the profile imports (posh-git, git-aliases,
# PSKubectlCompletion), or stand-ins on $env:PSModulePath.
#
# Run: pwsh -NoProfile -File tests/Smoke-Install.ps1

$ErrorActionPreference = "Stop"
$repo = Split-Path $PSScriptRoot -Parent
$failures = @()

function Assert-That([bool]$Condition, [string]$Message) {
    if ($Condition) {
        Write-Host "  ok   $Message" -ForegroundColor Green
    } else {
        Write-Host "  FAIL $Message" -ForegroundColor Red
        $script:failures += $Message
    }
}

$temp = Join-Path ([IO.Path]::GetTempPath()) ("profile-smoke-" + [guid]::NewGuid().ToString("N"))
$null = New-Item -ItemType Directory -Path $temp
$env:HOME = $temp
$env:USERPROFILE = $temp
$null = New-Item -ItemType Directory -Path (Join-Path $temp "Workspace")  # the profile ends with Set-Location ~/Workspace

try {
    # The installer and Test-Profile.ps1 both read $PROFILE from the calling scope.
    $PROFILE = Join-Path $temp "Documents/PowerShell/Microsoft.PowerShell_profile.ps1"
    $profileDir = Split-Path $PROFILE -Parent

    Write-Host "`n--- Install into $profileDir ---" -ForegroundColor Cyan
    & (Join-Path $repo "Install-Profile.ps1") -SkipModules -Force | Out-Null
    Assert-That (Test-Path $PROFILE) "profile copied to `$PROFILE"
    Assert-That (Test-Path (Join-Path $profileDir "k-aliases.ps1")) "k-aliases.ps1 copied next to the profile"
    foreach ($file in "Microsoft.Powershell_profile.ps1", "k-aliases.ps1") {
        $installed = if ($file -like "Microsoft*") { $PROFILE } else { Join-Path $profileDir $file }
        $same = (Get-FileHash $installed).Hash -eq (Get-FileHash (Join-Path $repo $file)).Hash
        Assert-That $same "$file is identical to the repository copy"
    }

    Write-Host "`n--- Install again over an existing profile (-Force) ---" -ForegroundColor Cyan
    & (Join-Path $repo "Install-Profile.ps1") -SkipModules -Force | Out-Null
    $backups = @(Get-ChildItem $profileDir -Filter "*.backup.*")
    Assert-That ($backups.Count -eq 1) "the existing profile was backed up exactly once"
    Assert-That ((Get-FileHash $PROFILE).Hash -eq (Get-FileHash (Join-Path $repo "Microsoft.Powershell_profile.ps1")).Hash) "profile still matches after reinstall"

    Write-Host "`n--- Load the installed profile in a fresh PowerShell ---" -ForegroundColor Cyan
    $pwsh = (Get-Process -Id $PID).Path
    $probe = '. $env:SMOKE_PROFILE 2>$null; ' +
             '"kgpaa=" + (Get-Command kgpaa).ScriptBlock.ToString().Trim(); ' +
             '"kxpaa=" + (Get-Command kxpaa).ScriptBlock.ToString().Trim(); ' +
             '"kzgpw=" + (Get-Command kzgpw).ScriptBlock.ToString().Trim()'
    $env:SMOKE_PROFILE = $PROFILE
    $output = & $pwsh -NoProfile -Command $probe 2>&1 | Out-String
    Assert-That ($output -match [regex]::Escape('kgpaa=& kubectl get pods --all-namespaces $args')) "kgpaa expands to get pods --all-namespaces"
    Assert-That ($output -match [regex]::Escape('kxpaa=& kubectl delete pods --all $args')) "kxpaa expands to delete pods --all"
    Assert-That ($output -match [regex]::Escape('kzgpw=& kubectl --namespace=kube-system get pods --watch $args')) "kzgpw targets kube-system"

    Write-Host "`n--- Test-Profile.ps1 against the installed copy ---" -ForegroundColor Cyan
    # Runs in this scope so it picks up the overridden $PROFILE.
    & (Join-Path $repo "Test-Profile.ps1") | Out-Host
    Assert-That ($LASTEXITCODE -eq 0) "Test-Profile.ps1 passes (all 788+ kubectl expansions and the documented aliases)"
}
finally {
    Remove-Item -Recurse -Force $temp -ErrorAction SilentlyContinue
}

if ($failures.Count -gt 0) {
    Write-Host "`n$($failures.Count) smoke check(s) failed." -ForegroundColor Red
    exit 1
}
Write-Host "`nAll smoke checks passed." -ForegroundColor Green
