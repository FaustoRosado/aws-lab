#!/bin/bash
# Web Server User Data Script
# This script sets up a web server for compromise simulation

set -e

# Update system
yum update -y

# Install web server and tools
yum install -y httpd php mysql php-mysql

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Create a simple vulnerable web application
cat > /var/www/html/index.php << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Vulnerable Web App - Security Lab</title>
</head>
<body>
    <h1>Welcome to the Security Lab Web Server</h1>
    <p>This is a deliberately vulnerable web application for security testing.</p>
    
    <h2>User Input Form (Vulnerable to SQL Injection)</h2>
    <form method="GET" action="">
        <input type="text" name="id" placeholder="Enter user ID">
        <input type="submit" value="Search">
    </form>
    
    <?php
    if (isset($_GET['id'])) {
        $id = $_GET['id'];
        echo "<p>Searching for user ID: " . htmlspecialchars($id) . "</p>";
        // This is intentionally vulnerable for the lab
        echo "<p>Query: SELECT * FROM users WHERE id = $id</p>";
    }
    ?>
    
    <h2>File Upload (Vulnerable to File Upload)</h2>
    <form method="POST" enctype="multipart/form-data">
        <input type="file" name="file">
        <input type="submit" value="Upload">
    </form>
    
    <h2>System Information</h2>
    <p>Server: <?php echo $_SERVER['SERVER_SOFTWARE']; ?></p>
    <p>PHP Version: <?php echo phpversion(); ?></p>
    <p>Current Time: <?php echo date('Y-m-d H:i:s'); ?></p>
</body>
</html>
EOF

# Create a vulnerable PHP file for testing
cat > /var/www/html/info.php << 'EOF'
<?php
// This file is intentionally vulnerable for security testing
phpinfo();
?>
EOF

# Set permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# Create a simple log file for monitoring
echo "$(date): Web server initialized" >> /var/log/security-lab.log

# Install additional tools for monitoring
yum install -y net-tools tcpdump

# Create a monitoring script
cat > /opt/monitor.sh << 'EOF'
#!/bin/bash
# Simple monitoring script
while true; do
    echo "$(date): Active connections: $(netstat -an | grep ESTABLISHED | wc -l)" >> /var/log/security-lab.log
    sleep 30
done
EOF

chmod +x /opt/monitor.sh

# Start monitoring in background
nohup /opt/monitor.sh > /dev/null 2>&1 &

echo "Web server setup complete at $(date)" >> /var/log/security-lab.log
