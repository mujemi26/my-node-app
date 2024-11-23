
pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
              git branch: 'main' , url:  'https://github.com/mujemi26/my-node-app.git'  // Replace with your repository URL
            }
        }
        stage('Build') {
            steps {
                script {
                    
                   
                    sh 'node app.js' 
                    
                    
                }
            }
        }
    }
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
