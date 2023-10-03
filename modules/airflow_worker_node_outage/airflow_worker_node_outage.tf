resource "shoreline_notebook" "airflow_worker_node_outage" {
  name       = "airflow_worker_node_outage"
  data       = file("${path.module}/data/airflow_worker_node_outage.json")
  depends_on = [shoreline_action.invoke_memory_cpu_threshold_check,shoreline_action.invoke_update_resources]
}

resource "shoreline_file" "memory_cpu_threshold_check" {
  name             = "memory_cpu_threshold_check"
  input_file       = "${path.module}/data/memory_cpu_threshold_check.sh"
  md5              = filemd5("${path.module}/data/memory_cpu_threshold_check.sh")
  description      = "Insufficient resources on the Airflow worker node, leading to memory or CPU exhaustion."
  destination_path = "/agent/scripts/memory_cpu_threshold_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_resources" {
  name             = "update_resources"
  input_file       = "${path.module}/data/update_resources.sh"
  md5              = filemd5("${path.module}/data/update_resources.sh")
  description      = "If the issue persists, consider increasing the resources allocated to the worker node, such as CPU, memory, or disk space."
  destination_path = "/agent/scripts/update_resources.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_memory_cpu_threshold_check" {
  name        = "invoke_memory_cpu_threshold_check"
  description = "Insufficient resources on the Airflow worker node, leading to memory or CPU exhaustion."
  command     = "`chmod +x /agent/scripts/memory_cpu_threshold_check.sh && /agent/scripts/memory_cpu_threshold_check.sh`"
  params      = ["MEMORY_THRESHOLD","CPU_THRESHOLD"]
  file_deps   = ["memory_cpu_threshold_check"]
  enabled     = true
  depends_on  = [shoreline_file.memory_cpu_threshold_check]
}

resource "shoreline_action" "invoke_update_resources" {
  name        = "invoke_update_resources"
  description = "If the issue persists, consider increasing the resources allocated to the worker node, such as CPU, memory, or disk space."
  command     = "`chmod +x /agent/scripts/update_resources.sh && /agent/scripts/update_resources.sh`"
  params      = ["NODE_ID","NEW_CPU_COUNT","NEW_DISK_SIZE","NEW_MEMORY_SIZE"]
  file_deps   = ["update_resources"]
  enabled     = true
  depends_on  = [shoreline_file.update_resources]
}

