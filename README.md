# Product-Service CI/CD

This repository hosts a **sample Spring Boot web application** and demonstrates **GitHub workflows** for automated deployment using [Terraform](https://developer.hashicorp.com/terraform), [Ansible](https://docs.ansible.com/), and [Docker](https://www.docker.com/).

It’s ideal for learning how to integrate infrastructure provisioning, deployment, and containerization with CI/CD pipelines.

## Table of Contents

1. [Included Workflows](#included-workflows)
2. [Repository Setup](#repository-setup)

    * [AWS Access Keys](#1-aws-access-keys)
    * [Personal Access Token (PAT)](#2-personal-access-token-pat)
    * [SSH Deploy Key](#3-ssh-deploy-key)
3. [Manual Workflow Trigger](#manual-workflow-trigger)


## Included Workflows

### 1. Infrastructure workflow

**File:** `infrastructure-workflow.yml`
**Purpose:** Provision and configure an AWS EC2 instance.

**What it does:**

* Creates a new EC2 instance using Terraform.
* Configures SSH access and environment variables.

> **Required secrets:** `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`.

### 2. JAR workflow

**File:** `deploy-JAR.yml`
**Purpose:** Build and deploy the Spring Boot application to the EC2 instance.

**What it does:**

* Uses Ansible to configure the EC2 instance.
* Uses Ansible to starts the application with the correct environment configuration.

> **Required secret:** `EC2_SSH_KEY`, `EC2_HOST`, `EC2_USER`.

### 3. Docker workflow

**File:** `deploy-docker.yml`
**Purpose:** Deploy Docker containers on the EC2 instance.

**What it does:**

* Installs Docker and Docker Compose via Ansible.
* Launches containers defined in `docker-compose.yml`.
* Supports containerized applications or microservices.

> **Required secret:** `EC2_SSH_KEY`, `EC2_HOST`, `EC2_USER`. Additional secrets may be needed for container configurations.

---

## Repository Setup

> **Warning:** Do **not** modify secrets or push changes directly to this repository. Fork it to run experiments safely.

Before running workflows, set up the following **GitHub secrets**.

### 1. SSH deploy key

> Required for all workflows.

SSH key pairs enable secure connections to your EC2 instance. The following operations allows you and your github action to add a public key to the EC2 instance and correctly connect to it when you run your workflow.

On your personal Linux machine Generate a SSH key pair using the following commands:

```bash
cd ~/.ssh
ssh-keygen -t ed25519 -C "deploy_key" -f ./deploy_key -N ""
```

View your keys using:

```bash
cat ~/.ssh/deploy_key.pub   # Public key
cat ~/.ssh/deploy_key       # Private key
```

* Replace the content of `.ssh/github.deployment_key.pub` file in this repository using the content of your `deploy_key.pub`.
* Insert the content of `deploy_key` into a secret named `EC2_SSH_KEY`.

You need to follow the next step **only if you want to create an AWS EC2 instance without terraform**:

* On your terminal execute the following command to open an SSH connection using your private key saved into the `.pem` file:

```bash
ssh -i <your-key.pem> ubuntu@<machine-public-ip>
```

* Add the content of your `deploy_key.pub` file into the machine `.ssh/authorized_keys` file.
* Now toy can create SSH conncetion using your `deploy_key` or the generated `ec2-key.pem`.

### 2. Secrets for SSH connetion

> Required for `deploy-JAR.yml`, `deploy-docker.yml`.

In order to use SSH connection between github runners and the EC2 instance, the runner needs to know the EC2 instance IP address and the username to login.

* Set the `EC2_USER` secret with the username `ubuntu`
* Set the `EC2_HOST` secret with the EC2 instance public IP address.

### 3. AWS Access Keys

> Required for `infrastructure-provisioning.yml`.

AWS access keys enable Terraform to provision cloud infrastructure. You need:

* **AWS Access Key ID** – public identifier.
* **AWS Secret Access Key** – private key.

Generate keys via your [AWS Console](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user_manage_add-key.html) and save them as two secrets named `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`.

If you wont use the infrustructure provisioning workflow you can manually set up an AWS EC2 instance [following this guide](./infrastructure.md).

## Manual workflow trigger

Some workflows run automatically on `push`. To trigger manually:

1. Go to the **Actions** tab.
2. Select the desired workflow.
3. Click **Run workflow** and provide any required inputs.
