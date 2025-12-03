variable "project_name" {
  type        = string
  description = "Project name"
}

variable "region" {
  type        = string
  default     = "europe-west1"
  description = "GCP region"
}

variable "bucket_name" {
  type        = string
  description = "Bucket for storing data pipeline additional code"
}

# variable "data_service_account" {
#   type = string
#   # ... (inne definicje)
#   # required = true  <-- Usuń lub zakomentuj
#   default = "" # Dodaj tę linię, aby były opcjonalne
# }

# variable "dag_bucket_name" {
#   type = string
#   # ... (inne definicje)
#   # required = true  <-- Usuń lub zakomentuj
#   default = "" # Dodaj tę linię, aby były opcjonalne
# }

variable "data_bucket_name" {
  type        = string
  description = "Apache Airflow bucket for storing and processing data"
}
