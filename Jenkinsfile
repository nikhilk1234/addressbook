pipeline {
   agent none
   tools{
//     jdk "myjava"
        maven "mymaven"
   }
   environment{
      DEV_SERVER_IP='ec2-user@172.31.15.100'
      DEPLOY_SERVER_IP='ec2-user@172.31.8.20'
      IMAGE_NAME='nikhilkdevops/myrepo'
   }
    stages {
        stage('Compile') { //prod
        agent any
            steps {
                echo "Compile the code"
                //sh "mvn compile"
            }
        }
         stage('UnitTest') { //test
         agent any
            steps {
                echo "Test the code"
                //sh "mvn test"
            }
        }
         stage('Package') {//dev
         //agent {label 'linux_slave'}
            agent any
            steps {
               script{
                  sshagent(['Slave2']){
                      withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                sh "scp -o StrictHostKeyChecking=no server-script.sh ${DEV_SERVER_IP}:/home/ec2-user"
               sh "ssh -o StrictHostKeyChecking=no ${DEV_SERVER_IP} bash /home/ec2-user/server-script.sh ${IMAGE_NAME}"
               sh "ssh ${DEV_SERVER_IP} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
               sh "ssh ${DEV_SERVER_IP} sudo docker push ${IMAGE_NAME}"
                    }
                }
           }
        }
    }
stage('Deploy') {//dev
         //agent {label 'linux_slave'}
            agent any
            steps {
               script{
                  sshagent(['Slave2']){
                      withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                 sh "ssh -o StrictHostKeyChecking=no ${DEPLOY_SERVER_IP} sudo yum install docker -y"
               sh "ssh ${DEPLOY_SERVER_IP} sudo systemctl start docker"
               sh "ssh ${DEPLOY_SERVER_IP} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
               sh "ssh ${DEPLOY_SERVER_IP} sudo docker run -itd -P ${IMAGE_NAME}"
                    }
                  }
           }
        }
    }    
}
}
