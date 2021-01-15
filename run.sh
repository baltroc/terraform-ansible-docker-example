#!/bin/bash

cd terraform
terraform init -input=false
terraform apply -input=false -auto-approve
cd ..

cat terraform/terraform.tfstate | jq --raw-output '.resources[1].instances[0].attributes.private_key' > id_ubuntu_new.pem
chmod 600 id_ubuntu_new.pem

sleep 20 # give some time to setup instances

list="0 1 2 3"
echo "[ubuntuGroup]" > ansible/hosts
for i in $list
do
  instanceIP=$(cat terraform/terraform.tfstate | jq --raw-output ".resources[0].instances[$i].attributes.access_ip_v4")
  echo "$instanceIP ansible_connection=ssh ansible_user=ubuntu" >> ansible/hosts
done


export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook --private-key id_ubuntu_new.pem -i ansible/hosts ansible/docker.yml
ansible-playbook --private-key id_ubuntu_new.pem -i ansible/hosts ansible/firewall.yml
ansible-playbook --private-key id_ubuntu_new.pem -i ansible/hosts ansible/mongoDBDocker.yml
ansible-playbook --private-key id_ubuntu_new.pem -i ansible/hosts ansible/HTTPdocker.yml
