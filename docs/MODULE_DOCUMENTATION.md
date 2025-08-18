# 🔧 Module Documentation - AWS Security Lab

This document provides detailed explanations of each Terraform module in the AWS Security Lab, including their purpose, components, and configuration details.

## 📚 Table of Contents

1. [VPC Module](#vpc-module)
2. [Security Groups Module](#security-groups-module)
3. [EC2 Module](#ec2-module)
4. [S3 Module](#s3-module)
5. [GuardDuty Module](#guardduty-module)
6. [Security Hub Module](#security-hub-module)
7. [CloudWatch Module](#cloudwatch-module)
8. [IAM Module](#iam-module)

---

## 🏗️ VPC Module

**Location**: `terraform/modules/vpc/`

### Purpose
The VPC (Virtual Private Cloud) module creates the foundational networking infrastructure for the security lab. It establishes a private, isolated network environment where all lab resources will be deployed.

### Components

#### 1. VPC Resource (`aws_vpc.main`)
- **Purpose**: Creates the main virtual private cloud
- **CIDR Block**: `10.0.0.0/16` (65,536 IP addresses)
- **Features**:
  - DNS hostnames enabled for easy resource identification
  - DNS support enabled for internal name resolution
  - Tagged for easy identification and cost tracking

#### 2. Internet Gateway (`aws_internet_gateway.main`)
- **Purpose**: Provides internet connectivity for public subnets
- **Function**: Routes traffic between the VPC and the internet
- **Attachment**: Automatically attached to the VPC

#### 3. Public Subnets (`aws_subnet.public`)
- **Purpose**: Host resources that need direct internet access
- **Count**: 2 subnets (one per availability zone)
- **CIDR Blocks**: 
  - `10.0.1.0/24` (256 IPs) - us-east-1a
  - `10.0.2.0/24` (256 IPs) - us-east-1b
- **Features**:
  - Auto-assign public IPs enabled
  - Located in different availability zones for high availability

#### 4. Private Subnets (`aws_subnet.private`)
- **Purpose**: Host resources that should not have direct internet access
- **Count**: 2 subnets (one per availability zone)
- **CIDR Blocks**:
  - `10.0.10.0/24` (256 IPs) - us-east-1a
  - `10.0.11.0/24` (256 IPs) - us-east-1b
- **Features**:
  - No public IP assignment
  - Isolated from direct internet access

#### 5. Route Tables
- **Public Route Table**: Routes internet traffic through the Internet Gateway
- **Private Route Table**: No internet access (for future NAT Gateway implementation)

### Network Architecture
```
Internet
    │
    ▼
Internet Gateway
    │
    ▼
Public Subnets (10.0.1.0/24, 10.0.2.0/24)
    │
    ▼
Private Subnets (10.0.10.0/24, 10.0.11.0/24)
```

### Security Benefits
- **Network Isolation**: Resources are isolated in a private network
- **Controlled Access**: Public resources are separated from private resources
- **Availability**: Resources span multiple availability zones
- **Scalability**: Easy to add more subnets as needed

---

## 🛡️ Security Groups Module

**Location**: `terraform/modules/security_groups/`

### Purpose
Security Groups act as virtual firewalls for EC2 instances, controlling inbound and outbound traffic. This module creates three different security groups for different types of resources.

### Components

#### 1. Public EC2 Security Group (`aws_security_group.public_ec2`)
- **Purpose**: Controls access to web servers and other public-facing resources
- **Inbound Rules**:
  - **SSH (Port 22)**: Access from anywhere (for lab purposes)
  - **HTTP (Port 80)**: Web traffic from anywhere
  - **HTTPS (Port 443)**: Secure web traffic from anywhere
- **Outbound Rules**: All traffic allowed (for internet access)
- **Use Case**: Web servers, load balancers, bastion hosts

#### 2. Private EC2 Security Group (`aws_security_group.private_ec2`)
- **Purpose**: Controls access to internal resources like databases
- **Inbound Rules**:
  - **SSH (Port 22)**: Access only from within the VPC
  - **MySQL (Port 3306)**: Database access from VPC resources
- **Outbound Rules**: All traffic allowed (for updates and monitoring)
- **Use Case**: Database servers, application servers, internal services

#### 3. VPC Endpoints Security Group (`aws_security_group.vpc_endpoints`)
- **Purpose**: Controls access to AWS service endpoints within the VPC
- **Inbound Rules**:
  - **HTTPS (Port 443)**: Access from VPC resources only
- **Use Case**: S3, DynamoDB, and other AWS service endpoints

### Security Principles Applied
- **Least Privilege**: Only necessary ports are open
- **Defense in Depth**: Multiple layers of security controls
- **Network Segmentation**: Public and private resources are isolated
- **Controlled Access**: Database access restricted to VPC only

### Traffic Flow Examples
```
Internet → Public EC2 (Port 80/443) ✅
Internet → Private EC2 (Port 22) ❌
Public EC2 → Private EC2 (Port 3306) ✅
Public EC2 → Private EC2 (Port 22) ✅
```

---

## 🖥️ EC2 Module

**Location**: `terraform/modules/ec2/`

### Purpose
The EC2 module creates the compute instances that will be targeted in the security lab. It sets up both a public web server (attack target) and a private database server (lateral movement target).

### Components

#### 1. SSH Key Pair (`aws_key_pair.lab_key`)
- **Purpose**: Provides secure SSH access to EC2 instances
- **Generation**: Automatically created during module deployment
- **Storage**: Private key stored locally, public key uploaded to AWS
- **Security**: 2048-bit RSA encryption

#### 2. Public Web Server (`aws_instance.public_web`)
- **Purpose**: Primary target for compromise simulation
- **AMI**: Latest Amazon Linux 2 (free tier eligible)
- **Instance Type**: t3.micro (1 vCPU, 1 GB RAM)
- **Network**: Placed in public subnet for internet access
- **Security**: Protected by public EC2 security group
- **User Data**: Automatically installs and configures web server

#### 3. Private Database Server (`aws_instance.private_db`)
- **Purpose**: Secondary target for lateral movement simulation
- **AMI**: Latest Amazon Linux 2
- **Instance Type**: t3.micro
- **Network**: Placed in private subnet (no direct internet access)
- **Security**: Protected by private EC2 security group
- **User Data**: Automatically installs and configures MySQL database

#### 4. AMI Selection (`data.aws_ami.amazon_linux`)
- **Purpose**: Dynamically selects the latest Amazon Linux 2 AMI
- **Filters**:
  - Most recent version
  - HVM virtualization (hardware-assisted)
  - x86_64 architecture
  - GP2 storage optimized

### User Data Scripts

#### Web Server Script (`web_server.sh`)
- **Purpose**: Automates server setup after launch
- **Actions**:
  - Updates system packages
  - Installs Apache, PHP, and MySQL client
  - Creates vulnerable web application
  - Sets up monitoring and logging
  - Configures security lab environment

#### Database Server Script (`database_server.sh`)
- **Purpose**: Automates database setup after launch
- **Actions**:
  - Updates system packages
  - Installs MySQL server
  - Creates security lab database
  - Populates with sample data
  - Sets up monitoring and logging

### Security Lab Features
- **Vulnerable Web App**: Intentionally insecure for testing
- **Sample Data**: Realistic database with sensitive information
- **Monitoring**: Built-in logging and monitoring scripts
- **Access Control**: SSH access for investigation and remediation

---

## 🗄️ S3 Module

**Location**: `terraform/modules/s3/`

### Purpose
The S3 module creates a secure storage bucket for threat intelligence data, lab artifacts, and security findings. This bucket serves as a central repository for security-related information.

### Components

#### 1. S3 Bucket (`aws_s3_bucket.threat_intel`)
- **Purpose**: Primary storage for threat intelligence and lab data
- **Naming**: Globally unique bucket name
- **Region**: Same as the lab deployment
- **Tags**: Properly tagged for cost tracking and identification

#### 2. Bucket Versioning (`aws_s3_bucket_versioning.threat_intel`)
- **Purpose**: Maintains multiple versions of objects
- **Benefits**:
  - Protects against accidental deletion
  - Enables point-in-time recovery
  - Maintains audit trail of changes
- **Use Case**: Tracking changes to threat intelligence files

#### 3. Server-Side Encryption (`aws_s3_bucket_server_side_encryption_configuration`)
- **Purpose**: Encrypts data at rest
- **Algorithm**: AES-256 (industry standard)
- **Type**: Server-side encryption with S3-managed keys
- **Benefits**: Automatic encryption of all uploaded objects

#### 4. Public Access Block (`aws_s3_bucket_public_access_block`)
- **Purpose**: Prevents accidental public access
- **Settings**:
  - Block public ACLs
  - Block public policies
  - Ignore public ACLs
  - Restrict public buckets
- **Security**: Ensures bucket remains private

#### 5. Bucket Policy (`aws_s3_bucket_policy.threat_intel`)
- **Purpose**: Fine-grained access control
- **Policy**: Denies public read access
- **Principals**: Only root users can access (for lab purposes)
- **Security**: Prevents unauthorized access to sensitive data

#### 6. Sample Threat Intelligence Files
- **Malware Indicators**: JSON file with sample malware hashes
- **IP Blacklists**: Text file with malicious IP addresses
- **Domain Blacklists**: Text file with malicious domains
- **Compromise Artifacts**: JSON file with attack indicators

### Data Structure
```
threat-intel-bucket/
├── threats/
│   ├── malware_indicators.json
│   ├── ip_blacklist.txt
│   ├── domain_blacklist.txt
│   └── compromise_artifacts.json
└── lab-artifacts/
    ├── logs/
    ├── findings/
    └── reports/
```

### Security Features
- **Encryption**: All data encrypted at rest
- **Access Control**: Strict IAM-based permissions
- **Versioning**: Protection against data loss
- **Audit Trail**: Complete access logging
- **Compliance**: Meets security and compliance requirements

---

## 🚨 GuardDuty Module

**Location**: `terraform/modules/guardduty/`

### Purpose
AWS GuardDuty is a threat detection service that continuously monitors for malicious activity and unauthorized behavior. This module enables GuardDuty and configures it to detect various types of security threats.

### Components

#### 1. GuardDuty Detector (`aws_guardduty_detector.main`)
- **Purpose**: Core threat detection engine
- **Status**: Enabled by default
- **Region**: Automatically configured for the deployment region
- **Features**: Continuous monitoring of AWS accounts and workloads

#### 2. SNS Topic (`aws_sns_topic.guardduty_findings`)
- **Purpose**: Notification system for security findings
- **Name**: Environment-specific naming convention
- **Use Case**: Real-time alerts for security incidents
- **Integration**: Can trigger automated responses

#### 3. SNS Topic Policy (`aws_sns_topic_policy.guardduty_findings`)
- **Purpose**: Controls who can publish to the SNS topic
- **Principals**: Only GuardDuty service can publish
- **Actions**: Limited to SNS:Publish
- **Security**: Prevents unauthorized publishing

#### 4. Publishing Destination (`aws_guardduty_publishing_destination.main`)
- **Purpose**: Configures where GuardDuty sends findings
- **Destination**: SNS topic for real-time notifications
- **KMS Key**: Uses AWS-managed GuardDuty key
- **Integration**: Connects GuardDuty to notification system

#### 5. Threat Intelligence Sets
- **Malicious IPs**: List of known malicious IP addresses
- **Trusted IPs**: List of known trusted IP addresses
- **Source**: S3 bucket with threat intelligence data
- **Activation**: Automatically activated for real-time detection

### Threat Detection Capabilities

#### 1. API Call Monitoring
- **Unauthorized Access**: Detects unusual API usage patterns
- **Privilege Escalation**: Identifies suspicious permission changes
- **Data Exfiltration**: Monitors unusual data access patterns

#### 2. Network Activity
- **Suspicious Connections**: Detects connections to known malicious IPs
- **Port Scanning**: Identifies network reconnaissance activities
- **Data Exfiltration**: Monitors unusual outbound traffic

#### 3. Instance Compromise
- **Malware Detection**: Identifies malicious software installation
- **Unauthorized Access**: Detects suspicious login patterns
- **Resource Abuse**: Monitors unusual resource usage

#### 4. Account Compromise
- **Credential Abuse**: Detects suspicious credential usage
- **Unauthorized Changes**: Monitors account modifications
- **Data Access**: Tracks unusual data access patterns

### Integration Points
- **CloudWatch**: Metrics and logging
- **SNS**: Real-time notifications
- **Security Hub**: Centralized findings
- **Lambda**: Automated response actions
- **Step Functions**: Complex workflow orchestration

---

## 🔒 Security Hub Module

**Location**: `terraform/modules/security_hub/`

### Purpose
AWS Security Hub provides a comprehensive view of security alerts and compliance status across AWS accounts. This module enables Security Hub and configures security standards and insights.

### Components

#### 1. Security Hub Account (`aws_securityhub_account.main`)
- **Purpose**: Enables Security Hub for the AWS account
- **Standards**: Automatically enables default security standards
- **Controls**: Automatically enables security controls
- **Region**: Configured for the deployment region

#### 2. Security Standards
- **CIS AWS Foundations**: Industry-standard security benchmarks
- **AWS Foundational Security**: AWS-specific security best practices
- **Compliance**: Helps meet regulatory requirements
- **Automation**: Automatic control enablement

#### 3. Action Targets (`aws_securityhub_action_target.guardduty_findings`)
- **Purpose**: Defines actions that can be taken on findings
- **Integration**: Connects Security Hub to GuardDuty
- **Automation**: Enables automated response workflows
- **Customization**: Can be extended for specific use cases

#### 4. Security Insights
- **High Severity Findings**: Focuses on critical security issues
- **GuardDuty Findings**: Specific insights for threat detection
- **Grouping**: Organizes findings by common attributes
- **Prioritization**: Helps focus on most important issues

### Security Standards Details

#### CIS AWS Foundations Benchmark
- **Purpose**: Industry-standard security configuration
- **Controls**: 100+ security controls
- **Categories**:
  - Identity and Access Management
  - Logging and Monitoring
  - Networking and Security
  - Data Protection
- **Compliance**: Helps meet regulatory requirements

#### AWS Foundational Security Best Practices
- **Purpose**: AWS-specific security guidance
- **Controls**: 50+ security controls
- **Categories**:
  - Security Best Practices
  - Operational Excellence
  - Reliability
  - Performance Efficiency
- **Integration**: Native AWS service integration

### Finding Management

#### 1. Finding Aggregation
- **Multiple Sources**: Combines findings from various services
- **Centralized View**: Single dashboard for all security issues
- **Deduplication**: Eliminates duplicate findings
- **Prioritization**: Ranks findings by severity and impact

#### 2. Automated Response
- **Lambda Functions**: Custom response actions
- **Step Functions**: Complex workflow orchestration
- **SNS Notifications**: Real-time alerting
- **Integration**: Connects to existing security tools

#### 3. Compliance Reporting
- **Standards Mapping**: Maps findings to compliance frameworks
- **Progress Tracking**: Monitors compliance improvement
- **Documentation**: Generates compliance reports
- **Audit Trail**: Complete history of security actions

---

## 📊 CloudWatch Module

**Location**: `terraform/modules/cloudwatch/`

### Purpose
Amazon CloudWatch provides monitoring, observability, and operational insights for AWS resources and applications. This module creates dashboards, alarms, and log groups for comprehensive security monitoring.

### Components

#### 1. Log Groups
- **Security Lab Logs**: Centralized logging for lab activities
- **EC2 Logs**: Instance-specific logging and monitoring
- **Retention**: 7-day log retention (configurable)
- **Encryption**: Automatic encryption at rest

#### 2. Security Dashboard (`aws_cloudwatch_dashboard.security_dashboard`)
- **Purpose**: Real-time security monitoring visualization
- **Layout**: 4-widget dashboard with security metrics
- **Refresh**: 5-minute metric update intervals
- **Integration**: Connects to multiple AWS services

#### 3. Dashboard Widgets

##### Widget 1: GuardDuty Findings
- **Metrics**: Finding counts by severity
- **Display**: Line chart with time series
- **Alerts**: Visual indicators for high finding counts
- **Trends**: Historical finding patterns

##### Widget 2: Security Hub Findings
- **Metrics**: Overall security compliance status
- **Display**: Single metric with trend
- **Context**: Security posture overview
- **Actions**: Quick access to detailed findings

##### Widget 3: EC2 Performance
- **Metrics**: CPU, network, and memory utilization
- **Display**: Multi-line chart
- **Baselines**: Normal performance ranges
- **Anomalies**: Performance deviation detection

##### Widget 4: VPC Network Activity
- **Metrics**: Network connection counts
- **Display**: Single metric with context
- **Security**: Network traffic monitoring
- **Alerts**: Unusual network activity detection

#### 4. CloudWatch Alarms

##### High CPU Alarm (`aws_cloudwatch_metric_alarm.high_cpu`)
- **Purpose**: Monitors EC2 CPU utilization
- **Threshold**: 80% CPU usage
- **Evaluation**: 2 consecutive periods
- **Actions**: Configurable response actions

##### GuardDuty Findings Alarm (`aws_cloudwatch_metric_alarm.guardduty_findings`)
- **Purpose**: Alerts on new security findings
- **Threshold**: Any new findings
- **Evaluation**: 1 evaluation period
- **Actions**: Immediate security team notification

### Monitoring Capabilities

#### 1. Real-Time Metrics
- **5-Minute Intervals**: Near real-time monitoring
- **Custom Metrics**: Application-specific measurements
- **Baseline Analysis**: Normal behavior identification
- **Anomaly Detection**: Unusual pattern recognition

#### 2. Log Management
- **Centralized Collection**: All logs in one place
- **Structured Data**: JSON-formatted log entries
- **Search and Filter**: Powerful log querying
- **Retention Policies**: Configurable log lifecycle

#### 3. Alerting and Notification
- **Multiple Channels**: SNS, email, SMS, webhooks
- **Escalation**: Progressive alert routing
- **Customization**: Flexible alert conditions
- **Integration**: Connects to existing tools

#### 4. Performance Optimization
- **Resource Utilization**: CPU, memory, network monitoring
- **Capacity Planning**: Resource usage trends
- **Cost Optimization**: Identify underutilized resources
- **Scaling Decisions**: Data-driven scaling decisions

### Security Monitoring Features

#### 1. Threat Detection
- **Finding Correlation**: Connect related security events
- **Pattern Recognition**: Identify attack patterns
- **Baseline Deviation**: Detect unusual behavior
- **Real-Time Alerts**: Immediate incident notification

#### 2. Compliance Monitoring
- **Standards Tracking**: Monitor compliance progress
- **Control Status**: Track security control effectiveness
- **Audit Logging**: Complete audit trail
- **Reporting**: Automated compliance reports

#### 3. Incident Response
- **Quick Assessment**: Rapid incident evaluation
- **Context Provision**: Relevant information gathering
- **Response Coordination**: Team collaboration tools
- **Post-Incident Analysis**: Lessons learned documentation

---

## 👤 IAM Module

**Location**: `terraform/modules/iam/`

### Purpose
The IAM (Identity and Access Management) module creates roles, policies, and instance profiles that provide secure, least-privilege access to AWS resources. This ensures that lab resources can only perform necessary actions.

### Components

#### 1. EC2 Instance Role (`aws_iam_role.ec2_role`)
- **Purpose**: Provides permissions for EC2 instances
- **Trust Policy**: Allows EC2 service to assume the role
- **Use Case**: Web server and database server permissions
- **Security**: Follows principle of least privilege

#### 2. EC2 Instance Policy (`aws_iam_role_policy.ec2_policy`)
- **Purpose**: Defines specific permissions for EC2 instances
- **Permissions**:
  - **CloudWatch**: Metrics and logging
  - **CloudWatch Logs**: Log management
  - **S3**: Threat intelligence access
- **Resources**: Limited to specific S3 bucket access

#### 3. EC2 Instance Profile (`aws_iam_instance_profile.ec2_profile`)
- **Purpose**: Attaches IAM role to EC2 instances
- **Function**: Enables instances to use IAM roles
- **Security**: No long-term credentials stored on instances
- **Rotation**: Automatic credential rotation

#### 4. Lambda Role (`aws_iam_role.lambda_role`)
- **Purpose**: Permissions for Lambda functions
- **Use Case**: Automated security response actions
- **Trust Policy**: Allows Lambda service to assume the role
- **Security**: Minimal required permissions

#### 5. Lambda Policy (`aws_iam_role_policy.lambda_policy`)
- **Purpose**: Defines Lambda function permissions
- **Permissions**:
  - **CloudWatch Logs**: Function logging
  - **GuardDuty**: Finding management
  - **Security Hub**: Finding updates
- **Resources**: Limited to specific actions

### Permission Structure

#### 1. CloudWatch Permissions
- **PutMetricData**: Send custom metrics
- **CreateLogGroup**: Create log groups
- **CreateLogStream**: Create log streams
- **PutLogEvents**: Write log entries
- **DescribeLogGroups**: List log groups
- **DescribeLogStreams**: List log streams

#### 2. S3 Permissions
- **GetObject**: Download threat intelligence files
- **PutObject**: Upload lab artifacts
- **ListBucket**: Browse bucket contents
- **Scope**: Limited to specific threat intelligence bucket

#### 3. Security Service Permissions
- **GuardDuty**: Read and update findings
- **Security Hub**: Read and update findings
- **Actions**: Limited to necessary operations
- **Resources**: Restricted to lab-specific resources

### Security Best Practices

#### 1. Least Privilege
- **Minimal Permissions**: Only necessary actions allowed
- **Resource Scoping**: Limited to specific resources
- **Action Limiting**: Restricted to required operations
- **Regular Review**: Periodic permission audits

#### 2. Credential Management
- **No Long-Term Keys**: Uses temporary credentials
- **Automatic Rotation**: Credentials rotate automatically
- **Instance Profiles**: Secure credential delivery
- **Audit Logging**: Complete access tracking

#### 3. Access Control
- **Service Principals**: Limited to specific AWS services
- **Conditional Access**: Additional access restrictions
- **Resource Policies**: Fine-grained resource control
- **Cross-Account**: Secure cross-account access

#### 4. Monitoring and Auditing
- **CloudTrail**: Complete API call logging
- **CloudWatch**: Permission usage metrics
- **Security Hub**: IAM-related findings
- **Compliance**: Regular security assessments

### Integration Points

#### 1. EC2 Integration
- **Instance Profiles**: Secure role attachment
- **Metadata Service**: Credential retrieval
- **Auto-scaling**: Role inheritance
- **Spot Instances**: Consistent permissions

#### 2. Lambda Integration
- **Function Execution**: Role-based permissions
- **Event Sources**: Trigger-based access
- **Environment Variables**: Secure configuration
- **Layers**: Shared permission sets

#### 3. Security Service Integration
- **GuardDuty**: Automated response actions
- **Security Hub**: Finding management
- **CloudWatch**: Monitoring and alerting
- **SNS**: Notification delivery

---

## 🔗 Module Dependencies

### Dependency Chain
```
VPC Module
    ↓
Security Groups Module (depends on VPC)
    ↓
EC2 Module (depends on VPC, Security Groups)
    ↓
S3 Module (independent)
    ↓
GuardDuty Module (depends on S3)
    ↓
Security Hub Module (independent)
    ↓
CloudWatch Module (depends on VPC)
    ↓
IAM Module (depends on S3)
```

### Resource Dependencies
- **VPC ID**: Required by Security Groups, EC2, and CloudWatch
- **Subnet IDs**: Required by EC2 module
- **Security Group IDs**: Required by EC2 module
- **S3 Bucket Name**: Required by GuardDuty and IAM modules
- **Environment**: Used by all modules for consistent naming

### Data Flow
1. **VPC Creation**: Establishes network foundation
2. **Security Groups**: Define access controls
3. **EC2 Instances**: Deploy compute resources
4. **S3 Bucket**: Store threat intelligence
5. **Security Services**: Enable monitoring and detection
6. **Monitoring**: Track security and performance metrics
7. **IAM Roles**: Provide secure access to resources

---

## 🚀 Module Customization

### Common Customizations

#### 1. Network Configuration
- **CIDR Blocks**: Modify IP address ranges
- **Availability Zones**: Change deployment regions
- **Subnet Sizing**: Adjust subnet capacity
- **Route Tables**: Customize routing logic

#### 2. Security Configuration
- **Port Access**: Modify allowed ports
- **Source IPs**: Restrict access to specific IPs
- **Security Rules**: Add custom security group rules
- **Access Controls**: Modify IAM permissions

#### 3. Resource Configuration
- **Instance Types**: Change EC2 instance sizes
- **Storage**: Modify EBS volume configurations
- **Monitoring**: Adjust CloudWatch settings
- **Retention**: Change log retention periods

#### 4. Service Configuration
- **GuardDuty**: Customize threat detection
- **Security Hub**: Modify security standards
- **CloudWatch**: Customize dashboards and alarms
- **S3**: Adjust bucket policies and settings

### Environment-Specific Configurations

#### Development Environment
- **Instance Types**: Smaller, cost-effective instances
- **Monitoring**: Basic monitoring and alerting
- **Security**: Standard security configurations
- **Retention**: Shorter log retention periods

#### Production Environment
- **Instance Types**: Larger, performance-optimized instances
- **Monitoring**: Comprehensive monitoring and alerting
- **Security**: Enhanced security configurations
- **Retention**: Longer log retention periods

#### Lab Environment
- **Instance Types**: Free tier eligible instances
- **Monitoring**: Security-focused monitoring
- **Security**: Intentionally vulnerable configurations
- **Retention**: Standard retention for learning purposes

---

## 📝 Module Best Practices

### 1. Naming Conventions
- **Consistent Prefixes**: Use environment-based prefixes
- **Descriptive Names**: Clear, meaningful resource names
- **Tag Consistency**: Standardized tagging strategy
- **Version Control**: Track configuration changes

### 2. Security Configuration
- **Least Privilege**: Minimal required permissions
- **Network Segmentation**: Isolate different resource types
- **Access Control**: Restrict access to necessary sources
- **Monitoring**: Comprehensive security monitoring

### 3. Resource Management
- **Cost Optimization**: Use appropriate instance types
- **Auto-scaling**: Implement scaling policies
- **Backup Strategies**: Regular data backup
- **Disaster Recovery**: Plan for failure scenarios

### 4. Monitoring and Alerting
- **Comprehensive Coverage**: Monitor all critical resources
- **Proactive Alerts**: Alert before issues occur
- **Escalation Procedures**: Clear response workflows
- **Documentation**: Maintain runbooks and procedures

---

## 🔍 Troubleshooting Common Issues

### 1. VPC Issues
- **CIDR Conflicts**: Ensure unique IP ranges
- **Route Table Problems**: Verify routing configuration
- **Subnet Availability**: Check AZ availability
- **Internet Gateway**: Verify attachment and routing

### 2. Security Group Issues
- **Port Conflicts**: Check for duplicate rules
- **Source IPs**: Verify CIDR block formatting
- **Rule Order**: Understand rule evaluation order
- **Default Rules**: Check implicit deny rules

### 3. EC2 Issues
- **AMI Availability**: Verify AMI in target region
- **Instance Types**: Check region availability
- **Key Pair**: Verify SSH key configuration
- **User Data**: Check script syntax and permissions

### 4. Service Issues
- **GuardDuty**: Verify service enablement
- **Security Hub**: Check region support
- **CloudWatch**: Verify metric availability
- **S3**: Check bucket naming and permissions

### 5. IAM Issues
- **Role Permissions**: Verify policy attachments
- **Trust Policies**: Check service principal configuration
- **Instance Profiles**: Verify role attachment
- **Cross-Account**: Verify account configuration

---

## 📚 Additional Resources

### AWS Documentation
- [VPC User Guide](https://docs.aws.amazon.com/vpc/)
- [EC2 User Guide](https://docs.aws.amazon.com/ec2/)
- [S3 User Guide](https://docs.aws.amazon.com/s3/)
- [GuardDuty User Guide](https://docs.aws.amazon.com/guardduty/)
- [Security Hub User Guide](https://docs.aws.amazon.com/securityhub/)
- [CloudWatch User Guide](https://docs.aws.amazon.com/cloudwatch/)
- [IAM User Guide](https://docs.aws.amazon.com/iam/)

### Terraform Documentation
- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Language](https://www.terraform.io/language)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/)

### Security Resources
- [AWS Security Best Practices](https://aws.amazon.com/security/security-learning/)
- [CIS AWS Foundations](https://www.cisecurity.org/benchmark/amazon_web_services/)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

---

This comprehensive module documentation provides the foundation for understanding how each component works together to create a secure, monitored, and educational AWS environment. Each module is designed with security best practices, clear separation of concerns, and extensibility for future enhancements.
