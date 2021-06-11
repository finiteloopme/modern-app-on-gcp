output "gce-instances" {
    # value       = "[${module.gce_instances[].instance_self_link}]"
    value       = { for vm in keys(module.gce_instances) : vm => module.gce_instances[vm].instance_self_link }
    sensitive   = true
}