# AWS EC2 instance setup with Terraform

## Get your AWS CLI credentials

AWS CLI access keys enable Terraform to provision cloud infrastructure. You need:

* **AWS Access Key ID** – public identifier.
* **AWS Secret Access Key** – private key.

Generate keys via your [AWS Console](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user_manage_add-key.html) and save them as two secrets named `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`.

## Set up an SSH keypair

SSH key pairs enable secure connections to your EC2 instance. The following operations allows you and your github action to add a public key to the EC2 instance and correctly connect to it when you run your workflow.

### Step 1: generate a new SSH keypair

On your personal Linux terminal generate an SSH keypair using the following commands:

```bash
cd ~/.ssh
ssh-keygen -t ed25519 -C "deploy_key" -f ./deploy_key -N ""
```

View your keys using:

```bash
cat ~/.ssh/deploy_key.pub   # Public key
cat ~/.ssh/deploy_key       # Private key
```

### Step 2: update the public key file

* Replace the content of `.ssh/github.deployment_key.pub` file in this repository using the content of your `deploy_key.pub` (your public key).

Terraform uses this file to create a new *AWS keypair* resource. Remember that an *AWS keypair* must be unique, so if you previously created an *AWS keypair* with the same public key you must delete it using the AWS Management Console.

### Step 3: update the private key secret

* Insert the content of `deploy_key` (your private key) into a GitHub secret named `EC2_SSH_KEY`.

This secret allows GitHub runners to create connections to the EC2 instance.

>[!NOTE]
> Copy and paste **ALL** the content of your private key file into the secret variable. Include also the following lines from the file:
>
> `-----BEGIN OPENSSH PRIVATE KEY-----`
>
> `-----END OPENSSH PRIVATE KEY-----`

## Manually trigger terraform workflow

When you want to get an infrastructure using Terraform you can trigger the `infrastructure-provisioning` workflow.

On GitHub:
* Go to repository **Actions** tab.
* Select the `infrastructure-provisioning` workflow.
* Click on the **Run workflow** button.

At the end of the workflow execution you can check workflow logs and get your machine public IP.

## Set up repository secrets

If toy want to run deploy workflows you need to setup some repository secrets.

On GitHub:
* Reach your forked repository
* Go to repository **Settings** > **Secrets and variables** > **Actions**
* Create the following repository secrets using the **New repository secret button** or update existing secrets.

Secrets:
* `EC2_USER`: insert the value `ubuntu`
* `EC2_HOST`: insert the EC2 instance public IP (the IP address in your Terraform logs)

Now you can run deployment workflows.