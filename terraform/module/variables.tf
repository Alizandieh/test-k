variable "role_name" {
  type = string
}

variable "group_name" {
  type = string
}

variable "policy_name" {
  type = string
}

variable "user_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

