data "archive_file" "register_user_lambda" {
    type        = "zip"
    source_file = "${path.module}/back-end/register_user.py" # path to file , path.module is the path to this module
    output_path = "${path.module}/back-end/register_user.zip" # wehre to save it
}

resource "aws_lambda_function" "register_user_lambda" {
  function_name = "register_user_lambda"
  filename      = "${path.module}/back-end/register_user.zip" # choose the zip file
#   role          = aws_iam_role.DynamoDB_write_role.arn # take this arn from iam module throw main.tf
  role          = var.DynamoDB_write_role_arn # take this arn from iam module throw main.tf
  handler       = "register_user.lambda_handler" # inside zip file -> find -> register_user_lambda -> lambda_handler (main function (entry point))
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


