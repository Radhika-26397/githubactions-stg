aws_access_key = "AKIAZI2LFQF4DMNZ62YN"
aws_secret_key = "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"
aws_region = "us-east-1"
vpc_cidr = "192.168.0.0/16"
public_subnet1_cidr = "192.168.1.0/24"
public_subnet2_cidr = "192.168.2.0/24"
private_subnet_cidr = "192.168.4.0/24"
vpc_name = "GIT_Test"
IGW_name = "GIT_Test-IG"
public_subnet1_name = "GIT_Test_SN1"
public_subnet2_name = "GIT_Test_SN2"
private_subnet_name = "GIT_Test_SN3-Private"
Main_Routing_Table = "GIT_Test_RTtesting"
settings = [
    {
      description = "Allows SSH access"
      port        = 22
    },
    {
      description = "Allows HTTP traffic"
      port        = 80
    },
    {
      description = "Allows HTTPS traffic"
      port        = 443
    }
  ]
#key_name = "LaptopKey"
environment = "dev"
