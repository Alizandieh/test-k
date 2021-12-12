# getting the aws account ID
data "aws_caller_identity" "current" {}

# create the assume role which is usable by all users within the account
resource "aws_iam_role" "iam_role" {

  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Sid       = ""
        Principal = { "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }
      },
    ]
  })
  tags = var.tags

}

# creating a group
resource "aws_iam_group" "group" {
  name = var.group_name
}

# creating a policy for the group and the users inside it
resource "aws_iam_policy" "policy" {

  name = var.policy_name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.role_name}"
    }
  ]
}
EOF

  tags = var.tags
}

# Attach the policy to the group
resource "aws_iam_group_policy_attachment" "test-attach" {
  group      = aws_iam_group.group.name
  policy_arn = aws_iam_policy.policy.arn
}

# Creating a new user
resource "aws_iam_user" "user" {
  name = var.user_name
}

# Add the user to the group
resource "aws_iam_group_membership" "team" {
  name = "test-group-membership"

  users = [
    aws_iam_user.user.name,
  ]

  group = aws_iam_group.group.name
}
