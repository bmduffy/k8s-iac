# Kubernetes Terraform on AWS

This infrastructure code provides a fully configurable `kubernetes` cluster on
`aws`. The intent is to create a cluster with a simple architecture quickly on
public cloud.

## Prerequisites

The following prerequisites need to be met before running the code in this repo.

| Requirement   | Optional | Description            |
| ------------- | :------: | ---------------------- |
| `terraform`   | `no `    | Code in this repo is based on `terraform` `0.11.13` |
| `aws` account | `no`     | Code is using the `aws` provider only |
|  IAM     | `no`     | Create [IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html?icmpid=docs_iam_console) users and groups to manage automation. They need to have full EC2, VPC and Route53 access to run the automation |
|  keypair  | `no`    | Create a key and down load the `pem` to your host box |
|  AMIs | `no`    | Create AMIs using the `packer` code in this repository |
| domain   | `yes`   | Purchase a registered domain that you can use to connect bastion box |
| `awscli` | `yes`   | Useful for debugging and exploring `aws` API |

#### AWS Client Configuration
The following configuration on your host box is required to run `terraform` for
this implementation. It is also required to run `awscli`. Replace the redacted
values with the access key and secret that was downloaded when you created
your `aws` [IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html?icmpid=docs_iam_console) automation account.
```
>> cat ~/.aws/credentials
[automation]
aws_access_key_id=XXXXXXXXXXXXXXXXXXXX
aws_secret_access_key=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

>> cat ~/.aws/config
[default]
region = eu-west-1
output = table
```

#### AWS AMIs
As mentioned in the prerequisite table, you should first run `packer` to build
the pre-encrypted base images. Nodes instantiate from these base-images
which are packed with `kubernetes` software. The cluster software is
activated by the `terraform` provisioners.

## Environments
The code in this repo is intended to be highly reusable. Only project and `aws`
specific values need to be provided. By default, one bastion node is created
along with one master node and 2 worker nodes.
```
>> cat env/dev/bootcamp.b1.m1.n2.tfvars
{
   "my_owner_id": "456813123929",
   "project_name": "bootcamp",
   "environment": "development",
   "public_dns": "bootcamp.io",
   "aws_region": "eu-west-1",
   "aws_profile": "automation"
}
```
The number of nodes in the cluster is also configurable.

#### Bastion Node
The `bastion` node is effectively a `jumpbox` seeded with your `pem` key and
exposed to the public internet. This is how you can access the cluster once it
is deployed. The `bastion` node is created from a special image that is created
with `packer`. It has `ansible` and other useful tools installed so that you
can run post configuration playbooks against the cluster.

## Usage
Once the prerequisites have been satisfied, run the following commands to
generate a plan and create the cluster.
```
>> terraform init
>> terraform plan -var-file="env/dev/bootcamp.b1.m1.n2.tfvars" -out="bootcamp.plan"
>> terraform apply bootcamp.plan
```
