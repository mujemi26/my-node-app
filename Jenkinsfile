pipeline {
    agent any
    
    environment {
        // Define Docker Hub credentials ID (you need to add these in Jenkins credentials)
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        // Replace with your Docker Hub username
        DOCKER_HUB_USERNAME = 'mujimmy'
        // Replace with your desired image name
        IMAGE_NAME = 'my-node-app'
        // You can use BUILD_NUMBER for versioning
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/mujemi26/my-node-app.git'
            }
        }
        
        stage('Build') {
            steps {
                script {
                    sh 'node app.js'
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh "docker build -t ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG} ."
                    // Also tag it as latest
                    sh "docker tag ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:latest"
                }
            }
        }
        
        stage('Login to Docker Hub') {
            steps {
                script {
                    // Login to Docker Hub
                    sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    // Push both tagged version and latest
                    sh "docker push ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker push ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:latest"
                }
            }
        }
    }
    
    post {
        always {
            // Always clean up by logging out of Docker Hub
            sh 'docker logout'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
