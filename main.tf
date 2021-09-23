# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

provider "archive" {}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "DiceRoll_Simulation_lambda.py"
  output_path = "DiceRoll_Simulation_lambda.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name = "DiceRoll_Simulation_lambda"

  filename         = "${data.archive_file.zip.output_path}"
  source_code_hash = "${data.archive_file.zip.output_base64sha256}"

  role    = "${aws_iam_role.iam_dice_post_lambda_role.arn}"
  handler = "DiceRoll_Simulation_lambda.lambda_handler"
  runtime = "python3.8"
}

data "archive_file" "zip1" {
  type        = "zip"
  source_file = "DiceRoll_GetData_lambda.py"
  output_path = "DiceRoll_GetData_lambda.zip"
}
resource "aws_lambda_function" "lambda2" {
  function_name = "DiceRoll_GetData_lambda"

  filename         = "${data.archive_file.zip1.output_path}"
  source_code_hash = "${data.archive_file.zip1.output_base64sha256}"

  role    = "${aws_iam_role.iam_dice_post_lambda_role.arn}"
  handler = "DiceRoll_GetData_lambda.lambda_handler"
  runtime = "python3.8"
}

