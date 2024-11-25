pipeline {
    agent any
    
    environment {
        // Docker Hub configurations
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKER_HUB_USERNAME = 'mujimmy'
        IMAGE_NAME = 'my-node-app'
        IMAGE_TAG = "${BUILD_NUMBER}"
        
        // EC2 configurations
        EC2_HOST = '52.73.65.200'  // Just the IP address without ec2-user@
        EC2_USER = 'ec2-user'
        EC2_SSH_KEY = credentials('ec2-ssh-key')  // Make sure this is the correct credentials ID        
        APP_PORT = '3000'  // The port your application runs on
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
                    sh "docker build -t ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG} ."
                    sh "docker tag ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:latest"
                }
            }
        }
        
        stage('Login to Docker Hub') {
            steps {
                script {
                    sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    sh "docker push ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"
                    
                }
            }
        }
        
        stage('Deploy to EC2') {
            steps {
                script {
                    // Write the deployment script to a temporary file
                    writeFile file: 'deploy.sh', text: """
                        #!/bin/bash
                        # Stop and remove existing container if it exists
                        docker stop ${IMAGE_NAME} || true
                        docker rm ${IMAGE_NAME} || true
                        
                        # Remove old images to free up space
                        docker system prune -af
                        
                        # Login to Docker Hub
                        echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin
                        
                        # Pull the latest image
                        docker pull ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}
                        
                        # Run the new container
                        docker run -d \\
                            --name ${IMAGE_NAME} \\
                            -p ${APP_PORT}:${APP_PORT} \\
                            --restart unless-stopped \\
                            ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}
                            
                        # Logout from Docker Hub
                        docker logout
                    """
                    
                    // Make the script executable and copy it to EC2
                    sh "chmod +x deploy.sh"
                    sh "scp -o StrictHostKeyChecking=no -i ${EC2_SSH_KEY} deploy.sh ${EC2_USER}@${EC2_HOST}:~/"
                    
                    // Execute the deployment script on EC2
                    sh """
                        ssh -o StrictHostKeyChecking=no -i ${EC2_SSH_KEY} ${EC2_USER}@${EC2_HOST} '~/deploy.sh'
                    """
                    
                    // Clean up the deployment script
                    sh "rm deploy.sh"
                    sh "ssh -i ${EC2_SSH_KEY} ${EC2_USER}@${EC2_HOST} 'rm ~/deploy.sh'"
                }
            }
        }
    }
    
    post {
        always {
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
