variable "environment" {}
variable "project" {}
variable "bucket_list" {}

locals {
  timestamp = "${timestamp()}"
  timestamp_filtered = "${replace("${local.timestamp}", "/[-| |T|Z|:]/", "")}"
}