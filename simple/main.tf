resource "aws_instance" "test" {
  # awsのクイックスタートAMI
  ami           = "ami-072bfb8ae2c884cc4"
  instance_type = "t3.micro"
  user_data = <<EOF
    #!/bin/bash
    apt-get install nginx
    systemctl start nginx.service
EOF
}
