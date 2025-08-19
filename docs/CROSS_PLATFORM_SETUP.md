# Cross-Platform Setup Guide

This guide provides setup instructions for the AWS Security Lab across different operating systems and platforms.

## Supported Platforms

- **Windows 10/11** (PowerShell 7+)
- **macOS 10.15+** (Bash/Terminal)
- **Linux** (Ubuntu 18.04+, CentOS 7+, RHEL 7+)
- **WSL2** (Windows Subsystem for Linux)

## Prerequisites

### All Platforms
- AWS Account with appropriate permissions
- Internet connection
- Text editor (VS Code, Notepad++, Vim, etc.)

### Windows
- PowerShell 7+ (recommended) or PowerShell 5.1
- Windows Terminal (optional but recommended)

### macOS
- Terminal.app or iTerm2
- Homebrew (recommended for package management)

### Linux
- Bash shell
- Package manager (apt, yum, dnf)

## Platform-Specific Setup

### Windows Setup

#### Install PowerShell 7
```powershell
# Using winget (Windows 10 1709+)
winget install Microsoft.PowerShell

# Using Chocolatey
choco install powershell

# Manual download
# https://github.com/PowerShell/PowerShell/releases
```

#### Install Windows Terminal (Optional)
```powershell
# Using Microsoft Store (recommended)
# Search for "Windows Terminal" in Microsoft Store

# Using winget
winget install Microsoft.WindowsTerminal
```

#### Install Git
```powershell
# Using winget
winget install Git.Git

# Using Chocolatey
choco install git

# Manual download
# https://git-scm.com/download/win
```

#### Install VS Code
```powershell
# Using winget
winget install Microsoft.VisualStudioCode

# Using Chocolatey
choco install vscode

# Manual download
# https://code.visualstudio.com/
```

### macOS Setup

#### Install Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Install Required Tools
```bash
# Install Git
brew install git

# Install VS Code
brew install --cask visual-studio-code

# Install iTerm2 (optional)
brew install --cask iterm2

# Install PowerShell (optional)
brew install --cask powershell
```

#### Configure Terminal
```bash
# Set default shell to bash
chsh -s /bin/bash

# Add Homebrew to PATH (if not already done)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Linux Setup

#### Ubuntu/Debian
```bash
# Update package list
sudo apt update

# Install required packages
sudo apt install -y git curl wget unzip

# Install VS Code (optional)
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install -y code
```

#### CentOS/RHEL
```bash
# Install EPEL repository
sudo yum install -y epel-release

# Install required packages
sudo yum install -y git curl wget unzip

# Install VS Code (optional)
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yum/repos/code\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo yum install -y code
```

## Common Tools Installation

### AWS CLI v2

#### Windows
```powershell
# Using winget
winget install Amazon.AWSCLI

# Using Chocolatey
choco install awscli

# Manual download
# https://awscli.amazonaws.com/AWSCLIV2.msi
```

#### macOS
```bash
# Using Homebrew
brew install awscli

# Manual download
# https://awscli.amazonaws.com/AWSCLIV2.pkg
```

#### Linux
```bash
# Download and install
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

### Terraform

#### Windows
```powershell
# Using Chocolatey
choco install terraform

# Manual download
# https://www.terraform.io/downloads.html
```

#### macOS
```bash
# Using Homebrew
brew install terraform

# Manual download
# https://www.terraform.io/downloads.html
```

#### Linux
```bash
# Download and install
wget https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip
unzip terraform_1.5.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

### Docker (Optional)

#### Windows
```powershell
# Using winget
winget install Docker.DockerDesktop

# Using Chocolatey
choco install docker-desktop
```

#### macOS
```bash
# Using Homebrew
brew install --cask docker

# Manual download
# https://www.docker.com/products/docker-desktop
```

#### Linux
```bash
# Ubuntu/Debian
sudo apt install -y docker.io docker-compose
sudo usermod -aG docker $USER

# CentOS/RHEL
sudo yum install -y docker docker-compose
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
```

## Environment Configuration

### Windows Environment Variables
```powershell
# Set environment variables
$env:AWS_DEFAULT_REGION = "us-east-1"
$env:AWS_PROFILE = "default"

# Add to PowerShell profile for persistence
Add-Content $PROFILE "`$env:AWS_DEFAULT_REGION = 'us-east-1'"
Add-Content $PROFILE "`$env:AWS_PROFILE = 'default'"
```

### macOS/Linux Environment Variables
```bash
# Add to shell profile
echo 'export AWS_DEFAULT_REGION=us-east-1' >> ~/.bashrc
echo 'export AWS_PROFILE=default' >> ~/.bashrc

# Reload profile
source ~/.bashrc
```

### Cross-Platform Environment File
```bash
# Copy template
cp env.template .env.lab

# Edit with your values
# Windows: notepad .env.lab
# macOS: open -e .env.lab
# Linux: nano .env.lab or vim .env.lab
```

## Platform-Specific Scripts

### Windows Scripts
```powershell
# Run PowerShell scripts
.\scripts\setup_credentials.ps1 setup
.\scripts\setup_lab.ps1 check-aws
.\scripts\setup_lab.ps1 deploy
```

### macOS/Linux Scripts
```bash
# Make scripts executable
chmod +x scripts/*.sh

# Run shell scripts
./scripts/setup_credentials.sh setup
./scripts/setup_lab.sh check-aws
./scripts/setup_lab.sh deploy
```

## Troubleshooting

### Windows Issues

#### PowerShell Execution Policy
```powershell
# Check current policy
Get-ExecutionPolicy

# Set policy for current user
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### Path Issues
```powershell
# Check if tools are in PATH
Get-Command aws
Get-Command terraform

# Add to PATH if needed
$env:PATH += ";C:\Program Files\Amazon\AWSCLIV2"
$env:PATH += ";C:\terraform"
```

### macOS Issues

#### Permission Issues
```bash
# Fix Homebrew permissions
sudo chown -R $(whoami) /opt/homebrew

# Fix script permissions
chmod +x scripts/*.sh
```

#### Path Issues
```bash
# Check PATH
echo $PATH

# Add Homebrew to PATH
echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zprofile
source ~/.zprofile
```

### Linux Issues

#### Package Manager Issues
```bash
# Ubuntu/Debian
sudo apt update && sudo apt upgrade

# CentOS/RHEL
sudo yum update
```

#### Permission Issues
```bash
# Fix ownership
sudo chown -R $USER:$USER ~/.aws

# Fix script permissions
chmod +x scripts/*.sh
```

## Development Environment Setup

### VS Code Extensions

#### Recommended Extensions
- **AWS Toolkit** - AWS service integration
- **Terraform** - Terraform file support
- **YAML** - YAML file support
- **GitLens** - Enhanced Git integration
- **Remote Development** - Remote development support

#### Install Extensions
```bash
# Using VS Code CLI
code --install-extension AmazonWebServices.aws-toolkit-vscode
code --install-extension HashiCorp.terraform
code --install-extension redhat.vscode-yaml
code --install-extension eamodio.gitlens
code --install-extension ms-vscode-remote.vscode-remote-extensionpack
```

### Git Configuration
```bash
# Set global Git configuration
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set default branch name
git config --global init.defaultBranch main

# Configure line endings
git config --global core.autocrlf input  # Linux/macOS
git config --global core.autocrlf true   # Windows
```

## Performance Optimization

### Windows
- Use Windows Terminal instead of Command Prompt
- Enable WSL2 for Linux development
- Use PowerShell 7+ for better performance

### macOS
- Use iTerm2 for better terminal performance
- Install tools via Homebrew for better management
- Use native macOS tools when possible

### Linux
- Use a lightweight desktop environment
- Install only necessary packages
- Use package managers for dependency management

## Security Considerations

### All Platforms
- Never commit credentials to version control
- Use IAM users with minimal permissions
- Enable MFA on AWS accounts
- Regularly rotate access keys

### Platform-Specific
- **Windows**: Use Windows Defender and keep updated
- **macOS**: Enable Gatekeeper and FileVault
- **Linux**: Use firewall (ufw/iptables) and keep updated

## Next Steps

1. **Complete platform setup** using the instructions above
2. **Install required tools** (AWS CLI, Terraform)
3. **Configure environment** using the template
4. **Test your setup** using the validation scripts
5. **Proceed with lab deployment**

## Additional Resources

- [AWS CLI Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Terraform Installation Guide](https://developer.hashicorp.com/terraform/downloads)
- [PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/)
- [Homebrew Documentation](https://brew.sh/)
- [VS Code Documentation](https://code.visualstudio.com/docs)

---

**Remember:** Take your time to set up your development environment properly. A well-configured environment will make your learning experience much smoother!
