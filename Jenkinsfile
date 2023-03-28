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

           stage("Start the app") {
          steps {
              sh 'docker compose -f tooling.yaml  up -d'
             
          }
      }

        stage("Test App") {
         steps {
             script {
                def response = sh(returnStdout: true, script: "curl -s -o /dev/null -w '%{http_code}' localhost:8000")
                  // def response = httpRequest 'http://localhost:8000'
                    if (response.status == 200) {
                        echo 'Endpoint test passed!'
                    } else {
                        error 'Endpoint test failed with response code: ' + response
                    }
                
                }
            }
        }

        stage('Push Docker image') {
             when { expression { response.status == 200 } }
            steps {
                    withCredentials([string(credentialsId: 'docker-pat', variable: 'dockerpat')]) {
                        sh 'docker login -u kebsdev -p ${dockerpat}'
                        sh 'docker push "${IMAGE_NAME}:${IMAGE_TAG}"'
            }             
          }
        }

        stage ('Clean Up') {
            steps {
                script {
                    sh 'docker stop "${IMAGE_NAME}:${IMAGE_TAG}"'
                    sh 'docker rm "${IMAGE_NAME}:${IMAGE_TAG}"'
                    sh 'docker rmi "${IMAGE_NAME}:${IMAGE_TAG}:${env.BRANCH_NAME}-${env.BUILD_NUMBER}'
                }
            }
        }
    }
}


