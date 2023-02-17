pipeline {

    agent any
    environment {
    DOCKER_REGISTRY = "hub.docker.com/repository/docker/kebsdev/php-todo-jenkins" // e.g. "docker.io"
    DOCKER_IMAGE_NAME = "php-todo" // e.g. "my-app"
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
                git branch: 'main', url: 'https://github.com/kebsOps/php-todo.git'
            }
        }
        

       stage("Build Docker Image") {
        steps {
         script {
          docker.build("${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}", "-f Dockerfile .")
        }
      }
    }

      stage("Push Docker Image") {
       steps {
        script {
          docker.withRegistry("${DOCKER_REGISTRY}", "docker-registry-credentials-id") {
            docker.image("${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}").push()
          }
        }
      }

    }

}
    

