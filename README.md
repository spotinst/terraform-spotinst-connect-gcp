# Terraform GCP Examples for Spot.io

## Introduction
The module will aid in automatically connecting your GCP project to Spot account via terraform.

### Pre-Reqs
* Spot Organization Admin API token.

## Example
## Usage
```hcl
#Call the spot module to create a Spot account and link project to the platform
module "spotinst-connect-gcp-project" {
  source               = "spotinst/connect-gcp/spotinst"
  project              = "demo-labs"
  name                 = "demo-acct_123456"
  spotinst_token       = "redacted"
  spot_organization_id = "demo-org-1234567890"
}
output "spot_account_id" {
    value = module.spotinst-connect-gcp-project.spot_account_id
}
```

### Run
This terraform module will do the following:

On Apply:
* Create Spot Account within Spot Organization.
* Create GCP Service Account.
* Create GCP Service Account Key.
* Create GCP Project Role.
* Assign Project Role to Service Account.
* Provide GCP Service Account Key to newly created Spot Account.

On Destroy:
* Remove all above resources including deleting the Spot Account.
