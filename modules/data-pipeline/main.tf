locals {
  # Logika związana z dag_bucket_name usunięta, ponieważ module.composer jest wyłączony
  # dag_bucket_name_levels = split("/", var.dag_bucket_name)
  # dag_bucket_name_length = length(local.dag_bucket_name_levels)
  # dag_folder             = element(local.dag_bucket_name_levels, local.dag_bucket_name_length - 1)
  # dag_bucket_name        = element(local.dag_bucket_name_levels, 2)

  # Musimy użyć 'dummy' wartości, aby reszta kodu się nie załamała, 
  # jeśli wciąż używa tych zmiennych. Najlepiej usunąć zależności.
  # Ponieważ zasoby Google Storage Bucket Object poniżej używają lokalnej zmiennej dag_bucket_name,
  # jeśli jej nie usuniemy, błąd się powtórzy.
}


resource "google_storage_bucket" "tbd-code-bucket" {
  project                     = var.project_name
  name                        = var.bucket_name
  location                    = var.region
  uniform_bucket_level_access = false #tfsec:ignore:google-storage-enable-ubla
  force_destroy               = true
  versioning {
    enabled = true
  }

  #checkov:skip=CKV_GCP_62: "Bucket should log access"
  #checkov:skip=CKV_GCP_29: "Ensure that Cloud Storage buckets have uniform bucket-level access enabled"
  #checkov:skip=CKV_GCP_78: "Ensure Cloud storage has versioning enabled"
  public_access_prevention = "enforced"
}

/*
# ZAKOMENTOWANY: Ten zasób IAM był wymagany dla Service Account Composera, 
# które jest teraz nieobecne w var.data_service_account.
resource "google_storage_bucket_iam_member" "tbd-code-bucket-iam-viewer" {
  bucket = google_storage_bucket.tbd-code-bucket.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${var.data_service_account}"
}
*/

resource "google_storage_bucket_object" "job-code" {
  for_each = toset(["spark-job.py"])
  bucket   = google_storage_bucket.tbd-code-bucket.name
  name     = each.value
  source   = "${path.module}/resources/${each.value}"
}

/*
# ZAKOMENTOWANY: Zasób odpowiedzialny za upload DAG-a, 
# który trafiał do bucketu zarządzanego przez Composera (local.dag_bucket_name).
resource "google_storage_bucket_object" "dag-code" {
  for_each = toset(["data-dag.py"])
  bucket   = local.dag_bucket_name # Zmienna lokalna oparta o var.dag_bucket_name
  name     = "${local.dag_folder}/${each.value}" # Zmienna lokalna oparta o var.dag_bucket_name
  source   = "${path.module}/resources/${each.value}"
}
*/


resource "google_storage_bucket" "tbd-data-bucket" {
  project                     = var.project_name
  name                        = var.data_bucket_name
  location                    = var.region
  uniform_bucket_level_access = false #tfsec:ignore:google-storage-enable-ubla
  force_destroy               = true
  public_access_prevention    = "enforced"
  versioning {
    enabled = true
  }
}

/*
# ZAKOMENTOWANY: Ten zasób IAM był wymagany dla Service Account Composera, 
# które jest teraz nieobecne w var.data_service_account.
resource "google_storage_bucket_iam_member" "tbd-data-bucket-iam-editor" {
  bucket = google_storage_bucket.tbd-data-bucket.name
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${var.data_service_account}"
}
*/

/*
# ZAKOMENTOWANY: Zasób odpowiedzialny za upload DAG-a dbt, 
# który trafiał do bucketu zarządzanego przez Composera (local.dag_bucket_name).
resource "google_storage_bucket_object" "dbt-dag-code" {
  for_each = toset(["dbt-dag.py"])
  bucket   = local.dag_bucket_name # Zmienna lokalna oparta o var.dag_bucket_name
  name     = "${local.dag_folder}/${each.value}" # Zmienna lokalna oparta o var.dag_bucket_name
  source   = "${path.module}/resources/${each.value}"
}
*/