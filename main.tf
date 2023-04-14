provider "aws" {
  region = "eu-west-2"
}

data "template_file" "hostnames" {
  template = "${file("${path.module}/install_splunk.sh")}"
  vars = {
    name = "${var.instance_names[count.index]}"
  }
  count = length(var.instance_names)
 
}


resource "aws_instance" "splunk" {

  ami           = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [ "sg-0cf67084f5e30ed28" ]
  availability_zone = var.availability_zone
  # for_each = toset(var.instance_names)
  key_name = "packer_key_pair"
  user_data = data.template_file.hostnames[count.index].rendered
  count = length(var.instance_names)

  ebs_block_device {
 
    volume_size = 10
    volume_type = "gp3"
    device_name = "sdf"
  }
  
  tags = {
    Name = var.instance_names[count.index]
  }

}