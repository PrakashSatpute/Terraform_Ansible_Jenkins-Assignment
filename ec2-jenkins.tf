resource "aws_instance" "jenkins" {
  ami           = "ami-0aa2b7722dc1b5612"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "jenkins"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y awscli",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/home/prakash/terraform_key")
    host        = aws_instance.bastion.public_ip

    bastion_host        = aws_instance.bastion.public_ip
    bastion_user        = "ubuntu"
    bastion_private_key = file("/home/prakash/terraform_key")
  }
}

