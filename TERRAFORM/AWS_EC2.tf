# Configure the AWS Provider
provider "aws" {
  version    = "~> 3.0"
  region     = "us-east-1"
  access_key = "aaaaaaaaaaaaaaa"
  secret_key = "AAAAAAAAAAAAAAAAAAA"
}

# 1. Creates a vpc
resource "aws_vpc" "terraform-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "terraform-vpc"
  }
}

# 2. Creates Internet Gateway
resource "aws_internet_gateway" "terraform-gateway" {
  vpc_id = aws_vpc.terraform-vpc.id

  tags = {
    Name = "terraform-gateway"
  }
}

# 3. Creates Custom Route Table
resource "aws_route_table" "terraform-route-table" {
  vpc_id = aws_vpc.terraform-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform-gateway.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.terraform-gateway.id
  }

  tags = {
    Name = "terraform-route-table"
  }
}

# 4. Create a Subnet
resource "aws_subnet" "terraform-subnet-1" {
  vpc_id            = aws_vpc.terraform-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "terraform-subnet"
  }
}

# 5. Associates subnet with Route Table
resource "aws_route_table_association" "terraform-routetable-subnet-association" {
  subnet_id      = aws_subnet.terraform-subnet-1.id
  route_table_id = aws_route_table.terraform-route-table.id
}

# 6. Creates Security Group to allow port 22,80,443
resource "aws_security_group" "terraform-allow-web" {
  name        = "allow_web_traffic"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.terraform-vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

# 7. Creates a network interface with an ip in the subnet that was created in step 4
resource "aws_network_interface" "terraform-webserver-nic" {
  subnet_id       = aws_subnet.terraform-subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.terraform-allow-web.id]

}

# 8. Assigns an elastic IP to the network interface created in step 7
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.terraform-webserver-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.terraform-gateway]
}

output "server_public_ip" {
  value = aws_eip.one.public_ip
}

# 9. Creates Ubuntu server and install/enable apache2
resource "aws_instance" "terraform-web-server-instance" {
  ami               = "ami-0bcc094591f354be2"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "mainkeyppk"

  network_interface {
    network_interface_id = aws_network_interface.terraform-webserver-nic.id
    device_index         = 0
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo your very first web server > /var/www/html/index.html'
                EOF

  tags = {
    Name = "terraform-web-server"
  }
}

output "server_private_ip" {
  value = aws_instance.terraform-web-server-instance.private_ip
}

output "server_id" {
  value = aws_instance.terraform-web-server-instance.id
}
