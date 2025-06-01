bucket         = "terraform-state-140023376669"
region         = "ap-southeast-7"
encrypt        = true
kms_key_id     = "alias/terraform-state-140023376669"
use_lockfile   = true
#dynamodb_table = "terraform-state-140023376669"
assume_role = {
    role_arn = "arn:aws:iam::140023376669:role/terraform-state-140023376669"
}