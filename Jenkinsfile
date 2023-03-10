pipeline {

    agent any
    environment {
    DOCKER_REGISTRY = "https://registry.hub.docker.com" // e.g. "docker.io"
    DOCKER_REPO_NAME = "kebsdev/php-todo"
    DOCKER_USERNAME = credentials('kebsdev')
    DOCKER_PASSWORD = credentials('dockerhub')
    DOCKER_IMAGE_TAG = "feature-${env.BRANCH_NAME}-0.0.1" // e.g. "feature-main-0.0.1"
  }

    stages {

        stage("Workspace Cleanup") {
            steps{
                dir("$WORKSPACE") {
                    deleteDir()
                }
            
            }
        }

         stage('Checkout SCM') {
            steps {
                git branch: 'main',  credentialsId: '1ec4f5ca-4594-4117-b75f-52eee5798ec4', url: 'https://github.com/kebsOps/php-todo.git'
            }
        }
    

          stage('Build Docker image') {
            steps {
                script {
                    sh """
                        docker build -t ${DOCKER_REGISTRY}/${DOCKER_REPO_NAME}:${DOCKER_IMAGE_TAG} .
                    """
                }
            }
        }

      stage('Push Docker image') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'docker-registry-credentials', url: "${DOCKER_REGISTRY}"]) {
                        sh """
                            docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD} ${DOCKER_REGISTRY}
                            docker push ${DOCKER_REGISTRY}/${DOCKER_REPO_NAME}:${DOCKER_IMAGE_TAG}
                        """
                    }
                }
            }
        }
    }
}


