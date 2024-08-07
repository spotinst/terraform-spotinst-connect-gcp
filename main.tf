provider "spotinst" {
    token = var.spotinst_token
}

# Create account on Spot
resource "spotinst_account" "spot_acct" {
    name=local.name
}

# Allows management of a customized Cloud IAM project role.
resource "google_project_iam_custom_role" "SpotRole" {
    role_id     = var.role_id == null ? "SpotRole${replace(spotinst_account.spot_acct.id, "-", "")}" : var.role_id
    title       = var.role_title == null ? "SpotRole${replace(spotinst_account.spot_acct.id, "-", "")}" : var.role_title
    description = var.role_description
    project     = var.project
    permissions = var.role_permissions
}

# Allows management of a Google Cloud service account.
resource "google_service_account" "spotserviceaccount" {
    depends_on = [spotinst_account.spot_acct]
    provisioner "local-exec" {
        # Without this set-cloud-credentials fails
        command = "sleep 10"
    }
    account_id   = var.service_account_id == null ? "spot-${var.spot_organization_id}-${spotinst_account.spot_acct.id}" : var.service_account_id
    display_name = var.service_account_display_name == null ? "spot-${var.spot_organization_id}-${spotinst_account.spot_acct.id}" : var.service_account_display_name

    description  = var.service_account_description
    project      = var.project
}

# Creates and manages service account keys, which allow the use of a service account with Google Cloud.
resource "google_service_account_key" "key" {
    service_account_id = google_service_account.spotserviceaccount.name
}

# Authoritative for a given role. Updates the IAM policy to grant a role to a list of members. Other roles within the IAM policy for the project are preserved.
resource "google_project_iam_binding" "spot-account-iam" {
    project = var.project
    role    = google_project_iam_custom_role.SpotRole.name
    members = [
        google_service_account.spotserviceaccount.member
    ]
}

# Authoritative for a given role. Updates the IAM policy to grant a role to a list of members. Other roles within the IAM policy for the project are preserved.
resource "google_project_iam_binding" "service-account-user-iam" {
    project = var.project
    role    = "roles/iam.serviceAccountUser"
    members = [
        google_service_account.spotserviceaccount.member
    ]
}
# Link a Spot account to a GCP Cloud account.
resource "spotinst_credentials_gcp" "gcp_connect" {
    provisioner "local-exec" {
        # Without this set-cloud-credentials fails
        command = "sleep 10"
    }
    account_id = spotinst_account.spot_acct.id
    type = "service_account"
    project_id = jsondecode(base64decode(google_service_account_key.key.private_key))["project_id"]
    private_key_id = jsondecode(base64decode(google_service_account_key.key.private_key))["private_key_id"]
    private_key = jsondecode(base64decode(google_service_account_key.key.private_key))["private_key"]
    client_email = jsondecode(base64decode(google_service_account_key.key.private_key))["client_email"]
    client_id = jsondecode(base64decode(google_service_account_key.key.private_key))["client_id"]
    auth_uri = jsondecode(base64decode(google_service_account_key.key.private_key))["auth_uri"]
    token_uri = jsondecode(base64decode(google_service_account_key.key.private_key))["token_uri"]
    auth_provider_x509_cert_url = jsondecode(base64decode(google_service_account_key.key.private_key))["auth_provider_x509_cert_url"]
    client_x509_cert_url = jsondecode(base64decode(google_service_account_key.key.private_key))["client_x509_cert_url"]

    lifecycle {
        ignore_changes = [
            private_key,
            account_id
        ]
    }

}