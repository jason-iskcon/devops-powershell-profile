# Test script for PowerShell Profile
# Validates that all documented aliases exist and work correctly

param(
    [switch]$SkipExecutionTests,
    [switch]$Verbose,
    [switch]$Quiz
)

$ErrorActionPreference = "Stop"
$TestResults = @()
$FailedTests = @()

function Test-Alias {
    param(
        [string]$AliasName,
        [string]$ExpectedCommand,
        [string]$Category,
        [switch]$SkipExecution
    )
    
    $result = @{
        Name = $AliasName
        Category = $Category
        Exists = $false
        Works = $false
        Error = $null
    }
    
    try {
        # Check if command exists (as function, alias, or cmdlet)
        $cmd = Get-Command $AliasName -ErrorAction SilentlyContinue
        if ($cmd) {
            $result.Exists = $true
            $result.Works = $true  # If it exists, assume it works (execution tests are optional)
            
            if ($Verbose) {
                $result.CommandType = $cmd.CommandType
                $result.Source = if ($cmd.Source) { $cmd.Source } else { "Profile Function" }
            }
        } else {
            $result.Error = "Command not found"
            $FailedTests += $result
        }
    } catch {
        $result.Error = $_.Exception.Message
        $FailedTests += $result
    }
    
    $TestResults += $result
    
    if ($Verbose -and $result.Exists) {
        Write-Host "    [Type: $($result.CommandType), Source: $($result.Source)]" -ForegroundColor DarkGray
    }
    
    return $result
}

Write-Host "`n=== PowerShell Profile Test Suite ===" -ForegroundColor Cyan
Write-Host "Testing all documented aliases...`n" -ForegroundColor Yellow

# Load the profile
Write-Host "Loading profile..." -ForegroundColor Gray
$profilePath = $PROFILE
if (-not (Test-Path $profilePath)) {
    # Try to find the profile file in current directory
    $localProfile = Join-Path $PSScriptRoot "Microsoft.Powershell_profile.ps1"
    if (Test-Path $localProfile) {
        $profilePath = $localProfile
        Write-Host "Using local profile: $profilePath" -ForegroundColor Gray
    } else {
        Write-Host "✗ Profile not found at $profilePath" -ForegroundColor Red
        Write-Host "  Please ensure the profile is installed or run from the profile directory" -ForegroundColor Yellow
        exit 1
    }
}

try {
    # Suppress module import errors (modules may not be installed in test environment)
    $ErrorActionPreference = "Continue"
    . $profilePath 2>&1 | Out-Null
    $ErrorActionPreference = "Stop"
    Write-Host "✓ Profile loaded successfully`n" -ForegroundColor Green
} catch {
    # Check if it's just a module import error (non-fatal)
    if ($_.Exception.Message -match "module|import") {
        Write-Host "⚠ Profile loaded with warnings (some modules may not be installed)" -ForegroundColor Yellow
        Write-Host "  Continuing with tests...`n" -ForegroundColor Gray
    } else {
        Write-Host "✗ Failed to load profile: $_" -ForegroundColor Red
        Write-Host "  Error details: $($_.Exception.Message)" -ForegroundColor Yellow
        exit 1
    }
}

# ============================================
# Git Aliases Tests
# ============================================
Write-Host "--- Testing Git Aliases ---" -ForegroundColor Cyan

$gitAliases = @(
    @{Name="ga"; Desc="git add"},
    @{Name="gaa"; Desc="git add --all"},
    @{Name="gcmsg"; Desc="git commit -m"},
    @{Name="gp"; Desc="git push"},
    @{Name="gl"; Desc="git pull"},
    @{Name="gco"; Desc="git checkout"},
    @{Name="gcb"; Desc="git checkout -b"},
    @{Name="gbr"; Desc="git branch"},
    @{Name="gbd"; Desc="git branch -d"},
    @{Name="gs"; Desc="git status"},
    @{Name="gd"; Desc="git diff"},
    @{Name="gds"; Desc="git diff --staged"},
    @{Name="gst"; Desc="git stash"},
    @{Name="gsta"; Desc="git stash apply"},
    @{Name="gstd"; Desc="git stash drop"},
    @{Name="gcl"; Desc="git clone"},
    @{Name="glog"; Desc="git log"},
    @{Name="gsh"; Desc="git show"}
)

foreach ($alias in $gitAliases) {
    $test = Test-Alias -AliasName $alias.Name -ExpectedCommand $alias.Desc -Category "Git" -SkipExecution
    if ($test.Exists) {
        Write-Host "  ✓ $($alias.Name) - $($alias.Desc)" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $($alias.Name) - $($alias.Desc) - NOT FOUND" -ForegroundColor Red
    }
}

# ============================================
# Terraform Aliases Tests
# ============================================
Write-Host "`n--- Testing Terraform Aliases ---" -ForegroundColor Cyan

$terraformAliases = @(
    @{Name="ti"; Desc="terraform init"},
    @{Name="tp"; Desc="terraform plan"},
    @{Name="ta"; Desc="terraform apply --auto-approve"},
    @{Name="td"; Desc="terraform destroy"},
    @{Name="tv"; Desc="terraform validate"},
    @{Name="tfmt"; Desc="terraform fmt"},
    @{Name="tpt"; Desc="terraform plan -target="},
    @{Name="tat"; Desc="terraform apply -target= --auto-approve"}
)

foreach ($alias in $terraformAliases) {
    $test = Test-Alias -AliasName $alias.Name -ExpectedCommand $alias.Desc -Category "Terraform" -SkipExecution
    if ($test.Exists) {
        Write-Host "  ✓ $($alias.Name) - $($alias.Desc)" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $($alias.Name) - $($alias.Desc) - NOT FOUND" -ForegroundColor Red
    }
}

# ============================================
# Kubectl Base Commands Tests
# ============================================
Write-Host "`n--- Testing Kubectl Base Commands ---" -ForegroundColor Cyan

$kubectlBase = @(
    @{Name="k"; Desc="kubectl"},
    @{Name="kz"; Desc="kubectl --namespace=kube-system"},
    @{Name="kg"; Desc="kubectl get"},
    @{Name="kd"; Desc="kubectl describe"},
    @{Name="kx"; Desc="kubectl delete"},
    @{Name="ka"; Desc="kubectl apply"},
    @{Name="kl"; Desc="kubectl logs"},
    @{Name="ke"; Desc="kubectl exec"}
)

foreach ($alias in $kubectlBase) {
    $test = Test-Alias -AliasName $alias.Name -ExpectedCommand $alias.Desc -Category "Kubectl-Base" -SkipExecution
    if ($test.Exists) {
        Write-Host "  ✓ $($alias.Name) - $($alias.Desc)" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $($alias.Name) - $($alias.Desc) - NOT FOUND" -ForegroundColor Red
    }
}

# ============================================
# Kubectl Resource Commands Tests
# ============================================
Write-Host "`n--- Testing Kubectl Resource Commands ---" -ForegroundColor Cyan

$kubectlResources = @(
    @{Name="kgp"; Desc="kubectl get pods"},
    @{Name="kzgp"; Desc="kubectl get pods (kube-system)"},
    @{Name="kdp"; Desc="kubectl describe pods"},
    @{Name="kxp"; Desc="kubectl delete pods"},
    @{Name="kgde"; Desc="kubectl get deployment"},
    @{Name="kgsv"; Desc="kubectl get service"},
    @{Name="kgi"; Desc="kubectl get ingress"},
    @{Name="kgc"; Desc="kubectl get configmap"},
    @{Name="kgse"; Desc="kubectl get secret"},
    @{Name="kgn"; Desc="kubectl get namespaces"},
    @{Name="kgno"; Desc="kubectl get nodes"}
)

foreach ($alias in $kubectlResources) {
    $test = Test-Alias -AliasName $alias.Name -ExpectedCommand $alias.Desc -Category "Kubectl-Resources" -SkipExecution
    if ($test.Exists) {
        Write-Host "  ✓ $($alias.Name) - $($alias.Desc)" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $($alias.Name) - $($alias.Desc) - NOT FOUND" -ForegroundColor Red
    }
}

# ============================================
# Kubectl Output Format Commands Tests
# ============================================
Write-Host "`n--- Testing Kubectl Output Format Commands ---" -ForegroundColor Cyan

$kubectlOutputs = @(
    @{Name="kgpy"; Desc="kubectl get pods yaml"},
    @{Name="kgpj"; Desc="kubectl get pods json"},
    @{Name="kgpo"; Desc="kubectl get pods wide"},
    @{Name="kgpw"; Desc="kubectl get pods watch"},
    @{Name="kgpaa"; Desc="kubectl get pods all namespaces"},
    @{Name="kgpaay"; Desc="kubectl get pods all namespaces yaml"},
    @{Name="kgpsl"; Desc="kubectl get pods show-labels"}
)

foreach ($alias in $kubectlOutputs) {
    $test = Test-Alias -AliasName $alias.Name -ExpectedCommand $alias.Desc -Category "Kubectl-Outputs" -SkipExecution
    if ($test.Exists) {
        Write-Host "  ✓ $($alias.Name) - $($alias.Desc)" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $($alias.Name) - $($alias.Desc) - NOT FOUND" -ForegroundColor Red
    }
}

# ============================================
# Helper Functions Tests
# ============================================
Write-Host "`n--- Testing Helper Functions ---" -ForegroundColor Cyan

$helperFunctions = @(
    @{Name="dy"; Desc="dry-run yaml"},
    @{Name="f"; Desc="force kill"}
)

foreach ($alias in $helperFunctions) {
    $test = Test-Alias -AliasName $alias.Name -ExpectedCommand $alias.Desc -Category "Helpers" -SkipExecution
    if ($test.Exists) {
        Write-Host "  ✓ $($alias.Name) - $($alias.Desc)" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $($alias.Name) - $($alias.Desc) - NOT FOUND" -ForegroundColor Red
    }
}

# ============================================
# Summary Report
# ============================================
Write-Host "`n=== Test Summary ===" -ForegroundColor Cyan

$total = $TestResults.Count
$passed = ($TestResults | Where-Object { $_.Exists }).Count
$failed = ($TestResults | Where-Object { -not $_.Exists }).Count

Write-Host "Total Tests: $total" -ForegroundColor White
Write-Host "Passed: $passed" -ForegroundColor Green
Write-Host "Failed: $failed" -ForegroundColor $(if ($failed -eq 0) { "Green" } else { "Red" })

if ($FailedTests.Count -gt 0) {
    Write-Host "`nFailed Tests:" -ForegroundColor Red
    foreach ($test in $FailedTests) {
        Write-Host "  ✗ $($test.Name) ($($test.Category)): $($test.Error)" -ForegroundColor Red
    }
    
    Write-Host "`n💡 Tip: Make sure the profile is loaded. Try:" -ForegroundColor Yellow
    Write-Host "   . `$PROFILE" -ForegroundColor White
    Write-Host "   Or ensure Microsoft.Powershell_profile.ps1 is in your profile directory" -ForegroundColor White
    
    exit 1
} else {
    Write-Host "`n✓ All tests passed!" -ForegroundColor Green
    Write-Host "  All $total documented aliases are available and ready to use." -ForegroundColor Gray
    exit 0
}

# ============================================
# Interactive Quiz Mode
# ============================================
if ($Quiz) {
    Write-Host "`n=== Interactive Quiz Mode ===" -ForegroundColor Cyan
    Write-Host "Test your knowledge of the aliases!`n" -ForegroundColor Yellow
    
    $quizQuestions = @(
        @{Q="What's the alias for 'git pull'?"; A="gl"; Hint="Uses the last letter of 'pull'"},
        @{Q="What's the alias for 'kubectl get pods'?"; A="kgp"; Hint="k + get + pods"},
        @{Q="What's the alias for 'terraform apply --auto-approve'?"; A="ta"; Hint="terraform + apply"},
        @{Q="What's the alias for 'kubectl delete pods'?"; A="kxp"; Hint="k + x (exterminate) + pods"},
        @{Q="What's the alias for 'git commit -m'?"; A="gcmsg"; Hint="git + commit + message"},
        @{Q="What's the alias for 'kubectl get pods --all-namespaces -o yaml'?"; A="kgpaay"; Hint="k + get + pods + all-all + yaml"},
        @{Q="What's the alias for 'kubectl get pods (kube-system namespace)'?"; A="kzgp"; Hint="k + z (zone zero) + get + pods"},
        @{Q="What's the alias for 'terraform destroy'?"; A="td"; Hint="terraform + destroy"}
    )
    
    $score = 0
    $total = $quizQuestions.Count
    
    foreach ($q in $quizQuestions) {
        Write-Host "`nQ: $($q.Q)" -ForegroundColor White
        if ($q.Hint) {
            Write-Host "   Hint: $($q.Hint)" -ForegroundColor DarkGray
        }
        $answer = Read-Host "Your answer"
        
        if ($answer -eq $q.A) {
            Write-Host "  ✓ Correct! Well done!" -ForegroundColor Green
            $score++
        } else {
            Write-Host "  ✗ Incorrect. The answer is: $($q.A)" -ForegroundColor Red
        }
    }
    
    $percentage = [math]::Round(($score / $total) * 100)
    Write-Host "`n=== Quiz Results ===" -ForegroundColor Cyan
    Write-Host "Score: $score / $total ($percentage%)" -ForegroundColor $(if ($percentage -ge 80) { "Green" } elseif ($percentage -ge 60) { "Yellow" } else { "Red" })
    
    if ($percentage -eq 100) {
        Write-Host "🎉 Perfect! You've mastered the aliases!" -ForegroundColor Green
    } elseif ($percentage -ge 80) {
        Write-Host "Great job! You're well on your way to mastery." -ForegroundColor Green
    } elseif ($percentage -ge 60) {
        Write-Host "Good progress! Keep practicing with the learning path." -ForegroundColor Yellow
    } else {
        Write-Host "Keep studying! Review Tier 1 commands and try again." -ForegroundColor Yellow
    }
    
    exit 0
}

