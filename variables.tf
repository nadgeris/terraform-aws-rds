variable "subnet_ids" {
    type = list
    default = []
}

variable "name" {
    type = string
    default = ""
}

variable "vpc_cidr" {
    type = string
    default = "" 
}
variable "vpc_id" {
    type = string
    default = ""
  
}
variable "instance_type" {
    type = string
    default = "db.t3.micro" 
}