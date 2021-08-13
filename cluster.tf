# Usage: https://registry.terraform.io/modules/terraform-google-modules

module "gke_auth" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  depends_on   = [module.gke]
  project_id   = var.project_id
  location     = module.gke.location
  cluster_name = module.gke.name
}
resource "local_file" "kubeconfig" {
  content  = module.gke_auth.kubeconfig_raw
  filename = "kubeconfig-${var.env_name}"
}
module "gke" {
  source                 = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id             = var.project_id
  name                   = "${var.cluster_name}-${var.env_name}"
  regional               = true
  region                 = var.region
  network                = module.gcp-network.network_name
  subnetwork             = module.gcp-network.subnets_names[0]
  ip_range_pods          = var.ip_range_pods_name
  ip_range_services      = var.ip_range_services_name
  node_pools = [
    {
      name                      = "k8s-node-pool-1"
      machine_type              = "e2-micro"
      node_locations            = "us-west1-a,us-central1-a,us-east1-a"
      min_count                 = 1
      max_count                 = 1
      disk_size_gb              = 30
    }#,
    #{
    #  name                      = "k8s-fast-pool-1"
    #  machine_type              = "n1-highcpu-4"
    #  node_locations            = "europe-west2-b"
    #  min_count                 = 1
    #  max_count                 = 3
    #  disk_size_gb              = 100
   #}
  ]
}