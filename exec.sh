#!/bin/sh

HOST="localhost"
USERNAME="ec2-user"
KEY=" -i .ssh/id_rsa"

if [ "$#" -gt 2 ]; then
    echo "Illegal number of parameter"
    exit 1
fi

for var in "$@"
do
    if [ "$var" = "-nokey" ]; then
        KEY=""
    elif echo $var | grep -Eq '@'; then
        USERNAME=$(echo "$var" | cut -d "@" -f 1)
        HOST=$(echo "$var" | cut -d "@" -f 2)
    else
        HOST=$var
    fi
done
        
if [ "$HOST" = "localhost" ]; then
    echo "I think you forgot to set the host address"
    exit 1
fi

ssh$KEY $USERNAME@$HOST