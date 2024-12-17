/* import shared library */
@Library('shared-library')_
pipeline {
    environment {

        IMAGE_NAME = "${PARAM_IMAGE_NAME}"                    /*ic-webapp*/
        IMAGE_TAG = "${PARAM_IMAGE_TAG}"                      /*1.0*/
        APP_EXPOSED_PORT = "${PARAM_EXPOSED_PORT}"            /*8000 by default*/
        INTERNAL_PORT = "${PARAM_INTERNAL_PORT}"              /*8000 by default*/
        EXTERNAL_PORT = "${PARAM_EXPOSED_PORT}"
        CONTAINER_IMAGE = "${DOCKERHUB_USR}/${IMAGE_NAME}:${IMAGE_TAG}"
        DOCKERHUB_USR = "${PARAM_DOCKERHUB_ID}"             /*younesabdh*/
        DOCKERHUB_PSW = credentials('dockerhub_psw')
        PRIVATE_KEY = credentials('private_key')            // SSH private key for Ansible access

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
                    sh 'sleep 5'
                    sh 'curl -k http://172.17.0.1:$APP_EXPOSED_PORT | grep -i "IC GROUP"'
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

        // stage('Login and Push Image on Docker Hub') {
        //     when{
        //         expression {GIT_BRANCH == 'origin/main'}
        //     }
        //     agent any
        //     steps{
        //         script {
        //             sh '''
        //                 echo $DOCKERHUB_PSW | docker login -u $DOCKERHUB_USR --password-stdin
        //                 docker push $DOCKERHUB_USR/$IMAGE_NAME:$IMAGE_TAG
        //             '''
        //         }
        //     }
        // }

        // stage('Provision DEV env on AWS') {
        //     agent { 
        //         docker { 
        //             image 'jenkins/jnlp-agent-terraform'  
        //         } 
        //     }
        //     environment {
        //         AWS_ACCESS_KEY = credentials('aws_access_key')
        //         AWS_SECRET_KEY = credentials('aws_secret_key')
        //         AWS_PRIVATE_KEY = credentials('aws_private_key')
        //     }
        //     steps {
        //         script {
        //             sh '''
        //                 echo "Setting up AWS credentials"
        //                 rm -rf devops-hamid.pem ~/.aws || true
        //                 mkdir -p ~/.aws

        //                 echo "[default]" > ~/.aws/credentials
        //                 echo "aws_access_key_id=$AWS_ACCESS_KEY" >> ~/.aws/credentials
        //                 echo "aws_secret_access_key=$AWS_SECRET_KEY" >> ~/.aws/credentials
        //                 chmod 600 ~/.aws/credentials

        //                 cd "/var/jenkins_home/workspace/ic-webapp"
        //                 echo "Cleaning up old files"
        //                 rm -f devops-hamid.pem

        //                 echo "Configuring AWS private key"
        //                 cp $AWS_PRIVATE_KEY devops-hamid.pem
        //                 chmod 600 devops-hamid.pem
        //             '''

        //             // Create Dev environment
        //             sh '''
        //                 echo "Initializing Terraform"
        //                 cd "./sources/terraform/dev"
        //                 terraform init -input=false

        //                 echo "Validating Terraform configuration"
        //                 terraform validate

        //                 echo "Generating Terraform plan"
        //                 terraform plan -out=tfplan

        //                 echo "Applying Terraform plan"
        //                 terraform apply -input=false -auto-approve tfplan

        //                 echo "Generating host_vars for EC2 dev-server"
        //                 echo "ansible_host: $(awk '{print $2}' ./files/ec2_IP.txt)" > /var/jenkins_home/workspace/ic-webapp/sources/ansible/host_vars/dev-server.yml

        //             ''' 
        //         }
        //         stash includes: '**/*', name: 'workspace-stash'
        //     }
        // }

        // stage('Deploy app on DEV env on AWS') {
        //     agent {
        //         docker {
        //             image 'registry.gitlab.com/robconnolly/docker-ansible:latest'
        //         }
        //     }
        //     stages {
        //         stage ('Ping dev server'){
        //             steps {
        //                 unstash 'workspace-stash'
        //                 script {
        //                     sh '''
        //                         apt update -y
        //                         apt install sshpass -y

        //                         export ANSIBLE_CONFIG=$PWD/sources/ansible/ansible.cfg
        //                         ansible dev-server -m ping --private-key devops-hamid.pem
        //                     '''
        //                 }
        //             }
        //         }

        //         stage ('Install Docker and Deploy app on DEV env'){
        //             steps {
        //                 unstash 'workspace-stash'
        //                 script {
        //                     sh '''
        //                         export ANSIBLE_CONFIG=$PWD/sources/ansible/ansible.cfg
        //                         ansible-playbook sources/ansible/playbooks/install_docker_linux.yml --private-key devops-hamid.pem -l dev
        //                         ansible-playbook sources/ansible/playbooks/deploy_odoo.yml --private-key devops-hamid.pem -l dev
        //                         ansible-playbook sources/ansible/playbooks/deploy_pgadmin.yml --private-key devops-hamid.pem -l dev
        //                         ansible-playbook sources/ansible/playbooks/deploy_icwebapp.yml --private-key devops-hamid.pem -l dev


        //                     '''
        //                 }
        //             }
        //         }
        //     }
        // }

        // stage('Delete DEV env and Provision PROD env') {
        //     agent {
        //         docker { 
        //             image 'jenkins/jnlp-agent-terraform'  
        //         }
        //     }
        //     environment {
        //         AWS_ACCESS_KEY = credentials('aws_access_key')
        //         AWS_SECRET_KEY = credentials('aws_secret_key')
        //         AWS_PRIVATE_KEY = credentials('aws_private_key')
        //     }

        //     steps {
        //         unstash 'workspace-stash'
        //         script {

        //             input message: "Do you confirm deleting AWS DEV environment ?", ok: 'Yes'

        //             // Delete DEV environment
        //             sh'''
        //                 cd "./sources/terraform/dev"
        //                 terraform destroy --auto-approve
        //             '''
        //             // Create PROD environment
        //             sh '''
        //                 echo "Initializing Terraform"
        //                 cd "./sources/terraform/prod"
        //                 terraform init -input=false

        //                 echo "Validating Terraform configuration"
        //                 terraform validate

        //                 echo "Generating Terraform plan"
        //                 terraform plan -out=tfplan

        //                 echo "Applying Terraform plan"
        //                 terraform apply -input=false -auto-approve tfplan

        //                 echo "Generating host_vars for EC2 prod-server"
        //                 echo "ansible_host: $(awk '{print $2}' ./files/ec2_IP.txt)" > /var/jenkins_home/workspace/ic-webapp/sources/ansible/host_vars/prod-server.yml
        //             ''' 
        //         }
        //         stash includes: '**/*', name: 'workspace-prod-stash'
        //     }
        // }

        // stage('Deploy app on PROD env on AWS') {
        //     agent {
        //         docker {
        //             image 'registry.gitlab.com/robconnolly/docker-ansible:latest'
        //         }
        //     }
        //     stages {
        //         stage ('Ping PROD server'){
        //             steps {
        //                 unstash 'workspace-prod-stash'
        //                 script {
        //                     sh '''
        //                         apt update -y
        //                         apt install sshpass -y
        //                         pwd

        //                         export ANSIBLE_CONFIG=$PWD/sources/ansible/ansible.cfg
        //                         ansible prod-server -m ping --private-key devops-hamid.pem
        //                     '''
        //                 }
        //             }
        //         }

        //         stage ('Install Docker and Deploy applications PROD env on AWS'){
        //             steps {
        //                 unstash 'workspace-prod-stash'
        //                 script {
        //                     sh '''
        //                         export ANSIBLE_CONFIG=$PWD/sources/ansible/ansible.cfg
        //                         ansible-playbook sources/ansible/playbooks/install_docker_linux.yml --private-key devops-hamid.pem -l prod
        //                         ansible-playbook sources/ansible/playbooks/deploy_odoo.yml --private-key devops-hamid.pem -l prod
        //                         ansible-playbook sources/ansible/playbooks/deploy_pgadmin.yml --private-key devops-hamid.pem -l prod
        //                         ansible-playbook sources/ansible/playbooks/deploy_icwebapp.yml --private-key devops-hamid.pem -l prod
        //                     '''
        //                 }
        //             }
        //         }
        //     }
        // }

    }

    post {
        always {
            script {
                slackNotifier currentBuild.result
            }
        }  
    }
}