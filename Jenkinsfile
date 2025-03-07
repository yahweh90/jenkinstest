pipeline {
    agent any
    tools {
        jfrog 'jfrog-cli'
    }
    
    environment {
        AWS_REGION = 'us-east-1'
        TF_IN_AUTOMATION = 'true'
    }
    
    options {
        timestamps()
        disableConcurrentBuilds()
        timeout(time: 1, unit: 'HOURS')
    }
    
    stages {
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
            }
        }
        
        stage('Checkout Code') {
            steps {
                git branch: 'main', 
                    url: 'https://github.com/yahweh90/jenkinstest',
                    changelog: true
            }
        }

        stage('Initialize Terraform') {
            steps {
                sh 'terraform --version'
                sh 'terraform init -no-color'
            }
        }

        stage('Plan Terraform') {
            steps {
                withAWS(credentials: 'jenkins', region: env.AWS_REGION) {
                    sh '''
                        terraform plan -no-color -out=tfplan
                        terraform show -no-color tfplan > tfplan.txt
                    '''
                    archiveArtifacts artifacts: 'tfplan.txt', fingerprint: true
                }
            }
        }

        stage('Upload Plan to JFrog') {
           stages {
               stage ('Testing') {
                   steps {
                       jf '-v' 
                       jf 'c show'
                       jf 'rt ping'
                       sh 'touch test-file'
                       jf 'rt u test-file jfrog-cli/'
                       jf 'rt bp'
                       jf 'rt dl jfrog-cli/test-file'
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                input message: "Review the plan in tfplan.txt. Approve Terraform Apply?", ok: "Deploy"
                withAWS(credentials: 'jenkins', region: env.AWS_REGION) {
                    sh 'terraform apply -no-color -auto-approve tfplan'
                }
            }
        }
    }
    
    post {
        always {
            cleanWs(cleanWhenNotBuilt: false,
                   deleteDirs: true,
                   disableDeferredWipeout: true,
                   notFailBuild: true)
        }
        success {
            echo 'Terraform deployment completed successfully!'
        }
        failure {
            echo 'Terraform deployment failed!'
        }
    }
}
