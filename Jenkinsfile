pipeline {

    agent any
      
    environment {
            DOCKERHUB_CREDENTIALS=credentials('dockerhub-cred-kebsdev')
            DOCKER_REGISTRY = "hub.docker.com"
            IMAGE_NAME = "kebsdev/php-todo"
            IMAGE_TAG = "feature-${env.BRANCH_NAME}-0.0.${env.BUILD_NUMBER}"

            
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

                  sh  'docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" .'
              
                }
              }

        stage("Start A") {
          script {
                    sh "sleep 60"
                    sh "curl -I 105.113.6.66:8000"
                }
        }

        stage('Push Docker image') {
            steps {
                when { expression { response.status == 200 } }
                    withCredentials([string(credentialsId: 'docker-pat', variable: 'dockerpat')]) {
                        sh 'docker login -u kebsdev -p ${dockerpat}'
                        sh 'docker push "${IMAGE_NAME}:${IMAGE_TAG}"'
            }             
          }
        }
    }
}


