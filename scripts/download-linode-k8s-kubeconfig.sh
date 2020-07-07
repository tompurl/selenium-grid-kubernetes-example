#!/bin/bash
set -e

echo Warning: This script assumes that you have only one Linode LKE cluster.

export CLUSTER_ID=$(linode-cli lke clusters-list --text | grep sel | awk '{print $1}')
export CLUSTER_NAME=$(linode-cli lke clusters-list --text | grep sel | awk '{print $2}')

test -d ~/.kube || mkdir -vp ~/.kube

test -f ~/.kube/${CLUSTER_NAME}-config.yaml \
    || linode-cli lke kubeconfig-view $CLUSTER_ID --text \
    | tail -1 \
    | base64 --decode > ~/.kube/${CLUSTER_NAME}-config.yaml

cat <<EOF

It worked!

Now please execute the following command in each terminal that needs to
access this LKE cluster:

export KUBECONFIG=~/.kube/${CLUSTER_NAME}-config.yaml
EOF
