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
      name = "frontend"
      machine_type  = "c2-standard-4"
      script = ""
      instance_tags = "http,https,modern-gcp-app,frontend"
    },
    {
      name = "bus-logic"
      machine_type  = "n1-highmem-8"
      script = ""
      instance_tags = "http,https,modern-gcp-app,bus-logic"
    },
    {
      name = "user-logic"
      machine_type  = "n1-highmem-8"
      script = "scripts/run-userservice.sh"
      instance_tags = "http,https,modern-gcp-app,user-logic"
    },
    {
      name = "ledger-db"
      machine_type  = "n1-highmem-8"
      script = "scripts/run-ledger-db.sh"
      instance_tags = "db,modern-gcp-app,ledger-db"
    },
    {
      name = "accounts-db"
      machine_type  = "n1-highmem-8"
      script = "scripts/run-accounts-db.sh"
      instance_tags = "db,modern-gcp-app,accounts-db"
    },
  ]
}