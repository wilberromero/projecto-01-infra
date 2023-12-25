resource "aws_iam_role" "ecs_task_execution_role" {
    name = "ecs-task-execution-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect    = "Allow"
                Principal = {
                    Service = "ecs-tasks.amazonaws.com"
                },
                Action  = "sts:AssumeRole"
            }
        ]
    })

    inline_policy {
        name = "ecs-ecs_task_execution_policy"

        policy = jsonencode({
            Version = "2012-10-17"
            Statement = [
                {
                    Effect    = "Allow"                    
                    Action  = "iam:CreateRole"
                    Resource = "arn:aws:iam::393732592512:role/*"
                }
            ]
        })
    }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attachment" {
    role = aws_iam_role.ecs_task_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEcsTaskExecutionRolePolicy"
}