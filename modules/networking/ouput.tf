output "subnet_public_1" {
    value = aws_subnet.public_subnet_1.id
}

output "subnet_public_2" {
    value = aws_subnet.public_subnet_2.id
}

output "vpc_id" {
    value = aws_vpc.main.id
}

output "aws_internet_gateway" {
    value = aws_internet_gateway.gw.id
}

output "aws_security_group" {
    value = aws_security_group.example.id
}

output "aws_cloudfront_distribution" {
    value = aws_cloudfront_distribution.my_distribution.arn
}

output "oai_arn" {
    value = ${split(':', aws_cloudfront_origin_access_identity.mi_oai.cloudfront_access_identity_path)[5]}"
}

