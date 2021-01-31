# Ansible Playbooks
This repo contains playbooks written in yaml that runs different setups and processes on Red Hat Enterprise Linux Servers. 

## Pre-Setup for ansible on Red Hat Enterprise Linux Servers. 
You will need to have ansible install on your master server to kick off the process of executing commands on your remote nodes. 
```sh
#!/bin/bash
#The following portion will run on all servers:

sudo su - 
yum install python3 -y
alternatives --set python /usr/bin/python3
python --version
yum -y install python3-pip
useradd -p $(openssl passwd ********) ansible 
echo "ansible ALL=(ALL) ALL" >> /etc/sudoers
sed -ie 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
service sshd reload

# Next you want to proceed with switching to the "ansible" user and installing ansible. 
su - ansible 
pip3 install ansible --user

# Finally on your master server you will run the following:
ssh-keygen -t rsa
ssh-copy-id ansible@<target-server>

```


several web servers on Red Hat Enterprise Linux servers. 

## Playbook for installing Apache HTTP Server
Below is a snippet for setting up Apache on remote servers. 

```yml
---
- hosts: webservers
  become: yes

  tasks:
  - name: Installing Lastest version of Apache
    yum: name=httpd state=latest
    
  - name: Copying the demo file
    template: src=/etc/ansible/index.html dest=/var/www/html 
         owner=apache group=apache mode=0644
  
  - name: Start HTTPD service 
    service:
      name: httpd 
      state: started 
  
  - name: Enable service httpd
    service: 
      name: httpd 
      enabled: yes 
```

## Simple playbook for storing a message
Below is a snippet for storing a welcome message
```yml
---
- name: Simple Welcome message 
  hosts: webservers
  tasks:
    - name: Create test file '/tmp/welcome.txt'
      shell: echo -e "Welcome $(whoami)! Your unit is $(hostname -f)\n" >> /tmp/welcome.txt
```
