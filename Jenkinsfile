pipeline {
    agent any
    tools {
        terraform 'Terraform'
    }
    parameters {
        choice(
            choices: 'dev\nprod\n',
            description: 'Name of Environment',
            name: 'environment'
        )
    }

    stages {
        
        stage('Terraform Version') {
            steps {
                sh 'terraform --version'
                sh 'echo "${GIT_BRANCH}"'
                sh 'echo "${env.BRANCH_NAME}"'
            }
        }
        
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        
        stage('Terraform Plan') {
            steps {
                script {
                    if (${GIT_BRANCH} == 'origin/master'){
                        sh 'terraform plan -var-file ./config/prod.tfvars'
                    }
                    else{
                        sh 'terraform plan -var-file ./config/dev.tfvars'
                    }
                }

            }
        }
        
        stage('Terraform Apply') {
            steps {
                script {
                    if (${GIT_BRANCH} == 'origin/master'){
                        sh 'terraform apply -var-file ./config/prod.tfvars -auto-approve'
                    }
                    else{
                        sh 'terraform apply -var-file ./config/dev.tfvars -auto-approve'
                    }
                }
            }
        }
        
        // stage('Terraform destroy') {
            
        //     steps {
        //         sh 'terraform destroy -var-file ./config/dev.tfvars -auto-approve'
        //     }
        // }
    }
}
