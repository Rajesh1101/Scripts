#!/bin/bash

ip=`curl ifconfig.me`
# clone the code
git clone https://vaibhav-eleven:Eleven12345@github.com/eleven01team/e01_deployment-scripts.git
cd e01_deployment-scripts
git clone https://vaibhav-eleven:Eleven12345@github.com/eleven01team/e01_nodemanagement.git

# run bootstrap
./bootstrap.sh
./install_mongo.sh
sed -i s/localhost/$ip/g setting.sh

cd e01_nodemanager
git checkout develop
nohup python app.py &

cd database
nohup python DBServer.py &
cd ../../

cd apicontainer
sed -i s/localhost/$ip/g setting.py
nohup python app.py &
cd ../

./setup.sh --c raft --a y --N 1 --nn TestNet --ip $ip --o 1 --nt n --n node1 --pw password12345 --r 22000 --w 22001 --t 22003 --dt 22004 --raft 22005 --ws 22006
