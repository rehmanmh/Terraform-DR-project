terraform { backend "s3" { bucket = "REPLACE-WITH-STATE-BUCKET"; key = "enterprise/qa/terraform.tfstate"; region = "ap-northeast-1"; encrypt = true; use_lockfile = true } }
