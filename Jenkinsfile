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
            sh 'docker run --network php_todo_app_network -h mysqlserverhost --name=mysql-server -e MYSQL_ROOT_PASSWORD=admin12345 -d '
            sh 'docker exec -i mysql-server mysql -uroot -p$MYSQL_PW < create_php_todo_user.sql'
            sh  'docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" .'
              
                }
              }

             stage("Start the app") {
          steps {
                script {
                    sh 'docker run -d -p 8000:8000 "${IMAGE_NAME}:${IMAGE_TAG}" '
                }
            }
        }

         stage("Test App") {
          steps {
            script{
                sh 'sleep 10'
                sh 'curl -I http://localhost:8000 | grep -q "HTTP/1.1 200 OK"'
                }
            }
        }
        
        stage('Push Docker image') {
           //  when { expression { response.status == 200 } }
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
                    sh 'docker rm "${IMAGE_NAME}:${IMAGE_TAG}"'
                }
            }
        }
    }
}


