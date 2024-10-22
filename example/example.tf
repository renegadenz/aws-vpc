provider "aws" {
  region  = "us-east-1"
  profile = "my-profile"  # Optional: Set the AWS profile if needed
}

module "vpc" {
  # Reference the module source, either local or remote (GitHub)
  # Replace this with the appropriate path to your module
  source = "../aws-vpc-module"  # If local
  # OR
  # source = "git::https://github.com/your-organization/your-vpc-module.git?ref=v1.0.0"  # If GitHub
  
  name                = "test-vpc"
  vpc_cidr            = "10.0.0.0/16"
  availability_zones  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  tags = {
    Environment = "test"
    Project     = "vpc-testing"
  }
}

# Output VPC ID and Flow Logs info
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_flow_logs_log_group" {
  value = module.vpc.vpc_flow_logs_log_group
}
