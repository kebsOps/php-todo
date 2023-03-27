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

        stage("Start APP") {
            steps {
                sh 'docker-compose -f tooling.yaml  up -d'
            }
        }    

        stage("Test Endpoint") {
            steps {
                script {
                     while (true) {
                        def response = httpRequest 'http://localhost:8000'
                        if (response.status == 200) {
                           echo(message: 'Test successful')
                            }
                            break 
                        }
                    }
                }
            }
        

        stage('Push Docker image') {
            steps {
           
                    withCredentials([string(credentialsId: 'docker-pat', variable: 'dockerpat')]) {
                        sh 'docker login -u kebsdev -p ${dockerpat}'
                        sh 'docker push "${IMAGE_NAME}:${IMAGE_TAG}"'
            }             
          }
        }
    }
}


