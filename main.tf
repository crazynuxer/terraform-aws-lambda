module "lambda_role" {
  source = "github.com/crazynuxer/terraform-aws-iam-role//modules/lambda?ref=v0.5.1"

  product_domain   = "${var.product_domain}"
  descriptive_name = "${var.lambda_name}"
}

resource "aws_iam_role_policy_attachment" "lambda_basic_role" {
  role       = "${module.lambda_role.role_name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_eni_management" {
  role       = "${module.lambda_role.role_name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaENIManagementAccess"
  count      = "${var.is_vpc_lambda == "true" ? 1 : 0}"
}

resource "aws_iam_role_policy" "lambda_additional_policy" {
  name   = "${var.lambda_name}"
  role   = "${module.lambda_role.role_name}"
  policy = "${var.iam_policy_document}"
  count  = "${length(var.iam_policy_document) > 0 ? 1 : 0}"
}

module "random_id" {
  source = "github.com/crazynuxer/terraform-aws-resource-naming?ref=v0.6.0"

  name_prefix   = "${var.product_domain}-${var.lambda_name}"
  resource_type = "lambda_function"
}

locals {
  default_tags = {
    Name          = "${var.lambda_name}"
    Environment   = "${var.environment}"
    ProductDomain = "${var.product_domain}"
    Description   = "${var.lambda_description}"
    ManagedBy     = "Terraform"
  }
}

resource "aws_lambda_function" "lambda_classic" {
  filename      = "${var.lambda_code_filename}"
  function_name = "${module.random_id.name}"
  description   = "${var.lambda_description}"
  role          = "${module.lambda_role.role_arn}"
  runtime       = "${var.lambda_runtime}"
  handler       = "${var.lambda_handler}"
  memory_size   = "${var.lambda_memory_size}"
  timeout       = "${var.lambda_timeout}"

  tags = "${merge(local.default_tags, var.tags)}"

  environment = {
    variables = "${merge(var.environment_variables, map("ManagedBy", "Terraform"))}"
  }

  count = "${var.is_vpc_lambda == "true" ? 0 : 1}"
}

resource "aws_lambda_function" "lambda_vpc" {
  filename      = "${var.lambda_code_filename}"
  function_name = "${module.random_id.name}"
  description   = "${var.lambda_description}"
  role          = "${module.lambda_role.role_arn}"
  runtime       = "${var.lambda_runtime}"
  handler       = "${var.lambda_handler}"
  memory_size   = "${var.lambda_memory_size}"
  timeout       = "${var.lambda_timeout}"

  tags = "${merge(local.default_tags, var.tags)}"

  vpc_config {
    subnet_ids         = ["${var.subnet_ids}"]
    security_group_ids = ["${var.security_group_ids}"]
  }

  environment = {
    variables = "${merge(var.environment_variables, map("ManagedBy", "Terraform"))}"
  }

  count = "${var.is_vpc_lambda == "true" ? 1 : 0}"
}
