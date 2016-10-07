Sample project
========================

This project installs postgres and loads a sample database on an AWS instance provisioned with terraform.

## Requirements ##
* terraform >= v0.7.4
* ansible >= 2.1.2.0
* boto library
* ssh keypair

## How to use ##

#### Create AWS instance with terraform ####
Set AWS credentials with:

```
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
```

You may optionally redefine following variables:
- `key_name`: Desired name of AWS key pair (default: "sample_key")
- `region`: AWS region (default: "us-west-2", alternative: "us-west-1". AMI and availability zones for other regions are not mapped)
- `vpc_name`: Desired name for the VPC (default: "sample_vpc")
- `control_cidr`: CIDR block which has full access to provisioned AWS resources (default = "193.109.118.0/24")
- `vpc_cidr`: VPC CIDR block (default = "10.77.0.0/16")
- `instance_type`: AWS instance type (default: "t2.micro")

The easiest way is creating a `terraform.tfvars` [variable file](https://www.terraform.io/docs/configuration/variables.html#variable-files) in `./terraform` directory. Terraform automatically imports it.

Run:
```
$cd terraform
$terraform apply
```

Terraform creates an AWS instance with Ubuntu 16.04 and outputs it's EIP.

#### Provision AWS instance with ansible ####
**ATTENTION!!!**
Ansible utilizes dynamic inventory script. Instances are added to an inventory by "sample" tag. If your AWS infrastructure has other instances with this tag, it might be unsafe to run playbook. Before running ansible playbook you can verify that only those instances are added which were provisioned on a previous step.
```
$cd ansible/hosts
$./ec2.py --list
```

Create `secrets.yml` file in `./ansible` folder and define `db_pass` within it.
You can optionally redefine:
- `proj_name` (default: "sample_proj")
- `database_name` (default: {{ proj_name }})
- `database_user` (default: {{ proj_name }})

Run playbook:
```
$cd ansible
$ansible-playbook postgres-single-host.yml
```
