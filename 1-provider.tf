terraform {
  backend "s3" {
    endpoint                    = "nyc3.digitaloceanspaces.com"
    region                      = "us-west-1"
    key                         = "terraform.tfstate"
    skip_requesting_account_id  = true
    skip_credentials_validation = true
    skip_get_ec2_platforms      = true
    skip_metadata_api_check     = true
  }
}

provider "digitalocean" {
  token = "${var.digitalocean_token}"
}

resource "random_string" "kube_init_token_a" {
  length  = 6
  special = false
  upper   = false
}

resource "random_string" "kube_init_token_b" {
  length      = 16
  special     = false
  upper       = false
  min_lower   = 6
  min_numeric = 6
}
