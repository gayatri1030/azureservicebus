
//locals {
//  rg_name     = var.newrg ? azurerm_resource_group.rg[0].name : var.resource_group_name
//  rg_location = var.newrg ? azurerm_resource_group.rg[0].location : var.location
//  //  topic_name = azurerm_servicebus_topic.workitemtopic.*.id
//}

//resource "azurerm_resource_group" "rg" {
//  count    = var.newrg ? 1 : 0
//  name     = var.resource_group_name
//  location = var.location
//  tags     = var.tags
//}
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_servicebus_namespace" "namespace" {
  location            = var.location
  name                = var.namespace_name != "" ? "${var.namespace_name}-${var.environment}" : "${var.app_name}-${var.environment}"
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = var.namespace_sku
  tags                = var.tags
  capacity            = var.namespace_capacity
  zone_redundant      = var.namespace_sku == "premium" ? true : false
}



resource "azurerm_servicebus_queue" "workitemqueue" {
  depends_on                              = [azurerm_servicebus_namespace.namespace]
  for_each                                = { for i in var.queue_config : i.queue_name => i.queue_name }
  name                                    = lookup({ for i in var.queue_config : i.queue_name => i.queue_name }, each.value)
  resource_group_name                     = data.azurerm_resource_group.rg.name
  namespace_name                          = azurerm_servicebus_namespace.namespace.name
  max_delivery_count                      = lookup({ for i in var.queue_config : i.queue_name => i.queue_max_delivery_count }, each.value)
  default_message_ttl                     = lookup({ for i in var.queue_config : i.queue_name => i.queue_default_message_ttl }, each.value)
  max_size_in_megabytes                   = lookup({ for i in var.queue_config : i.queue_name => i.queue_max_size_in_megabytes }, each.value)
  dead_lettering_on_message_expiration    = lookup({ for i in var.queue_config : i.queue_name => i.queue_dead_lettering_on_message_expiration }, each.value)
  auto_delete_on_idle                     = lookup({ for i in var.queue_config : i.queue_name => i.queue_auto_delete_on_idle }, each.value)
  enable_express                          = lookup({ for i in var.queue_config : i.queue_name => i.queue_enable_express }, each.value)
  requires_duplicate_detection            = lookup({ for i in var.queue_config : i.queue_name => i.queue_requires_duplicate_detection }, each.value)
  requires_session                        = lookup({ for i in var.queue_config : i.queue_name => i.queue_requires_session }, each.value)
  enable_batched_operations               = lookup({ for i in var.queue_config : i.queue_name => i.queue_enable_batched_operations }, each.value)
  duplicate_detection_history_time_window = lookup({ for i in var.queue_config : i.queue_name => i.queue_duplicate_detection_history_time_window }, each.value)
  enable_partitioning                     = lookup({ for i in var.queue_config : i.queue_name => i.queue_enable_partitioning }, each.value)
}


resource "azurerm_servicebus_topic" "workitemtopic" {
  depends_on                              = [azurerm_servicebus_queue.workitemqueue]
  for_each                                = { for i in var.topic_config : i.topic_name => i.topic_name }
  name                                    = lookup({ for i in var.topic_config : i.topic_name => i.topic_name }, each.value)
  resource_group_name                     = data.azurerm_resource_group.rg.name
  namespace_name                          = azurerm_servicebus_namespace.namespace.name
  max_size_in_megabytes                   = lookup({ for i in var.topic_config : i.topic_name => i.topic_max_size_in_megabytes }, each.value)
  default_message_ttl                     = lookup({ for i in var.topic_config : i.topic_name => i.topic_default_message_ttl }, each.value)
  auto_delete_on_idle                     = lookup({ for i in var.topic_config : i.topic_name => i.topic_auto_delete_on_idle }, each.value)
  status                                  = lookup({ for i in var.topic_config : i.topic_name => i.topic_status }, each.value)
  requires_duplicate_detection            = lookup({ for i in var.topic_config : i.topic_name => i.topic_requires_duplicate_detection }, each.value)
  enable_batched_operations               = lookup({ for i in var.topic_config : i.topic_name => i.topic_enable_batched_operations }, each.value)
  duplicate_detection_history_time_window = lookup({ for i in var.topic_config : i.topic_name => i.topic_duplicate_detection_history_time_window }, each.value)
  enable_partitioning                     = lookup({ for i in var.topic_config : i.topic_name => i.topic_enable_partitioning }, each.value)
  enable_express                          = lookup({ for i in var.topic_config : i.topic_name => i.topic_enable_express }, each.value)
  support_ordering                        = lookup({ for i in var.topic_config : i.topic_name => i.topic_support_ordering }, each.value)
}


resource "azurerm_servicebus_subscription" "subscription" {
  depends_on                                = [azurerm_servicebus_topic.workitemtopic]
  for_each                                  = { for i in var.subscription_config : i.subscription_name => i.subscription_name }
  name                                      = lookup({ for i in var.subscription_config : i.subscription_name => i.subscription_name }, each.value)
  resource_group_name                       = data.azurerm_resource_group.rg.name
  namespace_name                            = azurerm_servicebus_namespace.namespace.name
  topic_name                                = lookup({ for i in var.subscription_config : i.subscription_name => i.subscription_topic_name }, each.value)
  max_delivery_count                        = lookup({ for i in var.subscription_config : i.subscription_name => i.subscription_max_delivery_count }, each.value)
  lock_duration                             = lookup({ for i in var.subscription_config : i.subscription_name => i.subscription_lock_duration }, each.value)
  requires_session                          = lookup({ for i in var.subscription_config : i.subscription_name => i.subscription_requires_session }, each.value)
  enable_batched_operations                 = lookup({ for i in var.subscription_config : i.subscription_name => i.subscription_enable_batched_operations }, each.value)
  default_message_ttl                       = lookup({ for i in var.subscription_config : i.subscription_name => i.subscription_default_message_ttl }, each.value)
  auto_delete_on_idle                       = lookup({ for i in var.subscription_config : i.subscription_name => i.subscription_auto_delete_on_idle }, each.value)
  status                                    = lookup({ for i in var.subscription_config : i.subscription_name => i.subscription_status }, each.value)
  dead_lettering_on_message_expiration      = lookup({ for i in var.subscription_config : i.subscription_name => i.subscription_dead_lettering_on_message_expiration }, each.value)
  dead_lettering_on_filter_evaluation_error = lookup({ for i in var.subscription_config : i.subscription_name => i.subscription_dead_lettering_on_filter_evaluation_error }, each.value)
}

resource "azurerm_servicebus_subscription_rule" "subscription_rule_sql_filter" {
  depends_on = [azurerm_servicebus_subscription.subscription]
  for_each            = { for i in var.subscription_rule_config : i.subscription_rule_name => i.subscription_rule_name if i.subscription_rule_filter_type == "SqlFilter" }
  filter_type         = lookup({ for i in var.subscription_rule_config : i.subscription_rule_name => i.subscription_rule_filter_type }, each.value)
  name                = lookup({ for i in var.subscription_rule_config : i.subscription_rule_name => i.subscription_rule_name },each.value)
  namespace_name      = azurerm_servicebus_namespace.namespace.name
  resource_group_name = data.azurerm_resource_group.rg.name
  subscription_name   = lookup({ for i in var.subscription_rule_config : i.subscription_rule_name => i.subscription_name },each.value)
  topic_name          = lookup({ for i in var.subscription_rule_config : i.subscription_rule_name => i.topic_name },each.value)
  sql_filter          = lookup({ for i in var.subscription_rule_config : i.subscription_rule_name => i.subscription_rule_sql_filter },each.value)
}

resource "azurerm_servicebus_subscription_rule" "subscription_rule_correlation_filter" {
  depends_on = [azurerm_servicebus_subscription.subscription]
  for_each = {for i in var.subscription_rule_config : i.subscription_rule_name => i.subscription_rule_name if i.subscription_rule_filter_type == "CorrelationFilter"}
  filter_type = lookup({for i in var.subscription_rule_config : i.subscription_rule_name => i.subscription_rule_filter_type}, each.value)
  name = lookup({for i in var.subscription_rule_config : i.subscription_rule_name => i.subscription_rule_name}, each.value)
  namespace_name = azurerm_servicebus_namespace.namespace.name
  resource_group_name = data.azurerm_resource_group.rg.name
  subscription_name = lookup({for i in var.subscription_rule_config : i.subscription_rule_name => i.subscription_name}, each.value)
  topic_name = lookup({for i in var.subscription_rule_config : i.subscription_rule_name => i.topic_name}, each.value)
  correlation_filter {
    correlation_id = lookup({for i in var.subscription_rule_config : i.subscription_rule_name => i.subscription_rule_correlation_id}, each.value)
    label = lookup({for i in var.subscription_rule_config : i.subscription_rule_name => i.subscription_rule_correlation_label}, each.value)
  }
}
