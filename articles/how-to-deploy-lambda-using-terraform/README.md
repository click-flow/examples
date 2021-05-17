# Overview

1. Install Docker and Docker Compose
1. Run `docker-compose run app sh`
1. In `main.tf`, update the `aws` provider with your credentials
1. Run `terraform init` to download the required terraform modules
1. Run `terraform plan` to valide your local setup
1. Run `terraform apply -auto-approve` to deploy the lambdas to AWS
1. Run `terraform destroy -auto-approve` to teardown the lambdas in AWS
