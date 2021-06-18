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

variable "vm_template" {
  description = "GCE Template to be created"
  type        = map(string)
  default     = {
    name_prefix         = "gce-template-for-asm"
    machine_type        = "n1-highmem-8"
    source_image_family = "debian-10"
    source_image_project  = "debian-cloud"
    instance_tags         = "http,https,monolith,for-asm-gce-template"
  }

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
  # type          = list(map(any))
  type          = list(object({
    name  = string
    instance_tags = string
    network = string
    resource_labels = map(string)
    subnet  = object({
      name  = string
      cidr  = string
      subnet_region = string
    })
    secondary_ranges  = object({
      pod_ips = object({
        name  = string
        cidr  = string
      }),
      svc_ips = object({
        name  = string
        cidr  = string
      })
    })
  }))
  default       = [
    {
      "name"  = "bank-of-anthos-cluster"
      "instance_tags" = "gke,modern-gcp-app,bank-of-anthos"
      "network" = "default"
      resource_labels = {
        "workload"  = "bank-of-anthos"
      }

      "subnet"  = {
        "name"  = "bank-of-anthos-subnet-boa"
        "cidr"  = "10.10.0.0/16"
        "subnet_region" = "us-central1"
      }
      "secondary_ranges"  = {
        "pod_ips" = {
          "name"  = "pod-ips-secondary-range-boa"
          "cidr"  = "10.11.0.0/16"
        },
        "svc_ips" = {
          "name"  = "svc-ips-secondary-range-boa",
          "cidr"  = "10.12.0.0/16"}
      }
    },
    # {
    #   "name"  = "asm-control-plane-cluster"
    #   "instance_tags" = "gke,servicemesh-ctrl-plane"
    #   "network" = "default"
    #   resource_labels = {
    #     "workload"  = "asm-control-plane"
    #   }
    #   "subnet"  = {
    #     "name"  = "asm-ctrl-plane-subnet-asm"
    #     "cidr"  = "10.13.0.0/16"
    #     "subnet_region" = "us-central1"
    #   }
    #   "secondary_ranges"  = {
    #     "pod_ips" = {
    #       "name"  = "pod-ips-secondary-range-asm"
    #       "cidr"  = "10.14.0.0/16"
    #     },
    #     "svc_ips" = {
    #       "name"  = "svc-ips-secondary-range-asm",
    #       "cidr"  = "10.15.0.0/16"}
    #   }
    # },
    # {
    #   name = "servicemesh-control-plane-cluster"
    #   instance_tags = "gke,servicemesh-ctrl-plane"
    # },
  ]
}

# variable gke_instance{
#   description   = "List of GKE instances to be created"
#   type          = "map"
  # type          = map({
  #   name: string
  #   instance_tags: string
  #   subnet: {
  #     name: string
  #     cidr: string
  #   }
  #   secondary_ranges: {
  #     pod_ips: {
  #       name: string
  #       cidr: string
  #     },
  #     svc_ips: {
  #       name: string
  #       cidr: string
  #     }
  #   }
  # })
#}

variable "network" {
  description = "Network to use for provisioning resources"
  default = "default"
}

# variable "gke_network" {
#     description = "Name of the subnet which will host GKE cluster"
#     default = {
#       name: "gke-subnetwork",
#       cidr: "10.10.0.0/16"
#       subnet_region: "us-central1"
#     }
# }
# variable "ip_range_pods" {
#     description = "CIDR for PODs"
#     default = {
#       name: "pod-ips-secondary-range",
#       cidr: "10.11.0.0/16"
#     }
# }

# variable "svc_ips" {
#     description = "CIDR for Services"
#     default = {
#       name: "svc-ips-secondary-range",
#       cidr: "10.12.0.0/16"
#     }
# }
