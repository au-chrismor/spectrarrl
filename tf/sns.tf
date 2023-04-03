resource "aws_sns_topic" "Topic" {
    name = var.notification_topic_name
    display_name = var.notification_topic_display_name
}

resource "aws_sns_topic_subscription" "Subscription" {
    topic_arn = aws_sns_topic.Topic.arn
    protocol = "email"
    endpoint = var.notification_email_address
}
