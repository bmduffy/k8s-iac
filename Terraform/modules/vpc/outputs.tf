output "outputs"{
    value = {
        subnet_id             = "${aws_subnet.subnet.id}"
        subnet_dns_domain     = "${var.subnet["dns"]}"
        subnet_reverse_domain = "${var.subnet["reverse"]}"
        public_dns_domain     = "${var.public_dns}"
        security_group_id     = "${aws_security_group.network.id}"
        public_zone_id        = "${data.aws_route53_zone.public.zone_id}"
        private_zone_id       = "${aws_route53_zone.private.zone_id}"
        reverse_zone_id       = "${aws_route53_zone.reverse.zone_id}"
    }
}
