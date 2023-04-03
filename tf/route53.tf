resource "aws_route53_zone" "PrivateZone" {
    name = var.zone_name
    vpc {
        vpc_id = var.vpc_id
    }
}
