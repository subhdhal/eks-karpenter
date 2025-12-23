variable "cidr_block"{
    description = "CIDR block for the VPC"
    type = string
}
variable "vpc_name"{
    description = "Name for the VPC"
    type = string
}
variable "tags"{
    description = "Tags for the VPC"
    type = map(string)
    default = {}
}
variable "az_count"{
    description = "Number of availability zones"
    type =  number
    default = 2
}
variable "public_subnet_count"{
    description = "Number of public subnets"
    type = number
    default = 2
}
variable "private_subnet_count"{
    description = "Number of private subnets"
    type = number
    default = 2
}