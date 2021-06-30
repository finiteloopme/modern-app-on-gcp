module "gke-instance"{
  for_each          = {for gke_instance in var.gke_instances: gke_instance.name => gke_instance}
  source            = "git::https://github.com/finiteloopme/tf-modules-argolis.git//modules/gke"
  project_id        = var.project_id
  gke_instance      = each.value
  # gke_cluster_name  = each.value["name"]
  # instance_tags     = split(",", each.value["instance_tags"])
}

data "http" "start-up-file"{
  url         = "https://raw.githubusercontent.com/finiteloopme/bank-of-anthos/master/src/ledgermonolith/init/install-script.sh"
}

module "gce_template" {
  source            = "git::https://github.com/finiteloopme/tf-modules-argolis.git//modules/gce_template"
  project_id        = var.project_id
  gcp_region        = var.gcp_region
  name_prefix       = var.vm_template.name_prefix
  machine_type      = var.vm_template.machine_type
  source_image_family = var.vm_template.source_image_family
  source_image_project = var.vm_template.source_image_project
  instance_tags     = split(",", var.vm_template.instance_tags)
  metadata          = {
    gcs-bucket      = "bank-of-anthos"
    VmDnsSetting    = "ZonalPreferred"
    # startup-script  = file("https://raw.githubusercontent.com/finiteloopme/bank-of-anthos/master/src/ledgermonolith/init/install-script.sh")
    startup-script  = data.http.start-up-file.body
  }
}

module "asm"{
  source                = "git::https://github.com/finiteloopme/tf-modules-argolis.git//modules/asm"
  project_id            = var.project_id
  # TODO: Hard coding the name of the cluster for ASM deployment.
  # Need to handle this a better way
  gke_cluster           = "bank-of-anthos-cluster"
  gke_location          = var.gcp_region

  depends_on            = [
    module.gke-instance
  ]
}