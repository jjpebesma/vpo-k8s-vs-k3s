# vpo-k8s-vs-k3s
This repository is for a school experiment I had to conduct. It contains all of the necessary information and files to get started. The research document itself will not be public. This repository is solely for supporting the research document. Anything that can be found in this repository that might be useful for you can be used under the provided license.

# Prerequisites
- Host, 16CPU cores, 64GB RAM (Change the terraform files if you have less)
- ProxmoxVE 
- Terraform
- Ansible
- Kubectl

# Preperation
1. Edit the `cloud-image.sh` script. Change the storage (nvme0n1p1) to the proxmox-storage you wish to use (most-likely "local").
2. Copy the script to your Proxmox server and run it.
3. [Create an API-key for Terraform](https://youtu.be/dvyeoDBUtsU?feature=shared&t=166) to automatically create your VM's
4. Create a `credentials.auto.tfvars` file in the terraform directory that looks like the following and change the values accordingly:
```hcl
pm_api_url = "https://your-proxmox-url:8006"
pm_api_token_secret = "your-terraform-api-key"
pm_api_token_id = "terraform-prov@pve!terraform" 
ssh_keys = <<-EOF
    (your ssh key)
    EOF
ciuser = "your-username"
```
5. Change the `kubernetes.tf` file according to your needs. (Storage, IP-addresses etc)
6. Go in to the terraform folder, then type: `terraform init`, `terraform apply`, your vm's should be created.
7. Change the k3s and k8s files according to your needs.
8. Clone the [kubespray github repository](https://github.com/kubernetes-sigs/kubespray) with release v2.25.0. Change directory to the repository and type: `cp -rfp inventory/sample inventory/mycluster`. Copy `hosts.yaml` from this repository's k8s folder to `kubespray/inventory/mycluster/hosts.yaml`. Copy `k8s-cluster.yml` to `kubespray/inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yaml`.
9. Clone the [k3s-ansible](https://github.com/k3s-io/k3s-ansible) and place `inventory.yml` from this repository's k3s folder in `k3s-ansible/inventory.yml`.
10. Go through the prerequisites in the k3s-ansible and kubespray repo
11. Install paramiko for ansible to prevent some errors (optional)
12. Go through [the prerequisites of longhorn](https://longhorn.io/docs/1.6.2/deploy/install/#installation-requirements) to be able to install longhorn. (An ansible playbook is provided that already does this, create your own inventory and run it or manually execute the steps.)

# Experiment
- Create the k3s cluster by typing `ansible-playbook playbooks/site.yml -i inventory.yml` in the k3s-ansible repository.
- Create the k8s cluster by typing `ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root --user=(YOUR_USER) -c paramiko cluster.yml` in the kubespray repository. IMPORTANT: Replace (YOUR_USER) with the user you defined in terraform's `credentials.auto.tfvars`, AND `-c paramiko` argument is optional if you did step 10 of the preperation steps. 
- Grafana can be applied to the cluster using `kubectl apply -f grafana.yml` in the scenarios folder.
- Longhorn can be installed using `helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --version 1.6.2`