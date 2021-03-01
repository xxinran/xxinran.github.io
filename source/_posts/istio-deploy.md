---
title: 部署istio+k8s
date: 2021-03-01 17:30:27
tags:
- service-mesh
- deploy
categories: deploy
---



### 环境：

ubuntu20.04

kubernete 1.20



### Deploy K8s(all in one) using Kubeadm

#### Install docker 

```bash
sudo apt-get install docker.io
sudo groupadd docker
sudo usermod -aG docker ${USER}  # To resolve permission errors

# check 
docker ps -a
```

#### Install Kubeadm

```shell
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

#### Run kubeadm

```shell
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
#### Install Calico

```shell
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml
watch kubectl get pods -n calico-system

# untaint master node
kubectl taint nodes --all node-role.kubernetes.io/master-

# check
kubectl get nodes -o wide
```

#### Install Istio

```shell
curl -L https://istio.io/downloadIstio | sh -
export PATH="$PATH:/home/ubuntu/istio-1.9.0/bin"
cd istio-1.9.0
istioctl install 

# all pods in "default" ns will have the sidecar
kubectl label namespace default istio-injection=enabled
```


