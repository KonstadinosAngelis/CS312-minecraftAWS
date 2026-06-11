# CS312 Minecraft AWS Setup

## Background
Automates the provisioning, configuration, and deployment of a Minecraft Java server using an AWS EC2 instance and Terraform. Terraform handles infrastructure provisioning, an EC2 instance with proper security grouping, and elastic IP on a VPC. While the bash scripts handle downloading, configuring, and automation of the minecraft server. 

### Requirements
- [Terraform](https://developer.hashicorp.com/terraform/install) - at least version 1.15.5
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) - version 2
- An AWS account that allows you to create resources, including an EC2 instance, VPC, and security groups.
 
### AWS CLI Set up
You must have AWS Academy credentials from the AWS Academy Learner Lab.
1. Once the lab has started click **AWS Details** in the top right
2. Click the "Show" button next to AWS CLI
3. Use an editor of your choice to open the file `~/.aws/credentials`
4. Copy and paste the output from the learner lab into the file and save it

**NOTE** This process must be repeated every time you launch the learner lab as the Session Token is re-generated every time the lab expires, or is restarted.

You can run the command `aws sts get-caller-identity` to check the validity of your current credentials.

### Environment
Ubuntu 24.04 is used, but should be cross compatible with any debian based system, virtual machine, or windows subsystem for linux (WSL).

## Pipeline
 
```
deploy.sh
   |
   |---> terraform init + apply
   |         |---> Security Group    (port 25565 inbound)
   |         |---> EC2 Instance      (Ubuntu 24 LTS, t3.medium)
   |         |---> Elastic IP        (fixed public IP)
   |         |---> Network ACL       (allow all inbound/outbound)
   |
   |---> Wait 60s for SSM agent
   |
   |---> SSM Run Command
             |---> curl minecraft_setup.sh from GitHub
             |---> apt install Java 25
             |---> Download server.jar
             |---> Write eula.txt
             |---> Create systemd service
             |---> systemctl enable + start
```

## Commands
### 1. Clone the repo
```bash
git clone https://github.com/KonstadinosAngelis/CS312-minecraftAWS.git
cd CS312-minecraftAWS
```

### 2. Configure AWS credentials
Follow the [AWS Credentials Setup](#aws-credentials-setup) section above.
 
### 3. Run the deploy script
```bash
bash deploy.sh
```

This will provision all AWS infrastructure, wait for the instance to be ready, and run the Minecraft setup script on it via SSM. When it finishes it will print your server IP.
### 4. Verify the server is running
```bash
nmap -sV -Pn -p T:25565 <server-ip>
```
 
You should see:
```
25565/tcp open minecraft
```

If not, run the bash file one more time.
 
### 5. Tear down
```bash
terraform -chdir=terraform destroy
```

## Connecting to the Server
 
1. Open Minecraft Java Edition
2. Click **Multiplayer** -> **Add Server**
3. Enter the server IP printed by `deploy.sh` in the **Server Address** field
4. Click **Done** and connect

## Sources
 
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Systems Manager Run Command](https://docs.aws.amazon.com/systems-manager/latest/userguide/execute-remote-commands.html)
- [Minecraft Server Download](https://www.minecraft.net/en-us/download/server)
- [Ubuntu AMI Locator](https://cloud-images.ubuntu.com/locator/ec2/)
- [systemd Service Units](https://www.freedesktop.org/software/systemd/man/systemd.service.html)





