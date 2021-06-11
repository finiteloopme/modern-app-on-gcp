module "gce_instances"{
  for_each          = {for vm in var.vm_instances: vm.name => vm}
  source            = "git::https://github.com/finiteloopme/tf-modules-argolis.git//modules/gce"
  project_id        = var.project_id
  instance_name     = each.value["name"]
  machine_type      = each.value["machine_type"]
  instance_tags     = [
    "http",
    "https",
    "modern-gcp-app",
  ]

  startup_script    = each.value.script=="" ? file("${path.module}/scripts/install-docker.sh") : format("%s\n%s", file("${path.module}/scripts/install-docker.sh"), file("${path.module}/${each.value.script}"))
}