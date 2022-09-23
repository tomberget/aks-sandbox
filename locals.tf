locals {
  environment = var.terratest_postfix != "" ? format("%s-%s", var.environment, var.terratest_postfix) : var.environment

  tags = {
    "createdby"   = "terraform",
    "purpose"     = "iac",
    "environment" = var.environment
  }
}
