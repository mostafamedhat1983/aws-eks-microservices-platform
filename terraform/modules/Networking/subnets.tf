resource "aws_subnet" "eks_subnets" {
  for_each          = var.eks_subnets
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone


  tags = {
    Name = each.value.name
  }
}