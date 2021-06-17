# README #

AKS Cluster v1

### What is this repository for? ###

* Template for AKS cluster deployment
* Created for Jimmy Test Space.


      

1. update ./vars/<environment>.tfvars with the appropriate values 

2. Terraform init to initialize the correct backend 

3. Terraform plan -var-file=./vars/<environment>.tfvars 

4. Terraform apply -var-file=./vars/<environment>.tfvars 

5. kubectl get nodes --kubeconfig ./kube_config