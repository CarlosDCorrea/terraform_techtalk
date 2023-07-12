#GLUE
resource "aws_glue_job" "my_tf_tech_talk_job_glue" {
  name     = var.glue_job_name
  role_arn = aws_iam_role.my_tf_tech_talk_glue_job_execution_role.arn

  command {
    script_location = "s3://${aws_s3_bucket.tf_tech_talk_glue_bucket.bucket}/job_glue_script.py"
    name            = "pythonshell"
    python_version  = "3.9"
  }
}