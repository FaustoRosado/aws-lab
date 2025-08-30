#!/bin/bash
# Quantum Shield Security Monitoring Script
# P2W12 Advanced Cybersecurity Lab
# Team: Shannon Kelly, Fausto Rosado, Zeinab Ali, Latrisha Dodson, Javier Acosta

# Configuration
LOG_FILE="/var/log/security-monitor.log"
ALERT_FILE="/var/log/security-alerts.log"
CHECK_INTERVAL=30
MAX_SSH_CONNECTIONS=5
MAX_FAILED_LOGINS=10
SUSPICIOUS_PROCESSES="nc|netcat|nmap|hydra|john|hashcat|aircrack|reaver|wash"

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Alert function
send_alert() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    case $level in
        "INFO")
            echo -e "${BLUE}[INFO]${NC} $timestamp - $message" | tee -a "$ALERT_FILE"
            ;;
        "WARNING")
            echo -e "${YELLOW}[WARNING]${NC} $timestamp - $message" | tee -a "$ALERT_FILE"
            ;;
        "ALERT")
            echo -e "${RED}[ALERT]${NC} $timestamp - $message" | tee -a "$ALERT_FILE"
            ;;
        "CRITICAL")
            echo -e "${RED}[CRITICAL]${NC} $timestamp - $message" | tee -a "$ALERT_FILE"
            ;;
    esac
}

# Check SSH connections
check_ssh_connections() {
    local ssh_count=$(netstat -an | grep :22 | grep ESTABLISHED | wc -l)
    
    if [ $ssh_count -gt $MAX_SSH_CONNECTIONS ]; then
        send_alert "WARNING" "High number of SSH connections detected: $ssh_count (Threshold: $MAX_SSH_CONNECTIONS)"
        log_message "SSH connection count: $ssh_count"
    fi
}

# Check failed login attempts
check_failed_logins() {
    local failed_count=$(grep "Failed password" /var/log/secure 2>/dev/null | wc -l)
    
    if [ $failed_count -gt $MAX_FAILED_LOGINS ]; then
        send_alert "ALERT" "High number of failed login attempts: $failed_count (Threshold: $MAX_FAILED_LOGINS)"
        log_message "Failed login attempts: $failed_count"
    fi
}

# Check for suspicious processes
check_suspicious_processes() {
    local suspicious_count=$(ps aux | grep -E "$SUSPICIOUS_PROCESSES" | grep -v grep | wc -l)
    
    if [ $suspicious_count -gt 0 ]; then
        local processes=$(ps aux | grep -E "$SUSPICIOUS_PROCESSES" | grep -v grep | awk '{print $2, $11}' | head -5)
        send_alert "ALERT" "Suspicious processes detected: $suspicious_count - $processes"
        log_message "Suspicious processes: $suspicious_count"
    fi
}

# Check for unusual network connections
check_network_connections() {
    local established_connections=$(netstat -an | grep ESTABLISHED | wc -l)
    local listening_ports=$(netstat -an | grep LISTEN | wc -l)
    
    # Check for unusual listening ports
    local unusual_ports=$(netstat -an | grep LISTEN | grep -E ":(8080|4444|31337|12345|54321)" | wc -l)
    
    if [ $unusual_ports -gt 0 ]; then
        local ports=$(netstat -an | grep LISTEN | grep -E ":(8080|4444|31337|12345|54321)" | awk '{print $4}' | head -5)
        send_alert "WARNING" "Unusual listening ports detected: $ports"
        log_message "Unusual listening ports: $unusual_ports"
    fi
    
    log_message "Network connections - Established: $established_connections, Listening: $listening_ports"
}

# Check system resource usage
check_system_resources() {
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    local memory_usage=$(free | grep Mem | awk '{printf("%.0f", $3/$2 * 100.0)}')
    local disk_usage=$(df / | tail -1 | awk '{print $5}' | cut -d'%' -f1)
    
    # CPU usage alert
    if [ $cpu_usage -gt 80 ]; then
        send_alert "WARNING" "High CPU usage: ${cpu_usage}%"
    fi
    
    # Memory usage alert
    if [ $memory_usage -gt 85 ]; then
        send_alert "WARNING" "High memory usage: ${memory_usage}%"
    fi
    
    # Disk usage alert
    if [ $disk_usage -gt 90 ]; then
        send_alert "WARNING" "High disk usage: ${disk_usage}%"
    fi
    
    log_message "System resources - CPU: ${cpu_usage}%, Memory: ${memory_usage}%, Disk: ${disk_usage}%"
}

# Check for new files in critical directories
check_critical_files() {
    local critical_dirs="/etc /var/log /home /tmp"
    local new_files_count=0
    
    for dir in $critical_dirs; do
        if [ -d "$dir" ]; then
            local count=$(find "$dir" -type f -mtime -1 2>/dev/null | wc -l)
            new_files_count=$((new_files_count + count))
        fi
    done
    
    if [ $new_files_count -gt 50 ]; then
        send_alert "WARNING" "Large number of new files in critical directories: $new_files_count"
        log_message "New files in critical directories: $new_files_count"
    fi
}

# Check for web server attacks
check_web_attacks() {
    if [ -f "/var/log/httpd/access_log" ]; then
        local sql_injection_attempts=$(grep -i "union\|select\|insert\|update\|delete\|drop\|create" /var/log/httpd/access_log 2>/dev/null | wc -l)
        local xss_attempts=$(grep -i "script\|javascript\|onload\|onerror" /var/log/httpd/access_log 2>/dev/null | wc -l)
        local path_traversal=$(grep -i "\.\.\|%2e%2e" /var/log/httpd/access_log 2>/dev/null | wc -l)
        
        if [ $sql_injection_attempts -gt 0 ]; then
            send_alert "ALERT" "SQL injection attempts detected: $sql_injection_attempts"
            log_message "SQL injection attempts: $sql_injection_attempts"
        fi
        
        if [ $xss_attempts -gt 0 ]; then
            send_alert "ALERT" "XSS attempts detected: $xss_attempts"
            log_message "XSS attempts: $xss_attempts"
        fi
        
        if [ $path_traversal -gt 0 ]; then
            send_alert "ALERT" "Path traversal attempts detected: $path_traversal"
            log_message "Path traversal attempts: $path_traversal"
        fi
    fi
}

# Check for privilege escalation attempts
check_privilege_escalation() {
    local sudo_attempts=$(grep "sudo:" /var/log/secure 2>/dev/null | wc -l)
    local su_attempts=$(grep "su:" /var/log/secure 2>/dev/null | wc -l)
    
    if [ $sudo_attempts -gt 20 ]; then
        send_alert "WARNING" "High number of sudo attempts: $sudo_attempts"
        log_message "Sudo attempts: $sudo_attempts"
    fi
    
    if [ $su_attempts -gt 10 ]; then
        send_alert "WARNING" "High number of su attempts: $su_attempts"
        log_message "Su attempts: $su_attempts"
    fi
}

# Check for unusual user activity
check_user_activity() {
    local current_users=$(who | wc -l)
    local last_logins=$(last | head -10 | grep -v "still logged in" | wc -l)
    
    if [ $current_users -gt 3 ]; then
        send_alert "WARNING" "Multiple users logged in: $current_users"
        log_message "Current users: $current_users"
    fi
    
    log_message "Recent logins: $last_logins"
}

# Main monitoring loop
main() {
    log_message "Security monitoring started"
    send_alert "INFO" "Security monitoring service started"
    
    while true; do
        log_message "Starting security checks..."
        
        # Run all security checks
        check_ssh_connections
        check_failed_logins
        check_suspicious_processes
        check_network_connections
        check_system_resources
        check_critical_files
        check_web_attacks
        check_privilege_escalation
        check_user_activity
        
        log_message "Security checks completed"
        
        # Wait before next check
        sleep $CHECK_INTERVAL
    done
}

# Handle script termination
trap 'log_message "Security monitoring stopped"; exit 0' SIGTERM SIGINT

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

# Create log files if they don't exist
touch "$LOG_FILE" "$ALERT_FILE"
chmod 600 "$LOG_FILE" "$ALERT_FILE"

# Start monitoring
main
