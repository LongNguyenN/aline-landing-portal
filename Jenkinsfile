pipeline {
    agent any
    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "M3"
    }
    environment {
        TAG = "alpha"
        AWS_ACCESS_KEY_ID     = credentials('ln-aws-id')
        AWS_SECRET_ACCESS_KEY = credentials('ln-aws-key')
        SERVICE_ENV = credentials('ln-env')
	TERRAFORM_SECRET = credentials('ln-terraform-secret')
    }
    stages {
        stage('Build') {
            steps {
                echo 'Building..'
	            sh "mvn clean package -DskipTests"
            }
        }
        stage('SonarQube analysis') {
            steps {
                echo 'Testing..'
                withSonarQubeEnv('sonarqube-scanner') {
                    sh "mvn sonar:sonar"
                }
            }
        }
        stage("Quality gate") {
            steps {
                timeout(time: 1, unit: 'HOURS') {
			echo "Waiting for quality gate.."
                            //waitForQualityGate abortPipeline: true
                }
            }
        } 
        stage('Docker') {
            steps {
                echo 'Building image with docker....'
                sh "docker build -t ln/bank ."
            }
        }
        stage('Push to ECR') {
            steps {
                echo 'Pushing to ECR....'
                withCredentials([string(credentialsId: 'amazon-id', variable: 'AMAZON_ID')]) {
                    script {
                        docker.withRegistry("https://${AMAZON_ID}.dkr.ecr.us-east-1.amazonaws.com", 'ecr:us-east-1:ln-aws-creds') {
                            docker.image('ln/bank').push("$TAG")
                        }
                    }
                }
            }
        }
	stage('Deploy to EKS using eksctl') {
	    steps {
		echo "Deploying EKS.."
		sh "bash ./eks-up.sh"
	    }
	}
    }
    post { 
        always { 
            echo 'Clean workspace...'
            cleanWs()
        }
    }
}
