#!/bin/bash

# ====== Config ======
DATE=$(date '+%Y-%m-%d_%H-%M')
REGION="us-east-2"
REPORT_FILE="$HOME/aws-monitor-report-$DATE.txt"
SERVICES=("ec2" "s3" "rds" "lambda")
# ====================

# Check AWS CLI
if ! command -v aws &> /dev/null
then
    echo "[ERROR] AWS CLI is not installed!" >> "$REPORT_FILE"
    exit 1
fi

# Check AWS credentials
if ! aws sts get-caller-identity --region "$REGION" &> /dev/null
then
    echo "[ERROR] AWS CLI not configured properly!" >> "$REPORT_FILE"
    exit 1
fi

echo "=== AWS Resource Monitor Report ($DATE) ===" > "$REPORT_FILE"
echo "Region: $REGION" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# EC2 Instances
if [[ " ${SERVICES[@]} " =~ " ec2 " ]]; then
    echo ">>> EC2 Instances:" >> "$REPORT_FILE"
    aws ec2 describe-instances \
        --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,PublicIpAddress]' \
        --region "$REGION" --output table >> "$REPORT_FILE" 2>>"$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
fi

# S3 Buckets
if [[ " ${SERVICES[@]} " =~ " s3 " ]]; then
    echo ">>> S3 Buckets:" >> "$REPORT_FILE"
    aws s3 ls >> "$REPORT_FILE" 2>>"$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
fi

# RDS Instances
if [[ " ${SERVICES[@]} " =~ " rds " ]]; then
    echo ">>> RDS Instances:" >> "$REPORT_FILE"
    aws rds describe-db-instances \
        --query 'DBInstances[*].[DBInstanceIdentifier,DBInstanceClass,Engine,DBInstanceStatus,Endpoint.Address]' \
        --region "$REGION" --output table >> "$REPORT_FILE" 2>>"$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
fi

# Lambda Functions
if [[ " ${SERVICES[@]} " =~ " lambda " ]]; then
    echo ">>> Lambda Functions:" >> "$REPORT_FILE"
    aws lambda list-functions \
        --query 'Functions[*].[FunctionName,Runtime,LastModified]' \
        --region "$REGION" --output table >> "$REPORT_FILE" 2>>"$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
fi

echo ">>> Report generated at: $REPORT_FILE"

