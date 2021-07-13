
# this resource allows import of existing subnets so that terraform can manage them
# it is dynamic because number of subnets varies per region (up to 6)
# resource "aws_subnet" "default" {
#     count = length(var.subnets_cidr)
#     vpc_id = var.vpc_id
#     cidr_block = var.subnets_cidr[count.index]
# }
# can't get the above to work (requires terraform destroy which would ruin the rest of the architecture), doing it the long way for now. 

# creating configurations to allow import of existing infrastructure
resource "aws_vpc" "default" {
    count = 0
    cidr_block = var.vpc_cidr
}


resource "aws_subnet" "default_1" {
    count = 0
    vpc_id = aws_vpc.default[0].id
    cidr_block = var.subnets_cidr
}

resource "aws_subnet" "default_2" {
    count = 0
    vpc_id = aws_vpc.default[0].id
    cidr_block = var.subnets_cidr
}

resource "aws_subnet" "default_3" {
    count = 0
    vpc_id = aws_vpc.default[0].id
    cidr_block = var.subnets_cidr
}

resource "aws_subnet" "default_4" {
    count = 0
    vpc_id = aws_vpc.default[0].id
    cidr_block = var.subnets_cidr
}

resource "aws_subnet" "default_5" {
    count = 0
    vpc_id = aws_vpc.default[0].id
    cidr_block = var.subnets_cidr
}

resource "aws_subnet" "default_6" {
    count = 0
    vpc_id = aws_vpc.default[0].id
    cidr_block = var.subnets_cidr
}

resource "aws_internet_gateway" "default" {
    count = 0
}
