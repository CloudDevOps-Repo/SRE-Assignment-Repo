
#iam_dice_post_lambda_role
resource "aws_iam_role" "iam_dice_post_lambda_role" {
  name = "iam-dice-post-lambda-role"

  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
 {
   "Effect": "Allow",
   "Principal": {
     "Service": ["lambda.amazonaws.com"]
   },
   "Action": "sts:AssumeRole"
  }
  ]
 }
EOF
}

resource "aws_iam_role_policy" "iam_dice_post_lambda_policy" {
  name = "iam-dice-post-lambda-policy"
  role = aws_iam_role.iam_dice_post_lambda_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:*",
        "cloudwatch:*",
        "s3:*",
        "logs:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}