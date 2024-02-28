pipeline {
    agent any
    environment {
        PROJECT_ID = 'project-satheesh'
        LOCATION = 'us-central1'
        REPOSITORY_NAME = 'test-artifact-build'
        IMAGE_NAME = 'hello'
        IMAGE_TAG = env.BUILD_ID
        SERVICE_ACCOUNT_KEY = credentials('ce9a5b338acfa1ceecda86d21191cd431d2ec901')
    }
    stages {
        stage("Checkout code") {
            steps {
                // Checkout code and change directory to the parent directory
                checkout scm
                dir('.') {
                    // Build the Docker image from the Dockerfile in the parent directory
                    script {
                        docker.build("${PROJECT_ID}.gcr.io/${REPOSITORY_NAME}/${IMAGE_NAME}:${IMAGE_TAG}")
                    }
                }
            }
        }
        stage('Push image to Artifact Registry') {
            steps {
                script {
                    // Authenticate with Google Cloud using service account key
                    withCredentials([file(credentialsId: SERVICE_ACCOUNT_KEY, variable: 'SERVICE_ACCOUNT_KEY_FILE')]) {
                        sh """
                            gcloud auth activate-service-account --key-file="$SERVICE_ACCOUNT_KEY_FILE"
                            gcloud auth configure-docker
                        """
                    }
                    // Push the Docker image to Artifact Registry
                    docker.image("${PROJECT_ID}.gcr.io/${REPOSITORY_NAME}/${IMAGE_NAME}:${IMAGE_TAG}").push()
                }
            }
        }
        stage('Deploy to GKE') {
            steps {
                script {
                    // Deploy to GKE using Kubernetes Engine builder
                    sh "sed -i 's/hello:latest/hello:${IMAGE_TAG}/g' deployment.yaml"
                    step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'deployment.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
                }
            }
        }
    }
}
