pipeline {

    agent any
    
    environment {
            DOCKERHUB_CREDENTIALS=credentials('dockerhub-cred-kebsdev')
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
                    sh  'docker build -t kebsOps/php-todo:${env.BRANCH_NAME}-${env.BUILD_NUMBER} .'
                  
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


