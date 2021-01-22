# Rancher Application Hot Standby

* ./main.tf: Creates 4 nodes with rke2 on them
* ./userdata: Contains the cloud-init scripts required to install and enable RKE2
* ./fleet/application: Contains Application information with overlays
* ./fleet/gitrepo: Contains git repo manifests for fleets managed by fleet
* ./gitrepo: Contains the manifest required for the top level fleet

## External Actions/Requirements

* Certificates that are valid for both the local rancher url and the global rancher url.
* Rancher Installation on each rancher cluster
* Rancher import manifest on each managed cluster
* External Rancher Cluster with fleet secrets (containing KUBECONFIG).
