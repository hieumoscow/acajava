# variables.tf

variable "name" {
  description = "The name of the Container App"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "workload_profile_name" {
  description = "The name of the workload profile"
  type        = string
}

variable "workload_profile_type" {
  description = "The type of workload profile for the Container Apps Environment"
  type        = string
  default     = "D4"
}

variable "workload_profile_min_count" {
  description = "The minimum number of workload profiles"
  type        = number
  default     = 1
}

variable "workload_profile_max_count" {
  description = "The maximum number of workload profiles"
  type        = number
  default     = 3
}


variable "min_replicas" {
  description = "The minimum number of replicas for the Container App"
  type        = number
  default     = 1
}

variable "max_replicas" {
  description = "The maximum number of replicas for the Container App"
  type        = number
  default     = 10
}

variable "eureka_server_configurations" {
  description = "Configuration settings for Eureka server"
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "eureka.server.renewal-percent-threshold"
      value = "0.85"
    },
    {
      name  = "eureka.server.eviction-interval-timer-in-ms"
      value = "10000"
    }
  ]
}

variable "spring_config_configurations" {
  description = "Configuration settings for Spring Cloud Config server"
  type = list(object({
    name  = string
    value = string
  }))
  sensitive = true
  default = [
    {
      name  = "spring.cloud.config.server.git.uri"
      value = "https://github.com/YOUR/REPO.git"
    },
    {
      name  = "spring.cloud.config.server.git.username"
      value = "test"
    },
    {
      name  = "spring.cloud.config.server.git.password"
      value = "test"
    }
  ]
}

