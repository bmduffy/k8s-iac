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
    source    = "./modules/instances"
    prefix    = "bastion"
    image     = "${data.aws_ami.bastion.id}"
    type      = "${var.bastion_size}"
    tags      = "${local.default_tags}"
    keypair   = "${var.keypair}"
    vpc       = "${module.vpc.outputs}"
    public_ip = true
}

module "masters" {
    source   = "./modules/instances"
    prefix   = "master"
    quantity = "${var.ha_cluster ? 3 : 1}"
    image    = "${data.aws_ami.kubernetes.id}"
    type     = "${var.master_size}"
    tags     = "${local.default_tags}"
    keypair  = "${var.keypair}"
    vpc      = "${module.vpc.outputs}"
}

module "workers" {
    source   = "./modules/instances"
    prefix   = "worker"
    quantity = "${var.number_of_worker_nodes}"
    image    = "${data.aws_ami.kubernetes.id}"
    type     = "${var.worker_size}"
    tags     = "${local.default_tags}"
    keypair  = "${var.keypair}"
    vpc      = "${module.vpc.outputs}"
}
