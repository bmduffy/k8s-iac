
resource "null_resource" "data" {
    count = "${var.quantity}"
    triggers { name = "${format("%s%02d", var.prefix, count.index + 1)}" }
}

locals {
    hosts = "${null_resource.data.*.triggers.name}"
    boostrap_script = "${prefix}-bootstrap.sh"
}

resource "aws_instance" "ec2" {

    count = "${length(local.hosts)}"

    ami           = "${var.image}"
    instance_type = "${var.type}"
    subnet_id     = "${var.vpc["subnet_id"]}"
    key_name      = "${var.keypair}"

    associate_public_ip_address = "${var.public_ip}"

    root_block_device = {
        delete_on_termination = true
        volume_size = "${var.root_volume_size}"
        volume_type = "${var.root_volume_type}"
    }

    security_groups = ["${var.vpc.["security_group_id"]}"]

    tags = "${merge(
        var.tags, map("Type", var.prefix, "Name", local.hosts[count.index])
    )}"

    # provisioner "file" {
    #     source      = "./scripts/basic-bootstrap.sh"
    #     destination = "~/basic-bootstrap.sh"
    # }
    #
    # provisioner "local-exec" {
    #     command = "sudo bash ~/basic-bootstrap.sh"
    # }
}

locals {
    private_ips = "${aws_instance.ec2.*.private_ip}"
    public_ips  = "${aws_instance.ec2.*.public_ip}"
}

resource "aws_route53_record" "ec2_private_records" {
    count   = "${length(local.hosts)}"
    zone_id = "${var.vpc["private_zone_id"]}"
    name    = "${local.hosts[count.index]}.${var.vpc["subnet_dns_domain"]}"
    type    = "A"
    ttl     = "300"
    records = ["${local.private_ips[count.index]}"]
    depends_on = ["aws_instance.ec2"]
}

resource "aws_route53_record" "ec2_reverse_records" {
    count   = "${length(local.hosts)}"
    zone_id = "${var.vpc["reverse_zone_id"]}"
    name    = "${format(
        "%s.%s",
        element(split(".", local.private_ips[count.index]), 3),
        var.vpc["subnet_reverse_domain"]
    )}"
    type    = "CNAME"
    ttl     = "300"
    records = ["${local.hosts[count.index]}.${var.vpc["subnet_dns_domain"]}"]
    depends_on = ["aws_instance.ec2"]
}

resource "aws_route53_record" "ec2_public_records" {
    count   = "${var.public_ip ? length(local.hosts) : 0}"
    zone_id = "${var.vpc["public_zone_id"]}"
    name    = "${local.hosts[count.index]}.${var.vpc["public_dns_domain"]}"
    type    = "A"
    ttl     = "172800"
    records = ["${local.public_ips[count.index]}"]
    depends_on = ["aws_instance.ec2"]
}
