# terraform {
#   backend "s3" {
#     # Replace this with your bucket name!
#     bucket         = "my-state-bucket-ol2"
#     key            = "global/s3/terraform.tfstate"
#     region         = "us-east-1"

#     # Replace this with your DynamoDB table name!
#     dynamodb_table = "my-state-lock-ddb-ol"
#     encrypt        = true
#   }
# }