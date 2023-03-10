pipeline {

    agent any
    
  

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
                        docker build -t kebsOps/php-todo:${env.BRANCH_NAME}-${env.BUILD_NUMBER} .
                    """
                }
            }
        }

      stage('Push Docker image') {
            steps {
                script {
                     withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
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


