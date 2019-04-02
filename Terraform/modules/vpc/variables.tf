variable "tags" {
    type = "map"
    description = "Default tags to tag network components with"
}

variable "prefix" {
    type = "string"
    description = "Prefix all network component names"
}

variable "quantity" {
    type = "string"
    description = "TODO - this will be the number of subnets to deploy"
}

variable "public_dns" {
    type = "string"
    default = ""
    description = "Optional - Get the pre-create public dns zone ID"
}

variable "vpc_cidr" { default = "10.0.0.0/16" }

variable "subnet" {
    type = "map"
    default = {
        name    = "kubernetes"
        cidr    = "10.0.0.0/24"
        reverse = "0.0.10.in-addr.arpa"
        dns     = "iac.bootcamp"
    }
}
