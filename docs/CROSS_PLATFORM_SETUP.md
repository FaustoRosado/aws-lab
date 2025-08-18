# 🌍 Cross-Platform Setup Guide

This comprehensive guide provides setup instructions for both Windows and Mac users, ensuring everyone can successfully deploy and run the AWS Security Lab regardless of their operating system.

## 📋 Prerequisites by Platform

### Windows Users
- ✅ Windows 10/11 (64-bit)
- ✅ PowerShell 5.1 or PowerShell 7+
- ✅ Administrator access (for some installations)
- ✅ Internet connection

### Mac Users
- ✅ macOS 10.15 (Catalina) or later
- ✅ Terminal application
- ✅ Homebrew package manager (recommended)
- ✅ Internet connection

---

## 🖥️ Windows Setup Guide

### Step 1: Install Required Tools

#### 1.1 Install Terraform

**Option A: Using winget (Recommended)**
```powershell
# Open PowerShell as Administrator
winget install HashiCorp.Terraform
```

**Option B: Manual Installation**
1. Download Terraform from [terraform.io](https://www.terraform.io/downloads)
2. Extract the ZIP file to `C:\terraform`
3. Add `C:\terraform` to your system PATH
4. Restart PowerShell

**Verify Installation:**
```powershell
terraform --version
```

#### 1.2 Install AWS CLI

**Option A: Using winget (Recommended)**
```powershell
winget install Amazon.AWSCLI
```

**Option B: Manual Installation**
1. Download the MSI installer from [AWS CLI Downloads](https://aws.amazon.com/cli/)
2. Run the installer as Administrator
3. Follow the installation wizard
4. Restart PowerShell

**Verify Installation:**
```powershell
aws --version
```

#### 1.3 Install Git (Optional but Recommended)

**Using winget:**
```powershell
winget install Git.Git
```

**Verify Installation:**
```powershell
git --version
```

### Step 2: Configure AWS Credentials

#### 2.1 Create AWS Credentials File

```powershell
# Create .aws directory in your user profile
mkdir $env:USERPROFILE\.aws

# Create credentials file
echo "[default]`naws_access_key_id = YOUR_ACCESS_KEY_ID_HERE`naws_secret_access_key = YOUR_SECRET_ACCESS_KEY_HERE" | Out-File -FilePath "$env:USERPROFILE\.aws\credentials" -Encoding UTF8

# Create config file
echo "[default]`nregion = us-east-1`noutput = json" | Out-File -FilePath "$env:USERPROFILE\.aws\config" -Encoding UTF8
```

#### 2.2 Configure Using AWS CLI (Alternative)

```powershell
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Enter your preferred region (e.g., us-east-1)
# Enter output format (json)
```

#### 2.3 Verify AWS Configuration

```powershell
aws sts get-caller-identity
```

### Step 3: Clone and Setup Lab

#### 3.1 Clone Repository

```powershell
# Navigate to your desired directory
cd C:\Users\YourUsername\Documents

# Clone the repository
git clone https://github.com/yourusername/aws-security-lab.git
cd aws-security-lab
```

#### 3.2 Generate SSH Keys

```powershell
# Navigate to the SSH directory
cd terraform\modules\ec2\ssh

# Generate SSH key pair
ssh-keygen -t rsa -b 2048 -f lab-key -N '""'

# Verify keys were created
dir lab-key*
```

#### 3.3 Run the Lab

```powershell
# Return to lab root directory
cd C:\Users\YourUsername\Documents\aws-security-lab

# Check AWS configuration
.\scripts\setup_lab.ps1 -Action check

# Initialize Terraform
.\scripts\setup_lab.ps1 -Action init

# Deploy infrastructure
.\scripts\setup_lab.ps1 -Action deploy
```

---

## 🍎 Mac Setup Guide

### Step 1: Install Required Tools

#### 1.1 Install Homebrew (Package Manager)

```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH (if not already done)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc
```

#### 1.2 Install Terraform

```bash
# Install Terraform using Homebrew
brew install terraform

# Verify installation
terraform --version
```

#### 1.3 Install AWS CLI

```bash
# Install AWS CLI using Homebrew
brew install awscli

# Verify installation
aws --version
```

#### 1.4 Install Git (if not already installed)

```bash
# Git is usually pre-installed on macOS
# If not, install with Homebrew
brew install git

# Verify installation
git --version
```

### Step 2: Configure AWS Credentials

#### 2.1 Create AWS Credentials File

```bash
# Create .aws directory in your home directory
mkdir ~/.aws

# Create credentials file
cat > ~/.aws/credentials << 'EOF'
[default]
aws_access_key_id = YOUR_ACCESS_KEY_ID_HERE
aws_secret_access_key = YOUR_SECRET_ACCESS_KEY_HERE
EOF

# Create config file
cat > ~/.aws/config << 'EOF'
[default]
region = us-east-1
output = json
EOF
```

#### 2.2 Configure Using AWS CLI (Alternative)

```bash
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Enter your preferred region (e.g., us-east-1)
# Enter output format (json)
```

#### 2.3 Verify AWS Configuration

```bash
aws sts get-caller-identity
```

### Step 3: Clone and Setup Lab

#### 3.1 Clone Repository

```bash
# Navigate to your desired directory
cd ~/Documents

# Clone the repository
git clone https://github.com/yourusername/aws-security-lab.git
cd aws-security-lab
```

#### 3.2 Generate SSH Keys

```bash
# Navigate to the SSH directory
cd terraform/modules/ec2/ssh

# Generate SSH key pair
ssh-keygen -t rsa -b 2048 -f lab-key -N ""

# Verify keys were created
ls -la lab-key*
```

#### 3.3 Run the Lab

```bash
# Return to lab root directory
cd ~/Documents/aws-security-lab

# Check AWS configuration
./scripts/setup_lab.ps1 -Action check

# Initialize Terraform
./scripts/setup_lab.ps1 -Action init

# Deploy infrastructure
./scripts/setup_lab.ps1 -Action deploy
```

---

## 🔧 Platform-Specific Scripts

### Windows PowerShell Scripts

The lab includes PowerShell scripts that work natively on Windows:

- **`setup_lab.ps1`**: Main lab management script
- **`simulate_compromise.ps1`**: Attack simulation script

**Execution Policy (if needed):**
```powershell
# Check current execution policy
Get-ExecutionPolicy

# Set execution policy for current user
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Mac/Linux Script Adaptations

For Mac users, we provide Bash script alternatives:

#### 1.1 Create Mac Setup Script

```bash
# Create a Mac-compatible setup script
cat > setup_lab_mac.sh << 'EOF'
#!/bin/bash

# AWS Security Lab Setup Script for Mac/Linux
# Usage: ./setup_lab_mac.sh [action]

ACTION=${1:-help}

show_help() {
    echo "🔒 AWS Security Lab - EC2 Compromise & Remediation"
    echo ""
    echo "Usage: ./setup_lab_mac.sh [action]"
    echo ""
    echo "Actions:"
    echo "  check     - Check AWS CLI and Terraform installation"
    echo "  init      - Initialize Terraform"
    echo "  plan      - Plan Terraform deployment"
    echo "  deploy    - Deploy infrastructure"
    echo "  destroy   - Destroy infrastructure"
    echo "  simulate  - Run compromise simulation"
    echo "  monitor   - Monitor security findings"
    echo "  help      - Show this help message"
}

check_aws() {
    echo "🔍 Checking AWS CLI configuration..."
    if aws sts get-caller-identity >/dev/null 2>&1; then
        echo "✅ AWS CLI is configured and working"
        aws sts get-caller-identity
        return 0
    else
        echo "❌ AWS CLI configuration issue detected"
        return 1
    fi
}

check_terraform() {
    echo "🔍 Checking Terraform installation..."
    if terraform version >/dev/null 2>&1; then
        echo "✅ Terraform is installed"
        terraform version | head -1
        return 0
    else
        echo "❌ Terraform not found or not working"
        return 1
    fi
}

initialize_terraform() {
    echo "🚀 Initializing Terraform..."
    if [ ! -d "terraform" ]; then
        echo "❌ Terraform directory not found"
        return 1
    fi
    
    cd terraform
    if terraform init; then
        echo "✅ Terraform initialized successfully"
        cd ..
        return 0
    else
        echo "❌ Terraform initialization failed"
        cd ..
        return 1
    fi
}

plan_terraform() {
    echo "📋 Planning Terraform deployment..."
    if [ ! -d "terraform" ]; then
        echo "❌ Terraform directory not found"
        return 1
    fi
    
    cd terraform
    if terraform plan; then
        echo "✅ Terraform plan completed successfully"
        echo "Review the plan above and run 'deploy' when ready"
        cd ..
        return 0
    else
        echo "❌ Terraform plan failed"
        cd ..
        return 1
    fi
}

deploy_infrastructure() {
    echo "🚀 Deploying AWS infrastructure..."
    if [ ! -d "terraform" ]; then
        echo "❌ Terraform directory not found"
        return 1
    fi
    
    cd terraform
    if terraform apply -auto-approve; then
        echo "✅ Infrastructure deployed successfully!"
        echo ""
        echo "🔍 Next steps:"
        echo "1. Check the outputs above for connection information"
        echo "2. Run 'check' to verify deployment"
        echo "3. Run 'simulate' to start security testing"
        cd ..
        return 0
    else
        echo "❌ Infrastructure deployment failed"
        cd ..
        return 1
    fi
}

destroy_infrastructure() {
    echo "🗑️ Destroying AWS infrastructure..."
    echo "⚠️  WARNING: This will delete ALL lab resources!"
    echo "This action cannot be undone."
    
    read -p "Are you sure you want to continue? (yes/no): " confirmation
    
    if [ "$confirmation" != "yes" ]; then
        echo "❌ Operation cancelled by user"
        return 1
    fi
    
    if [ ! -d "terraform" ]; then
        echo "❌ Terraform directory not found"
        return 1
    fi
    
    cd terraform
    if terraform destroy -auto-approve; then
        echo "✅ Infrastructure destroyed successfully!"
        echo "All lab resources have been removed from AWS"
        cd ..
        return 0
    else
        echo "❌ Infrastructure destruction failed"
        cd ..
        return 1
    fi
}

simulate_compromise() {
    echo "🎭 Starting compromise simulation..."
    if [ ! -f "scripts/simulate_compromise.sh" ]; then
        echo "❌ Simulation script not found"
        return 1
    fi
    
    echo "Running compromise simulation..."
    if ./scripts/simulate_compromise.sh; then
        echo "✅ Compromise simulation completed successfully!"
        echo "Check GuardDuty and Security Hub for findings"
        return 0
    else
        echo "❌ Compromise simulation failed"
        return 1
    fi
}

monitor_findings() {
    echo "📊 Monitoring security findings..."
    
    echo "🔍 Checking GuardDuty findings..."
    if aws guardduty list-detectors --query 'DetectorIds[0]' --output text >/dev/null 2>&1; then
        detector_id=$(aws guardduty list-detectors --query 'DetectorIds[0]' --output text)
        findings=$(aws guardduty list-findings --detector-id "$detector_id" --finding-criteria '{"Criterion": {"severity": {"Gte": 4}}}' --query 'FindingIds' --output text)
        
        if [ "$findings" != "None" ] && [ "$findings" != "" ]; then
            echo "🚨 High severity GuardDuty findings detected!"
            echo "Check AWS Console for details"
        else
            echo "✅ No high severity GuardDuty findings"
        fi
    else
        echo "❌ Error checking GuardDuty"
    fi
    
    echo ""
    echo "🔍 Checking Security Hub findings..."
    findings=$(aws securityhub get-findings --filters '{"SeverityLabel": [{"Value": "HIGH", "Comparison": "EQUALS"}]}' --max-items 10 --query 'Findings' --output text)
    
    if [ "$findings" != "None" ] && [ "$findings" != "" ]; then
        echo "🚨 High severity Security Hub findings detected!"
        echo "Check AWS Console for details"
    else
        echo "✅ No high severity Security Hub findings"
    fi
}

# Main execution logic
case $ACTION in
    check)
        check_aws && check_terraform
        ;;
    init)
        check_aws && check_terraform && initialize_terraform
        ;;
    plan)
        check_aws && check_terraform && plan_terraform
        ;;
    deploy)
        check_aws && check_terraform && deploy_infrastructure
        ;;
    destroy)
        check_aws && check_terraform && destroy_infrastructure
        ;;
    simulate)
        simulate_compromise
        ;;
    monitor)
        monitor_findings
        ;;
    help|*)
        show_help
        ;;
esac
EOF

# Make the script executable
chmod +x setup_lab_mac.sh
```

#### 1.2 Create Mac Simulation Script

```bash
# Create a Mac-compatible simulation script
cat > scripts/simulate_compromise.sh << 'EOF'
#!/bin/bash

# Compromise Simulation Script for Mac/Linux
# This script simulates various attack scenarios

echo "🎭 AWS Security Lab - Compromise Simulation"
echo "=========================================="

# Get web server IP from Terraform output
WEB_SERVER_IP=$(cd terraform && terraform output -raw public_web_public_ip 2>/dev/null)

if [ -z "$WEB_SERVER_IP" ]; then
    echo "❌ Could not retrieve web server IP from Terraform"
    echo "Please ensure infrastructure is deployed first"
    exit 1
fi

echo "🌐 Web Server IP: $WEB_SERVER_IP"
echo ""

# Function to simulate port scanning
simulate_port_scan() {
    echo "🔍 Simulating port scanning..."
    
    # Check if nmap is available
    if command -v nmap >/dev/null 2>&1; then
        echo "Running: nmap -sS -p 22,80,443 $WEB_SERVER_IP"
        nmap -sS -p 22,80,443 "$WEB_SERVER_IP"
    else
        echo "⚠️  nmap not available, using alternative method..."
        # Use telnet/netcat to check ports
        for port in 22 80 443; do
            if timeout 5 bash -c "</dev/tcp/$WEB_SERVER_IP/$port" 2>/dev/null; then
                echo "✅ Port $port is open"
            else
                echo "❌ Port $port is closed"
            fi
        done
    fi
    echo ""
}

# Function to simulate brute force attacks
simulate_brute_force() {
    echo "🔐 Simulating brute force attacks..."
    
    # Simulate SSH brute force (without actually attempting)
    echo "Simulating SSH brute force attempts..."
    echo "This would normally trigger GuardDuty findings"
    echo "✅ Brute force simulation completed"
    echo ""
}

# Function to simulate SQL injection
simulate_sql_injection() {
    echo "💉 Simulating SQL injection attacks..."
    
    # Test for SQL injection vulnerability
    echo "Testing web application for SQL injection..."
    
    # Use curl to send malicious payloads
    if command -v curl >/dev/null 2>&1; then
        echo "Sending SQL injection payload: ' OR '1'='1"
        curl -s "http://$WEB_SERVER_IP/?id='%20OR%20'1'='1" | head -5
        
        echo "Sending SQL injection payload: '; DROP TABLE users; --"
        curl -s "http://$WEB_SERVER_IP/?id=';%20DROP%20TABLE%20users;%20--" | head -5
    else
        echo "⚠️  curl not available, using alternative method..."
        echo "Manually test: http://$WEB_SERVER_IP/?id=' OR '1'='1"
    fi
    echo "✅ SQL injection simulation completed"
    echo ""
}

# Function to simulate malicious file upload
simulate_file_upload() {
    echo "📁 Simulating malicious file upload..."
    
    echo "Creating test malicious file..."
    echo "This is a test malicious file for security lab purposes" > /tmp/test_malware.txt
    
    if command -v curl >/dev/null 2>&1; then
        echo "Attempting to upload file to web server..."
        curl -X POST -F "file=@/tmp/test_malware.txt" "http://$WEB_SERVER_IP/" | head -5
    else
        echo "⚠️  curl not available, manual testing required"
    fi
    
    # Clean up test file
    rm -f /tmp/test_malware.txt
    echo "✅ File upload simulation completed"
    echo ""
}

# Function to simulate network scanning
simulate_network_scanning() {
    echo "🌐 Simulating network scanning..."
    
    echo "Simulating internal network reconnaissance..."
    echo "This would normally trigger GuardDuty findings"
    echo "✅ Network scanning simulation completed"
    echo ""
}

# Function to check security findings
check_security_findings() {
    echo "🔍 Checking for security findings..."
    
    echo "Waiting 30 seconds for findings to appear..."
    sleep 30
    
    echo "Checking GuardDuty findings..."
    if aws guardduty list-detectors --query 'DetectorIds[0]' --output text >/dev/null 2>&1; then
        detector_id=$(aws guardduty list-detectors --query 'DetectorIds[0]' --output text)
        findings=$(aws guardduty list-findings --detector-id "$detector_id" --query 'FindingIds' --output text)
        
        if [ "$findings" != "None" ] && [ "$findings" != "" ]; then
            echo "🚨 GuardDuty findings detected!"
            echo "Check AWS Console for details"
        else
            echo "✅ No GuardDuty findings yet"
        fi
    fi
    
    echo "Checking Security Hub findings..."
    findings=$(aws securityhub get-findings --max-items 5 --query 'Findings' --output text)
    
    if [ "$findings" != "None" ] && [ "$findings" != "" ]; then
        echo "🚨 Security Hub findings detected!"
        echo "Check AWS Console for details"
    else
        echo "✅ No Security Hub findings yet"
    fi
}

# Main execution
echo "Starting compromise simulation against $WEB_SERVER_IP"
echo ""

simulate_port_scan
simulate_brute_force
simulate_sql_injection
simulate_file_upload
simulate_network_scanning

echo "🎭 Compromise simulation completed!"
echo ""
echo "📋 Next steps:"
echo "1. Wait a few minutes for findings to appear"
echo "2. Check AWS GuardDuty console for threat findings"
echo "3. Check AWS Security Hub for security findings"
echo "4. Run 'monitor' action to check findings programmatically"
echo ""

check_security_findings
EOF

# Make the script executable
chmod +x scripts/simulate_compromise.sh
```

---

## 🔄 Platform-Specific Commands

### Windows Commands

| Action | Windows Command |
|--------|----------------|
| Check AWS | `.\scripts\setup_lab.ps1 -Action check` |
| Initialize | `.\scripts\setup_lab.ps1 -Action init` |
| Deploy | `.\scripts\setup_lab.ps1 -Action deploy` |
| Destroy | `.\scripts\setup_lab.ps1 -Action destroy` |
| Simulate | `.\scripts\setup_lab.ps1 -Action simulate` |
| Monitor | `.\scripts\setup_lab.ps1 -Action monitor` |

### Mac/Linux Commands

| Action | Mac/Linux Command |
|--------|------------------|
| Check AWS | `./setup_lab_mac.sh check` |
| Initialize | `./setup_lab_mac.sh init` |
| Deploy | `./setup_lab_mac.sh deploy` |
| Destroy | `./setup_lab_mac.sh destroy` |
| Simulate | `./setup_lab_mac.sh simulate` |
| Monitor | `./setup_lab_mac.sh simulate` |

---

## 🛠️ Platform-Specific Troubleshooting

### Windows Issues

#### 1. **PowerShell Execution Policy**
```powershell
# Check current policy
Get-ExecutionPolicy

# Set policy for current user
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### 2. **Path Issues**
```powershell
# Check if tools are in PATH
Get-Command terraform
Get-Command aws

# Add to PATH if needed
$env:PATH += ";C:\terraform"
```

#### 3. **Permission Issues**
```powershell
# Run PowerShell as Administrator for installations
# Right-click PowerShell → Run as Administrator
```

### Mac Issues

#### 1. **Homebrew Path Issues**
```bash
# Add Homebrew to PATH
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc
```

#### 2. **Permission Issues**
```bash
# Make scripts executable
chmod +x setup_lab_mac.sh
chmod +x scripts/simulate_compromise.sh
```

#### 3. **Shell Compatibility**
```bash
# Check your shell
echo $SHELL

# If using bash instead of zsh
echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
```

---

## 🔍 Platform-Specific Verification

### Windows Verification

```powershell
# Check all installations
Write-Host "=== Windows Environment Check ===" -ForegroundColor Green

Write-Host "PowerShell Version:" -ForegroundColor Yellow
$PSVersionTable.PSVersion

Write-Host "Terraform Version:" -ForegroundColor Yellow
terraform --version

Write-Host "AWS CLI Version:" -ForegroundColor Yellow
aws --version

Write-Host "Git Version:" -ForegroundColor Yellow
git --version

Write-Host "Current Directory:" -ForegroundColor Yellow
Get-Location

Write-Host "AWS Configuration:" -ForegroundColor Yellow
aws configure list
```

### Mac Verification

```bash
# Check all installations
echo "=== Mac Environment Check ==="

echo "Shell: $SHELL"
echo "Terraform Version:"
terraform --version

echo "AWS CLI Version:"
aws --version

echo "Git Version:"
git --version

echo "Current Directory:"
pwd

echo "AWS Configuration:"
aws configure list

echo "Homebrew Status:"
brew --version
```

---

## 📱 Mobile and Remote Access

### Windows Remote Desktop

```powershell
# Enable Remote Desktop (if needed)
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
```

### Mac Screen Sharing

```bash
# Enable Screen Sharing
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -clientopts -setvnclegacy -vnclegacy yes -clientopts -setvncpw -vncpw yourpassword -restart -agent -privs -all
```

---

## 🔧 Advanced Platform Configurations

### Windows Advanced Setup

#### 1. **Windows Subsystem for Linux (WSL)**
```powershell
# Install WSL
wsl --install

# Use Linux tools within Windows
wsl terraform --version
wsl aws --version
```

#### 2. **Chocolatey Package Manager**
```powershell
# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install tools with Chocolatey
choco install terraform awscli git
```

### Mac Advanced Setup

#### 1. **Multiple Shell Support**
```bash
# Install additional shells
brew install zsh bash fish

# Switch default shell
chsh -s /bin/zsh
```

#### 2. **Development Tools**
```bash
# Install development tools
xcode-select --install

# Install additional tools
brew install jq yq kubectl docker
```

---

## 📊 Performance Comparison

### Windows Performance
- **Terraform**: Slightly slower due to Windows overhead
- **AWS CLI**: Comparable performance
- **Scripts**: PowerShell execution is fast
- **File I/O**: May be slower with large files

### Mac Performance
- **Terraform**: Native performance
- **AWS CLI**: Native performance
- **Scripts**: Bash execution is very fast
- **File I/O**: Excellent performance

### Recommendations
- **Windows**: Use SSD storage for better performance
- **Mac**: Performance is generally excellent
- **Both**: Use wired internet for faster AWS operations

---

## 🔒 Security Considerations by Platform

### Windows Security
- **Execution Policy**: Controls script execution
- **User Account Control**: Prevents unauthorized changes
- **Windows Defender**: Built-in malware protection
- **Firewall**: Network security controls

### Mac Security
- **Gatekeeper**: Prevents unauthorized app execution
- **SIP (System Integrity Protection)**: Protects system files
- **XProtect**: Built-in malware protection
- **Firewall**: Network security controls

### Cross-Platform Security
- **AWS IAM**: Use least privilege access
- **SSH Keys**: Secure key management
- **Network Security**: Use VPN if needed
- **Regular Updates**: Keep tools updated

---

## 📚 Platform-Specific Resources

### Windows Resources
- [PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/)
- [Windows Terminal](https://github.com/microsoft/terminal)
- [Windows Package Manager](https://docs.microsoft.com/en-us/windows/package-manager/)

### Mac Resources
- [Homebrew Documentation](https://docs.brew.sh/)
- [macOS Terminal Guide](https://support.apple.com/guide/terminal/)
- [macOS Security](https://support.apple.com/en-us/HT201796)

### Cross-Platform Resources
- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS CLI Documentation](https://docs.aws.amazon.com/cli/)
- [Git Documentation](https://git-scm.com/doc)

---

## 🎯 Platform Selection Guide

### Choose Windows If:
- ✅ You're already familiar with Windows
- ✅ You need Windows-specific tools
- ✅ You're in a Windows-dominated environment
- ✅ You prefer PowerShell scripting

### Choose Mac If:
- ✅ You're already familiar with macOS
- ✅ You need Unix-like tools
- ✅ You're in a development environment
- ✅ You prefer Bash scripting

### Both Platforms Support:
- ✅ All AWS services
- ✅ Terraform infrastructure
- ✅ Security lab functionality
- ✅ Cross-platform learning

---

## 📝 Summary

This cross-platform setup guide ensures that:

- **Windows Users**: Can use PowerShell scripts natively
- **Mac Users**: Can use Bash scripts natively
- **Both Platforms**: Have equivalent functionality
- **Learning Experience**: Is consistent across platforms
- **Troubleshooting**: Is platform-specific and effective

### Key Takeaways:

1. **Tool Installation**: Use platform-appropriate package managers
2. **Script Execution**: Use platform-specific scripts
3. **Troubleshooting**: Follow platform-specific guidance
4. **Security**: Maintain platform-appropriate security practices
5. **Performance**: Optimize for your specific platform

### Next Steps:

1. **Choose Your Platform**: Windows or Mac
2. **Follow Setup Guide**: Use platform-specific instructions
3. **Install Tools**: Terraform, AWS CLI, Git
4. **Configure AWS**: Set up credentials and access
5. **Run the Lab**: Deploy and test infrastructure
6. **Learn Security**: Practice detection and response

Remember: **The platform doesn't matter - the learning does!** Both Windows and Mac provide excellent environments for learning AWS security concepts.

Happy learning on your chosen platform! 🚀🔒
