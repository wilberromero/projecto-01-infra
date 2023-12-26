
variable "vpc_cidr" {
    description = "CIDR block para la vpc"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    default     = "10.0.0.0/24"
    type        = string
    description = "List of public subnet CIDR blocks"
}

variable "public_subnet_cidr_2" {
    default     = "10.0.3.0/24"
    type        = string
    description = "List of public subnet CIDR blocks"
}

variable "availability_zone" {
    description = "zona de disponibilidad"
    default = "us-east-1a"
}

variable "availability_zone_2" {
    description = "zona de disponibilidad"
    default = "us-east-1b"
}

variable "aws_bucket_id_from_networking_module" {
    description = "Id del bucket s3"
}