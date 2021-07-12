variable "region" {
    default = "us-west-2"
}

variable "vpc_id" {
    default = "	vpc-ae4e2dd3"
}

variable "vpc_cidr" {
    default = "172.31.0.0/16" #seems like the default VPC cidr is always the same? 
}

variable "subnets_cidr" {
    default = [
    "172.31.64.0/20", 
    "172.31.16.0/20", 
    "172.31.48.0/20", 
    "172.31.80.0/20", 
    "172.31.32.0/20",
    "172.31.0.0/20"
    ]
}