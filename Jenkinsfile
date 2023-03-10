pipeline {

    agent any
    environment {
    DOCKER_REGISTRY = "https://registry.hub.docker.com" // e.g. "docker.io"
    DOCKER_REPO_NAME = "kebsdev/php-todo"
  //  DOCKER_USERNAME = credentials('kebsdev')
  //  DOCKER_PASSWORD = credentials('dockerhub')
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
                git branch: 'main',  url: 'https://github.com/kebsOps/php-todo.git'
            }
        }
    

          stage('Build Docker image') {
            steps {
                script {
                    sh """
                          sh "docker build -t kebsOps/php-todo:${env.BRANCH_NAME}-${env.BUILD_NUMBER} ."
                    """
                }
            }
        }

      stage('Push Docker image') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'docker-registry-credentials', url: "${DOCKER_REGISTRY}"]) {
                        sh """
                          docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}
                          docker push kebsOps/php-todo:${env.BRANCH_NAME}-${env.BUILD_NUMBER}
                        """
                    }
                }
            }
        }
    }
}


