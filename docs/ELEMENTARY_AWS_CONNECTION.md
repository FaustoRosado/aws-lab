# 🚀 Very Elementary AWS Connection Guide

This guide is designed for complete beginners who have never used AWS before. We'll walk through every single step with screenshots and simple explanations.

## 🎯 What You'll Learn

By the end of this guide, you will:
- ✅ Create an AWS account
- ✅ Set up a user with the right permissions
- ✅ Get the keys needed to connect
- ✅ Test your connection
- ✅ Be ready to run the security lab

---

## 📋 Before We Start

### What You Need
- A computer with internet access
- A credit card (for AWS billing)
- An email address
- About 30 minutes of your time

### What This Will Cost
- **Free Tier**: First 12 months are free for most services
- **Lab Cost**: About $2-5 per day when running the lab
- **Total**: Less than $50 for a month of learning

---

## 🔐 Step 1: Create Your AWS Account

### 1.1 Go to AWS Website
1. Open your web browser (Chrome, Firefox, Safari, or Edge)
2. Go to: [https://aws.amazon.com](https://aws.amazon.com)
3. Click the **"Create an AWS Account"** button (usually orange)

### 1.2 Enter Your Email
1. Type your email address in the box
2. Choose a name for your account (this is just for you)
3. Click **"Continue"**

### 1.3 Create a Password
1. Create a strong password (at least 8 characters)
2. **Write this password down somewhere safe!**
3. Click **"Continue"**

### 1.4 Enter Your Contact Information
1. **Full Name**: Your real name
2. **Company**: Your company name (or "Personal" if it's just you)
3. **Phone Number**: Your phone number
4. **Country**: Select your country
5. **Address**: Your full address
6. Click **"Continue"**

### 1.5 Choose Account Type
1. Select **"Personal"** (unless you're doing this for work)
2. Click **"Continue"**

### 1.6 Enter Payment Information
1. **Card Number**: Your credit or debit card number
2. **Expiry Date**: When your card expires
3. **CVC**: The 3-digit security code on the back
4. **Name on Card**: Your name as it appears on the card
5. **Billing Address**: Same as your contact address
6. Click **"Continue"**

### 1.7 Verify Your Identity
1. AWS will call your phone number
2. Enter the 4-digit code they give you
3. Click **"Continue"**

### 1.8 Choose Support Plan
1. Select **"Free"** (you can always upgrade later)
2. Click **"Continue"**

### 1.9 Wait for Account Creation
1. AWS will take a few minutes to set up your account
2. You'll see a message saying "Your account is being activated"
3. **Don't close this page!**

---

## 🔑 Step 2: Sign In to Your Account

### 2.1 Go to AWS Console
1. Once your account is ready, go to: [https://console.aws.amazon.com](https://console.aws.amazon.com)
2. Click **"Sign In to the Console"**

### 2.2 Enter Your Details
1. **Account ID**: This is the 12-digit number AWS gave you
2. **Username**: Your email address
3. **Password**: The password you created
4. Click **"Sign In"**

### 2.3 Welcome to AWS!
1. You'll see the AWS Console dashboard
2. This is where you'll manage all your AWS services
3. **Don't worry about all the options right now!**

---

## 👤 Step 3: Create a User for the Lab

### 3.1 Find IAM Service
1. In the search box at the top, type: **"IAM"**
2. Click on **"IAM"** when it appears

### 3.2 Go to Users
1. In the left menu, click **"Users"**
2. Click the **"Create user"** button

### 3.3 Name Your User
1. **User name**: Type `security-lab-user`
2. Check the box: **"Provide user access to the AWS Management Console (optional)"**
3. Click **"Next"**

### 3.4 Set Password
1. Choose **"Custom password"**
2. **Password**: Type a new password (different from your main account)
3. **Write this password down!**
4. Check the box: **"Users must create a new password at next sign-in"**
5. Click **"Next"**

### 3.5 Give Permissions
1. Click **"Attach policies directly"**
2. In the search box, type each of these and check the box next to each one:

   **Type and check these one by one:**
   - `AmazonEC2FullAccess`
   - `AmazonVPCFullAccess`
   - `AmazonS3FullAccess`
   - `IAMFullAccess`
   - `AmazonGuardDutyFullAccess`
   - `AWSSecurityHubFullAccess`
   - `CloudWatchFullAccess`
   - `AmazonSSMFullAccess`

3. Click **"Next"**

### 3.6 Review and Create
1. Review what you've set up
2. Click **"Create user"**
3. **Success!** Click **"View user"**

---

## 🔑 Step 4: Get Your Access Keys

### 4.1 Go to Security Credentials
1. You should be on the user details page
2. Click the **"Security credentials"** tab
3. Scroll down to **"Access keys"**

### 4.2 Create Access Key
1. Click **"Create access key"**
2. Choose **"Command Line Interface (CLI)"**
3. Check the confirmation box
4. Click **"Next"**

### 4.3 Set Description
1. **Description**: Type `Security Lab CLI Access`
2. Click **"Next"**
3. Click **"Create access key"**

### 4.4 Download Your Keys
**🚨 VERY IMPORTANT: This is the only time you'll see your secret key!**

1. **Download the CSV file** - Click the download button
2. **Save it somewhere safe** on your computer
3. **Note down these two things:**
   - **Access Key ID**: Looks like `AKIAIOSFODNN7EXAMPLE`
   - **Secret Access Key**: Looks like `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY`
4. Click **"Done"**

### 4.5 Secure Your Keys
1. **Move the CSV file** to a safe folder
2. **Delete any temporary copies**
3. **Never share these keys with anyone**
4. **Consider using a password manager** to store them

---

## 🖥️ Step 5: Install Tools on Your Computer

### 5.1 Install AWS CLI

#### For Windows Users:
1. Open PowerShell as Administrator
2. Type this command and press Enter:
   ```powershell
   winget install Amazon.AWSCLI
   ```
3. Wait for it to finish
4. **Restart your computer**

#### For Mac Users:
1. Open Terminal
2. Type this command and press Enter:
   ```bash
   brew install awscli
   ```
3. Wait for it to finish

### 5.2 Install Terraform

#### For Windows Users:
1. Open PowerShell as Administrator
2. Type this command and press Enter:
   ```powershell
   winget install HashiCorp.Terraform
   ```
3. Wait for it to finish
4. **Restart your computer**

#### For Mac Users:
1. Open Terminal
2. Type this command and press Enter:
   ```bash
   brew install terraform
   ```
3. Wait for it to finish

---

## ⚙️ Step 6: Configure AWS on Your Computer

### 6.1 Open Your Terminal

#### For Windows Users:
1. Press `Windows + R` keys
2. Type `powershell` and press Enter

#### For Mac Users:
1. Press `Command + Space` keys
2. Type `terminal` and press Enter

### 6.2 Configure AWS
1. Type this command and press Enter:
   ```bash
   aws configure
   ```

2. **AWS Access Key ID**: Type your Access Key ID (the long one starting with AKIA)
3. **AWS Secret Access Key**: Type your Secret Access Key (the very long one)
4. **Default region name**: Type `us-east-1`
5. **Default output format**: Type `json`

### 6.3 Test Your Connection
1. Type this command and press Enter:
   ```bash
   aws sts get-caller-identity
   ```

2. **You should see something like this:**
   ```json
   {
       "UserId": "AIDACKCEVSQ6C2EXAMPLE",
       "Account": "123456789012",
       "Arn": "arn:aws:iam::123456789012:user/security-lab-user"
   }
   ```

3. **If you see this, you're connected!** 🎉

---

## 🧪 Step 7: Test Everything Works

### 7.1 Test Terraform
1. Type this command and press Enter:
   ```bash
   terraform --version
   ```

2. **You should see something like:**
   ```
   Terraform v1.12.2
   ```

### 7.2 Test AWS CLI
1. Type this command and press Enter:
   ```bash
   aws --version
   ```

2. **You should see something like:**
   ```
   aws-cli/2.28.11 Python/3.11.0
   ```

---

## 🎯 Step 8: You're Ready!

### What You've Accomplished
✅ Created an AWS account  
✅ Set up a secure user  
✅ Got your access keys  
✅ Installed the tools  
✅ Connected to AWS  
✅ Tested everything  

### What's Next
1. **Go back to the main lab guide**
2. **Follow the setup instructions**
3. **Start learning AWS security!**

---

## 🆘 If Something Goes Wrong

### Problem: "aws command not found"
**Solution**: Restart your computer after installation

### Problem: "Access Denied"
**Solution**: Check your Access Key ID and Secret Access Key are correct

### Problem: "Invalid region"
**Solution**: Make sure you typed `us-east-1` exactly

### Problem: "Permission denied"
**Solution**: Make sure you gave the user all the required permissions

---

## 📞 Getting Help

### AWS Support
- **Free Tier Support**: Available in AWS Console
- **Community Forums**: [AWS Developer Forums](https://forums.aws.amazon.com/)

### Lab Support
- **GitHub Issues**: Create an issue in the lab repository
- **Documentation**: Check the other guides in this folder

---

## 🔒 Security Reminders

### Never Do This:
❌ Share your access keys with anyone  
❌ Put keys in public code  
❌ Use the same keys for multiple accounts  
❌ Forget to rotate your keys regularly  

### Always Do This:
✅ Keep your keys secure  
✅ Use different keys for different purposes  
✅ Monitor your AWS usage  
✅ Follow security best practices  

---

## 🎉 Congratulations!

You've successfully:
- Created an AWS account
- Set up secure access
- Installed all the tools
- Connected everything together

**You're now ready to start the AWS Security Lab!**

### Next Steps:
1. **Return to the main lab guide**
2. **Follow the deployment instructions**
3. **Start learning about cloud security**

---

## 📚 Quick Reference

### Your Important Information:
- **AWS Account ID**: [Write it here]
- **Access Key ID**: [Write it here]
- **Secret Access Key**: [Write it here]
- **Region**: us-east-1

### Common Commands:
```bash
# Test AWS connection
aws sts get-caller-identity

# Check Terraform
terraform --version

# Check AWS CLI
aws --version
```

### Where to Go:
- **AWS Console**: [https://console.aws.amazon.com](https://console.aws.amazon.com)
- **Main Lab Guide**: README.md
- **Setup Guide**: SETUP_GUIDE.md

---

**Remember**: You're learning something new, so take your time and don't worry if you make mistakes. Every expert was once a beginner!

Happy learning! 🚀🔒
