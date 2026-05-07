output "register_user_lambda_invoke_arn" {
    value = aws_lambda_function.register_user_lambda.invoke_arn
}

output "get_users_lambda_invoke_arn" {
    value = aws_lambda_function.get_users_lambda.invoke_arn
}

output "register_user_lambda_func_name" {
  value = aws_lambda_function.register_user_lambda.function_name
}

output "get_users_lambda_func_name" {
  value = aws_lambda_function.get_users_lambda.function_name
}