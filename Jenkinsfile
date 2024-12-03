/* import shared library */
@Library('shared_library')_
pipeline {
    environment {

        IMAGE_NAME = "${PARAM_IMAGE_NAME}"                    /*ic-webapp*/
        //APP_NAME = "${PARAM_APP_NAME}"                        
        IMAGE_TAG = "${PARAM_IMAGE_TAG}"                      /*1.0*/
        

        DOCKERHUB_USR = "${PARAM_DOCKERHUB_ID}"             /*younesabdh*/
        DOCKERHUB_PSW = credentials('dockerhub_psw')
        APP_EXPOSED_PORT = "${PARAM_EXPOSED_PORT}"            /*8000 by default*/


        INTERNAL_PORT = "${PARAM_INTERNAL_PORT}"              /*8000 by default*/
        EXTERNAL_PORT = "${PARAM_EXPOSED_PORT}"
        CONTAINER_IMAGE = "${DOCKERHUB_USR}/${IMAGE_NAME}:${IMAGE_TAG}"
    }
    agent none
    stages {
        stage('Build image') {
            agent any
            steps {
                script {
                    sh 'docker build -t ${DOCKERHUB_USR}/$IMAGE_NAME:$IMAGE_TAG .'
                }
            }
        }
        stage('Run container based on built image'){
            agent any
            steps {
                script{
                    sh '''

                        echo "Cleaning existing container if exists"
                        docker ps -a | grep -i $IMAGE_NAME && docker rm -f $IMAGE_NAME
                        docker run --name $IMAGE_NAME -d -p $APP_EXPOSED_PORT:$INTERNAL_PORT ${DOCKERHUB_USR}/$IMAGE_NAME:$IMAGE_TAG
                        sleep 5
                    '''
                }
            }
        }
        stage('Test image') {
            agent any
            steps{
                script {
                    sh 'docker stop ${IMAGE_NAME} || true && docker rm ${IMAGE_NAME} || true'
                    sh 'docker run --name $IMAGE_NAME -d -p $APP_EXPOSED_PORT:$INTERNAL_PORT ${DOCKERHUB_USR}/$IMAGE_NAME:$IMAGE_TAG'
                    sh 'curl -k http://172.17.0.1:$APP_EXPOSED_PORT | grep -i "IC GROUP"'
                    sh 'sleep 10'
                    sh 'if [ $? -eq 0 ]; then echo "Acceptance test succeeded"; fi'
                }
            }
        }
        stage('Clean container') {
            agent any
            steps{
                script {
                    sh '''
                        docker stop $IMAGE_NAME
                        docker rm $IMAGE_NAME
                    '''
                }
            }
        }
        stage('Login and Push Image on Docker Hub') {
            when{
                expression {GIT_BRANCH == 'origin/main'}
            }
            agent any
            steps{
                script {
                    sh '''
                        echo $DOCKERHUB_PSW | docker login -u $DOCKERHUB_USR --password-stdin
                        docker push $DOCKERHUB_USR/$IMAGE_NAME:$IMAGE_TAG
                    '''
                }
            }
        }

    }
  post {
    always {
      script {
        slackNotifier currentBuild.result
      }
    }  
  }
}