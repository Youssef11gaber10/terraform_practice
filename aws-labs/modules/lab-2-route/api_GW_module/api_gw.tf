resource "aws_apigatewayv2_api" "http_api" {
  
  name = "users-http-api"
  protocol_type = "HTTP" #type of api 
  description = "http api for register-user and get-user lambda functions"

#after create s3 website bucket , put origin of the bucket here
  cors_configuration {
    allow_origins = [var.frontend_s3_origin] # put frontend s3 origin link like http://my-bucket.s3-website.us-east-1.amazonaws.com
    allow_methods = [ "GET", "POST" ]
    # allow_headers = ["*"]
    allow_headers = [ "Content-Type", "Authorization" ]
    max_age = 300
  }

tags = {
    Name = "users-http-api"
  }

}

# make auto deploy on every change in lambda function
resource "aws_apigatewayv2_stage" "http_api_stage" {
  api_id = aws_apigatewayv2_api.http_api.id
  name = "$default"
  auto_deploy = true

#   access_log_settings {
#     format = jsonencode({ "requestId": "$context.requestId", "ip": "$context.identity.sourceIp", "user": "$context.identity.user" })
#     destination_arn = aws_cloudwatch_log_group.api_gw_logs.arn
#   }

}

# resource "aws_cloudwatch_log_group" "api_gw_logs" {
#   name = "/aws/api_gw/${aws_apigatewayv2_api.http_api.name}"
#   retention_in_days = 7
  
# }


# make integration between api gateway and lambda function

# integrate /register-user api to register-user lambda


resource "aws_apigatewayv2_integration" "register_user_lambda_integration" {
  api_id = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_method = "POST" # internal communication between api gateway and lambda
#   integration_uri = aws_lambda_function.register_user_lambda.invoke_arn # get invoke_arn from lambda module throw main.tf
  integration_uri = var.register_user_lambda_invoke_arn # get invoke_arn from lambda module throw main.tf
  payload_format_version = "2.0"
}

#make route /register
resource "aws_apigatewayv2_route" "register_route" {
  api_id = aws_apigatewayv2_api.http_api.id
  route_key = "POST /register"
  target = "integrations/${aws_apigatewayv2_integration.register_user_lambda_integration.id}"
  
}
# allow api gateway to invoke register-user lambda
resource "aws_lambda_permission" "apigw_invoke_register_user" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = var.register_user_lambda_func_name # get lambda name from lambda module throw main.tf
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

# -------------

# integrate /get-users api to get-users lambda
resource "aws_apigatewayv2_integration" "get_users_lambda_integration" {
  api_id = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_method = "POST" # internal communication between api gateway and lambda
#   integration_uri = aws_lambda_function.get_users_lambda.invoke_arn # get invoke_arn from lambda module throw main.tf
  integration_uri = var.get_users_lambda_invoke_arn # get invoke_arn from lambda module throw main.tf
  payload_format_version = "2.0"
}

#make route /users
resource "aws_apigatewayv2_route" "get_users_route" {
  api_id = aws_apigatewayv2_api.http_api.id
  route_key = "GET /users"
  target = "integrations/${aws_apigatewayv2_integration.get_users_lambda_integration.id}"
  
}

# allow api gateway to invoke get-users lambda
resource "aws_lambda_permission" "apigw_invoke_get_users" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = var.get_users_lambda_func_name # get lambda name from lambda module throw main.tf
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}