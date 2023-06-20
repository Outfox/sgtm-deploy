# GTM server side Container Config ID:
container_config = ""

# GCP Project ID:
project_id = ""

# GCP region:
region = "europe-west1"

# Minimim Cloud Run instances:
min_instances = "2"

# Maximum Cloud Run instances:
max_instances = "100"

# Set to true to enable uptime checks:
enable_uptime_check = false

# GTM (client side) container ID to check:
gtm_container_id = ""

# List of emails address to notify for outages:
alert_emails = []

# Custom domain name to use:
custom_domain = ""

# Schedule for automatic revision update (every Monday at 9:00).
# Leave blank to disable:
cron_schedule = "0 9 * * 1"