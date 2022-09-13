locals {
  environment = var.postfix != "" ? format("%s-%s", var.environment, var.postfix) : var.environment

  tags = {
    "createdby"   = "terraform",
    "purpose"     = "iac",
    "environment" = var.environment
  }
}
