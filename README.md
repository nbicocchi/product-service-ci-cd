# Product-Service CI/CD

* This repository hosts a **sample Spring Boot web application** and demonstrates **GitHub workflows** for automated deployment using [Terraform](https://developer.hashicorp.com/terraform), [Ansible](https://docs.ansible.com/), and [Docker](https://www.docker.com/).

* To test automated workflows you need an AWS EC2 instance (a virtual machine with a public IP address). You can create an AWS EC2 instance in two ways:

  * **Manually** using the AWS console. Follow [this guide](./docs/ec2-manual-setup.md).
  * **Automatically** using Terraform files via `infrastructure provisioning` workflow. Follow [this guide](./docs/ec2-terraform-setup.md).

## About workflows

### Infrastructure clean workflow

* **Purpose:** Clean infrastructure before deploy workflow trigger
* **Required secret:** `EC2_SSH_KEY`, `EC2_HOST`, `EC2_USER`.


### Docker setup workflow

* **Purpose:** Deploy Docker on the EC2 instance.
* **Required secret:** `EC2_SSH_KEY`, `EC2_HOST`, `EC2_USER`.

### Docker run workflow

* **Purpose:** Deploy Docker containers on the EC2 instance.
* **Required secret:** `EC2_SSH_KEY`, `EC2_HOST`, `EC2_USER`.

### Infrastructure provisioning workflow

* **Purpose:** Provision and configure an AWS EC2 instance.
* **Required secrets:** `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`.