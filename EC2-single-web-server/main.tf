provider "aws" {
  region = "ap-southeast-2"
}

variable "server_port"{
  type = number
  description = "the port for HTTP"
  default = 8082
}
resource "aws_instance" "name" {
  ami = "ami-0310483fb2b488153"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              sudo busybox httpd -f -p ${var.server_port} &
              EOF
  
  user_data_replace_on_change = true

  tags={
    Name="terraform-example"
  }
}

resource "aws_security_group" "instance"{
  name="terraform-example-security-instance"
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags={
    Name="terraform-example"
  }
} 

output "public_ip" {
    value = aws_instance.name.public_ip
    description ="The public IP address of EC2"
}