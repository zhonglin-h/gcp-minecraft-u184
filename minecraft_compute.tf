data "google_project" "project" {}
data "google_compute_default_service_account" "default" {}

# note adding roles to minecraft_sa doesn't help scheduler
# It was default Compute Engine account that needed the permissions

resource "google_service_account" "minecraft_sa" {
  account_id   = "my-minecraft-sa"
  display_name = "Custom SA for VM Instance"
}

resource "google_project_iam_binding" "start_vm" {
  project = var.project_id
  role    = "projects/${data.google_project.project.project_id}/roles/instanceStateEditor"
  members = [
    "serviceAccount:${data.google_compute_default_service_account.default.email}"
  ]
}

resource "google_compute_instance" "minecraft_vm" {
  name         = "vanilla-minecraft-server"
  machine_type = "e2-highmem-2"
  zone         = "us-central1-a"

  boot_disk {
    auto_delete = true
    device_name = "instance-1"

    initialize_params {
      image = "projects/debian-cloud/global/images/debian-11-bullseye-v20231212"
      size  = 10
      type  = "pd-standard"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  network_interface {
    access_config {
      network_tier = "STANDARD"
    }

    subnetwork = "projects/total-array-395215/regions/us-central1/subnetworks/total-array-395215-subnet"
  }

  scheduling {
    instance_termination_action = "STOP"
    automatic_restart   = false
    on_host_maintenance = "TERMINATE"
    preemptible         = true
    provisioning_model  = "SPOT"
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.minecraft_sa.email
    scopes = ["cloud-platform"]
  }
}