# Product-Service CI/CD

This repository hosts a **sample Spring Boot web application** and demonstrates **GitHub workflows** for automated deployment using [Terraform](https://developer.hashicorp.com/terraform), [Ansible](https://docs.ansible.com/), and [Docker](https://www.docker.com/).

It’s ideal for learning how to integrate infrastructure provisioning, deployment, and containerization with CI/CD pipelines.

## Repository fork and setup

To test automated workflows you need an AWS EC2 instance (a virtual machine with a public IP address). You can create an AWS EC2 instance in two ways:

* **Manually** using the AWS console. Follow [this guide](./docs/ec2-manual-setup.md).
* **Automatically** using Terraform files via `infrastructure provisioning` workflow. Follow [this guide](./docs/ec2-terraform-setup.md).

## About workflows

### Infrastructure cleaning workflow

**File:** `infrastructure-clean.yml`
**Purpose:** Clean infrastructure before deploy workflow trigger

**What it does:**

* Removes webapp service
* Uninstalls Docker and PostgreSQL
* Cleans EC2 opt folder

> **Required secret:** `EC2_SSH_KEY`, `EC2_HOST`, `EC2_USER`.

### JAR workflow

**File:** `deploy-JAR.yml`
**Purpose:** Build and deploy the Spring Boot application to the EC2 instance.

**What it does:**

* Uses Ansible to setup a given EC2 instance.
* Uses Ansible to starts the application with the correct environment configuration.

> **Required secret:** `EC2_SSH_KEY`, `EC2_HOST`, `EC2_USER`.

### Docker workflow

**File:** `deploy-docker.yml`
**Purpose:** Deploy Docker containers on the EC2 instance.

**What it does:**

* Uses Ansible to setup a given EC2 instance.
* Launches containers defined in `docker-compose.yml`.
* Supports containerized applications or microservices.

> **Required secret:** `EC2_SSH_KEY`, `EC2_HOST`, `EC2_USER`. Additional secrets may be needed for container configurations.

### Infrastructure provisioning workflow

**File:** `infrastructure-provisioning.yml`
**Purpose:** Provision and configure an AWS EC2 instance.

**What it does:**

* Creates a new EC2 instance using Terraform.
* Configures SSH access and environment variables.

> **Required secrets:** `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`.