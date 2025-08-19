# Elementary AWS Connection Guide

This guide provides step-by-step instructions for establishing your first connection to AWS services.

## What You'll Learn

- How to create an AWS account
- How to set up basic AWS credentials
- How to connect to AWS from your computer
- How to verify your connection works

## Prerequisites

- Computer with internet access
- Valid email address
- Credit card (for AWS account verification)
- Basic understanding of command line operations

## Step 1: Create an AWS Account

### Why Create an AWS Account?

AWS (Amazon Web Services) is the cloud platform we'll use for the security lab. You need an account to access AWS services.

### Account Creation Process

1. **Visit AWS Website**
   - Go to [aws.amazon.com](https://aws.amazon.com)
   - Click "Create an AWS Account"

2. **Enter Account Information**
   - Email address (this becomes your AWS username)
   - Password (use a strong password)
   - AWS account name (e.g., "My Security Lab")

3. **Contact Information**
   - Full name
   - Company name (optional)
   - Phone number
   - Country/region

4. **Billing Information**
   - Credit card details
   - Billing address
   - Identity verification

5. **Account Verification**
   - AWS will call your phone number
   - Enter the verification code when prompted

6. **Support Plan Selection**
   - Choose "Free" plan for learning
   - You can upgrade later if needed

## Step 2: Access AWS Console

### What is AWS Console?

AWS Console is a web-based interface where you can manage AWS services through a graphical interface.

### First Login

1. **Sign In**
   - Go to [console.aws.amazon.com](https://console.aws.amazon.com)
   - Enter your email and password

2. **Choose Region**
   - Select a region close to you (e.g., "US East (N. Virginia)")
   - This determines where your resources are created

3. **Explore the Interface**
   - Notice the search bar at the top
   - Browse through different services
   - Don't worry about making changes yet

## Step 3: Create an IAM User

### Why Create an IAM User?

**Never use your root AWS account** for daily operations. Instead, create a dedicated user with specific permissions.

### Create the User

1. **Navigate to IAM**
   - Search for "IAM" in the services search bar
   - Click on "IAM" service

2. **Create User**
   - Click "Users" in the left sidebar
   - Click "Create user"
   - Enter username: "lab-user"
   - Check "Access key - Programmatic access"
   - Click "Next: Permissions"

3. **Attach Policies**
   - Click "Attach existing policies directly"
   - Search for and select:
     - `AmazonEC2FullAccess`
     - `AmazonVPCFullAccess`
     - `AmazonS3FullAccess`
   - Click "Next: Tags"

4. **Add Tags**
   - Key: "Purpose"
   - Value: "Security Lab"
   - Click "Next: Review"

5. **Review and Create**
   - Review the configuration
   - Click "Create user"

## Step 4: Generate Access Keys

### What are Access Keys?

Access keys are credentials that allow programs and scripts to access AWS services on your behalf.

### Create Access Keys

1. **Select Your User**
   - Click on the username you just created

2. **Create Access Key**
   - Click "Security credentials" tab
   - Click "Create access key"
   - Choose "Application running on an EC2 compute resource"
   - Click "Next"

3. **Add Description**
   - Description: "Security Lab Access Key"
   - Click "Create access key"

4. **Download Credentials**
   - **IMPORTANT**: This is the only time you'll see the secret key
   - Click "Download .csv file"
   - Save it securely on your computer
   - Click "Close"

### Access Key Information

The CSV file contains:
- **Access Key ID**: 20-character string starting with "AKIA"
- **Secret Access Key**: 40-character string
- **User ARN**: Your user's Amazon Resource Name

## Step 5: Install AWS CLI

### What is AWS CLI?

AWS CLI (Command Line Interface) is a tool that allows you to interact with AWS services from your computer's command line.

### Installation by Platform

#### Windows
```powershell
# Using winget (Windows 10 1709+)
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

### Verify Installation

```bash
# Check if AWS CLI is installed
aws --version

# You should see output like:
# aws-cli/2.x.x Python/3.x.x...
```

## Step 6: Configure AWS Credentials

### Configure Using AWS CLI

```bash
# Run the configure command
aws configure

# Enter the following when prompted:
# AWS Access Key ID: [Your Access Key ID]
# AWS Secret Access Key: [Your Secret Access Key]
# Default region name: us-east-1
# Default output format: json
```

### Manual Configuration

Alternatively, you can create the configuration files manually:

#### Windows
```powershell
# Create .aws directory
mkdir $env:USERPROFILE\.aws

# Create credentials file
notepad $env:USERPROFILE\.aws\credentials
```

#### macOS/Linux
```bash
# Create .aws directory
mkdir ~/.aws

# Create credentials file
nano ~/.aws/credentials
```

#### Credentials File Content
```ini
[default]
aws_access_key_id = YOUR_ACCESS_KEY_ID_HERE
aws_secret_access_key = YOUR_SECRET_ACCESS_KEY_HERE
```

#### Config File Content
```ini
[default]
region = us-east-1
output = json
```

## Step 7: Test Your Connection

### Verify Credentials

```bash
# Test your AWS credentials
aws sts get-caller-identity

# You should see output like:
# {
#     "UserId": "AIDACKCEVSQ6C2EXAMPLE",
#     "Account": "123456789012",
#     "Arn": "arn:aws:iam::123456789012:user/lab-user"
# }
```

### Test Basic Commands

```bash
# List AWS regions
aws ec2 describe-regions

# List S3 buckets (will be empty initially)
aws s3 ls

# Check your IAM user
aws iam get-user
```

## Step 8: Set Up Environment Variables

### Create Environment File

1. **Copy Template**
   ```bash
   cp env.template .env.lab
   ```

2. **Edit the File**
   Open `.env.lab` in your text editor and update:
   ```bash
   AWS_ACCESS_KEY_ID=your_actual_access_key_id
   AWS_SECRET_ACCESS_KEY=your_actual_secret_access_key
   AWS_ACCOUNT_ID=your_12_digit_account_id
   ```

3. **Verify Git Ignore**
   Ensure `.env.lab` is in your `.gitignore` file.

## Troubleshooting

### Common Issues

#### "Access Denied" Errors
**Problem:** AWS CLI commands fail with access denied
**Solutions:**
- Verify your access key and secret key are correct
- Check that your IAM user has the required permissions
- Ensure you're using the correct AWS region

#### "Command Not Found" Errors
**Problem:** `aws` command is not recognized
**Solutions:**
- Restart your terminal after installation
- Verify the installation path is in your system PATH
- Try using the full path to the AWS CLI executable

#### "Invalid Client Token" Errors
**Problem:** Getting authentication errors
**Solutions:**
- Check your system clock is synchronized
- Verify your credentials haven't expired
- Try regenerating your access keys

### Getting Help

1. **Check AWS CLI version**: `aws --version`
2. **Verify credentials**: `aws sts get-caller-identity`
3. **Check region**: `aws configure list`
4. **Review IAM policies**: Check your user's attached policies
5. **Check AWS documentation**: [AWS CLI User Guide](https://docs.aws.amazon.com/cli/)

## Security Best Practices

### Credential Security
- **Never share** your access keys
- **Never commit** them to version control
- **Rotate keys** every 90 days
- **Use IAM roles** when possible
- **Monitor usage** regularly

### Account Security
- **Enable MFA** on your AWS account
- **Use strong passwords**
- **Monitor account activity**
- **Set up billing alerts**

## Next Steps

Once your AWS connection is working:

1. **Run the lab setup script** to verify everything works
2. **Deploy your infrastructure** using Terraform
3. **Follow the lab checklist** to complete all objectives
4. **Monitor your resources** and costs
5. **Clean up** when finished

## Additional Resources

- [AWS CLI User Guide](https://docs.aws.amazon.com/cli/)
- [IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [AWS Security Best Practices](https://aws.amazon.com/security/security-learning/)
- [AWS Free Tier](https://aws.amazon.com/free/)

---

**Congratulations!** You've successfully connected to AWS. You're now ready to start learning about cloud security!
