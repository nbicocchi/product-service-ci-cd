# AWS EC2 instance manual setup guide

Following the next steps you will manually create and configure an AWS EC2 instance using the AWS Management Console.

## Prerequisites

- An active [AWS account](https://aws.amazon.com/console/)
- Basic familiarity with the AWS Management Console

## Keypair setup

A keypair is an SSH keypair that allows you to access the machine using SSH conncections. Each SSH keypair provides two keys (public and private).

### Step 1: Create a Key Pair

* In the **EC2 Dashboard**, scroll down and select **Key Pairs** from the sidebar.
* Click on **Create key pair**.
* Provide a name for your keypair (e.g. `my-ec2-key`)
* Select the **ED25519** encryption method.
* Select the `.pem` format for your pricate key file format.
* Click on **Create key pair**.

The process will automatically download a `my-ec2-key.pem` file.

> **Warning:** Keep this key file secure. You’ll need it to create an SSH connection to your instance.

### Step 2: manage the `.pem` file

The `.pem` contains your private key. Move it to the `.ssh` folder and set correct file permissions in order to use it for SSH connections.

On your terminal execute:

```bash
   mv ~/Download/my-ec2-key.pem ~/.ssh       # Move file
   chmod 400 ~/.ssh/my-ec2-key.pem           # Set file permissions
```

## Instance setup

### Step 1: Launch a new EC2 instance

* Log in to the **AWS Management Console**.
* Navigate to **EC2** from the **Services** menu.
* Click **Launch Instance**.
* Provide a name for your instance (e.g. `ec2-product-service`).

### Step 2: Choose an Amazon Machine Image (AMI)

The AWS machine image allows you to choose the machine architecture and its operating system.

* Under **Application and OS Images** select **Ubuntu Server XX.XX LTS (HVM), SSD Volume Type**.
* Confirm the architecture as **64-bit (x86)**.

### Step 3: Choose Instance Type

* Go to the **Instance type** section
* From the list, select **t3.micro** (Free Tier eligible).

### Step 4: Create or select a Key Pair

* In the **Key Pair** section choose the keypair name of the keypair generated during the previous steps.

### Step 5: Configure Security Group

* Under **Network settings**, click the **Edit** button.
* Select **Create security group**.
* Provide a name (e.g., `sg-prodcut-service`).
* Add inbound rules as follows using the **Add security group rule** button:

| Type         | Protocol  | Port Range  | Source        | Description                 |
|--------------|-----------|-------------|---------------|-----------------------------|
| SSH          | TCP       | 22          | 0.0.0.0/0     | SSH access for admin use    |
| Custom TCP   | TCP       | 7001        | 0.0.0.0/0     | Webapp port                 |
| Custom TCP   | TCP       | 8080        | 0.0.0.0/0     | Webapp port (docker)        |

* Keep outbound rules as default (all traffic allowed).

### Step 6: Launch the instance

* Review all settings.
* Click the **Launch Instance** button.
* Wait for the instance status to become **Running**.

## Elastic IP association

You can provide a fixed public IP to your EC2 instance using the Elastic IP service.

### Step 1: Allocate an Elastic IP

* In the **EC2 Dashboard**, scroll down and select **Elastic IPs** from the sidebar.
* Click **Allocate Elastic IP address**.
* Under **Network Border Group**, ensure it matches your instance’s region.
* Click **Allocate**.

### Step 2: Associate Elastic IP to the EC2 instance

* After allocation, select your new Elastic IP.
* Click **Actions > Associate Elastic IP address**.
* Under **Instance**, choose your running EC2 instance.
* Click **Associate**.

Your Elastic IP is now permanently associated with your EC2 instance.

## Test SSH connection to the machine

* From your terminal, create an SSH connection to your instance:

```bash
   cd ~/.ssh
   ssh -i my-ec2-key.pem ubuntu@<your-elastic-ip>
```

## Set up repository secrets

If toy want to run deploy workflows you need to setup some repository secrets.

On GitHub:
* Reach your forked repository
* Go to repository **Settings** > **Secrets and variables** > **Actions**
* Create the following repository secrets using the **New repository secret button** or update existing secrets.

Secrets:
* `EC2_USER`: insert the value `ubuntu`
* `EC2_HOST`: insert the EC2 instance public IP (the elastic IP address you previously allocated)
* `EC2_SSH_KEY`: all the content of you `.pem` file. This secret allows GitHub runners to create connections to the EC2 instance.

If you want to see the content of your `.pem` file:

```bash
sudo cat ~/.ssh/my-ec2-key.pem
```

>[!WARNING]
> Copy and paste **ALL** the content of your `.pem` file into the secret variable. Include also the following lines from the file:
>
> `-----BEGIN OPENSSH PRIVATE KEY-----`
>
> `-----END OPENSSH PRIVATE KEY-----`

## Too many steps!

Maybe you are thinking that setting up an EC2 instance is boring and time consuming. Maybe you are right, but you need an EC2 instance.

> It's a dirty job, but someones's gotta do it!

Luckly, **Terraform** is here for you!