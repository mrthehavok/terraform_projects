#------------------------------------------------------------------------------------------------
#
#                                  Module for creating ASG with EC2
#
#   Inputs :
#       - Max, min and desire ASG size
#       - Subnets ID
#
#
#   Outputs :
#       - DNS name for LB
#
#
#  
#------------------------------------------------------------------------------------------------

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

#------------------------------------------------------------------------------------------------

resource "aws_security_group" "web" {
  name = "Dynamic Security Group"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      description       = "${ingress.value} from dynamic terraform"
      from_port         = ingress.value
      to_port           = ingress.value
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Dynamic SecurityGroup"
    Owner = "idmitriev"
  }
}
#------------------------------------------------------------------------------------------------

resource "aws_launch_configuration" "web" {
  //  name            = "WebServer-Highly-Available-LC"
  name_prefix     = "WebServer-Highly-Available-LC-"
  image_id        = data.aws_ami.latest_amazon_linux.id
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.web.id]
  user_data       = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_autoscaling_group" "web" {
  name                 = "ASG-${aws_launch_configuration.web.name}"
  launch_configuration = aws_launch_configuration.web.name
  min_size             = var.min_asg_size
  max_size             = var.max_asg_size
  min_elb_capacity     = var.des_asg_size
  health_check_type    = "ELB"
  vpc_zone_identifier  = [var.subnet_id[0],var.subnet_id[1]]
  load_balancers       = [aws_elb.web.name]

/*
  dynamic "tag" {
    for_each = {
      Name   = "WebServer in ASG"
      Owner  = "idmitriev"
      TAGKEY = "TAGVALUE"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
*/

#tags = var.common_tags

  lifecycle {
    create_before_destroy = true
  }
}

#------------------------------------------------------------------------------------------------

resource "aws_elb" "web" {
  name               = "WebServer-HA-ELB"
#  availability_zones = ["eu-west-1a","eu-west-1b"]
  subnets = ["subnet-0fed20787957988b5"]
  security_groups    = [aws_security_group.web.id]
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }
  tags = merge (var.common_tags , {Name = "WebServer-Highly-Available-ELB"}) 
}

