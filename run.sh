#!/usr/bin/env bash

cd TPterraform
terraform init -input=false
terraform apply -input=false -auto-approve
cd ..

cat TPterraform/terraform.tfstate | jq --raw-output '.resources[1].instances[0].attributes.private_key' > id_ubuntu_new.pem
chmod 600 id_ubuntu_new.pem
#ssh-add id_ubuntu_new.pem

sleep 20 # to make sure the instance setup is done

list="0 1 2 3"
echo "[ubuntuGroup]" > TPansible/hosts
for i in $list
do
  instanceIP=$(cat TPterraform/terraform.tfstate | jq --raw-output ".resources[0].instances[$i].attributes.access_ip_v4")
  echo "$instanceIP ansible_connection=ssh ansible_user=ubuntu" >> TPansible/hosts
done


export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook --private-key id_ubuntu_new.pem -i TPansible/hosts TPansible/docker.yml
ansible-playbook --private-key id_ubuntu_new.pem -i TPansible/hosts TPansible/firewall.yml
ansible-playbook --private-key id_ubuntu_new.pem -i TPansible/hosts TPansible/mongoDBDocker.yml
ansible-playbook --private-key id_ubuntu_new.pem -i TPansible/hosts TPansible/HTTPdocker.yml
