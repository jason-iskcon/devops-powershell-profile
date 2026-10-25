# Export aliases to Anki-compatible CSV for spaced repetition
# Import this CSV into Anki to create flashcards for learning aliases

param(
    [string]$OutputFile = "aliases-anki.csv"
)

Write-Host "=== Anki Export Generator ===" -ForegroundColor Cyan
Write-Host "Creating Anki-compatible CSV for spaced repetition...`n" -ForegroundColor Yellow

$aliases = @()

# Git Aliases
$aliases += @{Front="git add"; Back="ga"; Category="Git - Tier 1"; Mnemonic="G + A = Add"}
$aliases += @{Front="git add --all"; Back="gaa"; Category="Git - Tier 1"; Mnemonic="double A = all"}
$aliases += @{Front="git commit -m"; Back="gcmsg"; Category="Git - Tier 1"; Mnemonic="G + Commit + MeSsaGe"}
$aliases += @{Front="git push"; Back="gp"; Category="Git - Tier 1"; Mnemonic="G + P = Push"}
$aliases += @{Front="git pull"; Back="gl"; Category="Git - Tier 1"; Mnemonic="G + L = puLl (last letter)"}
$aliases += @{Front="git checkout"; Back="gco"; Category="Git - Tier 2"; Mnemonic="G + CheckOut"}
$aliases += @{Front="git checkout -b"; Back="gcb"; Category="Git - Tier 2"; Mnemonic="G + Checkout Branch"}
$aliases += @{Front="git branch"; Back="gbr"; Category="Git - Tier 2"; Mnemonic="G + BRanch"}
$aliases += @{Front="git diff"; Back="gd"; Category="Git - Tier 3"; Mnemonic="G + Diff"}
$aliases += @{Front="git log"; Back="glog"; Category="Git - Tier 4"; Mnemonic="G + LOG (full word)"}

# Terraform Aliases
$aliases += @{Front="terraform init"; Back="ti"; Category="Terraform"; Mnemonic="Terraform Init"}
$aliases += @{Front="terraform plan"; Back="tp"; Category="Terraform"; Mnemonic="Terraform Plan"}
$aliases += @{Front="terraform apply --auto-approve"; Back="ta"; Category="Terraform"; Mnemonic="Terraform Apply (⚠️ auto-approve!)"}
$aliases += @{Front="terraform destroy"; Back="td"; Category="Terraform"; Mnemonic="Terraform Destroy (⚠️ destructive!)"}
$aliases += @{Front="terraform validate"; Back="tv"; Category="Terraform"; Mnemonic="Terraform Validate"}

# Kubectl Base Verbs
$aliases += @{Front="kubectl get"; Back="kg"; Category="Kubectl - Tier 1"; Mnemonic="K + Get"}
$aliases += @{Front="kubectl describe"; Back="kd"; Category="Kubectl - Tier 1"; Mnemonic="K + Describe"}
$aliases += @{Front="kubectl delete"; Back="kx"; Category="Kubectl - Tier 1"; Mnemonic="K + eXterminate (⚠️ destructive!)"}
$aliases += @{Front="kubectl apply"; Back="ka"; Category="Kubectl - Tier 1"; Mnemonic="K + Apply"}
$aliases += @{Front="kubectl logs"; Back="kl"; Category="Kubectl - Tier 1"; Mnemonic="K + Logs"}
$aliases += @{Front="kubectl exec"; Back="ke"; Category="Kubectl - Tier 1"; Mnemonic="K + Exec"}

# Kubectl Resources
$aliases += @{Front="kubectl get pods"; Back="kgp"; Category="Kubectl - Tier 2"; Mnemonic="K + Get + Pods"}
$aliases += @{Front="kubectl get deployment"; Back="kgde"; Category="Kubectl - Tier 2"; Mnemonic="K + Get + Deployment"}
$aliases += @{Front="kubectl get service"; Back="kgsv"; Category="Kubectl - Tier 2"; Mnemonic="K + Get + Service (S+V)"}
$aliases += @{Front="kubectl get pods --all-namespaces"; Back="kgpaa"; Category="Kubectl - Tier 3"; Mnemonic="K + Get + Pods + All-All"}
$aliases += @{Front="kubectl get pods -o yaml"; Back="kgpy"; Category="Kubectl - Tier 3"; Mnemonic="K + Get + Pods + Yaml"}
$aliases += @{Front="kubectl get pods (kube-system)"; Back="kzgp"; Category="Kubectl - Tier 4"; Mnemonic="K + Z(one zero) + Get + Pods"}

# Generate CSV
$csvLines = @()
$csvLines += "Front,Back,Category,Mnemonic"

foreach ($alias in $aliases) {
    $front = $alias.Front -replace ',', ';'  # Replace commas to avoid CSV issues
    $back = $alias.Back -replace ',', ';'
    $category = $alias.Category -replace ',', ';'
    $mnemonic = $alias.Mnemonic -replace ',', ';'
    
    $csvLines += "$front,$back,$category,$mnemonic"
}

# Write to file
$csvContent = $csvLines -join "`n"
$csvContent | Out-File -FilePath $OutputFile -Encoding UTF8

Write-Host "✓ Generated $($aliases.Count) flashcards" -ForegroundColor Green
Write-Host "✓ Saved to: $OutputFile`n" -ForegroundColor Green

Write-Host "=== How to Import into Anki ===" -ForegroundColor Cyan
Write-Host "1. Open Anki" -ForegroundColor White
Write-Host "2. File → Import" -ForegroundColor White
Write-Host "3. Select: $OutputFile" -ForegroundColor White
Write-Host "4. Field separator: Comma" -ForegroundColor White
Write-Host "5. Map fields: Front → Front, Back → Back" -ForegroundColor White
Write-Host "6. Import`n" -ForegroundColor White

Write-Host "💡 Tip: Create a custom note type with 'Category' and 'Mnemonic' fields for better organization!" -ForegroundColor Yellow
