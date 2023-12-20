variable "access_key" { 
  default     = "AKIAVXLCKSOAGNQYMXZN"
}

variable "secret_key" {
  default     = "wZ3Qn8nq6JRYo69X9MLPr98L+jqc38iegbpUzpqH"
}

variable "region" {
  description = "Región de AWS"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
    description = "CIDR block para la vpc"
    default = "10.0.0.0/24"
}

variable "public_subnet_cidr" {
    description = "CIDR block para la subnet"
    default = "10.1.2.0/24"
}

variable "public_subnet_cidr2" {
    description = "CIDR block para la subnet"
    default = "10.1.3.0/24"
}

variable "availability_zone" {
    description = "zona de disponibilidad"
    default = "us-east-1a"
}

variable "availability_zone_2" {
    description = "zona de disponibilidad"
    default = "us-east-1b"
}
