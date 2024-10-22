# AWS VPC Module

This Terraform module creates an AWS VPC with 9 subnets divided into three tiers:

- **DMZ Layer**: 3 public subnets
- **Logic Layer**: 3 private subnets with NAT Gateways
- **Data Layer**: 3 private subnets with NAT Gateways

## Features

- Creates a VPC with customizable CIDR block.
- Distributes subnets across provided availability zones.
- Sets up Internet Gateway and NAT Gateways for internet access.
- Configures route tables for public and private subnets.
- Tags resources for easy identification.

## Usage

```hcl
module "vpc" {
  source = "github.com/your-organization/aws-vpc-module"

  name               = "my-vpc"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```


## Inputs

| Name                | Description                                      | Type          | Default                      | Required |
|---------------------|--------------------------------------------------|---------------|------------------------------|----------|
| `name`              | Name prefix for all resources                    | `string`      | n/a                          | yes      |
| `vpc_cidr`          | CIDR block for the VPC                           | `string`      | `"10.0.0.0/16"`              | no       |
| `availability_zones`| List of availability zones to use                | `list(string)`| `["us-east-1a", "us-east-1b", "us-east-1c"]` | no |
| `tags`              | A map of tags to add to resources                | `map(string)` | `{}`                         | no       |
| `region`            | AWS region                                       | `string`      | `"us-east-1"`                | no       |

## Outputs

| Name                | Description                                      |
|---------------------|--------------------------------------------------|
| `vpc_id`            | The ID of the VPC                                |
| `dmz_subnet_ids`    | List of IDs of DMZ subnets                       |
| `logic_subnet_ids`  | List of IDs of Logic subnets                     |
| `data_subnet_ids`   | List of IDs of Data subnets                      |
| `nat_gateway_ids`   | List of NAT Gateway IDs                          |

## Notes

Ensure that your AWS credentials are configured.
Adjust the availability_zones variable according to your region.
lua

---

#### **g. examples/basic-usage/main.tf**

Provide an example of how to use the module:

```hcl
module "vpc" {
  source = "../../"

  name               = "example-vpc"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  tags = {
    Environment = "development"
    Owner       = "user@example.com"
  }
}