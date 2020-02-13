variable "workspace_to_environment_map" {
  type = map
  default = {
    dev     = "dev"
    qa      = "qa"
    staging = "staging"
    prod    = "prod"
  }
}

variable "environment_to_size_map" {
  type = map
  default = {
    dev     = "small"
    qa      = "medium"
    staging = "large"
    prod    = "xlarge"
  }
}

variable "workspace_to_size_map" {
  type = map
  default = {
    dev = "small"
  }
}

variable "region" {
  default = "northeurope"
}

variable "subnets" {
  type = map
  default = {
    subnet-1 = "10.0.1.0/24"
    subnet-2 = "10.0.2.0/24"
  }
}