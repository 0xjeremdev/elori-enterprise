pipeline {
    agent any

    stages {
        stage('Test') {
            steps {
                dir('frontend') {
                    sh 'npm run integrationtest'
                }
            }
        }
    }
}