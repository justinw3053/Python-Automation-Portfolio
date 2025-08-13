# This block configures Terraform to use AWS as the cloud provider.
provider "aws" {
  region = "eu-central-1" # Or your specified AWS region
}

# --- CRITICAL: Terraform S3 Backend Configuration ---
# This configures Terraform to store its state file remotely in an S3 bucket.
# This is crucial for CI/CD pipelines and collaborative environments,
# ensuring state is persistent and accessible from multiple locations.
terraform {
  backend "s3" {
    bucket         = "justinw3053-terraform-state-bucket" # <<< IMPORTANT: REPLACE with YOUR unique S3 bucket name
    key            = "my-flask-app/terraform.tfstate" # Path to the state file within the bucket
    region         = "eu-central-1"                 # Same region as your bucket
    dynamodb_table = "my-flask-app-terraform-locks" # <<< IMPORTANT: REPLACE with YOUR unique DynamoDB table name
    encrypt        = true                           # Encrypt the state file at rest
  }
}

# --- ECR Repository for our Docker image ---
# This resource creates the Elastic Container Registry (ECR) repository
# where our Docker image will be stored.
resource "aws_ecr_repository" "my_flask_app_repo" {
  name = "my-flask-app"
  # force_delete = true # Consider removing this in production to prevent accidental deletion
}


# --- VPC for our ECS cluster ---
# This creates a Virtual Private Cloud (VPC), which acts as a virtual network
# isolated from other AWS networks. All our resources will reside within this VPC.
resource "aws_vpc" "my_flask_app_vpc" {
  cidr_block = "10.0.0.0/16" # Defines the IP address range for the VPC
  tags = {
    Name = "my-flask-app-vpc"
  }
}

# --- Subnets within the VPC ---
# We create two public subnets in different Availability Zones (AZs) for high availability.
# ECS tasks will be deployed into these subnets.
resource "aws_subnet" "my_flask_app_subnet_1" {
  vpc_id            = aws_vpc.my_flask_app_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a" # Example AZ, adjust as per your region
  map_public_ip_on_launch = true # Allows tasks in this subnet to get public IPs
  tags = {
    Name = "my-flask-app-subnet-1"
  }
}

resource "aws_subnet" "my_flask_app_subnet_2" {
  vpc_id            = aws_vpc.my_flask_app_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b" # Example AZ, adjust as per your region
  map_public_ip_on_launch = true
  tags = {
    Name = "my-flask-app-subnet-2"
  }
}

# --- Internet Gateway for public internet access ---
# An Internet Gateway is attached to the VPC to enable communication between
# instances in the VPC and the internet.
resource "aws_internet_gateway" "my_flask_app_igw" {
  vpc_id = aws_vpc.my_flask_app_vpc.id
  tags = {
    Name = "my-flask-app-igw"
  }
}

# --- Route Table and Route to Internet Gateway ---
# This route table defines how network traffic is routed within the VPC.
# We add a default route (0.0.0.0/0) to the Internet Gateway, allowing outbound traffic.
resource "aws_route_table" "my_flask_app_route_table" {
  vpc_id = aws_vpc.my_flask_app_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_flask_app_igw.id
  }
  tags = {
    Name = "my-flask-app-route-table"
  }
}

# --- Associate Route Table with Subnets ---
# We associate our public subnets with the route table to ensure they can access the internet.
resource "aws_route_table_association" "my_flask_app_rta_subnet_1" {
  subnet_id      = aws_subnet.my_flask_app_subnet_1.id
  route_table_id = aws_route_table.my_flask_app_route_table.id
}

resource "aws_route_table_association" "my_flask_app_rta_subnet_2" {
  subnet_id      = aws_subnet.my_flask_app_subnet_2.id
  route_table_id = aws_route_table.my_flask_app_route_table.id
}


# --- Security Group for ECS Tasks ---
# This security group acts as a virtual firewall, controlling inbound and outbound traffic
# to the ECS tasks. We allow inbound traffic on port 5000 (our Flask app's port) from anywhere.
resource "aws_security_group" "my_flask_app_sg" {
  name        = "my-flask-app-sg"
  description = "Allow inbound traffic on Flask app port and all outbound traffic"
  vpc_id      = aws_vpc.my_flask_app_vpc.id

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow from all IPs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow to all IPs
  }

  tags = {
    Name = "my-flask-app-sg"
  }
}

# This resource creates an ECS cluster, a logical grouping for our services.
resource "aws_ecs_cluster" "my_flask_app_cluster" {
  name = "my-flask-app-cluster"
}

# This resource defines the ECS Task Definition, which is a blueprint for our application.
resource "aws_ecs_task_definition" "my_flask_app_task" {
  family                   = "my-flask-app-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

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

# This resource creates an IAM role for ECS Task Execution.
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

# This attaches a managed policy to the IAM role.
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# This resource creates the ECS Service.
resource "aws_ecs_service" "my_flask_app_service" {
  name            = "my-flask-app-service"
  cluster         = aws_ecs_cluster.my_flask_app_cluster.id
  task_definition = aws_ecs_task_definition.my_flask_app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  # This block specifies the subnets and security groups for the ECS tasks.
  network_configuration {
    subnets         = [aws_subnet.my_flask_app_subnet_1.id, aws_subnet.my_flask_app_subnet_2.id]
    security_groups = [aws_security_group.my_flask_app_sg.id]
    assign_public_ip = true # Assigns a public IP to the task ENI
  }
}