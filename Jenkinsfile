pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                dir('frontend') {
                    sh 'npm install'
                }
            }
        }
        stage('Test') {
            steps {
                dir('frontend') {
                    sh 'npm run integrationtest'
                }
            }
        }
    }
}