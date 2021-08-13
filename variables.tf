variable "project_id" {
  description = "ID of the project to host the cluster in"
}
variable "cluster_name" {
  description = "The name of the GKE cluster"
  default     = "testk8s-cluster"
}
variable "env_name" {
  description = "The environment name of the GKE cluster"
  default     = "test"
}
variable "region" {
  description = "The region that will host the cluster"
  default     = "us-east1-a"
}
variable "network" {
  description = "The VPC network that will host the cluster"
  default     = "gke-network"
}
variable "subnetwork" {
  description = "The subnetwork that is will host the cluster"
  default     = "gke-subnet"
}
variable "ip_range_pods_name" {
  description = "The secondary ip range that is used for pods"
  default     = "ip-range-pods"
}
variable "ip_range_services_name" {
  description = "The secondary ip range that is used for services"
  default     = "ip-range-services"
}