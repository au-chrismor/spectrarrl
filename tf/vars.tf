variable "aws_account" {
    type = string
    default = "123456789abc"
}

variable "aws_region" {
    type = string
    default = "us-east-1"
}

variable environment {
    type = string
    default = "prod"
}

variable "access_cidr" {
    type = string
    default = "0.0.0.0/0"
}

variable "admin_ip_address" {
    type = string
    default = "123.123.123.123/32"
}

variable "admin_ip_port" {
    type = number
    default = 22
}

variable "admin_ip_protocol" {
    type = string
    default = "tcp"
}

variable "database_ip_port" {
    type = number
    default = 3306
}

variable "database_ip_protocol" {
    type = string
    default = "tcp"
}

variable "http_ip_port" {
    type = number
    default = 80
}

variable "http_ip_protocol" {
    type = string
    default = "tcp"
}

variable "https_ip_port" {
    type = number
    default = 443
}

variable "https_ip_protocol" {
    type = string
    default = "tcp"
}

variable "database_class" {
    type= string
    default = "db.t3.micro"
}

variable "database_name" {
    type = string
    default = "spectra"
}

variable "database_password" {
    type = string
    default = "V3ryB1g5ecret"
}

variable "database_size" {
    type = number
    default = 32
}

variable "database_user" {
    type = string
    default = "spectrauser"
}


variable "zone_name" {
    type = string
    default = "spectra.internal"
}

variable "server_ami" {
    type = string
    default = "ami-010203040506"
}

variable "server_type" {
    type = string
    default = "t3a.micro"
}

variable vpc_id {
    type = string
    default = "vpc-01020304"
}

variable vpc_cidr {
    type = string
    default = "172.16.0.0/16"
}

variable "notification_email_address" {
    type = string
    default = "your.email@host.oi"
}

variable "notification_topic_name" {
    type = string
    default = "ScalingTopic"
}

variable "notification_topic_display_name" {
    type = string
    default = "Autoscaling Notifications"
}

variable "db_subnet_a" {
    type = string
    default = "subnet-010203"
}

variable "db_subnet_b" {
    type = string
    default = "subnet-010203"
}

variable "db_subnet_c" {
    type = string
    default = "subnet-010203"
}

variable "pub_subnet_a" {
    type = string
    default = "subnet-010203"
}

variable "pub_subnet_b" {
    type = string
    default = "subnet-010203"
}

variable "pub_subnet_c" {
    type = string
    default = "subnet-010203"
}

variable "health_check_interval" {
    type = number
    default = 30
}

variable "health_check_path" {
    type = string
    default = "/ping"
}

variable "health_check_timeout" {
    type = number
    default = 10
}

variable "health_check_threshold" {
    type = number
    default = 4
}

variable "db_is_multi_az" {
    type = bool
    default = false
}

variable "db_max_size" {
    type = number
    default = 100
}

variable "db_skip_snapshot" {
    type = bool
    default = true
}
