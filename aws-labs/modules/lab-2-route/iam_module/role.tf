# create 2 policy one for get and another for put in table dynamo DB 
# make role for each policy to be assumed by lambda function

#create 2 policies one for read from dynamoDB and another for write to dynamoDB
# policy for read from dynamoDB
#(getitem, scan, query) 

resource "aws_iam_policy" "DynamoDB_read_policy" {
  name        = "DynamoDBReadPolicy"
  description = "allows getitem, scan, query on UsersTable"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "DynamoDBReadAccess", # this is just an identifier for this statement is optional
          "Action" : [
            "dynamodb:GetItem",
            "dynamodb:Scan",
            "dynamodb:Query"
          ],
          "Effect" : "Allow",
        #   "Resource" : "${aws_dynamodb_table.users_table.arn}" # take it as varaible - passed from main.tf from dynamoDB module
          "Resource" : var.users_table_arn # take it as varaible - passed from main.tf from dynamoDB module
        }
      ]
    }
                        )

}

# policy for write in dynamoDB
#(putitem, updateitem, deleteitem)

resource "aws_iam_policy" "DynamoDB_write_policy" {
  name        = "DynamoDBWritePolicy"
  description = "allows putitem, updateitem, deleteitem on UsersTable"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "DynamoDBWriteAccess", # this is just an identifier for this statement is optional
          "Action" : [
            "dynamodb:PutItem",
            "dynamodb:UpdateItem",
            "dynamodb:DeleteItem"
          ],
          "Effect" : "Allow",
        #   "Resource" : "${aws_dynamodb_table.users_table.arn}" # take it as varaible - passed from main.tf from dynamoDB module
          "Resource" : var.users_table_arn # take it as varaible - passed from main.tf from dynamoDB module
        }
      ]
    }
                        )
    
}





# allow lambda assume 2 roles i will create , because i need to refer to this allowance of assumation
data "aws_iam_policy_document" "lambda_assume_roles" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}


#create 2 roles assumed by lambda function 
    # one for read from dynamoDB use DynamoDB_read_policy
    # another for write to dynamoDB use DynamoDB_write_policy

#role for read
resource "aws_iam_role" "DynamoDB_read_role" {
  name = "DynamoDBReadRole"
  #who can assume this role
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_roles.json #the allowance of assumation i give to lambda function above
  tags = {
    Purpose = "GetUsers Lambda Read access to DynamoDB"
  }
}
# attach read_policy to read_role
resource "aws_iam_role_policy_attachment" "attach_read_policy" {
  role       = aws_iam_role.DynamoDB_read_role.name # name of role
  policy_arn = aws_iam_policy.DynamoDB_read_policy.arn # name of policy
}

#attach policy of cloudwatch to read_role
resource "aws_iam_role_policy_attachment" "attach_cloudwatch_policy_read_role" {
  role       = aws_iam_role.DynamoDB_read_role.name # name of role
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


# -------------------

#role for write
resource "aws_iam_role" "DynamoDB_write_role" {
  name = "DynamoDBWriteRole"
  #who can assume this role
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_roles.json #the allowance of assumation i give to lambda function above
  tags = {
    Purpose = "PutUsers Lambda Write access to DynamoDB"
  }

}

# attach write_policy to write_role
resource "aws_iam_role_policy_attachment" "attach_write_policy" {
  role       = aws_iam_role.DynamoDB_write_role.name # name of role
  policy_arn = aws_iam_policy.DynamoDB_write_policy.arn # name of policy
}

#attach policy of cloudwatch to write_role
resource "aws_iam_role_policy_attachment" "attach_cloudwatch_policy_write_role" {
  role       = aws_iam_role.DynamoDB_write_role.name # name of role
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


# i need to output the read_role_arn & write_role_arn to be used in main.tf from lambda module
