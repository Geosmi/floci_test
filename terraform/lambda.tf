data "archive_file" "test_zip" {
  type        = "zip"
  source_file = "../src/lambda/test_lambda/handler.py"
  output_path = "../src/lambda/test_lambda/handler.zip"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_lambda_function" "test_lambda" {
  filename         = "handler.zip"
  function_name    = "test-lambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "handler.lambda_handler"
  runtime          = "python3.11"
  source_code_hash = data.archive_file.test_zip.output_base64sha256
}