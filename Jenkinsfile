pipeline {
    agent { 
        label 'master' 
    }

    parameters {
        string(
            name: 'DOCKER_TAG',
            defaultValue: 'latest',
            description: 'Tag to use for the Docker image (e.g., latest, v1.0, build-42)'
        )
    }

    environment {
        DOCKER_IMAGE = "mohancggrl/petclinic"
    }

    tools {
        jdk 'jdk17'
    }

    stages {
        stage('Build with Maven') {
            steps {
                script {
                    sh '''
                        echo "🚀 Building project with Maven (skipping tests)..."
                        mvn clean install -DskipTests -s ./settings.xml
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "🐳 Building Docker image with tag: ${params.DOCKER_TAG} ..."
                    sh """
                        docker build -t ${DOCKER_IMAGE}:${params.DOCKER_TAG} .
                    """
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    script {
                        echo "📤 Logging in and pushing Docker image to Docker Hub..."
                        sh """
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                            docker push ${DOCKER_IMAGE}:${params.DOCKER_TAG}
                            docker logout
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Build and Docker push completed successfully. Image: ${DOCKER_IMAGE}:${params.DOCKER_TAG}"
        }
        failure {
            echo "❌ Build failed. Check logs for details."
        }
        always {
            echo "🧹 Cleaning up workspace..."
            cleanWs()  // <-- Cleans the Jenkins workspace after every run
        }
    }
}
