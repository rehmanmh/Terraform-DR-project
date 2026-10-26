# Terraform team operating guide

## Responsibility matrix
- Platform team: modules, VPC, IAM, backend, provider/version policy.
- Application team: AMIs, ASG sizing, app ports, ALB target health, releases.
- DBA: RDS engine/version, backup retention, PITR, snapshots and restores.
- Security: security group CIDRs, KMS, cross-account roles, policy-as-code.
- SRE/DR: RTO/RPO, restore tests, DNS failover, regional dependencies.

## Routine change: security group
Edit shared `modules/security/main.tf` for a common rule, or an approved variable for a scoped CIDR change. Run `terraform fmt`, `terraform validate`, and `terraform plan` independently for dev, qa, prod, dr. Review security exposure and apply only approved environments. DR's rules can differ for regional CIDRs.

## Routine change: add EC2 capacity
For an ASG, change `desired_capacity` or autoscaling policy, not an individual `aws_instance`. Review maximum capacity and AZ distribution. For DR Backup & Restore, preserve launch templates/AMIs and backup copies; do not necessarily launch running EC2 in DR.

## DR restore checklist
1. Declare incident, confirm RPO/RTO, freeze conflicting changes.
2. Validate copied AMIs, EBS snapshots, RDS snapshots/PITR, S3 object availability, and encryption keys.
3. Plan DR VPC, routing, security, DNS, access, and endpoints.
4. Restore RDS **from the appropriate snapshot/PITR**, verify data integrity, credentials and application connectivity.
5. Launch DR application from a valid regional AMI or deployment artifact; attach to ALB; verify `/health` and real application functionality.
6. Switch Route 53 or traffic routing only after verification, monitor recovery and log all changes.
7. Perform failback through a separately reviewed plan.

## CI/CD safeguards
Require GitLab merge requests, CODEOWNERS, plan review, security scanning, protected production/DR environments, manual apply approval, OIDC role assumption, state locking, and scheduled drift checks.
