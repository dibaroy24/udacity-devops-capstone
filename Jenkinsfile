pipeline {
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
				// sh '/home/ubuntu/.local/bin/hadolint Dockerfile'
				sh 'docker run --rm -i hadolint/hadolint < Dockerfile'
			}
		}
		stage('Building image') {
			steps {
				echo 'Building Docker image...'
				withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
					sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
					sh "docker build -t dibaroy24/udacity-devops-capstone ."
					sh "docker tag dibaroy24/udacity-devops-capstone dibaroy24/udacity-devops-capstone"
					sh "docker push dibaroy24/udacity-devops-capstone"
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
