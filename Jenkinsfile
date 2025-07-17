pipeline {
    agent any

    parameters {
        choice(name: 'SELECT_PROJECT', choices: ['project1', 'project2'], description: 'Choose which project to deploy')
    }

    environment {
        IMAGE_NAME = "${params.SELECT_PROJECT}-image"
        CONTAINER_NAME = "${params.SELECT_PROJECT}-container"
    }

    stages {

        stage('Build Selected Project') {
            steps {
                script {
                    echo "Triggering build for ${params.SELECT_PROJECT}"
                    build job: "${params.SELECT_PROJECT}", wait: true
                }
            }
        }

        stage('Copy WAR Artifact') {
            steps {
                echo "Copying WAR artifact from ${params.SELECT_PROJECT}"
                sh 'rm -rf build && mkdir build'
                copyArtifacts(
                    projectName: "${params.SELECT_PROJECT}",
                    filter: 'target/*.war',
                    target: 'build'
                )
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image for ${params.SELECT_PROJECT}"
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Run Docker Container') {
            steps {
                echo "Deploying container ${CONTAINER_NAME}"
                sh """
                    docker stop $CONTAINER_NAME || true
                    docker rm $CONTAINER_NAME || true
                    docker run -d -p 8080:8080 --name $CONTAINER_NAME $IMAGE_NAME
                """
            }
        }
    }

    post {
        success {
            echo "${params.SELECT_PROJECT} built and deployed successfully!"
        }
        failure {
            echo "Build or deployment failed for ${params.SELECT_PROJECT}"
        }
    }
}
