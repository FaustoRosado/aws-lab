# 📝 User Data Scripts - EC2 Instance Setup

## 📚 **What are User Data Scripts?**

**User Data Scripts** are **automated setup instructions** that run when your EC2 instances start up. Think of them as **recipes** that tell your new server exactly what to install, configure, and set up automatically.

### **🏠 Real-World Analogy**

- **📝 User Data Script** = A recipe for setting up your server
- **🚀 Instance Startup** = When you turn on your new computer
- **⚙️ Automatic Setup** = The computer follows the recipe automatically
- **🎯 Consistent Results** = Same setup every time, no manual work

---

## 🎯 **What These Scripts Do**

This folder contains **automated setup scripts** for different types of EC2 instances:

- **🌐 Web Server Setup** - Installs and configures web server software
- **🗄️ Database Setup** - Installs and secures database software
- **🔒 Security Hardening** - Applies security best practices
- **📊 Monitoring Setup** - Installs monitoring and logging tools

---

## 🏗️ **Script Structure**

```
user_data/
├── README.md           # 📖 This file!
├── web_server.sh       # 🌐 Sets up web server with Apache
└── database_server.sh  # 🗄️ Sets up MySQL database server
```

---

## 🔍 **How User Data Scripts Work**

### **🚀 When They Run**

1. **Instance Launches** - Your EC2 instance starts up
2. **Cloud-Init Runs** - AWS runs the cloud-init service
3. **Script Execution** - Your user data script runs automatically
4. **Setup Complete** - Server is ready to use

### **⚙️ What Happens During Execution**

- **System Updates** - Latest security patches are installed
- **Software Installation** - Required packages are downloaded and installed
- **Configuration** - Services are configured with your settings
- **Service Startup** - Services are started and enabled
- **Security Hardening** - Security settings are applied

---

## 📝 **Script Details**

### **🌐 Web Server Script (`web_server.sh`)**

**Purpose:** Sets up a web server for hosting websites and applications

**What it installs:**
- **Apache HTTP Server** - Web server software
- **System Updates** - Latest security patches
- **Basic Configuration** - Web server settings

**What it creates:**
- **Welcome Page** - Simple HTML page for testing
- **Service Configuration** - Apache starts automatically
- **Security Settings** - Basic security hardening

**Use cases:**
- Web application hosting
- Static website hosting
- Development and testing
- Security lab scenarios

### **🗄️ Database Server Script (`database_server.sh`)**

**Purpose:** Sets up a database server for storing and managing data

**What it installs:**
- **MySQL Server** - Database management system
- **System Updates** - Latest security patches
- **Security Tools** - Database security utilities

**What it configures:**
- **Database Service** - MySQL starts automatically
- **Security Settings** - Database access controls
- **Basic Setup** - Ready for database creation

**Use cases:**
- Application databases
- Data storage and management
- Development and testing
- Security lab scenarios

---

## 🔐 **Security Features**

### **🛡️ Built-in Security**

- **Automatic Updates** - Latest security patches
- **Service Hardening** - Secure default configurations
- **Access Controls** - Restricted access where appropriate
- **Logging** - Activity monitoring and audit trails

### **🔒 Security Best Practices**

- **Principle of Least Privilege** - Minimal required permissions
- **Regular Updates** - Automatic security patch installation
- **Service Isolation** - Separate configurations for different purposes
- **Audit Logging** - Track all system changes and access

---

## 🎨 **Customizing Your Scripts**

### **📝 Modify Existing Scripts**

You can edit these scripts to:
- **Add more software** packages
- **Change configurations** for your needs
- **Add custom applications** or services
- **Modify security settings** based on requirements

### **🆕 Create New Scripts**

You can create new scripts for:
- **Application servers** (Node.js, Python, etc.)
- **Monitoring servers** (Prometheus, Grafana, etc.)
- **Backup servers** (rsync, backup tools, etc.)
- **Specialized services** (mail servers, file servers, etc.)

---

## 🚨 **Important Notes**

### **⚠️ Security Considerations**

- **Never put secrets** in user data scripts
- **Use IAM roles** for AWS service access
- **Keep scripts simple** and focused
- **Test thoroughly** before production use

### **🔧 Technical Limitations**

- **Scripts run once** when instance starts
- **Maximum size** of 16 KB for user data
- **Timeout limits** for script execution
- **Network dependency** for package downloads

---

## 🎯 **Next Steps**

1. **🔍 Review the scripts** to understand what they do
2. **📝 Customize scripts** for your specific needs
3. **🧪 Test scripts** in a development environment
4. **🚀 Deploy instances** with your customized scripts
5. **📊 Monitor execution** to ensure successful setup

---

## 🔗 **Related Documentation**

- **[EC2 Module README](../README.md)** - Complete EC2 module documentation
- **[Terraform Documentation](../../../README.md)** - Infrastructure setup guide
- **[AWS User Data Guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html)** - Official AWS documentation

---

<div align="center">
  <p><em>📝 Your automated server setup is ready! 🚀</em></p>
</div>
