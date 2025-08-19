# AWS Credentials Setup Guide

This guide will help you set up AWS credentials securely for the AWS Security Lab.

## Prerequisites

- AWS Account with appropriate permissions
- AWS CLI v2 installed
- Basic understanding of AWS IAM

## Step 1: Create an IAM User

### Why Create an IAM User?

**Never use your root AWS account credentials** for programmatic access. Instead, create a dedicated IAM user with only the permissions needed for the lab.

### Create the User

1. **Sign in to AWS Console**
   - Go to [AWS Console](https://console.aws.amazon.com/)
   - Sign in with your root account

2. **Navigate to IAM**
   - Search for "IAM" in the services search bar
   - Click on "IAM" service

3. **Create New User**
   - Click "Users" in the left sidebar
   - Click "Create user"
   - Enter username: `lab-user` (or your preferred name)
   - Check "Access key - Programmatic access"
   - Click "Next: Permissions"

4. **Attach Policies**
   - Click "Attach existing policies directly"
   - Search for and select these policies:
     - `AmazonEC2FullAccess`
     - `AmazonVPCFullAccess`
     - `AmazonS3FullAccess`
     - `IAMFullAccess`
     - `AmazonGuardDutyFullAccess`
     - `SecurityHubFullAccess`
     - `CloudWatchFullAccess`
   - Click "Next: Tags"

5. **Add Tags (Optional)**
   - Key: `Purpose`
   - Value: `Security Lab`
   - Click "Next: Review"

6. **Review and Create**
   - Review the user configuration
   - Click "Create user"

## Step 2: Generate Access Keys

### Create Access Keys

1. **Select Your User**
   - Click on the username you just created

2. **Create Access Key**
   - Click "Security credentials" tab
   - Click "Create access key"
   - Choose "Application running on an EC2 compute resource" (for lab purposes)
   - Click "Next"
   - Add description: "Security Lab Access Key"
   - Click "Create access key"

3. **Download Credentials**
   - **IMPORTANT**: This is the only time you'll see the secret access key
   - Click "Download .csv file"
   - Save the file securely on your computer
   - Click "Close"

### Access Key Information

The CSV file contains:
- **Access Key ID**: A 20-character string starting with "AKIA"
- **Secret Access Key**: A 40-character string
- **User ARN**: Your user's Amazon Resource Name

## Step 3: Configure AWS CLI

### Install AWS CLI

**Windows:**
```powershell
# Download and run the MSI installer
# https://awscli.amazonaws.com/AWSCLIV2.msi
```

**macOS:**
```bash
# Using Homebrew
brew install awscli

# Or download the installer
# https://awscli.amazonaws.com/AWSCLIV2.pkg
```

**Linux:**
```bash
# Using package manager
sudo apt-get install awscli  # Ubuntu/Debian
sudo yum install awscli      # RHEL/CentOS

# Or download the installer
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

### Configure Credentials

```bash
# Configure AWS CLI with your credentials
aws configure

# Enter the following when prompted:
# AWS Access Key ID: [Your Access Key ID]
# AWS Secret Access Key: [Your Secret Access Key]
# Default region name: us-east-1
# Default output format: json
```

### Verify Configuration

```bash
# Test your credentials
aws sts get-caller-identity

# You should see output like:
# {
#     "UserId": "AIDACKCEVSQ6C2EXAMPLE",
#     "Account": "123456789012",
#     "Arn": "arn:aws:iam::123456789012:user/lab-user"
# }
```

## Step 4: Set Up Environment Variables

### Create Environment File

1. **Copy the Template**
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
   Ensure `.env.lab` is in your `.gitignore` file (it should be already).

## Step 5: Test Your Setup

### Run Validation Script

**Windows:**
```powershell
.\scripts\setup_credentials.ps1 validate
```

**macOS/Linux:**
```bash
./scripts/setup_credentials.sh validate
```

### Manual Testing

```bash
# Test AWS CLI
aws ec2 describe-regions

# Test specific services
aws guardduty list-detectors
aws securityhub get-findings
```

## Security Best Practices

### Access Key Security

- **Never share** your access keys
- **Never commit** them to version control
- **Rotate keys** every 90 days
- **Use IAM roles** when possible
- **Monitor usage** regularly

### IAM Policy Security

- **Principle of least privilege**: Only grant necessary permissions
- **Regular reviews**: Audit permissions monthly
- **Use groups**: Organize users into groups with similar permissions
- **Enable MFA**: Require multi-factor authentication

### Environment Security

- **Separate accounts**: Use different AWS accounts for different purposes
- **Resource tagging**: Tag all resources for cost tracking
- **CloudTrail**: Enable API logging for audit purposes
- **Cost alerts**: Set up billing alerts to avoid surprises

## Troubleshooting

### Common Issues

#### "Access Denied" Errors

**Problem:** AWS CLI commands fail with access denied
**Solutions:**
- Verify your access key and secret key are correct
- Check that your IAM user has the required permissions
- Ensure you're using the correct AWS region
- Verify your AWS account is active

#### "Invalid Client Token" Errors

**Problem:** AWS CLI reports invalid client token
**Solutions:**
- Check your system clock is synchronized
- Verify your access keys haven't expired
- Try regenerating your access keys

#### "Could not connect to endpoint" Errors

**Problem:** Cannot connect to AWS services
**Solutions:**
- Check your internet connection
- Verify firewall settings aren't blocking AWS endpoints
- Check if you're behind a corporate proxy

### Getting Help

1. **Check AWS CLI version**: `aws --version`
2. **Verify credentials**: `aws sts get-caller-identity`
3. **Check region**: `aws configure list`
4. **Review IAM policies**: Check your user's attached policies
5. **Check CloudTrail**: Look for API call logs

## Next Steps

Once your credentials are configured:

1. **Run the lab setup script** to verify everything works
2. **Deploy your infrastructure** using Terraform
3. **Follow the lab checklist** to complete all objectives
4. **Monitor your resources** and costs
5. **Clean up** when finished

## Additional Resources

- [AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [AWS CLI Configuration](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)
- [AWS Security Best Practices](https://aws.amazon.com/security/security-learning/)
- [IAM Policy Examples](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_examples.html)

---

**Remember:** Security is everyone's responsibility. Take the time to set up your credentials properly and follow security best practices!
