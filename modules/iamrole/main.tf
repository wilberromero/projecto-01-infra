
resource "aws_iam_policy" "ecs_task_execution_policy" {
    name = "ecs-task-execution-policy"

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                    Effect    = "Allow",              
                    Action = [
                        "iam:GetRole",
                        "iam:GetRolePolicy",
                        "iam:PassRole",
                        "iam:DetachRolePolicy",
                        "iam:DeleteRolePolicy",
                        "iam:DeleteRole",
                        "iam:CreateRole",
                        "iam:AttachRolePolicy",
                        "iam:PutRolePolicy"
                    ],
                    Resource = "*"
            }
        ]
    })    
}

resource "aws_iam_role" "ecs_task_execution_role" {
    name = "ecs-task-execution-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect    = "Allow",
                Principal = {
                    Service = "ecs-tasks.amazonaws.com"
                },
                Action  = "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attachment" {
    role = aws_iam_role.ecs_task_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEcsTaskExecutionRolePolicy"
}

resource "aws_iam_policy_attachment" "attachment_policy_to_ecs_role" {
    name = "attach_policy_to_ecs_role"
    roles = [aws_iam_role.ecs_task_execution_role.name]
    policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
}

