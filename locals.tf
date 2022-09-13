locals {
  environment = var.postfix != "" ? format("%s-%s", var.environment, var.postfix) : var.environment
}
