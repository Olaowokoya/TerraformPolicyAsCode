resource "aws_s3_bucket" "artifacts" {
  bucket = "my-artifact-bucket-ssme"

  #Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = false
  }
}

# resource "aws_s3_bucket" "example" {
#   bucket = "my-tf-test-bucket"
# }

# resource "aws_s3_bucket_policy" "allow_access_from_codebuild" {
#   bucket = aws_s3_bucket.example.id
#   policy = data.aws_iam_policy_document.allow_access_from_codebuild.json
# }

# data "aws_iam_policy_document" "allow_access_from_codebuild" {
#   statement {
#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::Aws:123456789012"]
#     }

#     actions = [
#       "s3:GetObject",
#       "s3:ListBucket",
#       "s3:GetObjectVersioning"
#     ]

#     resources = [
#       aws_s3_bucket.artifacts.arn,
#       "${aws_s3_bucket.artifacts.arn}/*",
#     ]
#   }
# }

# resource "aws_s3_bucket_policy" "artifacts" {
#   bucket = aws_s3_bucket.artifacts.id

#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Id": "MYBUCKETPOLICY",
#   "Statement": [
#     {
#       "Sid": "IPAllow",
#       "Effect": "Allow",
#       "Principal": {
#         "AWS": "*"
#         },
#       "Action": "s3:*",
#       "Resource": "arn:aws:s3:::my-artifact-bucket-ssme/*",
#     }
#   ]
# }
# POLICY
# }

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.artifacts.id
  policy = data.aws_iam_policy_document.allow_access_from_codebuild.json
}

data "aws_iam_policy_document" "allow_access_from_codebuild" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.artifacts.arn,
      "${aws_s3_bucket.artifacts.arn}/*",
    ]
  }
}


# resource "aws_s3_bucket" "terraform_state" {
#   bucket = "my-state-bucket-ssme"

#   #Prevent accidental deletion of this S3 bucket
#   lifecycle {
#     prevent_destroy = false
#   }
# }

# resource "aws_s3_bucket_versioning" "enabled" {
#   bucket = aws_s3_bucket.terraform_state.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
#   bucket = aws_s3_bucket.terraform_state.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }

# resource "aws_s3_bucket_public_access_block" "public_access" {
#   bucket                  = aws_s3_bucket.terraform_state.id
#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }

# resource "aws_dynamodb_table" "terraform_locks" {
#   name         = "my-state-lock-ddb-ol"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }

# terraform {
#   backend "s3" {
#     # Replace this with your bucket name!
#     bucket         = "my-state-bucket-ssme"
#     key            = "global/s3/terraform.tfstate"
#     region         = "us-east-1"

#     # Replace this with your DynamoDB table name!
#     dynamodb_table = "my-state-lock-ddb-ol"
#     encrypt        = true
#   }
# }


#Create VPC with VPC module
# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"

#   name = "my-vpc"
#   cidr = "10.0.0.0/16"

#   azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#   public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

#   enable_nat_gateway = true
#   enable_vpn_gateway = true

#   tags = {
#     Terraform = "true"
#     Environment = "dev"
#   }
# }


# #Security Group
# module "test_service_sg" {
#   source = "terraform-aws-modules/security-group/aws"

#   name        = "user-service"
#   description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
#   vpc_id      = "vpc-0709df3bfc2d7aa8e"

#   ingress_cidr_blocks      = ["0.0.0.0/0"]
#   ingress_rules            = ["https-443-tcp"]
#   ingress_with_cidr_blocks = [
#     {
#       from_port   = 443
#       to_port     = 443
#       protocol    = "tcp"
#       description = "User-service ports"
#       cidr_blocks = "10.10.0.0/16"
#     },
#     {
#       rule        = "postgresql-tcp"
#       cidr_blocks = "0.0.0.0/0"
#     },
#   ]
# }

# #create a network interface
# resource "aws_network_interface" "web-server-nic" {
#   subnet_id       = "${element(module.vpc.private_subnets, 0)}"
#   private_ips     = ["10.0.1.50"]
#   security_groups = ["${module.test_service_sg.user-service}"]
# }

# # Create Amazon Linux 2 web server server 
# resource "aws_instance" "web-server-instance" {
#   ami = "ami-06e46074ae430fba6"
#   instance_type = "t2.micro"
#   availability_zone = "us-east-1a"
#   key_name = "test-ol"

#   network_interface {
#     device_index = 0
#     network_interface_id = aws_network_interface.web-server-nic.id
#   }

#   user_data = <<-EOF
#               #!/bin/bash
#               sudo su
#               sudo yum update -y
#               sudo yum install httpd -y
#               systemctl start httpd
#               systemctl enable httpd
#               echo "Go Rocket!!" >/var/www/html/index.html
#               EOF
#   tags = {
#     Name = "terraform-web-server"
#   }
# }

# output "server_private_ip" {
#   value = aws_instance.web-server-instance.private_ip
# }

# output "server_public_ip" {
#   value = aws_instance.web-server-instance.public_ip
# }

# #Create internet gateway
# resource "aws_internet_gateway" "gw" {
#   vpc_id = aws_vpc.main.id
# }

# #3.Create Custom Route Table
# resource "aws_route_table" "dev-route-table" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.gw.id
#   }

#   route {
#     ipv6_cidr_block        = "::/0"
#     gateway_id = aws_internet_gateway.gw.id
#   }

#   tags = {
#     Name = "main-rt"
#   }
# }

# # 4. Create a Subnet
# resource "aws_subnet" "public-1" {
#     vpc_id = aws_vpc.main.id
#     cidr_block = var.public_cidr
#     availability_zone = var.availability_zone

#     tags = {
#         Name = "main-public-subnet"
#     }

# }

# # 5. 

# provider "aws" {
#   region = "us-east-2"
# }

# module "myvpc" {
#   source = "terraform-aws-modules/vpc/aws"

#   name = "my-vpc"
#   cidr = "10.0.0.0/16"

#   azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#   public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

#   #assign_generated_ipv6_cidr_block = true

#   enable_nat_gateway = true
#   single_nat_gateway = true

#   #enable_s3_endpoint       = true
#   #enable_dynamodb_endpoint = true

#   public_subnet_tags = {
#     Name = "overridden-name-public"
#   }

#   tags = {
#     Owner       = "user"
#     Environment = "dev"
#     Name        = "terraformtestvpc"
#   }

#   vpc_tags = {
#     Name = "vpc-name"
#   }
# }

# module "ssh_access_sg" {
#   source = "terraform-aws-modules/security-group/aws//modules/ssh"

#   name        = "ssh-access"
#   description = "Security group for ssh access"
#   vpc_id      = "${module.myvpc.vpc_id}"

#   ingress_cidr_blocks = ["0.0.0.0/0"]
# }

# data "aws_ami" "amazon_linux" {
#   most_recent = true

#   filter {
#     name = "name"

#     values = [
#       "amzn-ami-hvm-*-x86_64-gp2",
#     ]
#   }

#   filter {
#     name = "owner-alias"

#     values = [
#       "amazon",
#     ]
#   }
# }

# module "ec2" {
#   source = "terraform-aws-modules/ec2-instance/aws"

#   #instance_count = 2

#   name                        = "example-normal"
#   ami                         = "${data.aws_ami.amazon_linux.id}"
#   instance_type               = "t2.medium"
#   subnet_id                   = module.vpc.public_subnets [0]
#   vpc_security_group_ids      = [module.ssh_access_sg]
#   associate_public_ip_address = true

#   user_data = <<-EOF
#             #!/bin/bash
#             sudo su
#             sudo yum update -y
#             sudo yum install httpd -y
#             systemctl start httpd
#             systemctl enable httpd
#             echo "Go Rocket!!" >/var/www/html/index.html
#             EOF
#   tags = {
#     Name = "terraform-web-server"
#   }
# }







