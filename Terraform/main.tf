provider "aws" {
    profile = "${var.aws_profile}"
    region  = "${var.aws_region}"
}

data "aws_ami" "bastion" {
    most_recent = true
    owners = ["${var.my_owner_id}"]
    filter {
        name = "name"
        values = ["bastion-image-*"]
    }
    filter {
        name = "state"
        values = ["available"]
    }
}

data "aws_ami" "kubernetes" {
    most_recent = true
    owners = ["${var.my_owner_id}"]
    filter {
        name = "name"
        values = ["kubernetes-image-*"]
    }
    filter {
        name = "state"
        values = ["available"]
    }
}

locals {
    default_tags = {
        Project    = "${var.project_name}"
        Enviroment = "${var.environment}"
    }
}

module "vpc" {
    source     = "./modules/vpc"
    tags       = "${local.default_tags}"
    prefix     = "${var.project_name}"
    quantity   = "${var.ha_cluster ? 3 : 1}"
    public_dns = "${var.public_dns}"
}

module "bastion" {
    source          = "./modules/instances"
    prefix          = "bastion"
    image           = "${data.aws_ami.bastion.id}"
    type            = "${var.bastion_size}"
    tags            = "${local.default_tags}"
    keypair         = "${var.keypair}"
    vpc             = "${module.vpc.outputs}"
    public_ip       = true
    # subnet          = "${module.vpc.subnet}"
    # subnet_id       = "${module.vpc.subnet_id}"
    # security_group  = "${module.vpc.security_group_id}"
    # public_zone_id  = "${module.vpc.public_zone_id}"
    # private_zone_id = "${module.vpc.private_zone_id}"
    # reverse_zone_id = "${module.vpc.private_zone_id}"
}

module "masters" {
    source          = "./modules/instances"
    prefix          = "master"
    quantity        = "${var.ha_cluster ? 3 : 1}"
    image           = "${data.aws_ami.kubernetes.id}"
    type            = "${var.master_size}"
    tags            = "${local.default_tags}"
    keypair         = "${var.keypair}"
    vpc             = "${module.vpc.outputs}"
    # subnet          = "${module.vpc.subnet}"
    # subnet_id       = "${module.vpc.subnet_id}"
    # security_group  = "${module.vpc.security_group_id}"
    # public_zone_id  = "${module.vpc.public_zone_id}"
    # private_zone_id = "${module.vpc.private_zone_id}"
    # reverse_zone_id = "${module.vpc.private_zone_id}"
}

module "workers" {
    source          = "./modules/instances"
    prefix          = "worker"
    quantity        = "${var.number_of_worker_nodes}"
    image           = "${data.aws_ami.kubernetes.id}"
    type            = "${var.worker_size}"
    tags            = "${local.default_tags}"
    keypair         = "${var.keypair}"
    vpc             = "${module.vpc.outputs}"
    # subnet          = "${var.kubernetes_subnet}"
    # subnet_id       = "${module.vpc.subnet_id}"
    # security_group  = "${module.vpc.security_group_id}"
    # public_zone_id  = "${module.vpc.public_zone_id}"
    # private_zone_id = "${module.vpc.private_zone_id}"
    # reverse_zone_id = "${module.vpc.private_zone_id}"
}
