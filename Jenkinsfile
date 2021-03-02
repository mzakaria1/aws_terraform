pipeline {
    agent any
    tools {
        terraform 'Terraform'
    }

    stages {
        
        stage('Terraform Version') {
            steps {
                sh 'terraform --version'
            }
        }
        
        stage('Terraform Init') {
            // when {
            //     expression {
            //         $.ref == "ref/head/master" ;
            //     }
            // }
            // when {
            //     env.BRANCH_NAME ==  'master'
            // }

            steps {
                script {
                    if env.BRANCH_NAME == 'master'{
                        sh 'terraform init'
                    }
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -var-file ./config/dev.tfvars'
            }
        }
        
        stage('Terraform Apply') {
            when {
                branch 'master'
            }
            steps {
                script {

                }
                sh 'terraform apply -var-file ./config/dev.tfvars -auto-approve'
            }
        }
        
        stage('Terraform destroy') {
            
            steps {
                sh 'terraform destroy -var-file ./config/dev.tfvars -auto-approve'
            }
        }
    }
}
