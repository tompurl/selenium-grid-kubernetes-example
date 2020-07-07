#!/bin/bash
set -e

linode-cli lke cluster-create \
  --label selenium-test-$(date +%Y%m%d%H%M) \
  --region us-central \
  --k8s_version 1.17 \
  --node_pools.type g6-standard-4 --node_pools.count 3 \
  --tags demo \
  --text
