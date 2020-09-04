# Add docker provider
provider "docker" {
}

# Find the latest busybox image.
resource "docker_image" "busybox" {
  name = "busybox"
  keep_locally = true
}

# Start a busybox container
resource "docker_container" "busybox" {
  name  = "busybox"
  image = docker_image.busybox.latest
  command = ["tail", "-f", "/dev/null"]
}
