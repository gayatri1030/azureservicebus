

variable "resource_group_name" {
  description = "The name of the resource group in which to create the namespace."
}

variable "app_name" {
  default = ""
}

variable "environment" {
  default = ""
}

variable "location" {
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created"
}

variable "tags" {
  type        = map(string)
  description = "Tags for the resources getting created"
}

variable "namespace_name" {
  description = "Specifies the name of the ServiceBus Namespace"
}

variable "namespace_sku" {
  description = "The Tier used for the ServiceBus Namespace"
}

variable "namespace_capacity" {
  type        = number
  default     = "0"
  description = "The capacity of the ServiceBus Namespace."
}


variable "queue_config" {
  type = list(object({
    queue_name                                    = string
    queue_max_delivery_count                      = number
    queue_lock_duration                           = string
    queue_max_size_in_megabytes                   = number
    queue_default_message_ttl                     = string
    queue_dead_lettering_on_message_expiration    = bool
    queue_auto_delete_on_idle                     = string
    queue_status                                  = string
    queue_requires_duplicate_detection            = bool
    queue_requires_session                        = bool
    queue_enable_batched_operations               = bool
    queue_duplicate_detection_history_time_window = string
    queue_enable_partitioning                     = bool
    queue_enable_express                          = bool
  }))
  description = ""
}
variable "topic_config" {
  type = list(object({
    topic_name                                    = string
    topic_max_delivery_count                      = number
    topic_max_size_in_megabytes                   = number
    topic_default_message_ttl                     = string
    topic_auto_delete_on_idle                     = string
    topic_status                                  = string
    topic_requires_duplicate_detection            = bool
    topic_enable_batched_operations               = bool
    topic_duplicate_detection_history_time_window = string
    topic_enable_partitioning                     = bool
    topic_enable_express                          = bool
    topic_support_ordering                        = bool
  }))
  description = ""
}
variable "subscription_config" {
  type = list(object({
    subscription_name                                      = string
    subscription_max_delivery_count                        = number
    subscription_lock_duration                             = string
    subscription_topic_name                                = string
    subscription_requires_session                          = bool
    subscription_enable_batched_operations                 = bool
    subscription_default_message_ttl                       = string
    subscription_auto_delete_on_idle                       = string
    subscription_status                                    = string
    subscription_dead_lettering_on_message_expiration      = bool
    subscription_dead_lettering_on_filter_evaluation_error = bool
  }))

}

variable "subscription_rule_config" {
  type = list(object({
    subscription_rule_name              = string
    subscription_rule_filter_type       = string
    subscription_name                   = string
    topic_name                          = string
    subscription_rule_sql_filter        = string
    subscription_rule_correlation_id    = string
    subscription_rule_correlation_label = string
  }))
}




