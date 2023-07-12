resource "aws_s3_bucket" "tf_tech_talk_landing_bucket" {
  bucket        = var.s3_landing_bucket_name
  force_destroy = true


  tags = {
    Name        = "My bucket"
    Environment = var.environment
  }
}

resource "aws_s3_object" "tf_tech_talk_landing_bucket_object_folder" {
  key    = var.s3_landing_object_name
  bucket = aws_s3_bucket.tf_tech_talk_landing_bucket.id
}

resource "aws_s3_bucket" "tf_tech_talk_metrics_bucket" {
  bucket        = var.s3_metrics_bucket_name
  force_destroy = true

  tags = {
    Name        = "My bucket"
    Environment = var.environment
  }
}

#===============================================================
resource "aws_s3_bucket" "tf_tech_talk_raw_bucket" {
  bucket        = var.s3_raw_bucket_name
  force_destroy = true


  tags = {
    Name        = "My bucket"
    Environment = var.environment
  }
}

#===============================================================
resource "aws_s3_bucket" "tf_tech_talk_glue_bucket" {
  bucket        = var.s3_glue_bucket_name
  force_destroy = true

  tags = {
    Name        = "My bucket"
    Environment = var.environment
  }
}

resource "aws_s3_object" "tf_tech_talk_glue_bucket_object" {
  key    = var.s3_glue_object_name
  bucket = aws_s3_bucket.tf_tech_talk_glue_bucket.id
  source = var.s3_glue_object_name
}

#===============================================================
resource "aws_s3_bucket" "tf_tech_talk_athena_queries_bucket" {
  bucket        = var.s3_athena_queries_bucket_name
  force_destroy = true

  tags = {
    Name        = "My bucket"
    Environment = var.environment
  }
}

resource "aws_s3_object" "tf_tech_talk_athena_queries_object_folder" {
  key    = var.s3_athena_queries_object_name
  bucket = aws_s3_bucket.tf_tech_talk_athena_queries_bucket.id
}