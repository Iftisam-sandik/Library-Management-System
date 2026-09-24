# Production-Grade AWS Monitoring & Observability Platform

This project extends the existing Library Management System with a production-style AWS deployment, infrastructure automation, monitoring, centralized logging, alerting, and configuration management.

The original application source, authorship, and license remain preserved in the main project README.

## 1. Project Goals

The main goals of this implementation were to:

- deploy the application on AWS using a multi-server architecture
- place application traffic behind an Application Load Balancer
- run MySQL on a dedicated database server
- provision AWS infrastructure using Terraform
- automate server configuration and deployment using Ansible
- collect infrastructure, container, application, and database metrics
- centralize logs using Loki and Grafana Alloy
- configure alerting with Prometheus and Alertmanager
- provide Grafana dashboards for infrastructure, application, database, and availability monitoring
- keep the architecture cost-conscious

## 2. Architecture

Internet traffic reaches an AWS Application Load Balancer, which distributes requests between two Docker-based application servers.

Both application servers connect to a dedicated MySQL database server.

A separate monitoring server runs Prometheus, Grafana, Loki, Alertmanager, Blackbox Exporter, and Grafana Alloy.

## 3. AWS Infrastructure

Region: ap-south-1

Network:
- VPC: 10.20.0.0/16
- Subnet A: 10.20.1.0/24
- Subnet B: 10.20.2.0/24

EC2 servers:

| Server | Purpose | Instance Type |
|---|---|---|
| app-server-1 | Application server | t3.small |
| app-server-2 | Application server | t3.small |
| db-server | MySQL database | t3.micro |
| monitoring-server | Monitoring and logging | t3.medium |

All servers use Ubuntu Server 26.04 LTS.

The project avoids NAT Gateway, RDS, ECS, EKS, and Kubernetes to keep the environment simple and cost-conscious.

## 4. Application Deployment

The application uses:
- React frontend
- Node.js / Express backend
- MySQL database

The two application servers run the frontend and backend using Docker Compose.

Nginx serves the frontend on port 80 and proxies API requests to the backend.

The backend runs on port 5000 and exposes `/health` and `/metrics`.

The Application Load Balancer distributes incoming HTTP traffic between both application servers.

## 5. Database

MySQL runs directly on the dedicated database server.

Database name: `LibraryManagementSystem`

Application database user: `library_app@10.20.%`

The application user has SELECT, INSERT, UPDATE, DELETE, and EXECUTE privileges.

The database contains:
- 7 tables
- 8 stored procedures
- 8 functions
- 4 triggers

A 2 GB swap file is configured on the database server to reduce the risk of MySQL being terminated during memory pressure.

## 6. Monitoring Stack

The monitoring platform includes:

| Component | Purpose |
|---|---|
| Prometheus | Metrics collection and alert evaluation |
| Grafana | Dashboards and visualization |
| Node Exporter | Linux host metrics |
| cAdvisor | Docker container metrics |
| mysqld_exporter | MySQL metrics |
| Blackbox Exporter | External availability monitoring |
| Alertmanager | Alert notification delivery |
| Loki | Centralized log storage |
| Grafana Alloy | Log collection and forwarding |

## 7. Prometheus Monitoring

Prometheus uses AWS EC2 service discovery for dynamic infrastructure and application targets.

Monitored targets include:

- Node Exporter on app-server-1
- Node Exporter on app-server-2
- Node Exporter on db-server
- Node Exporter on monitoring-server
- cAdvisor on both application servers
- backend application metrics on both application servers
- mysqld_exporter on db-server
- Blackbox Exporter for the public ALB endpoint
- Prometheus itself

Final validation confirmed all active Prometheus targets were UP.

## 8. Application Metrics

The Node.js backend exposes Prometheus metrics through `/metrics`.

Application monitoring includes:

- HTTP request count
- response status
- request latency
- in-flight requests
- application-specific metrics

The Grafana application dashboard includes panels such as:

- Backend Request Rate
- Backend p95 Response Time
- Backend 5xx Error Rate

## 9. Grafana

Grafana uses Prometheus and Loki as data sources.

Dashboard folders:

- Application Monitoring
- Infrastructure Monitoring
- Database Monitoring

Configured dashboards include:

- Library Application Monitoring
- External Availability Monitoring
- Docker Monitoring
- Node Exporter Full
- MySQL Exporter Dashboard

Grafana teams:

- Developers
- Operations
- QA

Folder permissions are managed using different View, Edit, and Admin access levels.

## 10. Centralized Logging

Grafana Alloy runs on all four servers:

- app-server-1
- app-server-2
- db-server
- monitoring-server

On the application servers, Alloy collects Docker logs from the frontend and backend containers.

On the database server, Alloy collects MySQL logs from the systemd journal.

On the monitoring server, Alloy collects logs from:

- Prometheus
- Grafana
- Alertmanager
- Blackbox Exporter
- Loki

All logs are forwarded to Loki on the monitoring server.

End-to-end log ingestion was tested successfully from all four servers.

## 11. Alerting

Prometheus alert rules include:

- InstanceDown
- BackendTargetDown
- ApplicationDown
- MySQLDown

Alertmanager sends notifications through Gmail SMTP.

Alerting was tested by intentionally stopping the relevant service or exporter and confirming both firing and resolved notifications.

## 12. Infrastructure as Code

Terraform manages the AWS infrastructure, including:

- VPC
- public subnets
- Internet Gateway
- route table
- security groups
- EC2 instances
- Application Load Balancer
- target group
- IAM role and instance profile
- SSH key pair integration

A final Terraform plan confirmed that the deployed AWS infrastructure matches the Terraform configuration with no drift.

## 13. Configuration Management

Ansible runs from the monitoring server, which acts as the Ansible control node.

Automated roles include:

- node_exporter
- docker
- app_deploy
- cadvisor
- swap
- mysql_server
- library_database
- mysqld_exporter
- blackbox_exporter
- alertmanager
- loki
- prometheus
- grafana
- grafana_rbac
- grafana_dashboards
- alloy_app
- alloy_db
- alloy_monitoring

The top-level playbook is located at:

ansible/playbooks/site.yml

It orchestrates configuration across all four servers.

The final integrated Ansible run completed successfully with changed=0 and failed=0 on every server, confirming that the automation is idempotent.

## 14. Security Design

Security groups restrict communication based on server responsibility.

Examples:

- ALB accepts public HTTP traffic on port 80
- application port 80 accepts traffic from the ALB security group
- backend port 5000 is available to the monitoring server for monitoring
- MySQL port 3306 accepts traffic from the application servers
- mysqld_exporter port 9104 accepts traffic from the monitoring server
- Loki port 3100 is restricted to the private VPC network
- Grafana and SSH access are restricted to approved administrator IP addresses
- application and database servers allow SSH from the monitoring server for Ansible automation

Runtime secrets are stored outside the Git repository under:

~/.ansible-secrets/

Sensitive credentials are not committed to source control.

## 15. Final Validation

The completed platform passed the following checks:

- Terraform reported no infrastructure drift
- the full Ansible site playbook completed with changed=0 on all four servers
- all Prometheus active targets were UP
- Loki reported ready
- logs were received from app-server-1
- logs were received from app-server-2
- MySQL logs were available from db-server
- monitoring service logs were available from monitoring-server
- Alertmanager reported ready
- Prometheus reported zero active alerts during the final healthy-state check
- the public Application Load Balancer returned HTTP 200
- database tables, procedures, functions, and triggers passed validation

## 16. Tools and Technologies

- AWS
- Terraform
- Ansible
- Docker
- Docker Compose
- Nginx
- React
- Node.js
- Express
- MySQL
- Prometheus
- Grafana
- Loki
- Grafana Alloy
- Alertmanager
- Blackbox Exporter
- Node Exporter
- cAdvisor
- mysqld_exporter
- Git
- GitHub
- Linux

## 17. Repository Notes

This repository is a fork of the original Library Management System project.

The original application source, authorship, and license remain preserved.

The AWS infrastructure, Docker deployment, monitoring, logging, alerting, Terraform, and Ansible automation in this fork were added as part of this DevOps and observability implementation.
