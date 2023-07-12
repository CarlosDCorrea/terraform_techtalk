#LAMBDA
data "archive_file" "my_tf_tech_talk_lambda_source_code" {
  type        = "zip"
  source_file = "lambda_code.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "my_tf_tech_talk_lambda_function" {
  filename      = "lambda_function_payload.zip"
  function_name = var.lambda_name
  role          = aws_iam_role.my_tf_tech_talk_lambda_execution_role.arn
  handler       = "lambda_code.lambda_handler"

  source_code_hash = data.archive_file.my_tf_tech_talk_lambda_source_code.output_base64sha256
  runtime          = "python3.10"

  timeout = 60
}