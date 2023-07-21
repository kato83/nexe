provider "aws" {
  # デプロイしたいリージョンに適宜変更してください
  region = "ap-northeast-1"
}

# S3バケットを作成
resource "aws_s3_bucket" "lambda_bucket" {
  # ユニークなバケット名を指定してください
  bucket = "nexe-bucket"
}

# Lambda関数を作成
resource "aws_lambda_function" "example_lambda" {
  # ユニークな関数名を指定してください
  function_name = "nexe"
  role          = aws_iam_role.lambda_exec_role_attach_policy.arn
  # Node.jsランタイムを指定します
  runtime       = "nodejs18.x"
  # ハンドラは「ファイル名.エクスポート関数名」の形式で指定します
  handler       = "src/index.handler"
  # ZIPファイルのSHA256ハッシュ
  source_code_hash = filebase64sha256("dist/index.js.zip")

  # デプロイするコードのS3バケットとオブジェクトキーを指定します
  s3_bucket = aws_s3_bucket.lambda_bucket.bucket
  # ZIPファイルのオブジェクトキーを指定
  s3_key    = "index.js.zip"
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
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.lambda_exec_role_attach_policy.name
}
