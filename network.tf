# Usage: https://registry.terraform.io/modules/terraform-google-modules
module "gcp-network" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 3.0"
  project_id   = var.project_id
  network_name = "${var.network}-${var.env_name}"

  subnets = [
    {
      subnet_name   = "${var.subnetwork}-${var.env_name}"
      subnet_ip     = "10.1.10.0/24"
      subnet_region = var.region
    },
  ]
  
  secondary_ranges = {
    "${var.subnetwork}-${var.env_name}" = [
      {
        range_name    = var.ip_range_pods_name
        ip_cidr_range = "10.2.20.0/24"
      },
      {
        range_name    = var.ip_range_services_name
        ip_cidr_range = "10.3.30.0/24"
      },
    ]
  }
}