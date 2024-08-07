terraform {
  required_version = ">= 0.14.0"
  required_providers {
    google = {
      version = ">= 5.39.1"
    }
    spotinst = {
      source  = "spotinst/spotinst"
      version = ">=1.182.0"
    }
  }
}