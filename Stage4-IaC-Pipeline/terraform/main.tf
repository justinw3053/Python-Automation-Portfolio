# This block configures Terraform to use AWS as the cloud provider.
provider "aws" {
  region = "eu-central-1" # Or your specified AWS region
}

# This resource creates an ECS cluster, a logical grouping for our services.
resource "aws_ecs_cluster" "my_flask_app_cluster" {
  name = "my-flask-app-cluster"
}

# This resource defines the ECS Task Definition, which is a blueprint for our application.
resource "aws_ecs_task_definition" "my_flask_app_task" {
  family = "my-flask-app-task"
  # This tells ECS to use the Fargate launch type, a serverless compute engine.
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  # This is a JSON string that defines the container itself.
  container_definitions = jsonencode([
    {
      name      = "my-flask-app-container"
      image     = var.ecr_image_uri
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
    }
  ])
}

# This resource creates the ECS Service. The service is responsible for
# running and maintaining a specified number of instances of our task definition.
resource "aws_ecs_service" "my_flask_app_service" {
  name            = "my-flask-app-service"
  cluster         = aws_ecs_cluster.my_flask_app_cluster.id
  task_definition = aws_ecs_task_definition.my_flask_app_task.arn
  # We set the desired count to 1, meaning we want one instance of our application running.
  desired_count   = 1
  # We specify the launch type as Fargate.
  launch_type     = "FARGATE"
}