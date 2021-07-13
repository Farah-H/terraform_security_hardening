export TF_VAR_region="your-selected-region"

# import vpc
terraform import module.delete_default_vpc.aws_vpc.default "your-vpc-id"

# import subnets
terraform import module.delete_default_vpc.aws_subnet.default_1 "your-subnet-ids"
# terraform import module.delete_default_vpc.aws_subnet.default_2 "your-subnet-ids"
# terraform import module.delete_default_vpc.aws_subnet.default_3 "your-subnet-ids"
# terraform import module.delete_default_vpc.aws_subnet.default_4 "your-subnet-ids"
# terraform import module.delete_default_vpc.aws_subnet.default_5 "your-subnet-ids"
# terraform import module.delete_default_vpc.aws_subnet.default_6 "your-subnet-ids"

# import igw
terraform import module.delete_default_vpc.aws_internet_gateway.default "your-igw-id"

terraform apply