pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
                docker build -t nginx -f Dockerfile .   
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
