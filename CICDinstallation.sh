#!/bin/bash
echo "This is the file for installation of tools of CICD Pipeline (Jenkins,minikube,kubectl,argocd)"
sleep 2
echo "Please ensure that the user running the script has sudo permissions and this script is designed for CentOS and RHEL Only"
sleep 2
echo "First Installation is of Jenkins requires some tools to be installed"
sleep 1
sudo yum update
sleep 1
echo "Need of Container Technology....."
sleep 1
sudo yum install -y podman
echo "Starting the Installion of Jenkins......"
sleep 1
podman pull docker.io/devopsjourney1/jenkins-blueocean:2.332.3-1 && podman tag devopsjourney1/jenkins-blueocean:2.332.3-1 myjenkins-blueocean:2.332.3-1
echo "Creating a Network For jenkins....."
sleep 1
podman network create jenkins
echo "Starting the Jenkins Container......"
sleep 1
podman run --name jenkins-blueocean --restart=on-failure --detach \
  --network jenkins --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  myjenkins-blueocean:2.332.3-1
echo "Extracting the Password...... (copy karlo login kar paoge)"
sleep 1
docker exec jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword
echo "Its running on https://localhost:8080/"
curl https://localhost:8080/
echo "Finally the Jenkins installation is Completed"
sleep 1
echo "Now lets install minikube for readytodeploy cluster for (x86_64 if your architecture is different refer offical documentation)"
sleep 1
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
echo "Starting the minikube cluster......"
sleep 1
minikube start
echo "Checking pods......"
sleep 1
kubectl get pods -A
echo "Ohh we have not install kubectl so we got an error so lets install it for accessing the cluster"
sleep 2
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
echo "validating the binary...."
sleep 1
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
echo "output is okk good to install"
sleep 1
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
echo "lets check its installed properly or not (fingers crossed)"
sleep 1
kubectl version --client
echo "Now the minikube and kubectl installation is done successfully lets install argocd on cluster we just started"
sleep 2
kubectl create namespace argocd
echo "Installing argocd on minikube cluster........."
sleep 1
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
echo "Extracting the Initial admin-password for login (copy karlo)"
sleep 1
argocd admin initial-password -n argocd
echo "Port-forwarding the argocd service for acccessing UI"
sleep 1
kubectl port-forward svc/argocd-server -n argocd 8080:443
echo "Here the whole installation of all different tools finished get ready to configure this tools :-) :-)"
sleep 3
echo "Finishing ......."
sleep 2