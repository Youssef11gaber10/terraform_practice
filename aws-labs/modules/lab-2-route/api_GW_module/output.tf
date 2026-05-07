output "api_gw_endpoint" {
  value = aws_apigatewayv2_stage.http_api_stage.invoke_url
}


output "register_endpoint" {
  value = "${aws_apigatewayv2_stage.http_api_stage.invoke_url}/register"
}


output "get_users_endpoint" {
  value = "${aws_apigatewayv2_stage.http_api_stage.invoke_url}/users"
}
