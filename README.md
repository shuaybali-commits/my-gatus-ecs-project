# Gatus ECS Deployment

A production-style deployment of [Gatus](https://github.com/TwiN/gatus) on **Amazon ECS Fargate**, provisioned with **Terraform** and automatically deployed using **GitHub Actions**.

The project covers the full deployment lifecycle: containerisation, AWS infrastructure, Infrastructure as Code, CI/CD, HTTPS, monitoring, and secure AWS authentication using OIDC.

**Application:** <https://tm.shuaybali.com>

## Overview

Gatus runs as a minimal ARM64 Docker container on ECS Fargate behind an Application Load Balancer, with Route 53 and ACM providing custom DNS and HTTPS.

The infrastructure is managed through modular Terraform with an S3 remote backend and state locking, while separate GitHub Actions workflows manage infrastructure changes and application deployments.

Key features include:

- Multi-stage `scratch` Docker image
- Amazon ECS Fargate and ECR
- Application Load Balancer with HTTP → HTTPS redirect
- Route 53 and ACM
- Modular Terraform with remote state and locking
- GitHub Actions with AWS OIDC authentication
- Commit SHA image tagging and automated ECS deployments
- Post-deployment `/health` verification
- CloudWatch monitoring with SNS alerts

## Architecture

The application runs on Amazon ECS Fargate across a multi-AZ network, behind an Application Load Balancer with HTTPS provided by ACM and Route 53.

![Gatus AWS Architecture](screenshots/architecture.png)

## Tech Stack

| Area                   | Technologies                             |
| ---------------------- | ---------------------------------------- |
| Application            | Gatus v5.7.0                             |
| Containerisation       | Docker, Buildx, ARM64                    |
| Cloud                  | AWS ECS Fargate, ECR, ALB, Route 53, ACM |
| Infrastructure as Code | Terraform, S3 Remote Backend             |
| CI/CD                  | GitHub Actions, AWS OIDC                 |
| Monitoring             | CloudWatch, SNS                          |
| Security               | IAM, Security Groups, HTTPS              |
| Quality                | Terraform fmt, validate, TFLint          |

## Infrastructure & Terraform

The AWS infrastructure is provisioned using **Terraform** and organised into reusable modules for clear separation of responsibilities.

Terraform provisions:

- Custom VPC with public and private subnets structured across two Availability Zones
- Application Load Balancer with HTTP → HTTPS redirect
- ECS Fargate cluster, service and task definition
- Amazon ECR repository
- Route 53 DNS record and ACM certificate
- IAM task execution and task roles
- Security groups for ALB and ECS traffic
- CloudWatch logging, CPU/memory alarms and SNS notifications

Terraform state is stored remotely in **Amazon S3** with state locking, allowing the same state to be safely used by both local Terraform commands and GitHub Actions.

Infrastructure changes are validated with `terraform fmt`, `terraform validate` and `tflint` before a plan is generated. Changes pushed to `main` are then automatically applied through the Terraform GitHub Actions workflow.

## CI/CD

Three GitHub Actions workflows isolate application deployment, infrastructure management, and controlled teardown. All AWS authentication is securely negotiated via **OpenID Connect (OIDC)**, eliminating the need for long-lived IAM access keys.

### Application Deployment

Triggered automatically by changes to the `GatusApp/` directory or invoked manually:

1. Builds the minimal multi-stage `scratch` Docker image for `linux/arm64` using QEMU and Buildx.
2. Tags the image with the unique Git commit SHA and pushes it to Amazon ECR.
3. Registers a new ECS task definition revision and deploys it to the Fargate service.
4. Monitors deployment events until the ECS service reaches stability.
5. Performs a live HTTP verification against the production `/health` endpoint to confirm success.

### Terraform Infrastructure

Triggered automatically by changes to the `terraform/` directory or invoked manually:

`fmt ──► init ──► validate ──► TFLint ──► plan ──► apply`

- **Pull Requests:** Execute formatting check, initialization, validation, linting, and generate a `terraform plan`.
- **Pushes to main:** Execute the full lifecycle pipeline, automatically executing `terraform apply` to roll out changes.

### Terraform Destroy

A strictly isolated, manually triggered workflow provides controlled infrastructure teardown to manage cloud costs. The execution process requires an explicit, case-sensitive `DESTROY` text input confirmation before executing `terraform destroy`.

## Pipeline Evidence

![Application Deployment](screenshots/application-deployment-workflow.png)

![Terraform Infrastructure](screenshots/terraform-cicd-pipeline.png)

![Terraform Destroy](screenshots/terraform-destroy-workflow.png)
