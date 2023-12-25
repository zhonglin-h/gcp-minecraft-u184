# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "project_id" {
  value       = var.project_id
  description = "GCloud Project ID"
}

output "minecraft_server_name" {
  value       = google_compute_instance.minecraft_vm.name
  description = "Minecrat Server Compute Instance Name"
}
