##################
# Dokku Droplet for deploying sideprojects to subdomains
##################

terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option
variable "DIGITALOCEAN_ACCESS_TOKEN" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.DIGITALOCEAN_ACCESS_TOKEN
}

data "digitalocean_ssh_key" "terraform" {
  name = "terraform"
}

# dokku droplet
resource "digitalocean_droplet" "dokku" {
    image  = "dokku-20-04"
    name   = "dokku"
    region = "nyc1"
    size   = "s-1vcpu-2gb"
    ssh_keys = [data.digitalocean_ssh_key.terraform.id]
}

output "droplet_ip_address" {
  value = digitalocean_droplet.dokku.ipv4_address
}