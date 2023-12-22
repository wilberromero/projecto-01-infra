resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "MainVpc"
    }
}

resource "aws_subnet" "public_subnet_1" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidr
    availability_zone = var.availability_zone
    map_public_ip_on_launch = true
    tags = {
        Name = "PublicSubnet1"
    }
}

resource "aws_subnet" "public_subnet_2" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidr_2
    availability_zone = var.availability_zone_2
    map_public_ip_on_launch = true
    tags = {
        Name = "PublicSubnet2"
    }
}

# Crear un gateway de internet
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "InternetGateway"
    }
}


# Crear tabla de rutas 
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
    tags = {
        Name = "PublicRouteTable"
    }
}

# Asociar la subred publica a la tabla de rutas y agregar una ruta al gateway de internet
resource "aws_route_table_association" "public_route_association" {
    subnet_id = aws_subnet.public[0].id
    route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "example" {
    name = "example_security_group"
    description = "Allow inbound traffic"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port    = 80
        to_port      = 80
        protocol     = "tcp"
        cidr_blocks  =["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks =["0.0.0.0/0"]
    }
}
