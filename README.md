# Enterprise AWS Terraform: Dev, QA, Production, DR

This is a **learning scaffold**, not a deploy-as-is production baseline. It creates network + security in each environment, and optionally ALB, ASG, and RDS. Deployments can incur AWS charges. No production credentials or AMIs are included.

## Folder ownership
- `modules/`: reusable resource modules owned by Platform Engineering.
- `live/dev`, `live/qa`, `live/prod`, `live/dr`: independent root modules, regional variables, backend keys, state, and approvals.
- `live/_shared`: source reference for common root code; not deployed directly.
- `docs/`: operating and recovery runbooks.

## Quick start on your laptop
1. Install Terraform >=1.10, AWS CLI, and Git. Configure AWS SSO/assume-role credentials.
2. Create a secure, versioned S3 state bucket in Tokyo with limited IAM access; replace `REPLACE-WITH-STATE-BUCKET` in each backend.tf. Backend must exist before init. Enable state lock via `use_lockfile`.
3. For the environment you want to deploy, copy `terraform.tfvars.example` to `terraform.tfvars`. Set actual AWS Region-specific AMI and ACM certificate ARN for active stacks. Do not commit terraform.tfvars or secrets.
4. `cd live/dev`, then `terraform fmt -recursive` from project root, `terraform init`, `terraform validate`, `terraform plan -var-file=terraform.tfvars`. Review before `terraform apply -var-file=terraform.tfvars`.
5. Repeat independently for QA, production, and DR using separate AWS roles and change approvals. **Do not blindly apply to all four.**

## What happens when production changes?
1. For shared behavior, edit `modules/` (e.g., security module), review in Git, run plans for all environments.
2. For a production-only setting, edit `live/prod/terraform.tfvars` (or an approved tracked variable file).
3. For a common application topology change, prefer a shared versioned configuration or a reusable application stack module; **a prod-only root edit does not automatically update DR**.
4. DR defaults to `deploy_application=false` (Backup & Restore): network/security are provisioned but EC2/ALB/RDS are NOT. Backups, cross-Region AMI/snapshot copy, and restore procedures are separate processes. During recovery, set real DR AMI/certificate values and change `deploy_application=true` only after the database restoration design is prepared.

## Limitations and production work remaining
- No NAT gateways or VPC endpoints: private EC2 instances lack internet access by default. Add per-AZ NAT or required endpoints for SSM, monitoring, packages, and application dependencies.
- EC2 AMI must already run an application listening on port 8080 and serving `GET /health` with HTTP 200. Otherwise ALB health checks fail.
- RDS uses AWS-managed Secrets Manager master password. Applications need a secure secret retrieval mechanism and a least-privilege instance role, not supplied here.
- New DR RDS is **empty** unless restored from snapshot. Terraform `aws_db_instance` here is a new database; recovery must use `snapshot_identifier` or an approved restore process and state reconciliation.
- RDS final snapshot behavior, lifecycle protection, cross-account KMS keys, backups, immutable vaults, DNS failover, monitoring, WAF, scaling policies, data migration, and runbooks must be designed before production.
- Example GitLab pipeline demonstrates validation/planning only. It needs CI credentials (OIDC), separate protected AWS roles, protected apply jobs, plan artifacts and manual approvals.
- `live/_shared` copies are illustrative. For long-lived enterprise operation, publish a versioned **stack module** and have each root call it, or generate stacks from a controlled template, to avoid root drift.
- Never treat Terraform state as application backups.

See `docs/OPERATIONS.md` for common workflows.
