
#crear un ECS Cluster
resource "aws_ecs_cluster" "my_cluster" {
    name = "my_cluster"
}

#crear un Ecr repositorio
resource "aws_ecr_repository" "my_ecr_repo" {
    name = "my-container-repo"
}

# Definicion de tareas
resource "aws_ecs_task_definition" "example_task" {
    family                   = "example_task"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = 256
    memory                   = 512

    container_definitions = jsonencode([{
      name  = "example-container"
      image = aws_ecr_repository.my_ecr_repo.repository_url
      portMappings = [{
        containerPort = 80
        hostPort      = 80
      }]
    }])
}


# Servicio ECS
resource "aws_ecs_service" "example_service" {
  name            = "example-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.example_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = [var.subnet_public_1_id_from_networking_module,var.subnet_public_2_id_from_networking_module]
    security_groups = [var.aws_security_group_id_from_networking_module]
  }

}