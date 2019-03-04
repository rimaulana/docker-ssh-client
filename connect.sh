#!/bin/bash

NAMESPACE="ssh"

if [ -f deployment.yaml ]; then
    NAMESPACE=`cat deployment.yaml | grep namespace: | head -1 | cut -d ":" -f 2`
fi

POD=`kubectl get pod -n $NAMESPACE | egrep -o ssh-client[a-zA-Z0-9-]+`

if [ "$POD" = "" ]; then
    echo "Couldn't find ssh-client pod, try checking replication controller status"
    echo "kubectl describe rc -n $NAMESPACE ssh-client"
    exit 1
else
    kubectl exec -it -n $NAMESPACE $POD -- /bin/sh exec.sh $@
fi