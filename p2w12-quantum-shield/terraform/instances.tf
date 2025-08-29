# Data source for latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Kali Linux Attacker Instance (using Amazon Linux 2 for now)
resource "aws_instance" "kali_attacker" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type_kali
  key_name              = var.key_name
  vpc_security_group_ids = [aws_security_group.kali_sg.id]
  subnet_id              = aws_subnet.public_subnet.id
  
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y nmap netcat telnet
              echo "Kali Attacker Instance Ready" > /home/ec2-user/README.txt
              echo "This instance will be used for penetration testing" >> /home/ec2-user/README.txt
              EOF
  
  tags = {
    Name = "quantum-shield-kali-attacker"
    Role = "Attacker"
    Team = "P2W12"
  }
}

# Vulnerable Target Instance
resource "aws_instance" "vuln_target" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type_vuln
  key_name              = var.key_name
  vpc_security_group_ids = [aws_security_group.vuln_sg.id]
  subnet_id              = aws_subnet.private_app_subnet.id
  
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd php
              systemctl start httpd
              systemctl enable httpd
              
              # Create vulnerable web application
              cat > /var/www/html/index.html << 'HTML_EOF'
              <!DOCTYPE html>
              <html>
              <head>
                  <title>Vulnerable Web Server</title>
              </head>
              <body>
                  <h1>Quantum Shield - Vulnerable Target</h1>
                  <h2>P2W12 Team Project</h2>
                  <p>This is a deliberately vulnerable web server for penetration testing.</p>
              <p>Team Members:</p>
              <ul>
                  <li>Shannon Kelly - Lead Cloud Architect</li>
                  <li>Fausto Rosado - Infrastructure Engineer</li>
                  <li>Zeinab Ali - Red Team Engineer</li>
                  <li>Latrisha Dodson - Blue Team Engineer</li>
                  <li>Javier Acosta - Documentation Lead</li>
              </ul>
              <p>Current Time: <span id="time"></span></p>
              <script>
                  document.getElementById('time').innerHTML = new Date().toLocaleString();
              </script>
              </body>
              </html>
              HTML_EOF
              
              # Create a simple vulnerable PHP script
              cat > /var/www/html/info.php << 'PHP_EOF'
              <?php
              echo "<h2>PHP Info - Vulnerable Target</h2>";
              echo "<p>This page intentionally exposes system information for testing.</p>";
              phpinfo();
              ?>
              PHP_EOF
              
              # Set weak permissions for testing
              chmod 755 /var/www/html/
              chmod 644 /var/www/html/*.html
              chmod 644 /var/www/html/*.php
              EOF
  
  tags = {
    Name = "quantum-shield-vuln-target"
    Role = "Target"
    Team = "P2W12"
  }
}
