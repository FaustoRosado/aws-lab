#!/bin/bash
# Database Server User Data Script
# This script sets up a database server for the security lab

set -e

# Update system
yum update -y

# Install MySQL and tools
yum install -y mysql mysql-server

# Start and enable MySQL
systemctl start mysqld
systemctl enable mysqld

# Wait for MySQL to be ready
sleep 10

# Secure MySQL installation
mysql_secure_installation << EOF

y
1
Y
Y
Y
Y
EOF

# Create database and tables for the lab
mysql -u root << 'EOF'
CREATE DATABASE security_lab;
USE security_lab;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_type VARCHAR(50) NOT NULL,
    description TEXT,
    ip_address VARCHAR(45),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sensitive_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data_type VARCHAR(50) NOT NULL,
    content TEXT NOT NULL,
    access_level VARCHAR(20) DEFAULT 'public',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO users (username, email, password_hash) VALUES
('admin', 'admin@securitylab.com', '5f4dcc3b5aa765d61d8327deb882cf99'),
('user1', 'user1@securitylab.com', '7c4a8d09ca3762af61e59520943dc26494f8941b'),
('testuser', 'test@securitylab.com', '098f6bcd4621d373cade4e832627b4f6');

INSERT INTO sensitive_data (data_type, content, access_level) VALUES
('api_key', 'sk-1234567890abcdef', 'private'),
('database_password', 'dbpass123', 'private'),
('ssh_private_key', '-----BEGIN RSA PRIVATE KEY-----', 'private'),
('credit_card', '4111-1111-1111-1111', 'private');

-- Create a user for the web application
CREATE USER 'webapp'@'%' IDENTIFIED BY 'webapp123';
GRANT SELECT, INSERT, UPDATE ON security_lab.* TO 'webapp'@'%';
FLUSH PRIVILEGES;
EOF

# Create monitoring script
cat > /opt/db_monitor.sh << 'EOF'
#!/bin/bash
# Database monitoring script
while true; do
    echo "$(date): Database connections: $(mysql -u root -e 'SHOW PROCESSLIST' | wc -l)" >> /var/log/security-lab.log
    echo "$(date): Database size: $(du -sh /var/lib/mysql/security_lab 2>/dev/null | cut -f1)" >> /var/log/security-lab.log
    sleep 60
done
EOF

chmod +x /opt/db_monitor.sh

# Start monitoring in background
nohup /opt/db_monitor.sh > /dev/null 2>&1 &

# Create log file
echo "$(date): Database server initialized" >> /var/log/security-lab.log

echo "Database server setup complete at $(date)" >> /var/log/security-lab.log
