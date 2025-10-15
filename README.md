# Product-Service CI/CD

This repository hosts a **sample Spring Boot web application** and demonstrates **GitHub workflows** for automated deployment using [Terraform](https://developer.hashicorp.com/terraform), [Ansible](https://docs.ansible.com/), and [Docker](https://www.docker.com/).

It’s ideal for learning how to integrate infrastructure provisioning, deployment, and containerization with CI/CD pipelines.

---

## Table of Contents

1. [Included Workflows](#included-workflows)
2. [Repository Setup](#repository-setup)

    * [AWS Access Keys](#1-aws-access-keys)
    * [Personal Access Token (PAT)](#2-personal-access-token-pat)
    * [SSH Deploy Key](#3-ssh-deploy-key)
3. [Manual Workflow Trigger](#manual-workflow-trigger)

---

## Included Workflows

### 1. Infrastructure Workflow

**File:** `infrastructure-workflow.yml`
**Purpose:** Provision and configure an AWS EC2 instance.

**What it does:**

* Creates a new EC2 instance using Terraform.
* Configures SSH access and environment variables.
* Optionally updates the `EC2_HOST` secret with the instance IP.

> ⚡ **Required secrets:** `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `PAT_TOKEN`.

---

### 2. Deploy Workflow

**File:** `deploy-workflow.yml`
**Purpose:** Build and deploy the Spring Boot application to the EC2 instance.

**What it does:**

* Compiles the project with GitHub Actions.
* Uses Ansible to configure the EC2 instance.
* Starts the application with the correct environment configuration.

> ⚡ **Required secret:** `EC2_SSH_KEY`.

---

### 3. Docker Workflow

**File:** `docker-workflow.yml`
**Purpose:** Deploy Docker containers on the EC2 instance.

**What it does:**

* Installs Docker and Docker Compose via Ansible.
* Launches containers defined in `docker-compose.yml`.
* Supports containerized applications or microservices.

> ⚡ **Required secret:** `EC2_SSH_KEY`. Additional secrets may be needed for container configurations.

---

## Repository Setup

> **Warning:** Do **not** modify secrets or push changes directly to this repository. Fork it to run experiments safely.

Before running workflows, set up the following **GitHub secrets**:

---

### 1. AWS Access Keys

> Required for `infrastructure-workflow.yml`.

AWS access keys enable Terraform to provision cloud infrastructure. You need:

* **AWS Access Key ID** – public identifier.
* **AWS Secret Access Key** – private key.

Generate keys via your [AWS Console](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user_manage_add-key.html) and save them as:

```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

---

### 2. Personal Access Token (PAT)

> Required for `infrastructure-workflow.yml`.

PATs authenticate GitHub Actions for tasks like updating the `EC2_HOST` secret automatically.

Generate a token following [GitHub’s instructions](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic) and save it as:

```
PAT_TOKEN
```

---

### 3. SSH Deploy Key

> Required for all workflows.

SSH key pairs enable secure connections to your EC2 instance.

Generate a key pair:

```bash
cd ~/.ssh
ssh-keygen -t ed25519 -C "deploy_key" -f ./deploy_key -N ""
```

View keys:

```bash
cat ~/.ssh/deploy_key.pub   # Public key
cat ~/.ssh/deploy_key       # Private key
```

* Add `deploy_key.pub` to the `.ssh` folder in this repository.
* Save `deploy_key` as a secret:

```
EC2_SSH_KEY
```

---

## Manual Workflow Trigger

Some workflows run automatically on `push`. To trigger manually:

1. Go to the **Actions** tab.
2. Select the desired workflow.
3. Click **Run workflow** and provide any required inputs.
