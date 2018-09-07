pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        script {
          builtImage = docker.build "pittras/magellan-2018-base:$BUILD_ID"
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
}
