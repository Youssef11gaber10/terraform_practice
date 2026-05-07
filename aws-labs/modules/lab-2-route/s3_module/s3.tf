resource "aws_s3_bucket" "frontend_s3" {
    bucket = var.bucket_name #unique name
  tags = {
    Name = "frontend-website-s3"
  }
}

#diable -> block public access
resource "aws_s3_bucket_public_access_block" "frontend" {
    bucket = aws_s3_bucket.frontend_s3.id
    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
}

#bucket policy
resource "aws_s3_bucket_policy" "frontend_s3_policy" {
    bucket = aws_s3_bucket.frontend_s3.id
    #must wait for disabling block public access
    depends_on = [ aws_s3_bucket_public_access_block.frontend ]
    # policy = data.aws_iam_policy_document.frontend_s3_policy.json
    policy = jsonencode({
        "Version": "2012-10-17",
        "Id": "PublicReadGetObject",
        "Statement": [
            {
                "Sid": "PublicReadGetObject",
                "Effect": "Allow",
                "Principal": "*",
                "Action": [
                    "s3:GetObject"
                ],
                "Resource": [
                    "arn:aws:s3:::${aws_s3_bucket.frontend_s3.id}/*"
                ]
            }
        ]
    })


}


#create website
resource "aws_s3_bucket_website_configuration" "frontend" {
    bucket = aws_s3_bucket.frontend_s3.id
    index_document {
        suffix = "index.html"
    }
    error_document {
        key = "error.html"
    }
}


#---- upload index.html to s3 bucket
resource "aws_s3_object" "index_html" {
    bucket = aws_s3_bucket.frontend_s3.id
    key = "index.html"
    source = "${path.module}/front-end/index.html"
    content_type = "text/html"
}

#---- upload  script.js to s3 bucket
resource "aws_s3_object" "script_js" {
    bucket = aws_s3_bucket.frontend_s3.id
    key = "script.js"
    source = "${path.module}/front-end/script.js"
    content_type = "application/javascript"
}