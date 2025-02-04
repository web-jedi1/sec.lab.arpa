pipeline {
    agent any

    stages {
        stage('Checkout GitHub Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/web-jedi1/sec.lab.arpa.git'
            }
        }

        stage('Install Terraform') {
            steps {
                script {
                    if (!fileExists('/usr/local/bin/terraform')) {
                        echo "Terraform not found. Installing..."
                        sh 'curl -LO https://releases.hashicorp.com/terraform/1.5.3/terraform_1.5.3_linux_amd64.zip'
                        sh 'unzip terraform_1.5.3_linux_amd64.zip'
                        sh 'sudo mv terraform /usr/local/bin/'
                        sh 'terraform --version'
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform -chdir=terraform init -var-file="$TFVARS" -upgrade'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    sh 'terraform -chdir=terraform plan -var-file="$TFVARS" -out tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform -chdir=terraform apply -var-file="$TFVARS" -input=false tfplan'
                }
            }
        }
    }

    post {
        success {
            echo 'Terraform execution completed successfully.'
        }

        failure {
            echo 'Terraform execution failed.'
        }
    }
}
