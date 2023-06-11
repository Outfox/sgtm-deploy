# sGTM Deployment
This Terraform deployment of Server Side GTM aims to provide a standardized way to deploy sGTM containers in Cloud Run.
The deployment performs the follwing operations:
* Creates a service account for sGTM
* Deploys sGTM and preview server in Cloud Run
* Disables access logging (all http status codes < 400)
* Enables uptime checks with email alerts


## Deployment process
To run the deployment you need access to the GCP project where you will deploy sGTM with the "Owner" role.

Ensure you have the following info at hand before you begin:
* GCP Project ID for the cloud project where you will deploy sGTM
* Your sGTM container config key

Follow these steps to deploy sGTM:
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
        1. custom_domain
1. Save the file and go back to the Terminal
1. Run `terraform init`
1. Run `terraform plan`
1. Run `terraform apply` (type 'yes' when asked)
1. Wait until Terraform has completed the setup. You are done!


## Uptime checks
[Uptime check](https://console.cloud.google.com/monitoring/uptime) uses all 6 regions to check if the sGTM application is able to deliver a selected client side GTM container. The variable "gtm_container_id" contains the ID of the GTM container to monitor. Email notifications are sent to all recipients (listed in the "alert_emails" variable) if an outage is detected. 


## Custom domain
If you like to connect a custom domain name to the sGTM instance you first have to verify the domain through [Google Search Console](https://search.google.com/search-console/). Once the domain is verified you can add the desired DNS name (like "gtm.my-domain.com") to the "custom_domain" variable in the "terraform.tfvars" file. You can now run `terraform apply` apply the custom domain. Lastly you need to add a CNAME record to your DNS. If you have connected "gtm.my-domain.com" you will add "gtm" as your-hostname:

| Name          | Type  | Data                 |
|---------------|-------|----------------------|
| your-hostname | CNAME | ghs.googlehosted.com |


## Store Terraform state in Cloud Storage bucket
If multiple users (or CI/CD processes) need to manage the sGTM setup it recommended to store the state of the Terraform configuration in a Cloud Storage bucket. 
Once you have successfully run the `terraform apply` command a [Cloud Storage bucket](https://console.cloud.google.com/storage/browser) is created to host the state files. The bucket name is prefixed "terraform-sgtm-". 

1. Run `edit backend.tf`
1. Uncomment the entrire block. 
1. Add the name of your bucket to the "bucket" variable.
1. Save the file.
1. Run `terraform init`
1. Enter "yes" when asked to copy your local state file to the Storage Bucket.