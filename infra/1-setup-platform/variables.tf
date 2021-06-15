variable "project_id" {
  description = "ID for the project"
}

variable "gcp_region" {
  description = "GCP Region"
  default = "us-central1"
}

variable "gcp_zone" {
  description = "GCP zone"
  default = "us-central1-b"
}

variable vm_instances{
  description   = "List of VM instances to be created"
  type          = list(map(string))
  default       = [
    {
      name = "ledgermonolith-service"
      machine_type  = "n1-highmem-8"
      script = "scripts/run-ledger-db.sh"
      instance_tags = "http,https,db,modern-gcp-app,ledger,monolith"
    },
  ]
}

variable gke_instances{
  description   = "List of GKE instances to be created"
  type          = list(map(string))
  default       = [
    {
      name = "bank-of-anthos-cluster"
      instance_tags = "gke,modern-gcp-app,bank-of-anthos"
    },
    {
      name = "servicemesh-control-plane-cluster"
      instance_tags = "gke,servicemesh-ctrl-plane"
    },
  ]
}