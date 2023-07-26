provider "aws" {
  # デプロイしたいリージョンに適宜変更してください
  region = "ap-northeast-1"
}

variable "SLACK_SIGNING_SECRET" {
  type    = string
  default = "nothing"
}

variable "SLACK_BOT_TOKEN" {
  type    = string
  default = "nothing"
}

data "archive_file" "sample_function" {
  type        = "zip"
  source_dir  = "dist/js"
  output_path = "dist/index.js.zip"
}

# Lambda関数を作成
resource "aws_lambda_function" "lambda" {
  # ユニークな関数名を指定してください
  function_name = "nexe"
  role          = aws_iam_role.lambda_exec_role_attach_policy.arn
  # Node.jsランタイムを指定します
  runtime       = "nodejs18.x"
  # ハンドラは「ファイル名.エクスポート関数名」の形式で指定します
  handler       = "index.honi"
  # ZIPファイルのSHA256ハッシュ
  source_code_hash = "${data.archive_file.sample_function.output_base64sha256}"
  # アップロードする zip ファイルパス
  filename  = "${data.archive_file.sample_function.output_path}"

  environment {
    variables = {
      SLACK_BOT_TOKEN = "${var.SLACK_BOT_TOKEN}"
      SLACK_SIGNING_SECRET = "${var.SLACK_SIGNING_SECRET}"
    }
  }
}

# Lambda関数に対するIAMロールを作成
resource "aws_iam_role" "lambda_exec_role_attach_policy" {
  name = "lambda-nexe-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Lambda関数にS3バケットへのアクセスを許可するIAMポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "lambda_s3_access" {
  # 適切なポリシーARNを指定してください
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_exec_role_attach_policy.name
}

resource "aws_lambda_function_url" "aws_lambda_function_url" {
  function_name      = aws_lambda_function.lambda.function_name
  authorization_type = "NONE"
}
