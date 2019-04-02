variable "project_name" {
    type = "string"
    description = "Required - Name to tag all the objects with"
}

variable "my_owner_id" {
    type = "string"
    description = "Required - Provide your AWS owner ID"
}

variable "aws_region" {
    type = "string"
    description = "Required - Select the AWS region you want to deploy into"
}

variable "aws_profile" {
    type = "string"
    description = "Required - Provide name of AWS profile for terraform"
}

variable "ha_cluster" {
    type = "string"
    default = false
    description = "Optional - If false cluster has 1 master if HA 3 are created"
}

variable "number_of_worker_nodes"  {
    type = "string"
    default = "2"
}

variable "bastion_size" { default = "t2.micro" }
variable "master_size"  { default = "t2.medium" }
variable "worker_size"  { default = "t2.small" }

variable "public_dns" {
    type = "string"
    description = "Optional - If you have pre-created a public register zone and domain name"
}

variable "keypair" {
    type = "string"
    default = "k8s-key"
    description = "Name the SSH keypair to create the boxes with, must exist already in AWS"
}
