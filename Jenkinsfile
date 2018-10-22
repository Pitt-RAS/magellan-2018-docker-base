pipeline {
  agent any

  stages {
    stage('Submodule Checkout') {
        steps {
            script {
                sh 'git submodule update --init --recursive'
            }
        }
    }
    stage('Build') {
      steps {
        script {
          builtImage = docker.build("pittras/magellan-2018-base:$BRANCH_NAME-$BUILD_ID", "--no-cache .")
        }
      }
    }
    stage('Push') {
      steps {
        script {
          withDockerRegistry([credentialsId: 'rasdocker', url: '']) {
            builtImage.push()
          }
        }
      }
    }
  }
  post {
    always {
        cleanWs()
    }
  }
}
