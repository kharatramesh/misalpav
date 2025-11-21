resource "aws_lambda_function" "example" {
  function_name = "example_lambda_function1"
  role          = data.aws_iam_role.rolel1.arn
  handler       = "index.handler"
  runtime       = "nodejs22.x"
  #filename      = "index.js"

  source_code_hash = data.archive_file.example1.output_base64sha256
  filename         = data.archive_file.example1.output_path

  environment {
    variables = {
      ENV_VAR = "123"
    }
  }
}


data "aws_iam_role" "rolel1" {
  name = "rolel1"
}

data "archive_file" "example1" {
  type        = "zip"
  source_file = "${path.module}/index.js"
  output_path = "${path.module}/function.zip"
}

===========================================
touch index.js
=================
exports.handler = async (event) => {
    return {
        statusCode: 200,
        body: JSON.stringify('Hello World111'),
    };
};

