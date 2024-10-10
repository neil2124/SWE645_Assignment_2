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

Check if docker is running properly


Run the Docker Image Locally
To test the application locally, run the built image using:

docker run -d -p 8080:80 <your-dockerhub-username>/<image-name>:latest

List Running Containers
Check whether the container is running

docker ps



