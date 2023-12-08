resource "aws_instance" "jenkins" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  iam_instance_profile   = var.iam_instance_profile

  tags = {
    Name = "JenkinsInstance"
  }
}
