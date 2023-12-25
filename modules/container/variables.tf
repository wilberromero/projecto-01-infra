variable "subnet_public_1_id_from_networking_module" {
    description = "Id de la subnet 1 del mudulo de networking"
}

variable "subnet_public_2_id_from_networking_module" {
    description = "Id de la subnet 2 del mudulo de networking"
}

variable "aws_security_group_id_from_networking_module" {
    description = "Id del grupo de seguridad del mudulo de networking"
}

variable "ecs_task_execution_role_arn_from_iamrole_module" {
    description = "Arn del rol de IAM para la ejecucion de tareas de ECS"
}
