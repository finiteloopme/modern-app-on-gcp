#! /bin/bash
# Install Docker
sudo apt update
sudo apt install --yes apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
sudo apt update
sudo apt install --yes docker-ce

NEW_USER=developer
sudo adduser \
   --system \
   --group \
   --disabled-password \
   $NEW_USER

# Enable docker to be run without sudo
sudo groupadd docker
sudo usermod -aG docker $NEW_USER

sudo apt install -y kubectl
sudo apt install -y snapd
sudo snap install yq

# Install Minikube
echo "Start installing minikube"
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb
#sudo -u ${NEW_USER} minikube start
sudo -u ${NEW_USER} minikube start
echo "Done installing minikube"
