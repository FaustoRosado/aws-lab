// keypair.tf - SSH Key Pair Import

// Purpose: Imports your existing public key into AWS.
// This is essential for securely logging into your EC2 instances.
/*
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}
*/
