# CS312 Minecraft AWS Setup

## Background
Automates the provisioning, configuration, and deployment of a Minecraft Java server using an AWS EC2 instance and Terraform. Terraform handles infrastructure provisioning, an EC2 instance with proper security grouping, and elastic IP on a VPC. While the bash scripts handle downloading, configuring, and automation of the minecraft server. 

### Requirements
-[Terraform](https://developer.hashicorp.com/terraform/install) - at least version 1.15.5
-[AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) - version 2
-An AWS account that allows you to create resources, including an EC2 instance, VPC, and security groups.
 
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

## Commands
1. Clone the repo

2. Configure AWS Credentials




