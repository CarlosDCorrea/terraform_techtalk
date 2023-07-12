variable "region_deploy" {
  description = "Region en donde se desplegara la infra"
  type = string
}

#S3===============================================================
variable "environment" {
  description = "Environment tag of the resource"
  type        = string
  default     = "Dev"
}

variable "s3_landing_bucket_name" {
  description = "Name of the bucket"
  type        = string
  default     = "tf-tech-talk-landing-bucket"
}

variable "s3_landing_object_name" {
  description = "Name of the object that is in the landing bucket"
  type        = string
  default     = "to_load/"
}

variable "s3_metrics_bucket_name" {
  description = "Name of the bucket"
  type        = string
  default     = "tf-tech-talk-metrics-bucket"
}

variable "s3_raw_bucket_name" {
  description = "Name of the bucket"
  type        = string
  default     = "tf-tech-talk-raw-bucket"
}

variable "s3_glue_bucket_name" {
  description = "Name of the bucket"
  type        = string
  default     = "tf-tech-talk-glue-bucket"
}

variable "s3_glue_object_name" {
  description = "Name of the bucket"
  type        = string
  default     = "job_glue_script.py"
}

variable "s3_athena_queries_bucket_name" {
  description = "Name of the bucket"
  type        = string
  default     = "tf-tech-talk-athena-queries-bucket"
}

variable "s3_athena_queries_object_name" {
  description = "Name of the bucket"
  type        = string
  default     = "output/"
}

#Lambda===============================================================
variable "lambda_name" {
  description = "Name of the lambda that transport the data"
  type        = string
  default     = "tf-tech-talk-lambda"
}

#IAM roles for lambda===============================================================
variable "iam_lambda_execution_role_name" {
  description = "Name of the bucket"
  type        = string
  default     = "tf-tech-talk-lambda-execution-rol"
}

variable "iam_lambda_execution_role_log_policy_name" {
  description = "Log policy for the lambda execution rol"
  type        = string
  default     = "log"
}

variable "iam_lambda_execution_role_s3_landing_policy_name" {
  description = "Log policy for the lambda execution rol"
  type        = string
  default     = "s3-landing"
}

variable "iam_lambda_execution_role_s3_metrics_lambda_policy_name" {
  description = "Log policy for the lambda and glue execution rol"
  type        = string
  default     = "s3-metrics"
}

variable "iam_lambda_execution_role_s3_raw_policy_name" {
  description = "Log policy for the lambda execution rol"
  type        = string
  default     = "s3-raw"
}

#Glue===============================================================
variable "glue_job_name" {
  description = "Name of the job glue that executes the etl process"
  type        = string
  default     = "tf-tech-talk-glue-job"
}

#IAM roles for glue===============================================================
variable "iam_glue_execution_role_name" {
  description = "Name of the bucket"
  type        = string
  default     = "tf-tech-talk-glue-execution-rol"
}

variable "iam_lambda_execution_role_s3_metrics_glue_policy_name" {
  description = "Log policy for the lambda and glue execution rol"
  type        = string
  default     = "s3-metrics"
}

variable "iam_glue_execution_role_log_policy_name" {
  description = "Log policy for the glue execution rol"
  type        = string
  default     = "log-glue"
}

variable "iam_glue_execution_role_policy_name" {
  description = "Log policy for the glue execution rol"
  type        = string
  default     = "glue-policy"
}

variable "iam_glue_execution_role_s3_glue_policy_name" {
  description = "Log policy for the glue execution rol"
  type        = string
  default     = "s3-glue-policy"
}

variable "iam_glue_execution_role_lakeformation_policy_name" {
  description = "Log policy for the glue execution rol"
  type        = string
  default     = "lakeformation-glue"
}
