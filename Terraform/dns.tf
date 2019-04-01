# Pre-Created and Registere public domain

data "aws_route53_zone" "public" {
    name  = "bmduffy.net"
}

resource "aws_route53_zone" "test_zone" {

    name  = "iac.bootcamp.ammeon.ie"

    tags = {
        Name = "iac-bootcamp-public-zone"
        Project = "iac-bootcamp"
        Environment = "Test"
        InfraComponent = "DNS"
        DeploymentDate = "${timestamp()}"
    }
}

resource "aws_route53_zone" "private" {

    name  = "iac.bootcamp"

    vpc {
        vpc_id = "${aws_vpc.bootcamp.id}"
    }

    tags = {
        Name = "iac-bootcamp-private-zone"
        Project = "iac-bootcamp"
        Environment = "Test"
        InfraComponent = "DNS"
        DeploymentDate = "${timestamp()}"
    }
}

resource "aws_route53_record" "bastion_private_records" {
    count   = "${length(module.bastion.names)}"
    zone_id = "${aws_route53_zone.private.zone_id}"
    name    = "${module.bastion.names[count.index]}.${aws_route53_zone.private.name}"
    type    = "A"
    ttl     = "300"
    records = ["${module.bastion.private_ips[count.index]}"]
}

resource "aws_route53_record" "master_private_records" {
    count   = "${length(module.masters.names)}"
    zone_id = "${aws_route53_zone.private.zone_id}"
    name    = "${module.masters.names[count.index]}.${aws_route53_zone.private.name}"
    type    = "A"
    ttl     = "300"
    records = ["${module.masters.private_ips[count.index]}"]
}

resource "aws_route53_record" "worker_private_records" {
    count   = "${length(module.workers.names)}"
    zone_id = "${aws_route53_zone.private.zone_id}"
    name    = "${module.workers.names[count.index]}.${aws_route53_zone.private.name}"
    type    = "A"
    ttl     = "300"
    records = ["${module.workers.private_ips[count.index]}"]
}

resource "aws_route53_record" "bastion_public_records" {
    count   = "${length(module.bastion.names)}"
    zone_id = "${data.aws_route53_zone.public.zone_id}"
    name    = "bastion.${data.aws_route53_zone.public.name}"
    type    = "A"
    ttl     = "172800"
    records = ["${module.bastion.public_ips[count.index]}"]
}
