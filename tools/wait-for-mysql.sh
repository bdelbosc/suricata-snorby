#!/bin/bash
set -e

host="$1"
shift
cmd="$@"

while ! mysqladmin ping -h"$host" --silent; do
    echo "Wait for mysql to be up"
    sleep 1
done

>&2 echo "Mysql is up - executing command"
exec $cmd
