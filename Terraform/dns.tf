# Pre-Created and Registere public domain

data "aws_route53_zone" "public" {
    name = "${var.public_dns}"
}

resource "aws_route53_zone" "kubernetes_private" {

    name  = "${var.kubernetes_subnet["dns"]}"

    vpc { vpc_id = "${aws_vpc.bootcamp.id}" }

    tags = {
        Name = "iac-bootcamp-private-zone"
        Project = "iac-bootcamp"
        Environment = "Test"
        InfraComponent = "DNS"
        DeploymentDate = "${timestamp()}"
    }
}

resource "aws_route53_zone" "kubernetes_reverse_private" {

    name  = "${var.kubernetes_subnet["reverse"]}"

    vpc { vpc_id = "${aws_vpc.bootcamp.id}" }

    tags = {
        Name = "iac-bootcamp-private-reverse-zone"
        Project = "iac-bootcamp"
        Environment = "Test"
        InfraComponent = "DNS"
        DeploymentDate = "${timestamp()}"
    }
}
