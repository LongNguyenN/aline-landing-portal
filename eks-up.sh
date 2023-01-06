#!/bin/bash
export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
export AWS_DEFAULT_REGION=us-east-2

aws eks --region us-east-2 update-kubeconfig --name ln-eks
kubectl apply -f deployment.yaml
