#!/bin/sh

command=$1

if [ "$command" = "" ]; then
   command="help"
fi;

echo "Current Folder: $PWD"

echo 'num of args: '$#
i=0
xxargs=""
for arg in "$@"; do
   #echo 'arg: '$arg;
   if [ $i -gt "0" ]; then
      xxargs=$xxargs" "$arg
   fi;
   i=$((i + 1))
done

echo "./devops/scripts/"$command".sh"$xxargs
#./devops/cicd/scripts/pull.sh

echo "./devops/scripts/"$command".sh"$xxargs|sh -

