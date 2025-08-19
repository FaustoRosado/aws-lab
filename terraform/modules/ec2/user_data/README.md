# User Data Scripts - Automated Server Setup

## What are User Data Scripts?

**User Data Scripts** are **automated setup instructions** that run when your EC2 instances start up. Think of them as **recipes** that tell your server exactly what software to install, how to configure it, and what services to start - all automatically without manual intervention.

### Real-World Analogy

- **User Data Scripts** = Automated setup instructions for your server
- **Cloud-Init** = The service that reads and executes these instructions
- **Bash Commands** = Step-by-step commands to configure your server
- **Package Installation** = Installing software and dependencies
- **Service Configuration** = Setting up web servers, databases, etc.
- **Security Hardening** = Applying security best practices automatically

---

## What These Scripts Do

This folder contains **automated setup scripts** for different types of servers:

- **Web Server Setup** - Installs and configures Apache web server
- **Database Setup** - Installs and configures MySQL database
- **Security Hardening** - Applies security best practices
- **Monitoring Setup** - Installs basic monitoring tools
- **Environment Configuration** - Sets up development/production environments

---

## Script Structure

```
user_data/
├── README.md           # This documentation file
├── web_server.sh       # Web server setup and configuration
└── database_server.sh  # Database server setup and configuration
```

---

## How User Data Scripts Work

### The Process

1. **Instance Launch** - Your EC2 instance starts up
2. **Cloud-Init Service** - AWS automatically starts the cloud-init service
3. **Script Execution** - Your user data script runs automatically
4. **Software Installation** - Required packages and software are installed
5. **Configuration** - Services are configured and started
6. **Ready State** - Your server is ready to use

### When They Run

- **First Boot Only** - Scripts run only when the instance is first created
- **Not on Reboot** - Scripts don't run when you restart an existing instance
- **One-Time Setup** - Perfect for initial server configuration

---

## Web Server Script (`web_server.sh`)

### What It Does

This script automatically sets up a **production-ready web server**:

```bash
#!/bin/bash
# Update system packages
yum update -y

# Install Apache web server
yum install -y httpd

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Create a simple web page
echo "<h1>Welcome to AWS Security Lab!</h1>" > /var/www/html/index.html
echo "<p>This is your web server running in the cloud.</p>" >> /var/www/html/index.html
```

### Features

- **Automatic Updates** - Installs latest security patches
- **Web Server Installation** - Installs Apache HTTP server
- **Service Management** - Starts and enables Apache automatically
- **Custom Content** - Creates a welcome page for testing
- **Security** - Applies basic security configurations

### Use Cases

- **Web Applications** - Host websites and web apps
- **Development Servers** - Test and develop web applications
- **Load Balancer Backends** - Serve content behind load balancers
- **Static Content** - Host documentation and static files

---

## Database Server Script (`database_server.sh`)

### What It Does

This script automatically sets up a **secure database server**:

```bash
#!/bin/bash
# Update system packages
yum update -y

# Install MySQL database server
yum install -y mysql-server

# Start and enable MySQL
systemctl start mysqld
systemctl enable mysqld

# Secure the MySQL installation
mysql_secure_installation
```

### Features

- **Database Installation** - Installs MySQL database server
- **Service Management** - Starts and enables MySQL automatically
- **Security Hardening** - Applies MySQL security best practices
- **Automatic Startup** - Database starts automatically on boot
- **Production Ready** - Configured for production use

### Use Cases

- **Application Databases** - Store application data
- **Data Warehousing** - Store and analyze large datasets
- **Backup Storage** - Store database backups
- **Development Testing** - Test database applications

---

## Security Features

### Automatic Security Updates

```bash
# Update system packages for security
yum update -y
```

**What this does:** Installs the latest security patches and updates

### Service Hardening

```bash
# Secure MySQL installation
mysql_secure_installation
```

**What this does:** Removes default users, sets strong passwords, and applies security settings

### Firewall Configuration

```bash
# Configure firewall rules
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload
```

**What this does:** Opens only necessary ports and closes others for security

---

## Customizing Your Scripts

### Add More Software

```bash
# Install additional packages
yum install -y nginx php-fpm python3 nodejs

# Install development tools
yum groupinstall -y "Development Tools"
```

### Custom Configuration

```bash
# Set custom environment variables
echo "export ENVIRONMENT=production" >> /etc/environment
echo "export APP_VERSION=1.0.0" >> /etc/environment

# Create custom configuration files
cat > /etc/myapp/config.conf << EOF
[app]
name = My Application
version = 1.0.0
environment = production
EOF
```

### Service Management

```bash
# Start additional services
systemctl start nginx
systemctl enable nginx

# Configure service dependencies
systemctl enable httpd
systemctl enable mysqld
```

---

## Important Notes

### Script Limitations

- **Maximum Size** - User data scripts are limited to 16KB
- **Execution Time** - Scripts must complete within the instance launch timeout
- **One-Time Only** - Scripts run only on first boot
- **No Persistence** - Changes are lost if you terminate and recreate the instance

### Best Practices

- **Keep Scripts Simple** - Focus on essential setup tasks
- **Test Thoroughly** - Test scripts in a development environment first
- **Document Changes** - Comment your scripts for future maintenance
- **Use Idempotent Commands** - Commands that can run multiple times safely

### Troubleshooting

- **Check Cloud-Init Logs** - `/var/log/cloud-init.log` and `/var/log/cloud-init-output.log`
- **Verify Script Execution** - Check if expected files and services exist
- **Test Commands Manually** - Run script commands manually to debug issues
- **Check Permissions** - Ensure scripts have proper execution permissions

---

## Next Steps

1. **Review the scripts** to understand what they do
2. **Customize for your needs** by modifying the scripts
3. **Test in development** before using in production
4. **Deploy with Terraform** to create instances with these scripts
5. **Monitor execution** to ensure successful setup

---

## Related Documentation

- **EC2 Module README** - Learn about the EC2 instances that use these scripts
- **VPC Module README** - Understand the network configuration
- **Security Groups README** - Learn about firewall rules
- **Terraform Documentation** - Understand how to deploy with infrastructure as code

---

<div align="center">
  <p><em>Your automated server setup is ready!</em></p>
</div>
