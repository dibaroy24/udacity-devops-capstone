@Library('github.com/releaseworks/jenkinslib') _
pipeline {
	 environment {
		 registry = "dibaroy/udacity_devops_capstone_app"
		 registryCredential = 'dockerhub'
		 dockerImage = ''
	 }
  agent any
	stages {
		stage('Checking out git repo') {
			steps {
				// def registry = 'dibaroy24/udacity-devops-capstone'
				echo 'Checkout...'
				checkout scm
			}
		}
		stage('Checking environment') {
			steps {
				echo 'Checking environment...'
				sh 'git --version'
				echo "Branch: ${env.BRANCH_NAME}"
				sh 'docker -v'
			}
		}
		stage("Linting") {
			steps {
				echo 'Linting...'
				// sh 'sudo -S /home/dibaroy/.local/bin/hadolint Dockerfile'
				// sh '/home/ubuntu/.local/bin/hadolint Dockerfile'
				// sh 'docker run --rm -i hadolint/hadolint < Dockerfile'
				sh 'hadolint Dockerfile'
			}
		}
		stage('Building Docker Image') {
			steps {
				echo 'Building Docker image...'
				script {
					// dockerImage = docker.build registry + ":$BUILD_NUMBER"
					dockerImage = docker.build registry + ":latest"
				}
			}
		}
		stage('Deploying Docker Image') {
			steps {
				echo 'Deploying Docker image...'
				script {
					docker.withRegistry( '', registryCredential ) {
						dockerImage.push()
					}
				}
			}
		}
		stage('Deploying') {
			steps {
				echo 'Deploying to AWS EKS...'
				dir ('infrastructure') {
					withAWS(credentials: 'udacity-user', region: 'us-east-1') {
						// sh "aws2 eks --region us-east-1 update-kubeconfig --name udacity-devops-capstone-nginxcluster --role-arn arn:aws:iam::638224466109:role/udacity-devops-capstone-eks-node-NodeInstanceRole-15AR16QYFM2XP"
						sh "aws2 eks --region us-east-1 update-kubeconfig --name udacity-devops-capstone-nginxcluster"
						sh "curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl"
						sh "chmod +x ./kubectl"
						sh "mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH"
						sh "kubectl apply -f aws-auth-cm.yaml"
						// sh "kubectl set image deployments/capstone-app capstone-app=dibaroy24/udacity-devops-capstone:latest"
						sh "kubectl apply -f app-deployment.yml"
						sh "kubectl get nodes"
						sh "kubectl get pods"
					}
				}
			}
		}
		stage("Cleaning up") {
			steps {
				echo 'Cleaning up...'
				sh "docker system prune"
			}
		}
	}
}
