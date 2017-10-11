#!/bin/bash

# make scripts correct for osx/unix
cd packages
declare -a chapters=('composer-common' 'composer-admin' 'composer-client' 'composer-runtime' 'composer-runtime-hlfv1' )
for i in "${chapters[@]}"
do
    echo "changing to ${i}"
    cd "${i}" 
    pwd
   npm run prepublish
   cd ../
done