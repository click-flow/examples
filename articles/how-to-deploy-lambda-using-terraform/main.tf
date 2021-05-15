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

// 2) Setup Lambda parameters and Zip file that will be uploaded to AWS
locals {
	// Function parameters
	function_name = "hello-world-lambda"
	handler = "index.handler"
	runtime = "nodejs14.x"
	timeout = 6

	// Zip file that will be uploaded to AWS
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

// 4) Create an AWS IAM role which will manage your Lambda in
//    production.
data "aws_iam_policy_document" "default" {
	version = "2012-10-17"

	statement {
		actions = ["sts:AssumeRole"]
		effect = "Allow"

		principals {
			identifiers = ["lambda.amazonaws.com"]
			type = "Service"
		}
	}
}
resource "aws_iam_role" "default" {
	assume_role_policy = data.aws_iam_policy_document.default.json
}
resource "aws_iam_role_policy_attachment" "default" {
	policy_arn  = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
	role = aws_iam_role.default.name
}

// 5) Provision your Lambda resource inside AWS
resource "aws_lambda_function" "default" {
	// Function parameters
	function_name = local.function_name
	handler = local.handler
	runtime = local.runtime
	timeout = local.timeout

	// Upload .zip file to AWS
	filename = local.zip_file
	source_code_hash = data.archive_file.zip.output_base64sha256

	// Code and AWS IAM to mange
	role = aws_iam_role.default.arn

	// Optional environmental variables
	environment {
		variables = {
			NODE_ENV: "production"
		}
	}
}
