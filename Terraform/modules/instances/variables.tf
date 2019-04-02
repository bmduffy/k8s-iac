variable "prefix" {
    description = "Required - prefix for node name which will be combined with an enumerating suffix"
}

variable "quantity" {
    default = "1"
    description = "Optional - Number of instances of this type to deploy"
}

variable "image" {
    description = "Required - AMI image id to create the node from"
}

variable "type" {
    default = "t2.micro"
    description = "Optional - AWS node t-shirt size"
}

variable "vpc" {
    type = "map"
    description = "Required - Output map from AWS VPC creation"
}

variable "tags" {
    type = "map"
    description = "Required - Dictionary of tags to apply to the node"
}

variable "keypair" {
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
