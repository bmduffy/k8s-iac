#!/bin/bash
export cloud_meta_data="http://169.254.169.254"

export aws_instance_id=$(curl ${cloud_meta_data}/instance-id)
export aws_local_ipv4=$(curl ${cloud_meta_data}/local-ipv4)

# Requires reverse DNS look-up to be configured
export route_53_hostname=$(dig +short -x ${aws_local_ipv4})

# Overwrite hostname given by the cloud provieder
sudo hostnamectl set-hostname "${route_53_hostname}"


# Reboot to ensure all changes take effect
reboot
