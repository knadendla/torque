variable account {
    type = string
}

variable cluster-name {
    type = string
}

variable region {
    type = string
}

variable "role_arn" {
  type = string
}

variable "role_username" {
  type = string
}

variable fluentd {
    type = bool
    default = true
}

variable prometheus {
    type = bool
    default = true
}

variable elk{
    type = bool
    default = true
}

variable istio{
    type = bool
    default = true
}