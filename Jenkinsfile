pipeline {
    agent any
    environment {
        DOCKERHUB_PASS = credentials('dockerhub-credentials') // Use your DockerHub credentials stored in Jenkins
        DOCKERHUB_USER = 'neil2124' // DockerHub username
        DOCKER_IMAGE = 'neil2124/class-website:latest'
    }
    stages {
        stage("Building the Student Survey Image") {
            steps {
                script {
                    checkout scm // Checks out the repository from SCM
                    sh 'rm -rf *.war'
                    sh 'jar -cvf StudentSurvey.war -C WebContent/ .'
                    sh 'echo ${BUILD_TIMESTAMP}'
                    
                    // Logging into DockerHub
                    sh "docker login -u ${DOCKERHUB_USER} -p ${DOCKERHUB_PASS}"

                    // Building the Docker image with a unique tag using the build timestamp
                    def customImage = docker.build("${DOCKER_IMAGE}:${BUILD_TIMESTAMP}")
                }
            }
        }

        stage("Pushing Image to DockerHub") {
            steps {
                script {
                    // Pushing the built Docker image to DockerHub
                    sh "docker push ${DOCKER_IMAGE}:${BUILD_TIMESTAMP}"
                }
            }
        }

        stage("Deploying to Kubernetes as single pod") {
            steps {
                // Deploy the new image to the Kubernetes deployment using kubectl
                sh "kubectl set image my-app-deployment my-app=${DOCKER_IMAGE}:${BUILD_TIMESTAMP} -n jenkins-pipeline"
            }
        }

        stage("Deploying to Kubernetes with load balancer") {
            steps {
                // Deploy the new image to the Kubernetes load-balanced deployment using kubectl
                sh "kubectl set image my-app-deployment my-app=${DOCKER_IMAGE}:${BUILD_TIMESTAMP} -n jenkins-pipeline"
            }
        }
    }
}
