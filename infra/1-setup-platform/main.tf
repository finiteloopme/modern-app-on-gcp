module "gke-instance"{
  source            = "git::https://github.com/finiteloopme/tf-modules-argolis.git//modules/gke"
  project_id        = var.project_id
  gke_cluster_name  = "test"
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