
module "project-setup"{
  source            = "git::https://github.com/finiteloopme/tf-modules-argolis.git//modules/setup-project"

  project_id        = var.project_id
  organisation_id   = var.organisation_id
  billing_account   = var.billing_account
  folder_id         = var.folder_id
}