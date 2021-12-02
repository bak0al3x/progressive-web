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