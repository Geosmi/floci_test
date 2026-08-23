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
    },
    {
      Action    = "dynamodb:BatchWriteItem"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Resource  = "arn:aws:dynamodb:::*/test_table"
    },
    {
      Action    = "dynamodb:PutItem"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Resource  = "arn:aws:dynamodb:::*/test_table"
    },
    {
      Action    = "s3:GetObject"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Resource  = "arn:aws:s3:::*/test_bucket"
    }]
  })
}

resource "aws_lambda_function" "test_lambda" {
  filename         = "../src/lambda/test_lambda/handler.zip"
  function_name    = "test-lambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "handler.lambda_handler"
  runtime          = "python3.11"
  source_code_hash = data.archive_file.test_zip.output_base64sha256
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.test_bucket.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.test_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.test_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".txt"
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}