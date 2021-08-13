# Specify the provider (GCP, AWS, Azure)
provider "google" {
credentials = "${file("terraform.json")}"
project     = "terraform-GKE-Test-12082021"
region      = "europe-west2-c"
version     = "~> 3.75.0"
}