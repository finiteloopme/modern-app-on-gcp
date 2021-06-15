# output "gke-instance" {
    # value       = "[${module.gce_instances[].instance_self_link}]"
    # value       = {
    #                 "name":         module.gke-instance.name,
    #                 "cluster_id":   module.gke-instance.cluster_id,
    #                 "location":     module.gke-instance.location,
    #                 "type":         module.gke-instance.type,
    #                 "region":       module.gke-instance.region,
    #                 "zones":        module.gke-instance.zones
    #              }
    #sensitive   = true
# }