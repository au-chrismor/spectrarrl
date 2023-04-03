resource "aws_db_subnet_group" "DBSubnetGroup" {
    name = "Main Subnet Group"
    description = "Main Subnet Group"
    subnet_ids = [var.db_subnet_a, var.db_subnet_b, var.db_subnet_c]
}

resource "aws_db_instance" "Database" {
    engine = "mysql"
    db_name = var.database_name
    instance_class = var.database_class
    username = var.database_user
    password = var.database_password
    skip_final_snapshot = var.db_skip_snapshot
    allocated_storage = var.database_size
    max_allocated_storage = var.db_max_size
    db_subnet_group_name = aws_db_subnet_group.DBSubnetGroup.name
    multi_az = var.db_is_multi_az
    port = var.database_ip_port
    vpc_security_group_ids = [aws_security_group.DatabaseGroup.id]
}

resource "aws_route53_record" "DatabaseDns" {
    zone_id = aws_route53_zone.PrivateZone.id
    name = "db.${environment}.${zone_name}"
    type = "CNAME"
    ttl = 300
    records = [aws_db_instance.Database.address]
}
