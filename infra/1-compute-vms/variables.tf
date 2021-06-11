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
    },
    {
      name = "bus-logic"
      machine_type  = "n1-highmem-8"
      script = ""
    },
    {
      name = "user-logic"
      machine_type  = "n1-highmem-8"
      script = "scripts/run-userservice.sh"
    },
    {
      name = "ledger-db"
      machine_type  = "n1-highmem-8"
      script = "scripts/run-ledger-db.sh"
    },
    {
      name = "accounts-db"
      machine_type  = "n1-highmem-8"
      script = "scripts/run-accounts-db.sh"
    },
  ]
}