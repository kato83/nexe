# NEXE

## SETUP

### 1. AWS CLI

```shell
$ docker run --rm -it amazon/aws-cli:latest --version
aws-cli/2.13.2 Python/3.11.4 Linux/5.10.16.3-microsoft-standard-WSL2 docker/x86_64.amzn.2 prompt/off
# aws cli の設定
$ docker run --rm -it -v $(pwd)/.aws:/root/.aws amazon/aws-cli:latest configure
```

### 2. Terraform

```shell
# version 確認
$ docker run --rm -it -v $(pwd):/workpace -v ~/.aws:/root/.aws:ro -w /workpace hashicorp/terraform:latest -version
Terraform v1.5.3
on linux_amd64
# 初期化
$ docker run --rm -it -v $(pwd):/workpace -v $(pwd)/.aws:/root/.aws:ro -w /workpace hashicorp/terraform:latest init
# dry run
$ docker run --rm -it -v $(pwd):/workpace -v $(pwd)/.aws:/root/.aws:ro -w /workpace hashicorp/terraform:latest plan
# 適応
$ docker run --rm -it -v $(pwd):/workpace -v $(pwd)/.aws:/root/.aws:ro -w /workpace hashicorp/terraform:latest apply
```