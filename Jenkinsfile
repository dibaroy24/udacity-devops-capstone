pipeline {
	 environment {
		 registry = "dibaroy/udacity_devops_capstone_app"
		 registryCredential = 'dockerhub'
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
					dockerImage = docker.build registry + ":$BUILD_NUMBER"
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
				echo 'Deploying to AWS...'
				dir ('./') {
					withAWS(credentials: 'aws-credentials', region: 'us-east-1') {
						sh "aws eks --region us-east-1 update-kubeconfig --name udacity-devops-capstone-nginxcluster"
						sh "kubectl apply -f infrastructure/aws-auth-cm.yaml"
						sh "kubectl set image deployments/capstone-app capstone-app=dibaroy24/udacity-devops-capstone:latest"
						sh "kubectl apply -f infrastructure/app-deployment.yml"
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
