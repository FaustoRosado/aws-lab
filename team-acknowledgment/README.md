# Team Acknowledgment Website

Simple, professional website to acknowledge team contributions to the Quantum Shield AWS Cyber Range project.

## Quick Deploy

1. **Deploy to EC2**:
   ```bash
   cd team-acknowledgment
   ./deploy.sh
   ```

2. **Upload website**:
   ```bash
   scp -i ~/.ssh/gd-lab-keypair.pem index.html ec2-user@<PUBLIC_IP>:/tmp/
   ssh -i ~/.ssh/gd-lab-keypair.pem ec2-user@<PUBLIC_IP>
   sudo cp /tmp/index.html /var/www/html/
   ```

3. **Visit**: `http://<PUBLIC_IP>`

## Features

- Clean, professional design
- Interactive hover effects
- Mobile responsive
- Team member role highlights
- Project technology showcase
- Direct GitHub link

## Team Members Highlighted

- **Shannon Kelly** - Lead Cloud Architect & Project Lead
- **Fausto Rosado** - Infrastructure Engineer & Terraform Specialist  
- **Zeinab Ali** - Red Team Engineer & Offensive Security
- **Additional team members** - Blue Team & Documentation roles

## Cost

- **t3.micro instance**: Free tier eligible
- **Estimated cost**: <$5/month if kept running
- **Cleanup**: Terminate instance when done
