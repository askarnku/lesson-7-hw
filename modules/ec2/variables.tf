variable "subnet_ids" {
  type = list(string)
}

variable "ami" {
  type        = string
  default     = null
  description = "AMI ID for instance, defaults to latest if not specified"
}

variable "instance_type" {

}

variable "ec2_tag" {

}

variable "user_data" {
  type    = string
  default = ""
}

variable "security_groups" {
  type = list(any)
}

variable "key_name" {

}



