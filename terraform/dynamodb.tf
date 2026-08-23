resource "aws_dynamodb_table" "test_table" {
  name              = "test-table"
  billing_mode      = "PAY_PER_REQUEST"
  stream_enabled    = true
  stream_view_type  = "NEW_AND_OLD_IMAGES"
  hash_key          = "Id"
  range_key         = "Name"

  attribute {
    name = "Id"
    type = "S"
  }

  attribute {
    name = "Name"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }
}