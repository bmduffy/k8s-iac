#!/bin/bash
export cloud_meta_data="http://169.254.169.254"
export aws_instance_id=$(curl ${cloud_meta_data}/instance-id)
export aws_local_ipv4=$(curl ${cloud_meta_data}/local-ipv4)

# Reboot to ensure all changes take effect
# reboot
