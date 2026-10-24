# PowerShell Profile v2.0.0
# DevOps-focused profile with mnemonic aliases for Git, Terraform, and Kubectl
# See README.md for documentation

function cd.. { cd .. }

# Enable command line prompt for git branch and status
Import-Module posh-git

# Enable git aliases if so inclined
Import-Module git-aliases -DisableNameChecking
# https://github.com/gluons/powershell-git-aliases/blob/master/src/aliases.ps1

# e.g.
# gco "foo-feature"
# gcb "bar-new-feature"
# ga .
# gcmsg "this is my commit message"
# gp
# gl

# Tab auto-completion for kubectl command
Import-Module PSKubectlCompletion
Register-KubectlCompletion

# terraform aliases for the main command loop
New-Alias -Name "tf" -Value "terraform"

function ti { terraform init }
function tp { terraform plan }
function ta { terraform apply --auto-approve }
function td { terraform destroy }
function tv { terraform validate }
function tfmt { terraform fmt }
function tpt { terraform plan -target=$args }
function tat { terraform apply -target=$args --auto-approve }

# Powershell, give me grep!
function grep {
    $input | out-string -stream | select-string $args
}
# Powershell, give me export!
function export {
    $pos = $args[0].IndexOf("=")
    $leftPart  = $args[0].Substring(0, $pos)
    $rightPart = $args[0].Substring($pos+1)
    [System.Environment]::SetEnvironmentVariable($leftPart, $rightPart, [System.EnvironmentVariableTarget]::User)
}

# Powershell, give me touch!
function touch {
    New-Item -ItemType File -Name ($args[0])
}

# Powershell, I want to focus. Give me control of Spotify!
function focus {
    start 'https://open.spotify.com/user/spotify/playlist/37i9dQZF1DWX9ZIH7jslKG?si=I4EcN0cnQFy0tdyk_meqqA'
}

# Powershell, I want to relax. Give me control of Spotify!
function relax {
    start 'https://open.spotify.com/user/calmingmusicacademy/playlist/5ePKan7UdZQYLda19zLx2L?si=gUyqCHaPScqtm8uE9CkY7A'
}

# kubectl aliases - syntax 
#
# k = kubectl
#    z = --namespace kube-system
#
# sub-commands:
# g = get, d = describe, x = delete, a = apply -f, e = exec -i -t, l = logs -f
#
# resources:
# p = pod, de = deployment, i = ingress, sv = service, c = configmap, se = secret, n = namespace, no = node
# 
# flags:
# output = y (yaml), j (json), o (wide)
# aa = --all-namespaces (get/describe) or --all (delete; e.g. kxpaa = delete pods --all
#      in the current namespace -- destructive)
# long forms: oyaml/owide/ojson = -o=yaml/-o=wide/-o=json, all = aa (e.g. kgpaaoyaml)
# kgnso/kgnsoall = get namespaces -o=wide (kgno is nodes, so n+o cannot be combined)
# sl = --show-labels
# w = -w/--watch
# 
# value flags: (should be at the very end):
# f = -f/--filename
# l = -l/--selector

# kubectl aliases, generated from k-grammar.toml (python3 tools/generate_aliases.py)
. "$PSScriptRoot/k-aliases.ps1"

# Usage tracking for aliases (optional, disabled by default)
# Enable with: $env:TRACK_ALIAS_USAGE = "true"
if ($env:TRACK_ALIAS_USAGE -eq "true") {
    $aliasUsageLog = Join-Path $env:USERPROFILE ".alias-usage.log"
    
    function Track-AliasUsage {
        param([string]$AliasName, [string]$FullCommand)
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $entry = "$timestamp|$AliasName|$FullCommand"
        Add-Content -Path $aliasUsageLog -Value $entry -ErrorAction SilentlyContinue
    }
    
    # Wrap common aliases to track usage (example for a few key ones)
    # Note: This is a simplified version - full implementation would wrap all aliases
    $original_kgp = Get-Command kgp -ErrorAction SilentlyContinue
    if ($original_kgp) {
        function kgp { 
            Track-AliasUsage -AliasName "kgp" -FullCommand "kubectl get pods"
            & kubectl get pods $args 
        }
    }
}

Set-Location ~/Workspace
Clear-Host