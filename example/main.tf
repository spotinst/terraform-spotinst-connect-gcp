#Call the spot module to create a Spot account and link project
module "spot_account" {
    source = "../"

    # GCP Project you would like to connect to Spot
    spotinst_token       = "Redacted"
    project              = "demo-labs"
    name                 = "demo-acct_123456"
    spot_organization_id = "org_id"
}

output "spot_account_id" {
    value = module.spot_account.spot_account_id
}
