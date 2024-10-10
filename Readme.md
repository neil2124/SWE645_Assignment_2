# CI/CD Pipeline with Docker, AWS EKS, and Jenkins

## Overview
This project demonstrates a complete CI/CD pipeline for a web application using Docker, AWS EKS (Elastic Kubernetes Service), and Jenkins. The pipeline automates the building of Docker images, pushing the image to DockerHub, and deploying the application to a Kubernetes cluster managed by AWS EKS.

## Prerequisites
- Docker Desktop (Installed on your local machine)
- AWS Account with EKS setup (using AWS Learner's Lab)
- Jenkins installed on your local machine
- GitHub repository containing the application code, `deployment.yaml`, `service.yaml`, and Jenkinsfile
- AWS CLI, kubectl installed locally


### 1. Docker Setup

#### Build Docker Image for Your Application
Navigate to the root directory of your project where the `Dockerfile` is located and run the following command to build the image:
```bash
docker build -t neil2124/class-website:latest .
```

Check if docker is running properly

Run the Docker Image Locally
To test the application locally, run the built image using:

```bash 
docker run -d -p 8080:80 <your-dockerhub-username>/<image-name>:latest 
```

List Running Containers
Check whether the container is running
```bash
docker ps
```

Stop a Running Container
You can stop the container using the container ID obtained from docker ps:
```bash
docker stop <container-id>
```

Push Docker Image to DockerHub:
```bash
docker push <your-dockerhub-username>/<image-name>:latest
```

### 2. Kubernetes Setup on AWS EKS
Step 1: Log in to AWS Learner's Lab
Log in with the credentials provided by your AWS Learner's Lab account.
Once logged in, use the search bar at the top to search for EKS and select Elastic Kubernetes Service (EKS) from the dropdown.
Step 2: Create an EKS Cluster
In the EKS Console, click Create Cluster to start the process.

Configure Cluster:

Cluster name: Give your cluster a name, for example, my-cluster.
Kubernetes version: Select the latest available version or the one you need for your application.
Role: If you don’t already have a cluster service role, click Create a new role. In the IAM (Identity and Access Management) console, create a new role with the permissions required for EKS (AmazonEKSClusterPolicy). Attach the role to your cluster.
Networking Configuration:

VPC: If you have an existing Virtual Private Cloud (VPC), select it; otherwise, create a new one.
Subnets: Choose the subnets you want to use. At least two subnets in different Availability Zones are required for high availability.
Security groups: Use the default security group or create a new one with the necessary access.
Cluster Logging:

Enable logging for API, Audit, Authenticator, Controller Manager, and Scheduler to monitor your cluster activities.
This is optional but recommended to help with debugging and monitoring.
Click Create Cluster. It will take a few minutes to create the cluster. You can monitor the creation process from the Cluster page.

Step 3: Create Node Group
Once the EKS cluster is active, you need to create a node group, which is a set of EC2 instances that run your workloads.

In the EKS dashboard, go to your newly created cluster and click Add Node Group.

Configure Node Group:

Name: Provide a name for the node group.
Role: If no IAM role exists for the node group, create a new role. The role should have permissions to work with EC2 instances (AmazonEKSWorkerNodePolicy, AmazonEC2ContainerRegistryReadOnly, etc.).
Compute Configuration:

Instance Types: Choose an instance type for the EC2 nodes that will run your workloads.I have chosen t3.medium.
Disk Size: Set the disk size for your nodes (minimum 20 GB).
Scaling Configuration:

Set the minimum, maximum, and desired number of nodes for your node group. For a small deployment, i have max and min set to 1.
Subnets: Choose the subnets where the nodes will run. It’s ideal to select subnets from different Availability Zones for high availability.

Remote Access:

You can enable SSH access to your nodes by selecting a key pair. This is optional but recommended for troubleshooting.
Click Create Node Group. The node group will now be created, and it might take a few minutes for the nodes to join the cluster.

Step 4: Install AWS CLI and kubectl Locally
If not already installed, follow these steps to install AWS CLI and kubectl on your local machine.

Install AWS CLI:

Follow the official instructions to install the AWS CLI.
Once installed, configure AWS CLI with your credentials:

Go to the .aws file on your machine and edit the credentials file. For this lab we are provided the aws details like session id, secret key and session token.
Once done, save the credentials file, restart the aws cli

Install kubectl:

Install kubectl, the command-line tool for Kubernetes, by following the kubectl installation guide.
Verify the installation by running:

```bash
kubectl version --client
```

Step 5: Connect kubectl to Your EKS Cluster
Now that the EKS cluster is created and the node group is active, you need to configure kubectl to connect to the cluster.

Use AWS CLI to update the kubeconfig file:
```bash
aws eks --region <your-region> update-kubeconfig --name <cluster-name>
```
My Cluster:
```bash
aws eks --region us-east-1 update-kubeconfig --name my-cluster

```
This command updates the ~/.kube/config file on your local machine so you can interact with the EKS cluster using kubectl.

Verify that the nodes are connected by running:

```bash
kubectl get nodes

```

You should see the list of EC2 instances (nodes) attached to your cluster.

Step 6: Deploy Your Application
Ensure you have your deployment.yaml and service.yaml files in place. My files can be found in the root of this repo

Deploy the application using the following commands:

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

```

Verify that your deployment and service are running:

```bash
kubectl get deployments
kubectl get svc

```

Once your service is up, you can get the external IP address for your application and access it from a web browser:

```bash
kubectl get svc
```

Some other commands to check your EKS Cluster
```bash
kubectl get deployments
kubectl get nodes
```

3. Jenkins Setup for CI/CD Pipeline
Step 1: Install Jenkins on Windows
Download Jenkins:

Go to the official Jenkins website and download the Windows installer for Jenkins.
Run the installer and follow the on-screen instructions to complete the installation.
Unlock Jenkins:

After installation, open a web browser and navigate to http://localhost:9090 (or whatever port Jenkins is running on).
Jenkins will ask for an admin password. This password is stored in the following file:
```bash
C:\Program Files\Jenkins\secrets\initialAdminPassword
```

Open the file, copy the password, and paste it into the browser to unlock Jenkins.
Install Suggested Plugins:

After unlocking, Jenkins will prompt you to install plugins. Choose Install Suggested Plugins to install the most commonly used ones. Jenkins will automatically install them.
Create Admin User:

Once the plugins are installed, you’ll be prompted to create your first admin user. Fill out the required fields (username, password, full name, and email) and click Save.
Jenkins Is Ready:

After creating the admin user, Jenkins is ready for use. You should now see the Jenkins dashboard.
Step 2: Install Required Plugins
On the Jenkins dashboard, go to Manage Jenkins > Manage Plugins.

Under the Available tab, search for the following plugins and install them:

Pipeline: For running pipelines.
Git: To integrate with GitHub repositories.
Docker Pipeline: For building and pushing Docker images.
Kubernetes (optional for more Kubernetes-specific integrations).
After installing the required plugins, restart Jenkins.

Ensure that docker is running on the system as jenkins will need it to build and push the images 

Step 3: Configure GitHub and DockerHub Credentials in Jenkins
GitHub Credentials:

Go to Manage Jenkins > Manage Credentials.
In the global credentials section, click Add Credentials.
Select Username with password and enter your GitHub username and personal access token (you can generate one from GitHub under Settings > Developer Settings > Personal Access Tokens).
DockerHub Credentials:

Similarly, add another set of credentials for DockerHub.
Enter your DockerHub username and password.
Save the Credentials.

Step 4: Create a Jenkins Pipeline
Create a New Pipeline:

From the Jenkins dashboard, click New Item.
Name the item (for example, class-website-pipeline), select Pipeline, and click OK.
Configure the Pipeline:

Under the Pipeline section, select Pipeline script from SCM.
For SCM, select Git, and paste your GitHub repository URL (e.g., https://github.com/yourusername/your-repo.git).
For Credentials, select the GitHub credentials you configured earlier.
Jenkinsfile Setup:

Create a Jenkinsfile in the root directory of your GitHub repository. This file will define your CI/CD pipeline, including steps for building and deploying your application. It will also have the AWS configuration details in order to connect to our EKS Cluster.

Save and Run the Pipeline:

Save your Jenkins pipeline configuration and run it. Jenkins will pull the repository, build the Docker image, push it to DockerHub, and deploy it to your Kubernetes cluster.


View the Deployment
Once the pipeline is successful, you can check the deployment status using:
```bash
kubectl get deployments
kubectl get pods
kubectl get svc
```







