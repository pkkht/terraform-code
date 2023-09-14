provider "aws" {
  region = "ap-southeast-2"
}
resource "aws_instance" "name" {
  ami = "ami-0dfb78957e4edea0c"
  instance_type = "t2.micro"

  tags={
    Name="terraform-example"
  }
}