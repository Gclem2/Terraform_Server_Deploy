variable "server_port" {
description = "The port of the server we will use for HTTP request"
type = number
default = 8080
}
output "public_ip" {
  value = aws_instance.example.public_ip
  description = "The public IP address of the web server"
  
}
provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "example" {
  ami = "ami-0ec10929233384c7f"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data = <<-EOF
              #!/bin/bash
              yum install -y busybox
              mkdir /var/www
              echo "Hello World" > /var/www/index.html
              nohup busybox httpd -f -p $(var.server_port) -h /var/www &
              EOF
  user_data_replace_on_change = true

  tags = {
    Name = "terraform-example"
  }
}
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}

