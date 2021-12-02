#!/usr/bin/env bash

# Install ansible if not present
which ansible > /dev/null
if [ $? -eq 1 ]; then
    sudo pacman -S --noconfirm ansible
fi

# Setup Kubernetes Environment
ansible-playbook environment/k8s/setup.yaml --tags minikube

# Setup Helm
ansible-playbook environment/helm/setup.yaml

# Update Minikube's IP address for JenkinsX
cd environment/jenkins/jx-gitops
export DOMAIN="$(minikube ip).nip.io"
jx gitops requirements edit --domain $DOMAIN

# Ngrok related stuff
echo "|**************************************************************************************|"
echo "| Now you need to start the ngrok with the following command:                          |"
echo "|                                                                                      |"
echo "|   ngrok http 8080                                                                    |"
echo "|                                                                                      |"
echo "| Once you've done that, you need to add your generated dns entry to the following     |"
echo "| configuration file:                                                                  |"
echo "|                                                                                      |"
echo "| environment/jenkins/jx-gitops/charts/jenkins-x/jxboot-helmfile-resources/values.yaml |"
echo "|                                                                                      |"
echo "|**************************************************************************************|"

# Install the GitOperator for JenkinsX
jx admin operator \
    --url=https://github.com/bak0al3x/jx-gitops \
    --username bak0al3x \
    --token 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