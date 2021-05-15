terraform {
	required_version = "~> 0.15.0"

	required_providers {
		archive = {
			source = "hashicorp/archive"
			version = "~> 2.0"
		}
		aws = {
			source  = "hashicorp/aws"
			version = "~> 3.0"
		}
	}
}

// 1) Provide your access and secret keys to AWS
provider "aws" {
	access_key = "TODO-my-access-key"
	secret_key = "TODO-my-secret-key"
	region="us-east-1"
}

// 2) Setup function name and Zip file that will be uploaded to AWS
locals {
	function_name = "hello-world-lambda"
	zip_file = "${path.module}/hello-world-lambda.zip"
}

// 3) Create a .zip file on your local computer which includes
//    only our index.js file
data "archive_file" "zip" {
	excludes = [
		"main.tf",
		local.zip_file,
	]
	output_path = local.zip_file
	source_dir = path.module
	type = "zip"
}
