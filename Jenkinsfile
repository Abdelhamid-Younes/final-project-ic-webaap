pipeline {
    environment {

        IMAGE_NAME = "${PARAM_IMAGE_NAME}"                    /*ic-webapp*/
        APP_NAME = "${PARAM_APP_NAME}"                        /*younesabdh*/
        IMAGE_TAG = "${PARAM_IMAGE_TAG}"                      /*1.0*/
        

        DOCKERHUB_USR = "${PARAM_DOCKERHUB_ID}"
        DOCKERHUB_PSW = credentials('dockerhub')
        APP_EXPOSED_PORT = "${PARAM_PORT_EXPOSED}"            /*8000 by default*/


        INTERNAL_PORT = "${PARAM_INTERNAL_PORT}"              /*5000 by default*/
        EXTERNAL_PORT = "${PARAM_PORT_EXPOSED}"
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
                        sleep 30
                    '''
                }
            }
        }
        stage('Test image') {
            agent any
            steps{
                script {
                    sh '''
                        sh "docker logs $IMAGE_NAME"
                        curl http://172.17.0.1:$APP_EXPOSED_PORT | grep "IC GROUP"
                        if [ $? -eq 0 ]; then echo "Acceptance test succeed"; fi
                    '''
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

}