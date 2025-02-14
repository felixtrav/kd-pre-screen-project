resource "random_id" "id" {
	  byte_length = 8
}

resource "aws_s3_bucket" "flow_logs" {
  # Randomize the bucket name to avoid collisions
  bucket = "kd-flow-logs-${random_id.id.hex}"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "flow_logs" {
  bucket = aws_s3_bucket.flow_logs.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSLogDeliveryWrite"
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.flow_logs.arn}/*"
      }
    ]
  })
}
