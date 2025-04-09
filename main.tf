provider "google" {
  credentials = file("kubernetes-cluster-456118-08200ccfdf05.json")
  project     = "kubernetes-cluster-456118"
  region      = "europe-west1"
}

resource "google_container_cluster" "primary" {
  name     = "my-k8s-cluster"
  location = "europe-west1"

  initial_node_count = 3

  node_config {
    machine_type = "n2d-standard-2"
  }
}

resource "google_container_node_pool" "main_pool" {
  name     = "main-pool2"
  location = "europe-west1"
  cluster  = google_container_cluster.primary.name

  node_config {
    machine_type = "n2d-standard-2"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  initial_node_count = 1
  autoscaling {
    enabled = false
  }
}

resource "google_container_node_pool" "application_pool" {
  name     = "application-pool2"
  location = "europe-west1"
  cluster  = google_container_cluster.primary.name

  node_config {
    machine_type = "n2d-standard-2"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  initial_node_count = 3

  autoscaling {
    enabled     = true
    min_node_count = 1
    max_node_count = 3
  }
}
