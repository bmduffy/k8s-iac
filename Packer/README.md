# Packer For OS Image Builds

Hashicorp `packer` is a convenient automation tool for baking
images to use in your infrastructure deployments. You can pack
your images is all the prerequisite software and configuration
you need to enable faster infrastructure previsioning. Think of
this as a pre-processing step to increase operational efficiency.

Additionally if you are hosting infrastructure in multiple
cloud providers for regulatory or other reasons, you can achieve
image consistency across those providers by leveraging the `packer`
parallel build feature.

## How To Use

To create the base images for the `kubernetes` and bastion nodes
run the following commands;

```
>> packer build -var-file="./bastion.json" image.json
>> packer build -var-file="./kubernetes.json" image.json
```

## Environment Setup

## Finding Images

### AWS

https://wiki.centos.org/Cloud/AWS

```
aws --region us-east-1 ec2 describe-images --owners aws-marketplace --filters Name=product-code,Values=aw0evgkw8e5c1q413zgy5pjce
```

## Pack a Container Runtime Interface

Docker is not the only CRI available. You can configure images to use any of CRI-O, Containerd, frakti etc.

https://kubernetes.io/docs/setup/cri/

## Pack Kubernetes Software

https://kubernetes.io/docs/setup/independent/install-kubeadm/

## Preconfigure Firewall Rules


## Onward to Terraform
https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/
