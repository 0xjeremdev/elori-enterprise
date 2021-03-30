pipeline {
    agent any

    stages {
        stage('Test') {
            dir('frontend') {
                steps {
                    sh 'npm run integrationtest'
                }
            }
        }
    }
}