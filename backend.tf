terraform {
    backend "s3" {
    encrypt = true
    bucket = "zakaria-harness"
    dynamodb_table = "zakaria-jenkins-dynamo"
    region = "us-west-2"
    key = "global/terraform.tfstate"
    }
}