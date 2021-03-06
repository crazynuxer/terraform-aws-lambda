variable "lambda_code_filename" {
  type        = "string"
  description = "Name of lambda code that contains the function in zip file"
}

variable "lambda_name" {
  type        = "string"
  description = "Lambda function name"
}

variable "lambda_description" {
  type        = "string"
  description = "Description of what the lambda does"
  default     = ""
}

variable "lambda_runtime" {
  type        = "string"
  description = "Runtime of the lambda"
}

variable "lambda_handler" {
  type        = "string"
  description = "Handler of the function"
}

variable "lambda_memory_size" {
  type        = "string"
  description = "Lambda memory size"
}

variable "lambda_timeout" {
  type        = "string"
  description = "Lambda timeout value"
}

variable "tags" {
  type        = "map"
  description = "Tags associated with the lambda"
  default     = {}
}

variable "environment_variables" {
  type        = "map"
  description = "Environment variables for the lambda"
  default     = {}
}

variable "iam_policy_document" {
  type        = "string"
  description = "Additional policy associated with the lambda"
}

variable "subnet_ids" {
  type        = "list"
  description = "Subnet ids associated with the lambda"
  default     = []
}

variable "security_group_ids" {
  type        = "list"
  description = "Security group ids associated with the lambda"
  default     = []
}

variable "environment" {
  type        = "string"
  description = "The environment where the lambda is running"
}

variable "product_domain" {
  type        = "string"
  description = "The product domain of the lambda"
}

variable "is_vpc_lambda" {
  type        = "string"
  description = "True of false to indicate whether this lambda is executed within VPC or not"
  default     = "true"
}
