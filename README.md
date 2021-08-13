# Terraform with Google Kubernetes Engine (GKE)
# Deploying a GKE K8s cluster using Terraform

## Prepare the environment

1) Download Terraform binary:

`wget https://releases.hashicorp.com/terraform/0.12.1/terraform_0.12.1_linux_amd64.zip`

`unzip terraform_0.12.1_linux_amd64.zip -d /usr/local/bin`

2) Verify you can run terraform:

`terraform -v`

3) Download Google Cloud SDK:

`curl https://sdk.cloud.google.com | bash`  
Move to /usr/local/bin and/or set your PATH if needed

Or via your package manager, i.e for Ubuntu/Debian:
### Add the Cloud SDK distribution URI as a package source
`echo "deb http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list`

### Import the Google Cloud Platform public key
`curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -`

### Update the package list and install the Cloud SDK
`sudo apt-get update && sudo apt-get install google-cloud-sdk`

4) Run `gcloud init` and follow instructions 
5) Run `gcloud auth application-default login` and follow instructions
   
6) Enable the following API's for the compute and container services:
   
`gcloud services enable compute.googleapis.com`  
`gcloud services enable container.googleapis.com` 

7) You can now list your GKE clusters by running the following:

`gcloud container clusters list` 

### Provision a cluster via gcloud CLI for testing:

1) You can very easily create a GKE cluster by running:
`gcloud container clusters create testk8s-cluster --zone europe-west2-c`

Creating cluster testk8s-cluster in europe-west2-c...
Cluster is being deployed...
Cluster is being health-checked...

2) When the cluster is created you will find a kubeconfig file the the directory you ran the command from.
    
3) Install kubectl if you haven't alraeady:
`sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl` 

`echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list`

`sudo apt-get update && sudo apt-get install -y kubectl`

4)  Run `kubectl get nodes` 
5)  Run `gcloud container clusters update` to change settings in the cluster such as the number of nodes.
6)  Destroy the cluster by running:
`gcloud container clusters delete testk8s-cluster --zone europe-west2-c`
NOTE: be careful not to run this on a production cluster for obvious reasons!

# Provision GKE K8s via Terraform

1) Grab the terraform files in the repository

2)  Amend the tf files in the repo to match your project, region, credentials file, etc

3)  Run `terraform init`, this should initialize terraform and generate the state file
   
4) Run `terraform validate` to make sure the config has no errors 

5)  Run `terraform plan` which is essentially a dry-run and will provide a summary of all the changes that will be made and resources that will be created

6)  Now `terraform apply`, this will create the cluster environment, enter the project-id when prompted and hit yes to confirm you want to continue. Go grab a coffee, this may take a while.
   
7) Inspect your directry tree structure, you will now see the state and kubeconfig files have been generated. 
   
8) Run `export KUBECONFIG="${PWD}/kubeconfig-prod"`
Then run: `kubectl get pods --all-namespaces` 

9)  Now you can create deployments in the cluster and apply them like any other kubernetes:

`kubectl create -f deployment.yaml`

10)  Run `terraform destroy` to destroy the entire cluster.
NOTE: be careful not to run this in production!

## Expose your pods via a LoadBalancer
NOTE: this will incur charges!
`kubectl create -f svc-loadbalancer.yaml`

`kubectl get services`

## Routing traffic via an Ingress
`kubectl create -f ingress.yaml`

`kubectl describe ingress <pod>`

## kubectl example commands:
see: https://kubernetes.io/docs/reference/kubectl/cheatsheet/

`kubectl get pods -o wide`   
`kubectl get ingress`   
`kubectl get services`   
`kubectl get nodes`   
`kubectl logs <pod>`   
`kubectl exec --stdin --tty <pod> -- /bin/bash`   
`kubectl describe pods`   
`kubectl describe nodes`   
`kubectl create -f <yaml>`   
`kubectl delete -f <yaml>`   

## gcloud commands:

`gcloud compute forwarding-rules list \
  --filter description~hello-gke-k8s \
  --format \
  "table[box](name,IPAddress,target.segment(-2):label=TARGET_TYPE)"`