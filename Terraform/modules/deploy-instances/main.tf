
resource "null_resource" "node_data" {
    count = "${var.node_count}"
    triggers {
        name = "${format("%s%02d", var.node_name, count.index + 1)}"
    }
}

locals { node_names = "${null_resource.node_data.*.triggers.name}" }

resource "aws_instance" "ec2" {

    count = "${length(local.node_names)}"

    ami           = "${var.node_image}"
    instance_type = "${var.node_type}"
    subnet_id     = "${var.node_subnet_id}"
    key_name      = "${var.node_keypair}"

    associate_public_ip_address = "${var.public_ip}"

    root_block_device = {
        delete_on_termination = true
        volume_size = "${var.root_volume_size}"
        volume_type = "${var.root_volume_type}"
    }

    security_groups = ["${var.node_security_group}"]

    tags = "${merge(
        var.node_tags,
        map(
            "Name", local.node_names[count.index],
            "DeploymentDate", timestamp()
        )
    )}"

    provisioner "file" {
        source      = "./scripts/bootstrap.sh"
        destination = "~/bootstrap.sh"
    }

    provisioner "local-exec" {
        command = "sudo bash ~/bootstrap.sh"
    }
}

locals {
    private_ips = "${aws_instance.ec2.*.private_ip}"
    public_ips  = "${aws_instance.ec2.*.public_ip}"
}

resource "aws_route53_record" "ec2_private_records" {
    count   = "${length(local.node_names)}"
    zone_id = "${var.private_zone_id}"
    name    = "${local.node_names[count.index]}.${var.node_subnet["dns"]}"
    type    = "A"
    ttl     = "300"
    records = ["${local.private_ips[count.index]}"]
    depends_on = ["aws_instance.ec2"]
}

resource "aws_route53_record" "ec2_reverse_records" {
    count   = "${length(local.node_names)}"
    zone_id = "${var.reverse_zone_id}"
    name    = "${format(
        "%s.%s",
        element(split(".", local.private_ips[count.index]), 3),
        var.node_subnet["reverse"]
    )}"
    type    = "CNAME"
    ttl     = "300"
    records = ["${local.node_names[count.index]}.${var.node_subnet["dns"]}"]
    depends_on = ["aws_instance.ec2"]
}

resource "aws_route53_record" "ec2_public_records" {
    count   = "${var.public_ip ? length(local.node_names) : 0}"
    zone_id = "${var.public_zone_id}"
    name    = "${local.node_names[count.index]}.${var.public_dns}"
    type    = "A"
    ttl     = "172800"
    records = ["${local.public_ips[count.index]}"]
    depends_on = ["aws_instance.ec2"]
}
