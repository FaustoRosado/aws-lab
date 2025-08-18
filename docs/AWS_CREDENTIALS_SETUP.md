# 🔑 AWS Credentials Setup Guide

This comprehensive guide will walk you through setting up AWS credentials for the Security Lab on both Windows and Mac systems. Follow these steps carefully to ensure proper access to your AWS account.

## 📋 Prerequisites

Before you begin, ensure you have:

- ✅ An AWS account (free tier or paid)
- ✅ Administrative access to your AWS account
- ✅ A computer with internet access
- ✅ Basic understanding of command line operations

## 🚨 Security Warning

**IMPORTANT**: Never share your AWS credentials with anyone. These credentials provide access to your AWS account and can result in unauthorized charges or security breaches.

- ❌ Never commit credentials to version control
- ❌ Never share credentials in public forums
- ❌ Never use the same credentials across multiple accounts
- ❌ Always use IAM users with minimal required permissions

---

## 🔐 Step 1: Create an IAM User

### Why Create an IAM User?

Instead of using your AWS root account, we'll create a dedicated IAM user with specific permissions for the security lab. This follows security best practices and limits potential damage.

### 1.1 Sign in to AWS Console

1. Open your web browser and navigate to [AWS Console](https://console.aws.amazon.com/)
2. Sign in with your AWS account credentials
3. Ensure you're in the correct AWS account

### 1.2 Navigate to IAM Service

1. In the AWS Console search bar, type "IAM"
2. Click on "IAM" service
3. You should see the IAM dashboard

### 1.3 Create New IAM User

1. In the left navigation pane, click "Users"
2. Click "Create user" button
3. Enter a username: `security-lab-user` (or your preferred name)
4. **IMPORTANT**: Check the box "Provide user access to the AWS Management Console (optional)"
5. Click "Next"

### 1.4 Set Console Password

1. Choose "Custom password"
2. Enter a strong password (minimum 8 characters)
3. **IMPORTANT**: Check "Users must create a new password at next sign-in"
4. Click "Next"

### 1.5 Attach Permissions

1. Click "Attach policies directly"
2. Search for and select these policies:
   - `AmazonEC2FullAccess` (for EC2 management)
   - `AmazonVPCFullAccess` (for VPC management)
   - `AmazonS3FullAccess` (for S3 bucket management)
   - `IAMFullAccess` (for IAM role management)
   - `AmazonGuardDutyFullAccess` (for GuardDuty)
   - `AWSSecurityHubFullAccess` (for Security Hub)
   - `CloudWatchFullAccess` (for monitoring)
   - `AmazonSSMFullAccess` (for Systems Manager)

3. Click "Next"

### 1.6 Review and Create

1. Review the user configuration
2. Ensure all required policies are attached
3. Click "Create user"

### 1.7 Save User Information

1. After successful creation, you'll see a success message
2. **IMPORTANT**: Click "View user" to see the user details
3. Note down the username for future reference

---

## 🔑 Step 2: Create Access Keys

### What are Access Keys?

Access keys consist of an Access Key ID and Secret Access Key. These are used by the AWS CLI and Terraform to authenticate with AWS services programmatically.

### 2.1 Navigate to User Details

1. In the IAM Users list, click on your newly created user
2. Click the "Security credentials" tab
3. Scroll down to "Access keys" section

### 2.2 Create Access Key

1. Click "Create access key"
2. Choose "Command Line Interface (CLI)"
3. Check the confirmation box
4. Click "Next"

### 2.3 Set Description and Permissions

1. Add a description: "Security Lab CLI Access"
2. Click "Next"
3. Review the configuration
4. Click "Create access key"

### 2.4 Download and Save Credentials

**🚨 CRITICAL**: This is the only time you'll see the Secret Access Key!

1. **Download the CSV file** containing your credentials
2. **Save it securely** on your computer
3. **Note down the Access Key ID and Secret Access Key**
4. Click "Done"

### 2.5 Secure Your Credentials

1. **Move the CSV file** to a secure location
2. **Delete any temporary copies** from your Downloads folder
3. **Never share these credentials** with anyone
4. **Consider using a password manager** to store them securely

---

## 🖥️ Step 3: Configure AWS CLI

### Windows Users

#### 3.1 Install AWS CLI

1. **Option A: Using winget (Recommended)**
   ```powershell
   winget install Amazon.AWSCLI
   ```

2. **Option B: Manual Installation**
   - Download the MSI installer from [AWS CLI Downloads](https://aws.amazon.com/cli/)
   - Run the installer as Administrator
   - Follow the installation wizard

#### 3.2 Verify Installation

1. Open PowerShell or Command Prompt
2. Run the following command:
   ```powershell
   aws --version
   ```
3. You should see output like: `aws-cli/2.x.x Python/3.x.x...`

#### 3.3 Configure AWS Credentials

1. Open PowerShell or Command Prompt
2. Run the following command:
   ```powershell
   aws configure
   ```

3. Enter the following information when prompted:
   ```
   AWS Access Key ID: [Your Access Key ID]
   AWS Secret Access Key: [Your Secret Access Key]
   Default region name: us-east-1
   Default output format: json
   ```

#### 3.4 Verify Configuration

1. Test your configuration:
   ```powershell
   aws sts get-caller-identity
   ```

2. You should see output like:
   ```json
   {
       "UserId": "AIDACKCEVSQ6C2EXAMPLE",
       "Account": "123456789012",
       "Arn": "arn:aws:iam::123456789012:user/security-lab-user"
   }
   ```

### Mac Users

#### 3.1 Install AWS CLI

1. **Option A: Using Homebrew (Recommended)**
   ```bash
   brew install awscli
   ```

2. **Option B: Manual Installation**
   - Download the macOS installer from [AWS CLI Downloads](https://aws.amazon.com/cli/)
   - Extract the downloaded file
   - Run the installer script

#### 3.2 Verify Installation

1. Open Terminal
2. Run the following command:
   ```bash
   aws --version
   ```
3. You should see output like: `aws-cli/2.x.x Python/3.x.x...`

#### 3.3 Configure AWS Credentials

1. Open Terminal
2. Run the following command:
   ```bash
   aws configure
   ```

3. Enter the following information when prompted:
   ```
   AWS Access Key ID: [Your Access Key ID]
   AWS Secret Access Key: [Your Secret Access Key]
   Default region name: us-east-1
   Default output format: json
   ```

#### 3.4 Verify Configuration

1. Test your configuration:
   ```bash
   aws sts get-caller-identity
   ```

2. You should see output like:
   ```json
   {
       "UserId": "AIDACKCEVSQ6C2EXAMPLE",
       "Account": "123456789012",
       "Arn": "arn:aws:iam::123456789012:user/security-lab-user"
   }
   ```

---

## 🔧 Step 4: Advanced Configuration Options

### 4.1 Multiple AWS Profiles

You can create multiple profiles for different AWS accounts or environments:

#### Windows (PowerShell)
```powershell
aws configure --profile production
aws configure --profile development
aws configure --profile security-lab
```

#### Mac (Terminal)
```bash
aws configure --profile production
aws configure --profile development
aws configure --profile security-lab
```

### 4.2 Using Profiles

To use a specific profile:

#### Windows (PowerShell)
```powershell
aws sts get-caller-identity --profile security-lab
```

#### Mac (Terminal)
```bash
aws sts get-caller-identity --profile security-lab
```

### 4.3 Environment Variables

You can also set credentials using environment variables:

#### Windows (PowerShell)
```powershell
$env:AWS_ACCESS_KEY_ID="your-access-key-id"
$env:AWS_SECRET_ACCESS_KEY="your-secret-access-key"
$env:AWS_DEFAULT_REGION="us-east-1"
```

#### Mac (Terminal)
```bash
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
export AWS_DEFAULT_REGION="us-east-1"
```

---

## 🔍 Step 5: Troubleshooting Common Issues

### 5.1 "Access Denied" Errors

**Problem**: Getting "Access Denied" when running AWS commands

**Solutions**:
1. Verify your Access Key ID and Secret Access Key are correct
2. Ensure the IAM user has the required permissions
3. Check if the access keys are active
4. Verify you're using the correct AWS region

### 5.2 "Command Not Found" Errors

**Problem**: `aws` command is not recognized

**Solutions**:
1. **Windows**: Restart your terminal/PowerShell after installation
2. **Mac**: Restart your terminal or run `source ~/.bash_profile`
3. Verify the installation path is in your system PATH
4. Try using the full path to the AWS CLI executable

### 5.3 "Invalid Client Token" Errors

**Problem**: Getting authentication errors

**Solutions**:
1. Check your system clock is synchronized
2. Verify your credentials haven't expired
3. Ensure you're not behind a restrictive firewall
4. Try regenerating your access keys

### 5.4 Region-Specific Issues

**Problem**: Resources not found in expected region

**Solutions**:
1. Verify you're using the correct AWS region
2. Check if the service is available in your region
3. Use `aws configure list` to see current settings
4. Set the region explicitly: `aws configure set region us-east-1`

---

## 🛡️ Step 6: Security Best Practices

### 6.1 Regular Credential Rotation

- **Rotate access keys** every 90 days
- **Monitor key usage** in AWS CloudTrail
- **Delete unused keys** immediately
- **Use temporary credentials** when possible

### 6.2 Least Privilege Access

- **Only grant necessary permissions**
- **Use IAM policies** instead of full access
- **Regularly review permissions**
- **Remove unused permissions**

### 6.3 Monitoring and Alerting

- **Enable CloudTrail** for API logging
- **Set up CloudWatch alarms** for unusual activity
- **Monitor IAM user activity**
- **Set up billing alerts**

### 6.4 Secure Storage

- **Never store credentials in code**
- **Use secure credential managers**
- **Encrypt credential files**
- **Regular security audits**

---

## 🔄 Step 7: Updating and Maintenance

### 7.1 Updating AWS CLI

#### Windows
```powershell
winget upgrade Amazon.AWSCLI
```

#### Mac
```bash
brew upgrade awscli
```

### 7.2 Checking for Updates

```bash
aws --version
```

### 7.3 Updating Credentials

If you need to update your credentials:

1. **Update existing profile**:
   ```bash
   aws configure
   ```

2. **Create new profile**:
   ```bash
   aws configure --profile new-profile
   ```

3. **Remove old profile**:
   - Edit `~/.aws/credentials` (Mac/Linux)
   - Edit `%USERPROFILE%\.aws\credentials` (Windows)

---

## 📚 Step 8: Additional Resources

### 8.1 AWS Documentation

- [AWS CLI User Guide](https://docs.aws.amazon.com/cli/)
- [IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [Security Best Practices](https://aws.amazon.com/security/security-learning/)

### 8.2 Security Resources

- [AWS Security Blog](https://aws.amazon.com/blogs/security/)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [CIS AWS Foundations Benchmark](https://www.cisecurity.org/benchmark/amazon_web_services/)

### 8.3 Community Resources

- [AWS Developer Forums](https://forums.aws.amazon.com/)
- [Stack Overflow AWS Tag](https://stackoverflow.com/questions/tagged/amazon-web-services)
- [AWS Reddit Community](https://www.reddit.com/r/aws/)

---

## ✅ Verification Checklist

Before proceeding with the Security Lab, ensure you have completed:

- [ ] Created IAM user with appropriate permissions
- [ ] Generated Access Key ID and Secret Access Key
- [ ] Downloaded and secured credentials CSV file
- [ ] Installed AWS CLI on your system
- [ ] Configured AWS credentials using `aws configure`
- [ ] Verified configuration with `aws sts get-caller-identity`
- [ ] Tested basic AWS commands
- [ ] Understood security best practices
- [ ] Set up monitoring and alerting (optional)

---

## 🚀 Next Steps

Once you have successfully configured your AWS credentials:

1. **Proceed to the Security Lab Setup**: Follow the main setup guide
2. **Test Your Configuration**: Run the lab verification scripts
3. **Deploy Infrastructure**: Use Terraform to create lab resources
4. **Run Security Scenarios**: Execute the compromise simulation scripts
5. **Monitor and Learn**: Use AWS services to detect and respond to threats

---

## 🆘 Getting Help

If you encounter issues during setup:

1. **Check the troubleshooting section** above
2. **Review AWS documentation** for specific services
3. **Search community forums** for similar issues
4. **Contact AWS Support** if you have a support plan
5. **Create an issue** in the Security Lab repository

---

**Remember**: Security is everyone's responsibility. By following these best practices, you're not only protecting your AWS account but also learning valuable security principles that apply to all aspects of cybersecurity.

Good luck with your Security Lab journey! 🔒🚀
