data "archive_file" "get_users_lambda" {
    type        = "zip"
    source_file = "${path.module}/back-end/get_users.py" # path to file , path.module is the path to this module
    output_path = "${path.module}/back-end/get_users.zip" # wehre to save it
}


resource "aws_lambda_function" "get_users_lambda" {
  function_name = "get_users_lambda"
  filename      = "${path.module}/back-end/get_users.zip" # choose the zip file
#   role          = aws_iam_role.DynamoDB_write_role.arn # take this arn from iam module throw main.tf
  role          = var.DynamoDB_read_role_arn # take this arn from iam module throw main.tf
  handler       = "get_users.lambda_handler" # inside zip file -> find -> register_user_lambda -> lambda_handler (main function (entry point))
  runtime       = "python3.14"
  timeout = 10
  memory_size = 128


  environment {
    variables = {
        TABLE_NAME = var.DynamoDB_table_name # get table name from dyanom module throw main.tf
    }
  }

  tags = {
    Name = "register-user"
  }

}
