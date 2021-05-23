
module "servicebus" {
  source                                                 = "../../Terraform_Modules/AzureServiceBus"
  resource_group_name                                    = var.resource_group_name
  location                                               = var.location
  tags                                                   = var.tags
  namespace_sku                                          = var.namespace_sku
  namespace_capacity                                     = var.namespace_capacity
  namespace_name                                         = var.namespace_name

  #queueparameters
  queue_config                                           = var.queue_config
  queue_name                                              = var.queue_name
  queue_max_delivery_count                               = var.queue_max_delivery_count
  queue_lock_duration                                    = var.queue_lock_duration
  queue_max_size_in_megabytes                            = var.queue_max_size_in_megabytes
  queue_default_message_ttl                              = var.queue_default_message_ttl
  queue_dead_lettering_on_message_expiration             = var.queue_dead_lettering_on_message_expiration
  queue_enable_express                                   = var.queue_enable_express
  queue_auto_delete_on_idle                              = var.queue_auto_delete_on_idle
  queue_requires_duplicate_detection                     = var.queue_requires_duplicate_detection
  queue_status                                           = var.queue_status
  queue_requires_session                                 = var.queue_requires_session
  queue_enable_batched_operations                        = var.queue_enable_batched_operations
  queue_duplicate_detection_history_time_window          = var.queue_duplicate_detection_history_time_window
  queue_enable_partitioning                              = var.queue_enable_partitioning

  #topic Parameters
  topic_config                                           = var.topic_config
  topic_name                                            = var.topic_name
  topic_max_delivery_count                               = var.topic_max_delivery_count
  topic_default_message_ttl                              = var.topic_default_message_ttl
  topic_max_size_in_megabytes                            = var.topic_max_size_in_megabytes
  topic_requires_duplicate_detection = var.topic_requires_duplicate_detection
  topic_duplicate_detection_history_time_window          = var.topic_duplicate_detection_history_time_window
  topic_enable_batched_operations                        = var.topic_enable_batched_operations
  topic_enable_express                                   = var.topic_enable_express
  topic_enable_partitioning                              = var.topic_enable_partitioning
  topic_auto_delete_on_idle                              = var.topic_auto_delete_on_idle
  topic_status                                           = var.topic_status
  topic_support_ordering                                 = var.topic_support_ordering

  #subscription parameters
  subscription_config                                    = var.subscription_config
  subscription_name                                      = var.subscription_name
  subscription_topic_name                                =var.subscription_topic_name
  subscription_requires_sessions                         = var.subscription_requires_sessions
  subscription_max_delivery_count                        = var.subscription_max_delivery_count
  subscription_lock_duration                             = var.subscription_lock_duration
  subscription_enable_batched_operations                 = var.subscription_enable_batched_operations
  subscription_default_message_ttl                       = var.subscription_default_message_ttl
  subscription_auto_delete_on_idle                       = var.subscription_auto_delete_on_idle
  subscription_status                                    = var.subscription_status
  subscription_dead_lettering_on_message_expiration      = var.subscription_dead_lettering_on_message_expiration
  subscription_dead_lettering_on_filter_evaluation_error = var.subscription_dead_lettering_on_filter_evaluation_error
  subscription_rule_config = var.usr_subscription_rule_config

}