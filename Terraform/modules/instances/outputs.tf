
output "outputs" {
    value {
        ids         = "${aws_instance.ec2.*.id}"
        names       = "${aws_instance.ec2.*.tags.Name}"
        private_ips = "${aws_instance.ec2.*.private_ip}"
        public_ips  = "${aws_instance.ec2.*.public_ip}"
    }
}
