#!/bin/bash
#   
#   Installiert den Apache Web Server
#
export KUBECONFIG=$HOME/.kube/config
kubectl apply -f ~/M104/mysql.yaml
kubectl apply -f ~/M104/phpmyadmin.yaml
