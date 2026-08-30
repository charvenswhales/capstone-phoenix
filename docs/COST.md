# Cost Breakdown — Capstone Phoenix

## AWS Resources Used

| Resource | Type | Quantity | Cost/Hour | Hours | Total |
|----------|------|----------|-----------|-------|-------|
| EC2 Control Plane | t3.micro | 1 | $0.0104 | 72 | $0.75 |
| EC2 Worker 1 | t3.micro | 1 | $0.0104 | 72 | $0.75 |
| EC2 Worker 2 | t3.micro | 1 | $0.0104 | 72 | $0.75 |
| EBS Storage | gp3 20GB x3 | 3 | $0.002 | 72 | $0.43 |
| S3 Remote State | Standard | 1 | $0.000 | - | $0.01 |
| Data Transfer | Outbound | - | - | - | $0.10 |
| **Total** | | | | | **$2.79** |

## Notes
- All instances are t3.micro which qualify for AWS Free Tier
- Instances are stopped when not in use to minimise costs
- S3 bucket used for Terraform remote state storage
- Total estimated cost for 3-day deployment and demo: ~$2.79
- AWS Free Tier provides 750 hours/month of t3.micro usage

## Cost Optimisation Decisions
- Used t3.micro instead of larger instances to stay within free tier
- Used local-path storage instead of EBS volumes for Kubernetes PVCs
- Terminated all resources immediately after demo using terraform destroy
- Used nip.io for free domain instead of purchasing a custom domain

