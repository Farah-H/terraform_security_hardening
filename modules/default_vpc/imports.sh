# import vpc
terraform import module.delete_default_vpc.aws_vpc.default vpc-2ce2da54

# import subnets
terraform import module.delete_default_vpc.aws_subnet.default_1 subnet-5e465975
terraform import module.delete_default_vpc.aws_subnet.default_2 subnet-c6bf098c
terraform import module.delete_default_vpc.aws_subnet.default_3 subnet-ebf99db6
terraform import module.delete_default_vpc.aws_subnet.default_4 subnet-1044d168
terraform import module.delete_default_vpc.aws_subnet.default_5 subnet-1044d168
terraform import module.delete_default_vpc.aws_subnet.default_6 subnet-1044d168

# import igw
terraform import module.delete_default_vpc.aws_internet_gateway.default igw-10533e69
#terraform apply -auto-approve
