resource "aws_iam_role" "InstanceRole" {
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid = ""
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            },
        ]
    })
    managed_policy_arns = [
        "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
    ]
    path = "/"
}

resource "aws_iam_instance_profile" "InstanceProfile" {
    path = "/"
    role = aws_iam_role.InstanceRole.name
}
