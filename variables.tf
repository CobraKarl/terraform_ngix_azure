variable "RGName" {
  type = string

}

variable "location" {
  type = string

}

variable "subscriptionId" {
  type = string

}

variable "clientId" {
  type = string
}

variable "clientSecret" {
  type = string
}

variable "tenantId" {
  type = string

}

variable "instance_size" {
  type        = string
  description = "Azure instance size"
  default     = "Standard_F2"
}

variable "admin_username" {
  type = string

}

variable "admin_password" {
  type = string

}