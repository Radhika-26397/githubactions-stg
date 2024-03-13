provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}

resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags = {
        Name = "${var.vpc_name}"
	    Owner = "Testuser"
	    environment = "${var.environment}"
    }
}

resource "aws_internet_gateway" "IG2" {
    vpc_id = "${aws_vpc.default.id}"
	tags = {
        Name = "${var.IGW_name}"
    }
}

resource "aws_subnet" "subnet1-public" {
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "${var.public_subnet1_cidr}"
    availability_zone = "us-east-1a"

    tags = {
        Name = "${var.public_subnet1_name}"
    }
}

resource "aws_subnet" "subnet2-public" {
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "${var.public_subnet2_cidr}"
    availability_zone = "us-east-1b"

    tags = {
        Name = "${var.public_subnet2_name}"
    }
}


resource "aws_subnet" "subnet1-private" {
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "${var.private_subnet_cidr}"
    availability_zone = "us-east-1d"

    tags = {
        Name = "${var.private_subnet_name}"
    }
	
}


resource "aws_route_table" "RT2" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.IG2.id}"
    }

    tags = {
        Name = "${var.Main_Routing_Table}"
    }
}

resource "aws_route_table_association" "terraform-public" {
    subnet_id = "${aws_subnet.subnet1-public.id}"
    route_table_id = "${aws_route_table.RT2.id}"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.default.id}"

  dynamic "ingress" {
    for_each = var.settings
    iterator = test_sg_ingress

    content {
      description = test_sg_ingress.value["description"]
      from_port   = test_sg_ingress.value["port"]
      to_port     = test_sg_ingress.value["port"]
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
     
  }

  dynamic "egress" {
    for_each = var.settings
    iterator = test_sg_egress

    content {
      description = test_sg_egress.value["description"]
      from_port   = test_sg_egress.value["port"]
      to_port     = test_sg_egress.value["port"]
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    
  }
  tags = {
    Name = "TF_sg"
  }
   
}
resource "tls_private_key" "newkey" {
  algorithm     = "RSA"
  rsa_bits      = 4096
}

resource "aws_key_pair" "newkey" {
  key_name      = "TerraformKey"
  public_key    = tls_private_key.newkey.public_key_openssh
}

resource "aws_instance" "web-1" {
    #ami = var.imagename
    ami = "ami-0f403e3180720dd7e"
    #ami = "${data.aws_ami.my_ami.id}"
    availability_zone = "us-east-1a"
    instance_type = "t2.micro"
    key_name = aws_key_pair.newkey.key_name
    subnet_id = "${aws_subnet.subnet1-public.id}"
    vpc_security_group_ids = [aws_security_group.allow_all.id]
    associate_public_ip_address = true	
    tags = {
        Name = "Server-1"
        Env = "Dev"  
    }  
}
# resource "null_resource" "nginx"{
#     provisioner "remote-exec" {
#     inline = [
#       "sudo yum update -y",
#       "sudo yum install nginx -y ",
#       "sudo service nginx start",
      
#     ]
#     connection{
#         type = "ssh"
#         user = "ec2-user"
#         # private_key = local_file.newkey.content
#         private_key = "${file("TerraformKey")}"
#         host = "${aws_instance.web-1.public_ip}"
#     }
#   } 
# }
# resource "aws_eip" "elasticip" {
#   instance = aws_instance.web-1.id
#   tags = {
#         Name = "TF_EIP" 
#     } 
# }
# terraform {
#   backend "s3" {
#     bucket = "terraformbackend-s3-1"
#     key    = "terraform.tfstate"
#     region = "us-east-1"
#     # dynamodb_table = "Terraform_Statefile_Lock"
#     # encrypt        = true
#   }
# }
# # resource "aws_dynamodb_table" "terraform_locks" {
# #   name         = "${var.aws_dynamo_db_table}"
# #   billing_mode = "PAY_PER_REQUEST"
# #   hash_key     = "LockID"

# #   attribute {
# #     name = "LockID"
# #     type = "S"
# #   }
# # }




