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
        choice(
            choices: 'apply\ndestroy\n'
            description: 'The apply or destroy of terraform stack',
            name: 'buildState'
        )
    }

    stages {
        
        stage('Terraform Version') {
            steps {
                sh 'terraform --version';
                sh 'echo "${GIT_BRANCH}"';
            }
        }
        
        stage('Terraform Init') {
            when{
                expression {
                    params.buildState == "apply"
                }
            }

            steps {
                sh 'terraform init'
            }
        }
        
        stage('Terraform Plan') {
            steps {
                script {
                    if ("${GIT_BRANCH}" == 'origin/master'){
                        sh 'terraform plan -var-file ./config/prod.tfvars';
                    }
                    else{
                        sh 'terraform plan -var-file ./config/dev.tfvars';
                    }
                }

            }
        }
        
        stage('Terraform Apply') {
            when{
                expression {
                    params.buildState == "apply"
                }
            }

            steps {
                script {
                    if ("${GIT_BRANCH}" == 'origin/master'){
                        sh 'terraform apply -var-file ./config/prod.tfvars -auto-approve';
                    }
                    else{
                        sh 'terraform apply -var-file ./config/dev.tfvars -auto-approve';
                    }
                }
            }
        }
        
        stage('Terraform destroy') {
            when{
                expression {
                    params.buildState == "destroy"
                }
            }
            
            steps {
                sh 'terraform destroy -var-file ./config/dev.tfvars -auto-approve'
            }
        }
    }
}
