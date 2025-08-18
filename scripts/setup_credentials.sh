#!/bin/bash

# 🔐 AWS Security Lab - Credentials Setup Script (Mac/Linux)
# This script helps you set up AWS credentials securely

ACTION=${1:-help}
ENVIRONMENT=${2:-development}

echo "🔐 AWS Security Lab - Credentials Setup"
echo "======================================="

show_help() {
    echo ""
    echo "Usage: ./setup_credentials.sh [Action] [Environment]"
    echo ""
    echo "Actions:"
    echo "  setup     - Set up AWS credentials interactively"
    echo "  check     - Check if credentials are configured"
    echo "  validate  - Validate AWS credentials"
    echo "  help      - Show this help message"
    echo ""
    echo "Environments:"
    echo "  development - Development environment (default)"
    echo "  production  - Production environment"
    echo "  staging     - Staging environment"
    echo ""
    echo "Examples:"
    echo "  ./setup_credentials.sh setup"
    echo "  ./setup_credentials.sh check production"
    echo "  ./setup_credentials.sh validate"
}

show_security_warning() {
    echo ""
    echo "🚨 SECURITY WARNING"
    echo "=================="
    echo ""
    echo "⚠️  NEVER share your AWS credentials with anyone!"
    echo "⚠️  NEVER commit credentials to GitHub!"
    echo "⚠️  NEVER use the same credentials across multiple accounts!"
    echo ""
    echo "🔒 Security Best Practices:"
    echo "  • Use IAM users with minimal required permissions"
    echo "  • Rotate your access keys every 90 days"
    echo "  • Enable MFA on your AWS account"
    echo "  • Monitor your AWS usage regularly"
    echo "  • Use CloudTrail to audit API calls"
    echo ""
}

setup_credentials() {
    echo ""
    echo "🔑 Setting up AWS credentials for $ENVIRONMENT environment..."
    echo ""
    
    # Check if template exists
    if [ ! -f "env.template" ]; then
        echo "❌ Template file 'env.template' not found!"
        echo "Please ensure you're running this script from the project root directory."
        return 1
    fi
    
    # Create environment file
    ENV_FILE=".env.$ENVIRONMENT"
    ENV_FILE_LOCAL=".env.local"
    
    echo "📝 Creating $ENV_FILE_LOCAL from template..."
    
    if cp env.template "$ENV_FILE_LOCAL"; then
        echo "✅ Template copied successfully!"
    else
        echo "❌ Failed to copy template!"
        return 1
    fi
    
    echo ""
    echo "🚨 IMPORTANT: You need to manually edit $ENV_FILE_LOCAL with your real AWS credentials!"
    echo ""
    echo "Steps:"
    echo "1. Open $ENV_FILE_LOCAL in your text editor"
    echo "2. Replace 'YOUR_ACCESS_KEY_ID_HERE' with your actual AWS Access Key ID"
    echo "3. Replace 'YOUR_SECRET_ACCESS_KEY_HERE' with your actual AWS Secret Access Key"
    echo "4. Update other values as needed"
    echo "5. Save the file"
    echo ""
    echo "⚠️  NEVER commit $ENV_FILE_LOCAL to git - it's already in .gitignore"
    echo ""
    
    # Offer to open the file
    read -p "Would you like to open $ENV_FILE_LOCAL now? (y/n): " open_file
    if [[ $open_file =~ ^[Yy]$ ]]; then
        if command -v code >/dev/null 2>&1; then
            code "$ENV_FILE_LOCAL"
            echo "✅ File opened in VS Code"
        elif command -v nano >/dev/null 2>&1; then
            nano "$ENV_FILE_LOCAL"
        elif command -v vim >/dev/null 2>&1; then
            vim "$ENV_FILE_LOCAL"
        else
            echo "⚠️  Could not open file automatically. Please open it manually."
        fi
    fi
    
    echo ""
    echo "🎯 After editing your credentials, run:"
    echo "  ./setup_credentials.sh validate"
    echo ""
}

check_credentials() {
    echo ""
    echo "🔍 Checking AWS credentials configuration..."
    echo ""
    
    # Check for environment files
    ENV_FILES=(".env.local" ".env.development" ".env.production" ".env.staging")
    FOUND_FILES=()
    
    for file in "${ENV_FILES[@]}"; do
        if [ -f "$file" ]; then
            FOUND_FILES+=("$file")
        fi
    done
    
    if [ ${#FOUND_FILES[@]} -eq 0 ]; then
        echo "❌ No environment files found!"
        echo "Run './setup_credentials.sh setup' to create your credentials file."
        return 1
    fi
    
    echo "📁 Found environment files:"
    for file in "${FOUND_FILES[@]}"; do
        echo "  ✅ $file"
    done
    
    echo ""
    
    # Check AWS CLI configuration
    echo "🔧 Checking AWS CLI configuration..."
    
    AWS_CONFIG_PATH="$HOME/.aws/config"
    AWS_CREDENTIALS_PATH="$HOME/.aws/credentials"
    
    if [ -f "$AWS_CONFIG_PATH" ]; then
        echo "  ✅ AWS config found: $AWS_CONFIG_PATH"
    else
        echo "  ⚠️  AWS config not found: $AWS_CONFIG_PATH"
    fi
    
    if [ -f "$AWS_CREDENTIALS_PATH" ]; then
        echo "  ✅ AWS credentials found: $AWS_CREDENTIALS_PATH"
    else
        echo "  ⚠️  AWS credentials not found: $AWS_CREDENTIALS_PATH"
    fi
    
    echo ""
    echo "💡 Tip: You can use either environment files or AWS CLI configuration."
    echo "   Environment files are easier for lab purposes."
}

validate_credentials() {
    echo ""
    echo "🔍 Validating AWS credentials..."
    echo ""
    
    # Check if AWS CLI is installed
    if ! command -v aws >/dev/null 2>&1; then
        echo "❌ AWS CLI not found!"
        echo "Please install AWS CLI first."
        return 1
    fi
    
    AWS_VERSION=$(aws --version 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo "✅ AWS CLI found: $AWS_VERSION"
    else
        echo "❌ AWS CLI not working properly!"
        return 1
    fi
    
    # Try to get caller identity
    echo "🔐 Testing AWS credentials..."
    
    CALLER_IDENTITY=$(aws sts get-caller-identity 2>/dev/null)
    
    if [ $? -eq 0 ] && [ -n "$CALLER_IDENTITY" ]; then
        echo "✅ AWS credentials are valid!"
        echo ""
        echo "Account Information:"
        echo "$CALLER_IDENTITY" | jq -r '.Account' | while read -r account; do
            echo "  Account ID: $account"
        done
        echo "$CALLER_IDENTITY" | jq -r '.UserId' | while read -r userid; do
            echo "  User ID: $userid"
        done
        echo "$CALLER_IDENTITY" | jq -r '.Arn' | while read -r arn; do
            echo "  ARN: $arn"
        done
        echo ""
        echo "🎉 You're ready to use the AWS Security Lab!"
    else
        echo "❌ AWS credentials validation failed!"
        echo ""
        echo "🔧 Troubleshooting:"
        echo "1. Check if your credentials are correct"
        echo "2. Verify your AWS account is active"
        echo "3. Check if your IAM user has the necessary permissions"
        echo "4. Ensure your access keys haven't expired"
        echo ""
        echo "💡 Run './setup_credentials.sh setup' to reconfigure your credentials."
    fi
}

# Main script logic
case $ACTION in
    "setup")
        show_security_warning
        setup_credentials
        ;;
    "check")
        check_credentials
        ;;
    "validate")
        validate_credentials
        ;;
    "help")
        show_help
        ;;
    *)
        echo "❌ Unknown action: $ACTION"
        echo ""
        show_help
        exit 1
        ;;
esac

echo ""
echo "🔐 For more security information, see: docs/SECURITY_AND_CREDENTIALS.md"
echo "📚 For complete setup guide, see: docs/SETUP_GUIDE.md"
