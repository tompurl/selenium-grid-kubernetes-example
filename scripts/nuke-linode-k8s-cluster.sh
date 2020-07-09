#!/bin/bash
set -e

cat <<EOF
WARNING! This script does NOT come with any guarantee of working. PLEASE
__manually__ confirm that your cluster was deleted using the Linode web 
interface. 

The author of this script takes NO RESPONSIBILITY for any costs incurred
by using any Linode service!
EOF

export CLUSTER_ID=$(linode-cli lke clusters-list --text | grep sel | awk '{print $1}')

linode-cli lke cluster-delete $CLUSTER_ID

echo "It looked like the deletion was successful!"

linode-cli lke clusters-list
