resource "aws_dynamodb_table" "users_table" {
  name= "UsersTable"
  billing_mode = "PAY_PER_REQUEST"
#   hash_key = "email" # partition key   
    hash_key = var.partition_key

  attribute {
    # name = "email"
    name = var.partition_key
    type = "S" # string
  }
    tags = {
      Name = "UsersTable"
    }

}