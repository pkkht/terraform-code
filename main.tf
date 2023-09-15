provider "aws" {
  region = "ap-southeast-2"
}

variable "server_port"{
  type = number
  description = "the port for HTTP"
  default = 8080
}
resource "aws_instance" "name" {
  ami = "ami-0672b175139a0f8f4"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p {var.server_port} &
              EOF
  
  user_data_replace_on_change = true

  tags={
    Name="terraform-example"
  }
}

resource "aws_security_group" "instance"{
  name="terraform-example-security-instance"
  ingress  {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags={
    Name="terraform-example"
  }
} 

output "public_ip" {
    value = aws_instance.name.public_ip
    description ="The public IP address of EC2"
}