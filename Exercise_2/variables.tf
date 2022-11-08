# TODO: Define the variable for aws_region
variable "access_key_var" {
    type = string
    default = ""
}

variable "secret_key_var" {
    type = string
    default = ""
}

variable "region_var" {
    type = string
    default = "us-east-1"
}

variable "lambda_name" {
  default = "greet_lambda"
}

variable "lambda_source_output_path" {
  default = "output.zip"
}