resource "aws_instance" "vm1" {
  ami           = var.amiid
  instance_type = var.itype
  tags          = var.tgname
}


output "vm1_public_ip" {
  value = aws_instance.vm1.public_ip
}