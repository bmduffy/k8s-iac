
resource "aws_vpc" "bootcamp" {

    cidr_block           = "${var.vpc_cidr}"
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
        Name = "iac-bootcamp-vpc"
        Project = "iac-bootcamp"
        Environment = "Test"
        InfraComponent = "Network"
        DeploymentDate = "${timestamp()}"
    }
}

resource "aws_subnet" "kubernetes" {

    vpc_id     = "${aws_vpc.bootcamp.id}"
    cidr_block = "${var.kubernetes_subnet["cidr"]}"

    tags = {
        Name = "${var.kubernetes_subnet["name"]}"
        Project = "iac-bootcamp"
        Environment = "Test"
        InfraComponent = "Network"
        DeploymentDate = "${timestamp()}"
    }
}

resource "aws_internet_gateway" "bootcamp" {

    vpc_id = "${aws_vpc.bootcamp.id}"

    tags = {
        Name = "iac-bootcamp-igw"
        Project = "iac-bootcamp"
        Environment = "Test"
        InfraComponent = "Network"
        DeploymentDate = "${timestamp()}"
    }
}

resource "aws_route_table" "bootcamp" {

    vpc_id = "${aws_vpc.bootcamp.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.bootcamp.id}"
    }

    tags {
        Name = "iac-bootcamp-public"
        Project = "iac-bootcamp"
        Environment = "Test"
        InfraComponent = "Network"
        DeploymentDate = "${timestamp()}"
    }
}

resource "aws_route_table_association" "connect-k8s-subnet-to-bootcamp-route-table" {
  subnet_id      = "${aws_subnet.kubernetes.id}"
  route_table_id = "${aws_route_table.bootcamp.id}"
}

resource "aws_security_group" "kubernetes" {

    name        = "${var.kubernetes_subnet["name"]}"
    description = "Allow traffic to standard ports in kubernetes cluster"
    vpc_id      = "${aws_vpc.bootcamp.id}"

    tags {
        Name = "${var.kubernetes_subnet["name"]}"
        Project = "iac-bootcamp"
        Environment = "Test"
        InfraComponent = "Network"
        DeploymentDate = "${timestamp()}"
    }

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
