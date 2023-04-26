#SG
data "http" "myip" {
  url = "http://checkip.amazonaws.com/"
}

locals {
  myip = "${chomp(data.http.myip.body)}/32"
}

resource "aws_security_group" "bastion_sg" {
  name_prefix = "bastion_sg_"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.myip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "bastion_sg"
  }
}



