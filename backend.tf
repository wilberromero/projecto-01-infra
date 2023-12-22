# configurar el backend de Terraform para almacenar el tfstate en s3. 
terraform {
    backend "s3" {
        bucket = "example-infra23"
        key    = "terraform.tfstate"
        region = "us-east-1"
        access_key = "AKIAVXLCKSOAGNQYMXZN"
        secret_key = "wZ3Qn8nq6JRYo69X9MLPr98L+jqc38iegbpUzpqH"
    }
}