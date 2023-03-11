pipeline {

    agent any
    
    environment {
            DOCKERHUB_CREDENTIALS=credentials('dockerhub-cred-kebsdev')
            DOCKER_REGISTRY = "docker.io"
            IMAGE_NAME = "kebsOps/php-todo"
            IMAGE_TAG = "feature-${env.BRANCH_NAME}-0.0.1"
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
                   // sh  'docker build -t kebsOps/php-todo:${env.BRANCH_NAME}-${env.BUILD_NUMBER} .'
                  sh  'docker build("${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}") '
                }
              }
            }

      

      stage('Push Docker image') {
            steps {
                script {
                    docker.withRegistry("${DOCKER_REGISTRY}", "docker-credentials-id") {
                        dockerImage.push("${IMAGE_TAG}")
                    }
                }
            }
        }
    }
}


