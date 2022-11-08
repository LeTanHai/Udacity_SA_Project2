provider "aws" {
  access_key = var.access_key_var
  secret_key = var.secret_key_var
  region = var.region_var
}

// zip source for lambda
data "archive_file" "lambda_source" {
  type = "zip"
  source_file = "greet_lambda.py"
  output_path = var.lambda_source_output_path
}

// create iam role for lambda execution
resource "aws_iam_role" "lambda_execute_role" {
  name = "lambda_execute_role"
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
  }
  EOF
}

// create iam policy for lambda output log into cloudwatch
resource "aws_iam_policy" "lambda_logging_policy" {
    name = "lambda_logging_policy"
    path = "/"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

// attch policy for lambda iam role
resource "aws_iam_role_policy_attachment" "lambda_attch_policy" {
    role = aws_iam_role.lambda_execute_role.name
    policy_arn = aws_iam_policy.lambda_logging_policy.arn
}

// create cloudwatch log group
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 14
}

// create aws lambda function
resource "aws_lambda_function" "greet_lambda" {
  function_name = var.lambda_name
  filename = data.archive_file.lambda_source.output_path
  source_code_hash = data.archive_file.lambda_source.output_base64sha256
  handler = "greet_lambda.lambda_handler"
  runtime = "python3.8"
  role = aws_iam_role.lambda_execute_role.arn

  depends_on = [
    aws_iam_role_policy_attachment.lambda_attch_policy
  ]

  environment {
    variables = {
        greeting = "Hi, the world !!"
    }
  }
}