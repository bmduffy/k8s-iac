
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

module "bastion" {
    source              = "./modules/deploy-instances"
    node_name           = "bastion"
    node_image          = "${data.aws_ami.bastion.id}"
    node_type           = "${var.bastion_size}"
    node_count          = "${var.bastion_count}"
    node_tags           = "${var.bastion_tags}"
    node_subnet         = "${var.kubernetes_subnet}"
    node_subnet_id      = "${aws_subnet.kubernetes.id}"
    node_security_group = "${aws_security_group.kubernetes.id}"
    node_keypair        = "${var.ssh_keypair}"
    public_ip           = true
    public_dns          = "${var.public_dns}"
    public_zone_id      = "${data.aws_route53_zone.public.zone_id}"
    private_zone_id     = "${aws_route53_zone.kubernetes_private.zone_id}"
    reverse_zone_id     = "${aws_route53_zone.kubernetes_reverse_private.zone_id}"
}

module "masters" {
    source              = "./modules/deploy-instances"
    node_name           = "master"
    node_count          = "${var.master_count}"
    node_image          = "${data.aws_ami.kubernetes.id}"
    node_type           = "${var.master_size}"
    node_tags           = "${var.master_tags}"
    node_keypair        = "${var.ssh_keypair}"
    node_subnet         = "${var.kubernetes_subnet}"
    node_subnet_id      = "${aws_subnet.kubernetes.id}"
    node_security_group = "${aws_security_group.kubernetes.id}"
    public_zone_id      = "${data.aws_route53_zone.public.zone_id}"
    private_zone_id     = "${aws_route53_zone.kubernetes_private.zone_id}"
    reverse_zone_id     = "${aws_route53_zone.kubernetes_reverse_private.zone_id}"
}

module "workers" {
    source              = "./modules/deploy-instances"
    node_name           = "worker"
    node_count          = "${var.worker_count}"
    node_image          = "${data.aws_ami.kubernetes.id}"
    node_type           = "${var.worker_size}"
    node_tags           = "${var.worker_tags}"
    node_keypair        = "${var.ssh_keypair}"
    node_subnet         = "${var.kubernetes_subnet}"
    node_subnet_id      = "${aws_subnet.kubernetes.id}"
    node_security_group = "${aws_security_group.kubernetes.id}"
    public_zone_id      = "${data.aws_route53_zone.public.zone_id}"
    private_zone_id     = "${aws_route53_zone.kubernetes_private.zone_id}"
    reverse_zone_id     = "${aws_route53_zone.kubernetes_reverse_private.zone_id}"
}
