#!/bin/bash
set -e

SCRIPT_URL="https://raw.githubusercontent.com/KonstadinosAngelis/CS312-minecraftAWS/main/scripts/minecraft_setup.sh"

# Check AWS credentials are working
aws sts get-caller-identity > /dev/null
echo "Credentials look good!"

# Provision infrastructure
terraform -chdir=terraform init
terraform -chdir=terraform apply -auto-approve

# Grab instance ID and IP from terraform outputs
INSTANCE_ID=$(terraform -chdir=terraform output -raw instance_id)
SERVER_IP=$(terraform -chdir=terraform output -raw server_ip)

# Wait for SSM agent to come online
echo "Waiting for SSM agent..."
sleep 60

# Run the setup script on the instance via SSM
aws ssm send-command \
  --no-cli-pager \
  --instance-ids "$INSTANCE_ID" \
  --document-name "AWS-RunShellScript" \
  --parameters "{\"commands\":[
    \"curl -o /tmp/minecraft_setup.sh $SCRIPT_URL\",
    \"chmod +x /tmp/minecraft_setup.sh\",
    \"bash /tmp/minecraft_setup.sh\"
  ]}"

echo "Setup script sent! Server will be ready in a few minutes."
echo "Server IP: $SERVER_IP"
echo "Verify with: nmap -sV -Pn -p T:25565 $SERVER_IP"
