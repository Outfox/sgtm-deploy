# sGTM Deployment
This Terraform deployment of Server Side GTM aims to provide a standardized way to deploy sGTM containers in Cloud Run.
The deployment performs the follwing operations:
* Creates a service account for sGTM
* Deploys sGTM and preview server in Cloud Run
* Disables access logging (all http status codes < 400)
* Enables uptime monitoring with email alerts

## Deployment process
Ensure you have the following info before you begin:
* GCP Project ID for the cloud project where you will deploy sGTM
* Your sGTM container config key

1. Enable the [Resource Manager API](https://console.cloud.google.com/apis/library/cloudresourcemanager.googleapis.com)
1. Open [Cloud Shell](https://shell.cloud.google.com).
1. Run `git clone https://github.com/Outfox/sgtm-deploy`
1. Run `cd sgtm-deploy/terraform`
1. Edit the file configuration file "terraform.tfvars" by `edit terraform.tfvars`
    * Assign your own values to these variables:
        1. container_config
        1. project_id
    * Optionally you can modify the following variables to suit your setup:
        1. region
        1. service_account
        1. min_instances
        1. max_instances
        1. enable_uptime_check
        1. gtm_container_id
        1. alert_emails
1. Save the file and go back to the Terminal
1. Run `terraform init`
1. To make Terraform aware of the default logging sink in GCP run the following:
`terraform import google_logging_project_sink.default projects/*[YOUR_PROJECT_ID]*/sinks/_Default`
(note you have to replace [YOUR_PROJECT_ID] with your GCP Project ID)
1. Run `terraform plan`
1. Run `terraform apply` (type 'yes' when asked)
1. Wait until Terraform has completed the setup. You are done!

