resource_group_name = "acajava-rg"
name = "acajava"
location = "East Asia"
workload_profile_type = "D4"
workload_profile_name = "acawp"

eureka_server_configurations = [
  {
    name  = "eureka.server.renewal-percent-threshold"
    value = "0.85"
  },
  {
    name  = "eureka.server.eviction-interval-timer-in-ms"
    value = "10000"
  }
]

spring_config_configurations = [
  {
    name  = "spring.cloud.config.server.git.uri"
    value = "https://github.com/hieumoscow/acajava.git"
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
