# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  access_key = var.access_key_var
  secret_key = var.secret_key_var
  region = var.region_var
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
provider "aws_instance" "Udacity_T2" {
    count = "4"
    ami = "ami-09d3b3274b6c5d4aa"
    instance_type = "t2.micro"
    tag = {
        Name = "Udacity T2"
    }
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
provider "aws_instance" "Udacity_M4" {
  count = "2"
  ami = "m4.large"
  instance_type = "ami-09d3b3274b6c5d4aa"
  tag = {
    Name = "Udacity M4"
  }
}