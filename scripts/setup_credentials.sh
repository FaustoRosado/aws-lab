#!/bin/bash
# AWS Security Lab - Credentials Setup Script (Mac/Linux)
# This script helps you set up AWS credentials securely for the lab

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to display help
show_help() {
    echo -e "${GREEN}AWS Security Lab - Credentials Setup${NC}"
    echo ""
    echo "Usage: $0 [action] [environment]"
    echo ""
    echo "Actions:"
    echo "  setup     - Set up credentials for the specified environment"
    echo "  check     - Check current credential configuration"
    echo "  validate  - Validate AWS credentials"
    echo "  help      - Show this help message"
    echo ""
    echo "Environments:"
    echo "  lab       - Lab environment (default)"
    echo "  dev       - Development environment"
    echo "  test      - Testing environment"
    echo ""
    echo "Examples:"
    echo "  $0 setup lab"
    echo "  $0 check"
    echo "  $0 validate"
}

# Function to show security warning
show_security_warning() {
    echo -e "${RED}SECURITY WARNING${NC}"
    echo "================="
    echo ""
    echo -e "${YELLOW}NEVER share your AWS credentials with anyone!${NC}"
    echo -e "${YELLOW}NEVER commit credentials to GitHub!${NC}"
    echo -e "${YELLOW}NEVER use the same credentials across multiple accounts!${NC}"
    echo ""
    echo -e "${CYAN}Security Best Practices:${NC}"
    echo "1. Use IAM users with minimal required permissions"
    echo "2. Rotate your access keys every 90 days"
    echo "3. Enable MFA on your AWS account"
    echo "4. Monitor your AWS usage regularly"
    echo "5. Use environment variables or AWS CLI configuration"
    echo "6. Never hardcode credentials in scripts"
    echo "7. Use IAM roles when possible"
    echo "8. Regularly review and audit permissions"
}

# Function to set up credentials
setup_credentials() {
    local environment=$1
    
    echo -e "${YELLOW}Setting up AWS credentials for $environment environment...${NC}"
    
    # Check if template exists
    if [ ! -f "env.template" ]; then
        echo -e "${RED}Template file 'env.template' not found!${NC}"
        echo "Please ensure you're running this script from the project root directory."
        return 1
    fi
    
    # Create environment-specific file
    local env_file_local=".env.$environment"
    
    echo -e "${CYAN}Creating $env_file_local from template...${NC}"
    if cp env.template "$env_file_local"; then
        echo -e "${GREEN}Template copied successfully!${NC}"
    else
        echo -e "${RED}Failed to copy template!${NC}"
        return 1
    fi
    
    # Open file for editing
    echo -e "${RED}IMPORTANT: You need to manually edit $env_file_local with your real AWS credentials!${NC}"
    echo ""
    echo "Steps:"
    echo "1. Replace 'your_access_key_id_here' with your actual AWS Access Key ID"
    echo "2. Replace 'your_secret_access_key_here' with your actual AWS Secret Access Key"
    echo "3. Update other settings as needed"
    echo "4. Save the file"
    echo ""
    
    # Try to open file in default editor
    if command -v code >/dev/null 2>&1; then
        echo -e "${CYAN}Opening $env_file_local in VS Code...${NC}"
        code "$env_file_local"
        echo -e "${GREEN}File opened in VS Code${NC}"
    elif command -v nano >/dev/null 2>&1; then
        echo -e "${CYAN}Opening $env_file_local in nano...${NC}"
        nano "$env_file_local"
    elif command -v vim >/dev/null 2>&1; then
        echo -e "${CYAN}Opening $env_file_local in vim...${NC}"
        vim "$env_file_local"
    else
        echo -e "${YELLOW}Could not open file automatically. Please open it manually.${NC}"
    fi
    
    echo ""
    echo -e "${CYAN}After editing your credentials, run:${NC}"
    echo "  $0 check"
    echo "  $0 validate"
}

# Function to check credential configuration
check_credentials() {
    echo -e "${YELLOW}Checking AWS credentials configuration...${NC}"
    
    # Check for environment files
    local env_files=$(ls -1 .env* 2>/dev/null | grep -v "env.template" || true)
    
    if [ -z "$env_files" ]; then
        echo -e "${RED}No environment files found!${NC}"
        echo "Run '$0 setup' to create your credential file."
        return 1
    fi
    
    echo -e "${GREEN}Environment files found:${NC}"
    for file in $env_files; do
        echo -e "  ${GREEN}$file${NC}"
    done
    
    # Check AWS CLI configuration
    echo -e "${CYAN}Checking AWS CLI configuration...${NC}"
    
    local aws_config_path="$HOME/.aws/config"
    local aws_credentials_path="$HOME/.aws/credentials"
    
    if [ -f "$aws_config_path" ]; then
        echo -e "  ${GREEN}AWS config found: $aws_config_path${NC}"
    else
        echo -e "  ${YELLOW}AWS config not found: $aws_config_path${NC}"
    fi
    
    if [ -f "$aws_credentials_path" ]; then
        echo -e "  ${GREEN}AWS credentials found: $aws_credentials_path${NC}"
    else
        echo -e "  ${YELLOW}AWS credentials not found: $aws_credentials_path${NC}"
    fi
    
    echo ""
    echo -e "${CYAN}Tip: You can use either environment files or AWS CLI configuration.${NC}"
}

# Function to validate AWS credentials
validate_credentials() {
    echo -e "${YELLOW}Validating AWS credentials...${NC}"
    
    # Check if AWS CLI is installed
    if ! command -v aws >/dev/null 2>&1; then
        echo -e "${RED}AWS CLI not found!${NC}"
        echo "Please install AWS CLI first:"
        echo "  https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
        return 1
    fi
    
    # Get AWS CLI version
    local aws_version=$(aws --version 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}AWS CLI found: $aws_version${NC}"
    else
        echo -e "${RED}AWS CLI not working properly!${NC}"
        return 1
    fi
    
    # Test AWS credentials
    echo -e "${CYAN}Testing AWS credentials...${NC}"
    
    local caller_identity
    if caller_identity=$(aws sts get-caller-identity 2>/dev/null); then
        echo -e "${GREEN}AWS credentials are valid!${NC}"
        
        # Parse and display account information
        local account_id=$(echo "$caller_identity" | grep -o '"Account": "[^"]*"' | cut -d'"' -f4)
        local user_id=$(echo "$caller_identity" | grep -o '"UserId": "[^"]*"' | cut -d'"' -f4)
        local arn=$(echo "$caller_identity" | grep -o '"Arn": "[^"]*"' | cut -d'"' -f4)
        
        echo "  Account ID: $account_id"
        echo "  User ID: $user_id"
        echo "  ARN: $arn"
    else
        echo -e "${RED}AWS credentials validation failed!${NC}"
        echo ""
        echo -e "${YELLOW}Troubleshooting:${NC}"
        echo "1. Check your AWS credentials are correct"
        echo "2. Verify your AWS account has the required permissions"
        echo "3. Check your internet connection"
        echo "4. Verify your AWS region setting"
        echo ""
        echo -e "${CYAN}Run '$0 setup' to reconfigure your credentials.${NC}"
        return 1
    fi
}

# Main script logic
case "${1:-help}" in
    "setup")
        setup_credentials "${2:-lab}"
        show_security_warning
        ;;
    "check")
        check_credentials
        ;;
    "validate")
        validate_credentials
        ;;
    "help"|*)
        show_help
        ;;
esac

# Show additional resources
echo ""
echo -e "${CYAN}For more security information, see: docs/SECURITY_AND_CREDENTIALS.md${NC}"
echo -e "${CYAN}For complete setup guide, see: docs/SETUP_GUIDE.md${NC}"
