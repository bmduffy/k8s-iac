
resource "aws_instance" "ec2" {

    count = "${var.node_count}"

    ami           = "${var.node_image}"
    instance_type = "${var.node_type}"
    subnet_id     = "${var.node_subnet}"
    key_name      = "${var.node_keypair}"

    associate_public_ip_address = "${var.public_ip}"

    root_block_device = {
        delete_on_termination = true
        volume_size = "${var.root_volume_size}"
        volume_type = "${var.root_volume_type}"
    }

    security_groups = [
        "${var.node_sec_grp_id}"
    ]

    tags = "${merge(
        var.node_tags,
        map(
            "Name", format("%s%03d", var.node_name, count.index + 1),
            "DeploymentDate", timestamp()
        )
    )}"
}
