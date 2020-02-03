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

variable "kubernetes_client_id" {
  description = "The Client ID for the Service Principal to use for this Managed Kubernetes Cluster"
}

variable "kubernetes_client_secret" {
  description = "The Client Secret for the Service Principal to use for this Managed Kubernetes Cluster"
}

variable "public_ssh_key_path" {
  description = "The Path at which your Public SSH Key is located. Defaults to ~/.ssh/id_rsa.pub"
  // default     = "~/.ssh/id_rsa.pub"
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEA1JyyXQle9w4lUoDI6N7HhS0/cs6RyIBH6kFX54YeHJkpzRHBdCmy3PAVNtfX+j49WtuNMKuByNQV9iEpShLA8idkqrVmkw/UXJ8DJQr9lGiu3bwRcg3/6gC6/WB5rLaExwlri4KndPgMUSJimdDk7jJWCTPQ3PMiHfWBr0ZLcgPvZT4ZLwzhieuKaAxxoqu39ZXy2OL/XuQVpPePglucAItRwZl0YvSp4rwJsV3wQAl6Skybj+w5DEK4ttdIgLaZw60KAfrki5Z2gbMznvKWOqLGXEtw1ter4/+IEEDTNZAw+a7l+H4886zQC/2aOXNsqKBrJrotcMRKPJQxe2C8Nw== rsa-key-20200129"
}

