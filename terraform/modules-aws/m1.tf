variable "itype" {
  type = string
  default = "null"
}

variable "image" {
  type = string
  default = "null"
}

variable "webfile" {
  type = string
  default = "null"
}

variable "name" {
  type = string
  default = "null"
}
variable "index" {
    type = string
  default = "null"

}

resource "aws_key_pair" "wipro-key11" {
  key_name   = "wipro-trainer-july11107"
  public_key = file("~/.ssh/id_rsa.pub")
}


resource "aws_instance" "samosa" {
  ami = var.image
  key_name = aws_key_pair.wipro-key11.key_name
  instance_type =var.itype
  tags = {
    "Name" =var.name
  }
  provisioner "file" {
    source      = var.webfile
    destination = "/home/ec2-user/web.sh"
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(pathexpand("~/.ssh/id_rsa"))
    timeout     = "3m"
  }
   provisioner "file" {
    source      = var.index
    destination = "/home/ec2-user/index.html"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod a+x /home/ec2-user/web.sh",
      "sudo bash /home/ec2-user/web.sh",
      "sudo cp /home/ec2-user/index.html /var/www/html/index.html"
    ]
  }

}

