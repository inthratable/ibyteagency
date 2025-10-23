<#
git-setup.ps1
Initializes a git repo, creates .gitignore, commits files and optionally adds a remote and pushes.
Usage examples:
  .\git-setup.ps1 -Path "C:\Users\ivan7\Desktop\IBYTE\ibyte-agency" -Name "Tu Nombre" -Email "tu@email"
  .\git-setup.ps1 -Path . -Name "Tu Nombre" -Email "tu@email" -Remote "https://github.com/tu/tu-repo.git"
#>

param(
  [string]$Path = ".",
  [string]$Name = "",
  [string]$Email = "",
  [string]$Remote = ""
)

# Allow script execution in current process if blocked
Write-Output "Ensuring execution policy for this session..."
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# Resolve path and ensure it exists
$fullPath = (Resolve-Path $Path).Path
Write-Output "Using path: $fullPath"
Set-Location $fullPath

# Check git available
try {
  git --version | Out-Null
} catch {
  Write-Error "Git does not appear to be installed or is not in PATH. Install Git first."
  exit 1
}

# Configure user if provided
if ($Name -ne "") {
  git config --global user.name $Name
  Write-Output "Set git user.name = $Name"
}
if ($Email -ne "") {
  git config --global user.email $Email
  Write-Output "Set git user.email = $Email"
}

# Init repo if not already
if (-not (Test-Path .git)) {
  git init
  Write-Output "Initialized new git repository."
} else {
  Write-Output "Git repository already exists in $fullPath"
}

# Create .gitignore if missing
$gitignorePath = Join-Path $fullPath ".gitignore"
if (-not (Test-Path $gitignorePath)) {
  @"
node_modules
dist
.DS_Store
.env
"@ | Out-File -FilePath $gitignorePath -Encoding utf8 -Force
  Write-Output "Created .gitignore"
} else {
  Write-Output ".gitignore already exists"
}

# Stage and commit
git add .
# If there are no staged changes, skip commit
$staged = git status --porcelain
if (-not [string]::IsNullOrWhiteSpace($staged)) {
  git commit -m "Initial commit — IBYTE landing scaffold"
  Write-Output "Created initial commit."
} else {
  Write-Output "No changes to commit."
}

# Optional: add remote and push
if ($Remote -ne "") {
  git remote add origin $Remote 2>$null
  git branch -M main
  Write-Output "Pushing to remote $Remote (you may be asked for credentials)..."
  git push -u origin main
  Write-Output "Push complete (if credentials supplied)."
} else {
  Write-Output "No remote provided. To add remote manually:"
  Write-Output "  git remote add origin https://github.com/tuUsuario/tu-repo.git"
  Write-Output "  git branch -M main"
  Write-Output "  git push -u origin main"
}

Write-Output "Done. Repo initialized at: $fullPath"