#!/bin/bash
source /etc/os-release 

if [[ $ID == "amzn" ]]; then
    sleep 20
    sudo yum update -y
    sudo yum install python3-pip telnet git -y
    sudo python3 -m pip install ansible ansible-core
elif [[ $ID == "ubuntu" ]]; then
    sudo apt -f install -y
    sudo apt --fix-missing update
    sudo apt -f install -y 
    sudo apt clean
    sudo apt update
    sleep 1
    sudo apt install python3-pip git -y
    sleep 1
    sudo python3 -m pip install ansible ansible-core
fi
