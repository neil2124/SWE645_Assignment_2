pipeline {
    agent any
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub-credentials') // Jenkins credentials for DockerHub
        DOCKER_IMAGE = 'neil2124/class-website:latest'
        GITHUB_CREDENTIALS = credentials('github_credentials') // Jenkins GitHub credentials
    }
    stages {
        stage('Clone Repository') {
            steps {
                git credentialsId: 'github_credentials', url: 'https://github.com/neil2124/SWE645_Assignment_2.git'
                echo 'Repository cloned successfully'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image from root directory
                    echo "Building Docker image: ${DOCKER_IMAGE}"
                    docker.build("${DOCKER_IMAGE}")
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    echo "Pushing Docker image: ${DOCKER_IMAGE} to DockerHub"
                    docker.withRegistry('https://index.docker.io/v1/', 'DOCKER_HUB_CREDENTIALS') {
                        docker.image("${DOCKER_IMAGE}").push()
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    echo "Deploying Docker image: ${DOCKER_IMAGE} to Kubernetes"
                    sh '''
                        kubectl set image deployment/my-app-deployment my-app=${DOCKER_IMAGE} --record
                    '''
                }
            }
        }
    }
    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}
