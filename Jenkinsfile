pipeline {
  agent any

  environment {
    registryCredential = 'rasdocker'
  }

  stages {
    stage('Build') {
      steps {
        script {
          builtImage = docker.build "pittras/magellan-2018-base:$BUILD_NUMBER"
        }
      }
    }
  }
}
