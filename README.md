# AWS Resource Monitor Dashboard

A Bash-based monitoring script that automates the process of listing AWS resources across EC2, S3, RDS, and Lambda. The script verifies AWS CLI configuration, supports cron scheduling for daily reports, and automatically sends the report via email for easy access.

---

## Features

- Lists EC2 instances, S3 buckets, RDS instances, and Lambda functions.
- Verifies AWS CLI installation and credentials before running.
- Supports AWS region configuration.
- Generates readable `.txt` reports.
- Sends the report via email using `msmtp` and `mailutils`.
- Supports cron scheduling for daily automation.

---

## Prerequisites

- AWS CLI installed and configured  
  → [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

```bash
aws configure
```

- Bash shell (Ubuntu/Linux environment)
- Access to AWS EC2, S3, RDS, and Lambda services
- `msmtp` and `mailutils` installed for email support:

```bash
sudo apt install msmtp msmtp-mta mailutils -y
```

- Gmail App Password (recommended for SMTP auth)  
  → [Generate App Password](https://myaccount.google.com/apppasswords)

---

## Email Configuration

Create a `.msmtprc` file in your home directory:

```bash
nano ~/.msmtprc
```

Example config:

```ini
defaults
auth on
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile ~/.msmtp.log

account gmail
host smtp.gmail.com
port 587
from your-email@gmail.com
user your-email@gmail.com
password your-app-password

account default : gmail
```

Secure the file:

```bash
chmod 600 ~/.msmtprc
```

---

## Setup & Usage

1. **Clone the Repository**

```bash
git clone https://github.com/PasinduWaidyarathna/aws-resource-monitor-dashboard.git
cd aws-resource-monitor-dashboard
```

2. **Make the Script Executable**

```bash
chmod +x aws-monitor.sh
```

3. **Run the Script Manually**

```bash
./aws-monitor.sh
```

4. **Schedule with Cron**

Edit crontab:

```bash
crontab -e
```

Add this line to run the script daily at 7:00 AM:

```bash
0 7 * * * /home/ubuntu/aws-resource-monitor-dashboard/aws-monitor.sh >> /home/ubuntu/aws-monitor-cron.log 2>&1
```

---

## Sample Output

The script will generate a report like:

```
aws-monitor-report-2025-04-21_07-00.txt

=== AWS Resource Monitor Report (2025-04-21_07-00) ===
Region: us-east-2

>>> EC2 Instances:
| Instance ID        | Instance Type | State   | Public IP        |
|--------------------|---------------|---------|------------------|

>>> S3 Buckets:
2025-01-01  bucket-name-1
2025-03-15  bucket-name-2

...
```

The content of this report will be sent to your configured email address.

---

## Contributing

Contributions are welcome! Feel free to fork the repository, submit issues, and create pull requests.

## Author

- **Pasindu Waidyarathna**
