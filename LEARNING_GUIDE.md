# Terraform file-by-file learning guide

This archive preserves the original starter project while separating declarations into dedicated files. It is a **learning scaffold**, not production-ready infrastructure. No Terraform apply is required.

## Files
- `main.tf`: resources and module calls.
- `variables.tf`: input variable declarations.
- `outputs.tf`: exported values.
- `versions.tf`: required Terraform and provider versions.
- `providers.tf`: provider configuration in environment roots.
- `backend.tf`: remote state settings, unique to each environment.
- `terraform.tfvars.example`: example values; copy to a private `terraform.tfvars` for real deployment.

## How to practice safely
1. Inspect `modules/security/variables.tf`, then `modules/security/main.tf`, then `modules/security/outputs.tf`.
2. Inspect `live/dev/main.tf` and `live/dev/variables.tf`. Follow `allowed_ingress_cidrs` from root input to module input to rule.
3. Compare `live/dev/terraform.tfvars.example` with `live/dr/terraform.tfvars.example`. Values are independent.
4. Commit a change to an example input value on a Git feature branch and use `git diff` to see it. No cloud infrastructure changes until an authorized Terraform apply.

## Important cautions
- Editing a shared module changes its definition for all consumers, but separate plans and applies are required for each environment.
- Changing a value only in the production tfvars does NOT change DR. Use a shared input source or update DR intentionally.
- The starter's CI example and resource definitions require review before real deployment.
- Never commit actual credentials, state files, or private tfvars.
