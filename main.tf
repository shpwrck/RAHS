############
# PREAMBLE #
############

terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.3.0"
    }
  }
}

#############
# RESOURCES #
#############

variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_project" "shipwreck" {
  name = "shipwreck" 
}

/*
resource "digitalocean_droplet" "argo" {
  image = "ubuntu-20-04-x64"
  name = "argo-server"
  region = "nyc3"
  size = "s-2vcpu-4gb"
  ssh_keys = [ "bf:5c:93:0b:c2:59:54:79:d2:a8:08:32:c1:49:53:d0" ]
  tags = [
    "Owner:Skrzypek",
    "DoNotDelete:True"
  ] 
  user_data = file("./userdata/argo.userdata.template")
}
*/

resource "digitalocean_droplet" "clusters" {
  for_each = {
    rancher-primary = "nyc3"
    managed-primary = "nyc3"
    rancher-standby = "sfo3"
    managed-standby = "sfo3"
  }

  image = "ubuntu-20-04-x64"
  name = each.key
  region = each.value
  size = "s-2vcpu-4gb"
  ssh_keys = [ "bf:5c:93:0b:c2:59:54:79:d2:a8:08:32:c1:49:53:d0" ]
  tags = [
    "Owner:Skrzypek",
    "DoNotDelete:True"
  ] 
  user_data = file("./userdata/rancher.userdata.template")
}

resource "digitalocean_project_resources" "rancher-hot-standby" {
  project = data.digitalocean_project.shipwreck.id

  resources = [
    digitalocean_droplet.clusters["rancher-primary"].urn,
    digitalocean_droplet.clusters["rancher-standby"].urn,
    digitalocean_droplet.clusters["managed-primary"].urn,
    digitalocean_droplet.clusters["managed-standby"].urn
  ]
}

##########
# OUTPUT #
##########

output "rancher-primary-ssh" {
  value = format("Primary SSH: ssh root@%s\n",digitalocean_droplet.clusters["rancher-primary"].ipv4_address)
}
output "rancher-standby-ssh" {
  value = format("Standby SSH: ssh root@%s\n",digitalocean_droplet.clusters["rancher-standby"].ipv4_address)
}

output "managed-primary-ssh" {
  value = format("Primary SSH: ssh root@%s\n",digitalocean_droplet.clusters["managed-primary"].ipv4_address)
}
output "managed-standby-ssh" {
  value = format("Standby SSH: ssh root@%s\n",digitalocean_droplet.clusters["managed-standby"].ipv4_address)
}
