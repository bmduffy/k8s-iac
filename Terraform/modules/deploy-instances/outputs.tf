
output "ids" {
    value = "${aws_instance.ec2.*.id}"
}

output "names" {
    value = "${aws_instance.ec2.*.tags.Name}"
}

output "private_ips" {
    value = "${aws_instance.ec2.*.private_ip}"
}

output "public_ips" {
    value = "${aws_instance.ec2.*.public_ip}"
}
