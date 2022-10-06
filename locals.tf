locals {
  environment = var.terratest_postfix != "" ? format("%s-%s", var.environment, var.terratest_postfix) : var.environment

  default_tags = {
    "createdby"   = "terraform",
    "purpose"     = "iac",
    "environment" = var.environment
  }

  # Azure tag extras
  extra_tags = var.environment == "terratest" ? {
    "purpose"        = "terratest"
    "unique_postfix" = var.terratest_postfix
  } : {}

  tags = merge(local.default_tags, local.extra_tags)
}
