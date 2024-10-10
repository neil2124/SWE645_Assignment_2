pipeline {
    agent any
    environment {
        DOCKERHUB_USER = 'neil2124'
        DOCKERHUB_PASS = 'Dark_Angel@2124' // Alternatively, use Jenkins credentials.
        DOCKER_IMAGE = 'neil2124/class-website'
        KUBECONFIG_PATH = "C:/Users/neilm/.kube/config" // Path to your kubeconfig file
        AWS_SHARED_CREDENTIALS_FILE = "C:/Users/neilm/.aws/credentials"  // Path to your AWS credentials file
    }
    stages {
        stage("Clone Repository") {
            steps {
                git url: 'https://github.com/neil2124/SWE645_Assignment_2.git'
            }
        }

        stage("Building Docker Image") {
            steps {
                script {
                    // Logging into DockerHub
                     "docker login -u ${DOCKERHUB_USER} -p ${DOCKERHUB_PASS}"

                    // Building Docker image from Dockerfile in the repository
                    echo "Building Docker image: ${DOCKER_IMAGE}"
                    docker.build("${DOCKER_IMAGE}:latest")
                }
            }
        }

        stage("Pushing Docker Image to DockerHub") {
            steps {
                script {
                    // Pushing the Docker image to DockerHub
                    echo "Pushing Docker image: ${DOCKER_IMAGE} to DockerHub"
                    bat "docker push ${DOCKER_IMAGE}:latest"
                }
            }
        }

        stage("Deploying to Kubernetes") {
            steps {
                script {
                    // Kubernetes deployment (requires kubectl to be set up on Jenkins)
                     withEnv(["KUBECONFIG=${KUBECONFIG_PATH}", 
                             "AWS_SHARED_CREDENTIALS_FILE=${AWS_SHARED_CREDENTIALS_FILE}"]){
                        bat "kubectl set image deployment/my-app-deployment my-app=neil2124/class-website:latest --record"
                     // Restart the pods to reflect the new changes
                    bat "kubectl rollout restart deployment my-app-deployment"
                    }

                }
            }
        }
    }
}
