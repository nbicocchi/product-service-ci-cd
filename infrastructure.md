# AWS EC2 setup guide

This guide provides step-by-step instructions to create and configure an AWS EC2 instance with a new **key pair**, **security group**, and **Elastic IP**.

### Prerequisites

- An active [AWS account](https://aws.amazon.com/console/)
- Basic familiarity with the AWS Management Console

## Instance setup

### Step 1: Launch an EC2 instance

* Log in to the **AWS Management Console**.
* Navigate to **EC2** from the **Services** menu.
* Click **Launch Instance**.
* Provide a name for your instance (e.g. `ubuntu-t3-micro`).

---

### Step 2: Choose an Amazon Machine Image (AMI)

* Under **Application and OS Images (Amazon Machine Image)**:
   - Select **Ubuntu Server XX.XX LTS (HVM), SSD Volume Type**.
* Confirm the architecture as **x86_64**.

---

### Step 3: Choose Instance Type

* Go to the **Instance type** section
* From the list, select **t3.micro** (Free Tier eligible).

---

### Step 4: Create or select a Key Pair

A keypair is an SSH keypair that allows you to access the machine using SSH conncections.

* In the **Key Pair (Login)** section:
   - Choose **Create a new key pair**.
* Provide a name (e.g., `my-ec2-key`).
* Select **Key pair type**: `RSA`
* Choose **Private key file format**: `.pem`
* Click **Create key pair** — this will automatically download your key file (e.g., `my-ec2-key.pem`).

> **Warning:** Keep this key file secure. You’ll need it to create an SSH connection to your instance.

---

### Step 5: Configure Security Group

* Under **Network settings**, click **Edit**.
* Select **Create security group**.
* Provide a name (e.g., `my-ec2-sg`).
* Add inbound rules as follows using the **Add security group rule** button:

| Type        | Protocol | Port Range | Source       | Description                 |
|--------------|-----------|-------------|---------------|-----------------------------|
| SSH          | TCP       | 22          | 0.0.0.0/0     | SSH access for admin use    |
| Custom TCP   | TCP       | 7001        | 0.0.0.0/0     | Application port (optional) |
| Custom TCP   | TCP       | 8080        | 0.0.0.0/0     | Web application port        |

* Keep outbound rules as default (all traffic allowed).

---

### Step 6: Launch the instance

* Review all settings.
* Click **Launch Instance**.
* Wait for the instance status to become **Running**.

---

### Step 7: Allocate an Elastic IP

* In the **EC2 Dashboard**, scroll down and select **Elastic IPs** from the sidebar.
* Click **Allocate Elastic IP address**.
* Under **Network Border Group**, ensure it matches your instance’s region.
* Click **Allocate**.

---

### Step 8: Associate Elastic IP to the EC2 instance

* After allocation, select your new Elastic IP.
* Click **Actions > Associate Elastic IP address**.
* Under **Instance**, choose your running EC2 instance.
* Click **Associate**.

Your Elastic IP is now permanently associated with your EC2 instance.

---

### Step 9: Verify connection

* From your terminal, create an SSH connection to your instance using the Elastic IP:

```bash
   cd ~/.ssh
   chmod 400 my-ec2-key.pem
   ssh -i "my-ec2-key.pem" ubuntu@<your-elastic-ip>
```