pipeline {
    agent any
    environment {
        PROJECT_ID = 'project-satheesh'
        REPOSITORY_NAME = 'test-artifact-build'
        IMAGE_NAME = 'my-app'
        IMAGE_TAG = 'latest'
        SERVICE_ACCOUNT_KEY = credentials('c3dc6ea6-e9b2-4abd-8d7f-b82a69eb42a5')
    }
    stages {
        stage("Checkout code") {
            steps {
                checkout scm
            }
        }
        stage("Build and Push image to Artifact Registry") {
            steps {
                script {
                    // Build Docker image
                    docker.build("${PROJECT_ID}.pkg.dev/${REPOSITORY_NAME}/${IMAGE_NAME}:${IMAGE_TAG}")
                    
                    // Authenticate with Google Cloud using service account key
                    withCredentials([file(credentialsId: SERVICE_ACCOUNT_KEY, variable: 'SERVICE_ACCOUNT_KEY_FILE')]) {
                        sh """
                            gcloud auth activate-service-account --key-file="$SERVICE_ACCOUNT_KEY_FILE"
                            gcloud auth configure-docker "${PROJECT_ID}.gcr.io"
                        """
                    }
                    
                    // Push Docker image to Artifact Registry
                    sh "docker push ${PROJECT_ID}.gcr.io/${REPOSITORY_NAME}/${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
        // stage('Deploy to GKE') {
        //     steps {
        //         script {
        //             // Apply deployment to GKE
        //             sh "kubectl apply -f deployment.yaml"
        //         }
        //     }
        // }
    }
}
