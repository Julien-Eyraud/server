#!/bin/bash

USERNAME="bitwarden"
NOUSER=`id -u $USERNAME > /dev/null 2>&1; echo $?`
LUID=${LOCAL_UID:-999}

# Step down from host root
if [ $LUID == 0 ]
then
    LUID=999
fi

if [ $NOUSER == 0 ] && [ `id -u $USERNAME` != $LUID ]
then
    usermod -u $LUID $USERNAME
elif [ $NOUSER == 1 ]
then
    useradd -r -u $LUID -g $USERNAME $USERNAME
fi

chown -R $USERNAME:$USERNAME /app
mkdir -p /etc/bitwarden/core
mkdir -p /etc/bitwarden/logs
chown -R $USERNAME:$USERNAME /etc/bitwarden

gosu $USERNAME:$USERNAME dotnet /app/Admin.dll
