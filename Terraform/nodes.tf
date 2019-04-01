
data "aws_ami" "bastion" {

    most_recent = true
    owners = ["${var.my_owner_id}"]

    filter {
        name = "name"
        values = ["bastion-image-*"]
    }
}

data "aws_ami" "kubernetes" {

    most_recent = true
    owners = ["${var.my_owner_id}"]

    filter {
        name = "name"
        values = ["kubernetes-image-*"]
    }
}

module "bastion" {
    source          = "./modules/deploy-instances"
    node_name       = "bastion"
    node_image      = "${data.aws_ami.bastion.id}"
    node_type       = "${var.bastion_size}"
    node_count      = "${var.bastion_count}"
    node_keypair    = "${var.ssh_keypair}"
    node_tags       = "${var.bastion_tags}"
    node_subnet     = "${aws_subnet.kubernetes.id}"
    node_sec_grp_id = "${aws_security_group.kubernetes.id}"
    public_ip       = true
}

module "masters" {
    source          = "./modules/deploy-instances"
    node_name       = "master"
    node_count      = "${var.master_count}"
    node_image      = "${data.aws_ami.kubernetes.id}"
    node_type       = "${var.master_size}"
    node_keypair    = "${var.ssh_keypair}"
    node_tags       = "${var.master_tags}"
    node_subnet     = "${aws_subnet.kubernetes.id}"
    node_sec_grp_id = "${aws_security_group.kubernetes.id}"
}

module "workers" {
    source          = "./modules/deploy-instances"
    node_name       = "worker"
    node_count      = "${var.worker_count}"
    node_image      = "${data.aws_ami.kubernetes.id}"
    node_type       = "${var.worker_size}"
    node_keypair    = "${var.ssh_keypair}"
    node_tags       = "${var.worker_tags}"
    node_subnet     = "${aws_subnet.kubernetes.id}"
    node_sec_grp_id = "${aws_security_group.kubernetes.id}"
}
