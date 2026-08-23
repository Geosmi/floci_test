resource "aws_dynamodb_table" "test_table" {
  name                        = "test-table"
  billing_mode                = "PAY_PER_REQUEST"
  stream_enabled              = true
  stream_view_type            = "NEW_AND_OLD_IMAGES"
  hash_key                    = "Id"
  range_key                   = "Name"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  skip_region_validation      = true
  force_path_style            = true

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