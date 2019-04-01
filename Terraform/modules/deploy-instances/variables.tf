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
    description = "Required - AWS node t-shirt size"
}

variable "node_tags" {
    type = "map"
    description = "Required - Dictionary of tags to apply to the node"
}

variable "node_keypair" {
    description = "Required - Path to AWS PEM on jumpbox"
}

variable "node_subnet" {
    description = "Required - Put The node in this subnet"
}

variable "node_sec_grp_id" {
    description = "Required - security group"
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
