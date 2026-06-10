provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "minecraft_security_group" {
  name = "minecraft-sg"

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "minecraft_elasticIP" {
  instance = aws_instance.minecraft_server.id
  domain   = "vpc"
}

resource "aws_instance" "minecraft_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.medium"
  iam_instance_profile   = "LabInstanceProfile"
  vpc_security_group_ids = [aws_security_group.minecraft_security_group.id]


  tags = {
    Name = "automated-minecraft-server"
  }
}

