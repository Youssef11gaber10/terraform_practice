# i need to output the read_role_arn & write_role_arn to be used in main.tf from lambda module

output "DynamoDB_read_role_arn" {
    value = aws_iam_role.DynamoDB_read_role.arn
}
output "DynamoDB_write_role_arn" {
    value = aws_iam_role.DynamoDB_write_role.arn
}