pipeline {
    agent any
    environment {
        DOCKERHUB_USER = 'neil2124'
        DOCKERHUB_PASS = 'Dark_Angel@2124' // Alternatively, use Jenkins credentials.
        DOCKER_IMAGE = 'neil2124/class-website'
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
                    sh "docker login -u ${DOCKERHUB_USER} -p ${DOCKERHUB_PASS}"

                    // Building Docker image from Dockerfile in the repository
                    echo "Building Docker image: ${DOCKER_IMAGE}"
                    docker.build("${DOCKER_IMAGE}:${BUILD_TIMESTAMP}")
                }
            }
        }

        stage("Pushing Docker Image to DockerHub") {
            steps {
                script {
                    // Pushing the Docker image to DockerHub
                    echo "Pushing Docker image: ${DOCKER_IMAGE} to DockerHub"
                    sh "docker push ${DOCKER_IMAGE}:${BUILD_TIMESTAMP}"
                }
            }
        }

        stage("Deploying to Kubernetes") {
            steps {
                script {
                    // Kubernetes deployment (requires kubectl to be set up on Jenkins)
                    sh "kubectl set image deployment/my-app-deployment my-app=${DOCKER_IMAGE}:${BUILD_TIMESTAMP} --record"
                }
            }
        }
    }
}
