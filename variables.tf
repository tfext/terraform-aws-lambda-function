variable "name" {
  type = string
}

variable "source_dir" {
  type = string
}

variable "entrypoint" {
  type = string
}

variable "runtime" {
  type = string
}

variable "log_retention_days" {
  type = number
  default = 7
}

variable "environment" {
  type = map(string)
  default = null
}

variable "timeout" {
  default = 3
}

variable "memory" {
  default = 256
}