# sGTM Deployment
This Terraform deployment of Server Side GTM aims to provide a standardized way to deploy sGTM containers in Cloud Run.
The deployment performs the follwing operations:
* Creates a service account for sGTM
* Deploys sGTM and preview server in Cloud Run
* Disables access logging (all http status codes < 400)
* Enables uptime checks with email alerts
* Applies a custom domain to sGTM
* Creates scheduled updates of the sGTM application (Automatic revision update)


## Deployment process
To run the deployment you need access to the GCP project where you will deploy sGTM with the "Owner" role.

Ensure you have the following info at hand before you begin:
* GCP Project ID for the cloud project where you will deploy sGTM
* Your sGTM container config key

Follow these steps to deploy sGTM:
1. [Create a new GCP project](https://console.cloud.google.com/projectcreate) and ensure Billing is enabled.
1. Enable the [Resource Manager API](https://console.cloud.google.com/apis/library/cloudresourcemanager.googleapis.com)
1. Open [Cloud Shell](https://shell.cloud.google.com).
1. Run `git clone https://github.com/Outfox/sgtm-deploy`
1. Run `cd sgtm-deploy/terraform`
1. Edit the file configuration file "terraform.tfvars" by `edit terraform.tfvars`
    * Assign your own values to these variables:
        1. container_config
        1. project_id
        1. region
    * Optionally you can modify the following variables to suit your setup:
        1. service_account
        1. min_instances
        1. max_instances
        1. enable_uptime_check
        1. gtm_container_id
        1. alert_emails
        1. custom_domain
        1. cron_schedule
        1. cron_timezone
1. Save the file and go back to the Terminal
1. Run `terraform init`
1. Run `terraform plan`
1. Run `terraform apply` (type 'yes' when asked)
1. Wait until Terraform has completed the setup. You are done!


## Uptime checks
[Uptime check](https://console.cloud.google.com/monitoring/uptime) uses all 6 regions to check if the sGTM application is able to deliver a selected client side GTM container. The variable "gtm_container_id" contains the ID of the GTM container to monitor. Email notifications are sent to all recipients (listed in the "alert_emails" variable) if an outage is detected. 


## Custom domain
If you like to connect a custom domain name to the sGTM instance you first have to verify the domain through [Google Search Console](https://search.google.com/search-console/). Once the domain is verified you can add the desired DNS name (like "gtm.my-domain.com") to the "custom_domain" variable in the "terraform.tfvars" file. You can now run `terraform apply` to apply the custom domain. Lastly you need to add a CNAME record to your DNS. If you have connected "gtm.my-domain.com" you will add "gtm" as your-hostname:

| Name          | Type  | Data                 |
|---------------|-------|----------------------|
| your-hostname | CNAME | ghs.googlehosted.com |


## Automatic revision update
Google occasionally releases new versions of the [sGTM Docker image](https://console.cloud.google.com/gcr/images/cloud-tagging-10302018/GLOBAL/gtm-cloud-image). To ensure your sGTM setup always is up-to-date you can enable automatic revision update that deploys the latest (stable) release of Docker image on a scheduled interval; Just assign a schedule to the `cron_schedule` variable. Optionally you can assign a [TZ identifyer](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) to the `cron_timezone` variable. By default the time zone is "UTC".

When Automatic revision update is enabled Cloud Scheduler will trigger Cloud Build to deploy new revisions of the sGTM app to Cloud Run on the desired interval. It should not be necessary to run Automatic revision update more frequent than once a week.


## Store Terraform state in Cloud Storage bucket
If multiple users (or CI/CD processes) need to manage the sGTM setup it recommended to store the state of the Terraform configuration in a Cloud Storage bucket. 
Once you have successfully run the `terraform apply` command a [Cloud Storage bucket](https://console.cloud.google.com/storage/browser) is created to host the state files. The bucket name is prefixed "terraform-sgtm-". 

1. Run `edit backend.tf`
1. Uncomment the entire block. 
1. Add the name of your bucket to the "bucket" variable.
1. Save the file.
1. Run `terraform init`
1. Enter "yes" when asked to copy your local state file to the Storage Bucket.


# Service accounts created
During the deployment of sGTM there are two service accounts created:

**server-side-gtm**
The account executes the sGTM application in Cloud Run. Name of the account can be overridden with the "run_service_account" variable. The account is granted the following roles:
* Logs Writer

**cloud-builder**
The account runs the job in Cloud Build to deplay new releases of the sGTM application. Name of the account can be overridden with the "build_service_account" variable. The account is granted the following roles:
* Cloud Build Runner (see Custom role below)
* Cloud Run Admin
* Service Account User

# Custom role 
During the deployment the custom role "Cloud Build Runner" is created with the following permissions:
* cloudbuild.builds.create 
* cloudscheduler.jobs.run
* logging.logEntries.create
* logging.logEntries.route