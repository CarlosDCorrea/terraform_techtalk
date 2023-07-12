#IAM===================================================================
resource "aws_iam_role" "my_tf_tech_talk_lambda_execution_role" {
  name = var.iam_lambda_execution_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

#Glue
resource "aws_iam_role" "my_tf_tech_talk_glue_job_execution_role" {
  name = var.iam_glue_execution_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      },
    ]
  })
}

#Execution role policies for lambda=========================================
resource "aws_iam_role_policy" "cloud_watch_policy" {
  name = var.iam_lambda_execution_role_log_policy_name
  role = aws_iam_role.my_tf_tech_talk_lambda_execution_role.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "s3_landing_policy" {
  name = var.iam_lambda_execution_role_s3_landing_policy_name
  role = aws_iam_role.my_tf_tech_talk_lambda_execution_role.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : [
            "s3:GetObject",
            "s3:DeleteObject"
          ],
          "Resource" : "${aws_s3_bucket.tf_tech_talk_landing_bucket.arn}/${var.s3_landing_object_name}*"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "s3_metrics_lambda_policy" {
  name = var.iam_lambda_execution_role_s3_metrics_lambda_policy_name
  role = aws_iam_role.my_tf_tech_talk_lambda_execution_role.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : [
            "s3:PutObject",
            "s3:DeleteObject"
          ],
          "Resource" : "${aws_s3_bucket.tf_tech_talk_metrics_bucket.arn}/*"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "s3_raw_policy" {
  name = var.iam_lambda_execution_role_s3_raw_policy_name
  role = aws_iam_role.my_tf_tech_talk_lambda_execution_role.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : [
            "s3:PutObject",
            "s3:ListBucket",
            "s3:DeleteObject"
          ],
          "Resource" : [
            "${aws_s3_bucket.tf_tech_talk_raw_bucket.arn}",
            "${aws_s3_bucket.tf_tech_talk_raw_bucket.arn}/*"
          ]
        }
      ]
    }
  )
}

#Execution role policies for glue=========================================
resource "aws_iam_role_policy" "cloud_watch_glue_policy" {
  name = var.iam_glue_execution_role_log_policy_name
  role = aws_iam_role.my_tf_tech_talk_glue_job_execution_role.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "s3_metrics_glue_policy" {
  name = var.iam_lambda_execution_role_s3_metrics_glue_policy_name
  role = aws_iam_role.my_tf_tech_talk_glue_job_execution_role.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : [
            "s3:GetObject",
          ],
          "Resource" : "${aws_s3_bucket.tf_tech_talk_metrics_bucket.arn}/*"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "glue_policy" {
  name = var.iam_glue_execution_role_policy_name
  role = aws_iam_role.my_tf_tech_talk_glue_job_execution_role.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : [
            "glue:SearchTables",
            "glue:BatchCreatePartition",
            "glue:UpdateDatabase",
            "glue:CreatePartitionIndex",
            "glue:CreateTable",
            "glue:GetTables",
            "glue:GetPartitions",
            "glue:BatchDeletePartition",
            "glue:UpdateTable",
            "glue:BatchGetPartition",
            "glue:UpdateSchema",
            "glue:GetDatabases",
            "glue:GetPartitionIndexes",
            "glue:GetSchema",
            "glue:GetTable",
            "glue:GetDatabase",
            "glue:GetPartition",
            "glue:DeletePartitionIndex",
            "glue:CreateDatabase",
            "glue:CreateSchema",
            "glue:CreatePartition",
            "glue:DeletePartition",
            "glue:UpdatePartition"
          ],
          "Resource" : [
            "*"
          ]
        }
      ]
  })
}

resource "aws_iam_role_policy" "s3_glue_policy" {
  name = var.iam_glue_execution_role_s3_glue_policy_name
  role = aws_iam_role.my_tf_tech_talk_glue_job_execution_role.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : "s3:GetObject",
          "Resource" : "${aws_s3_bucket.tf_tech_talk_glue_bucket.arn}/*"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "lakeformation_policy" {
  name = var.iam_glue_execution_role_lakeformation_policy_name
  role = aws_iam_role.my_tf_tech_talk_glue_job_execution_role.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : [
            "lakeformation:BatchGrantPermissions",
            "lakeformation:GrantPermissions",
            "lakeformation:AddLFTagsToResource"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}