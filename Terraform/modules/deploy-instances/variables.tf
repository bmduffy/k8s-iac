variable "node_name" {
    description = "Required - unique name for the node"
}

variable "node_count" {
    default = 1
    description = "Optional - Number of instances of this type to deploy"
}

variable "node_image" {
    description = "Required - AMI image id to create the node from"
}

variable "node_type" {
    default = "t2.micro"
    description = "Optional - AWS node t-shirt size"
}

variable "node_subnet" {
    type = "map"
    description = "Required - subnet to put the node in"
}

variable "node_subnet_id" {}
variable "node_security_group" {}

variable "node_tags" {
    type = "map"
    description = "Required - Dictionary of tags to apply to the node"
}

variable "node_keypair" {
    description = "Required - Path to AWS PEM on jumpbox"
}

variable "root_volume_size" {
    default = 40
}

variable "root_volume_type" {
    default = "gp2"
}

variable "public_ip" {
    description = "Give this node a public IP address"
    default = false
}

variable "public_dns" { default = ""  }

variable "public_zone_id"  { default = "" }
variable "private_zone_id" {}
variable "reverse_zone_id" {}
