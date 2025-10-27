# AWS EC2 instance setup with Terraform

Terraform is an **Infrastructure as Code** tool that allows you to define infrastructure resources using a declarative language.

Terraform files into the [terraform folder](../terraform) of this repository allows you to easily get all the needed infrastructure resources to run deployment workflows.

## Prerequisites

- An active [AWS account](https://aws.amazon.com/console/)
- Basic familiarity with the AWS Management Console

## Get your AWS CLI credentials

AWS CLI access keys enable Terraform to provision cloud infrastructure. You need:

* **AWS Access Key ID** – public identifier.
* **AWS Secret Access Key** – private key.

Generate keys via your [AWS Console](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user_manage_add-key.html) and save them as two secrets named `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`.

## Set up repository secrets

If you want to run deploy workflows you need to setup some repository secrets.

On GitHub:
* Reach your forked repository
* Go to repository **Settings** > **Secrets and variables** > **Actions**
* Create the following repository secrets using the **New repository secret button** or update existing secrets.

Secrets:
* `EC2_USER`: insert the value `ubuntu`
* `EC2_HOST`: insert the EC2 instance public IP
* `EC2_SSH_KEY`: this secret allows GitHub runners to create connections to the EC2 instance (shown in Terraform logs).

>[!NOTE]
> Copy and paste **ALL** the private key into the secret variable. Include also the following lines:
>
> `-----BEGIN OPENSSH PRIVATE KEY-----`
>
> `-----END OPENSSH PRIVATE KEY-----`

## Test SSH connection to the machine

In your terminal:

* Go to **Actions** > `infrastructure-provisioning` and open the last action execution logs
* Copy the private key printed into the `Get OpenSSH private key` log.
* Create a private key file, paste into it the content of actions logs and set correct permsission:

```bash
cd ~/.ssh
> deploy_key
vim ./deploy_key
chmod 400 ./deploy_key
```

* Open an SSH connection to your instance:

```bash
cd ~/.ssh
ssh -i deploy_key ubuntu@<hostname>
```