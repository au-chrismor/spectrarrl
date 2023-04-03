resource "aws_security_group" "ServerAdminGroup" {
    name = "ServerAdminGroup"
    description = "Server Admin Access"
    vpc_id = var.vpc_id

    ingress {
        description = "SSH Inbound"
        from_port = var.admin_ip_port
        to_port = var.admin_ip_port
        protocol = var.admin_ip_protocol
        cidr_blocks = [var.admin_ip_address]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "DatabaseGroup" {
    name = "DatabaseGroup"
    description = "Database Access"
    vpc_id = var.vpc_id

    ingress {
        description = "Database Inbound"
        from_port = var.database_ip_port
        to_port = var.database_ip_port
        protocol = var.database_ip_protocol
        cidr_blocks = [var.vpc_cidr]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.vpc_cidr]
    }
}

resource "aws_security_group" "WebAccessGroup" {
    name = "WebAccessGroup"
    description = "Web Access"
    vpc_id = var.vpc_id

    ingress {
        description = "HTTP Inbound"
        from_port = var.http_ip_port
        to_port = var.http_ip_port
        protocol = var.http_ip_protocol
        cidr_blocks = [var.access_cidr]
    }

    ingress {
        description = "HTTPS Inbound"
        from_port = var.https_ip_port
        to_port = var.https_ip_port
        protocol = var.https_ip_protocol
        cidr_blocks = [var.access_cidr]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


