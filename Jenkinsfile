pipeline {
  agent any

  environment {
    registryCredential = 'rasdocker'
  }

  stages {
    stage('Build') {
      steps {
        script {
          builtImage = docker.build "pittras/magellan-2018-base:$BRANCH_NAME"
        }
      }
    }
    stage('Push') {
      steps {
        script {
          builtImage.push()
        }
      }
    }
  }
}
