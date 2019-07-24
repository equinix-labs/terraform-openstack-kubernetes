Deploying Kubernetes on OpenStack
===

This project bootstraps a Kubernetes cluster on an OpenStack cloud.

This will configure a cluster, network addon, and OpenStack cloud provider tooling. 

Requirements
---

OpenStack must already be running, and you will need the following variables to complete spinup:

```hcl
#OpenStack Provider
user_name   = ""
tenant_name = ""
password    = ""
#OpenStack Keystone v2 Endpoint
auth_url    = ""
region      = ""

#Instance & Cluster Details
ssh_key_name = ""
image_id = ""
flavor_id_controller = ""
flavor_id_node = ""
floating_network_id =  ""
network_name = ""
lb_subnet_id = ""
```

in your `tfvars`. 


Running
---

Once vars are populated, plan and apply the configuration:

```
terraform plan ; \
terraform apply
```

to complete this setup. 
