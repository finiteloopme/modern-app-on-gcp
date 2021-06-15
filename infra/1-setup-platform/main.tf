module "gke-subnet"{
  source            = "git::https://github.com/finiteloopme/tf-modules-argolis.git//modules/subnet"
  project_id                  = var.project_id
  network                     = var.network
  gke_network                 = var.gke_network
  ip_range_pods               = var.ip_range_pods
  svc_ips                     = var.svc_ips

}
module "gke-instance"{
  for_each          = {for gke_instance in var.gke_instances: gke_instance.name => gke_instance}
  source            = "git::https://github.com/finiteloopme/tf-modules-argolis.git//modules/gke"
  project_id        = var.project_id
  gke_cluster_name  = each.value["name"]
  instance_tags     = split(",", each.value["instance_tags"])
}

module "gce_instances"{
  for_each          = {for vm in var.vm_instances: vm.name => vm}
  source            = "git::https://github.com/finiteloopme/tf-modules-argolis.git//modules/gce"
  project_id        = var.project_id
  instance_name     = each.value["name"]
  machine_type      = each.value["machine_type"]
  instance_tags     = split(",", each.value["instance_tags"])
  # startup_script    = each.value.script=="" ? file("${path.module}/scripts/install-docker.sh") : format("%s\n%s", file("${path.module}/scripts/install-docker.sh"), file("${path.module}/${each.value.script}"))
}