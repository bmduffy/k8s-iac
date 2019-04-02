
resource "aws_vpc" "network" {
    cidr_block           = "${var.vpc_cidr}"
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = "${merge(var.tags, map("Name", format("%s-vpc", var.prefix)))}"
}

# TODO - implement multiple subnetes for HA cluster
resource "aws_subnet" "subnet" {
    vpc_id     = "${aws_vpc.network.id}"
    cidr_block = "${var.subnet["cidr"]}"
    tags = "${merge(var.tags, map("Name", format("%s-subnet", var.prefix)))}"
}

resource "aws_internet_gateway" "network" {
    vpc_id = "${aws_vpc.network.id}"
    tags = "${merge(var.tags, map("Name", format("%s-gateway", var.prefix)))}"
}

resource "aws_route_table" "network" {
    vpc_id = "${aws_vpc.network.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.network.id}"
    }
    tags = "${merge(var.tags, map("Name", format("%s-routes", var.prefix)))}"
}

resource "aws_route_table_association" "route_subnet" {
    subnet_id      = "${aws_subnet.subnet.id}"
    route_table_id = "${aws_route_table.network.id}"
}

resource "aws_security_group" "network" {

    name        = "${var.subnet["name"]}"
    description = "Allow traffic to standard ports in kubernetes cluster"
    vpc_id      = "${aws_vpc.network.id}"

    tags = "${merge(var.tags, map("Name", format("%s-sec-grp", var.prefix)))}"

    ingress {
        from_port   = 53
        to_port     = 53
        protocol    = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 53
        to_port     = 53
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = -1
        to_port     = -1
        protocol    = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 53
        to_port     = 53
        protocol    = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 53
        to_port     = 53
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

data "aws_route53_zone" "public" {
    count = "${var.public_dns == "undefined" ? 0 : 1}"
    name  = "${var.public_dns}"
}

locals {
    zones = "${data.aws_route53_zone.public.*.zone_id}"
}

resource "null_resource" "public" {
    triggers {
        zone_id = "${length(local.zones) > 0 ? local.zones[0] : "undefined"}"
    }
}

resource "aws_route53_zone" "private" {
    name  = "${var.subnet["dns"]}"
    vpc { vpc_id = "${aws_vpc.network.id}" }
    tags = "${merge(var.tags, map("Name", format("%s-private", var.prefix)))}"
}

resource "aws_route53_zone" "reverse" {
    name  = "${var.subnet["reverse"]}"
    vpc { vpc_id = "${aws_vpc.network.id}" }
    tags = "${merge(var.tags, map("Name", format("%s-reverse", var.prefix)))}"
}
