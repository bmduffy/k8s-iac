
variable "my_owner_id" { default = "456813123929" }

variable "bastion_count" { default = 1 }
variable "master_count"  { default = 1 }
variable "worker_count"  { default = 2 }

variable "bastion_size" { default = "t2.micro" }
variable "master_size"  { default = "t2.medium" }
variable "worker_size"  { default = "t2.small" }

variable "vpc_cidr"   { default = "10.0.0.0/16" }
variable "public_dns" { default = "bmduffy.net" }

variable "kubernetes_subnet" {
    type = "map"
    default = {
        name    = "kubernetes"
        cidr    = "10.0.0.0/24"
        reverse = "0.0.10.in-addr.arpa"
        dns     = "iac.bootcamp"
    }
}

variable "worker_tags" {
    type = "map"
    default = {
        Project = "iac-bootcamp"
        Environment = "Test"
        InfraComponent = "Node"
        NodeType = "Worker"
    }
}

variable "master_tags" {
    type = "map"
    default = {
        Project = "iac-bootcamp"
        Environment = "Test"
        InfraComponent = "Node"
        NodeType = "Master"
    }
}

variable "bastion_tags" {
    type = "map"
    default = {
        Project = "iac-bootcamp"
        Environment = "Test"
        InfraComponent = "JumpBox"
        NodeType = "Bastion"
    }
}

variable "ssh_keypair" {
    type = "string"
    default = "k8s-key"
    description = "Name the SSH keypair to create the boxes with, must exist already in AWS"
}
