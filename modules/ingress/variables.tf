variable "name" {
  description = "Used to define name of the resource, as well as the host identifier."
  type = string
}

variable "namespace" {
  description = "Define the namespace where the resource should be created"
  type = string
}

variable "annotations" {
  description = <<EOT
    Annotations that should be added to the default annotations.
    annotations = {
      "some_key" = "some_value",
      "other_key" = "other_value",
    }
    EOT
  type = map(string)
}

variable "ingress_class_name" {
  description = "The ingress class that should be used for the ingress resource."
  type = string
}

variable "hostname" {
  description = "Used with `name` to create the ingress `host`."
}

variable "app_service_name" {
  description = "The service name of the application that the ingress resource should connect to."
  type = string
}

variable "app_service_port" {
  description = "The service port of the application that the ingress resource should connect to."
  type = number
  default = 80
}

variable "path" {
  description = "Default path of the application"
  type = string
  default = "/"
}
