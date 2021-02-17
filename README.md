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
echo "ansible ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
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

## Playbook for installing Nginx HTTP Server
Below is a snippet for installing Nginx

```yml
- hosts: nginx_servers
  become: yes
  
  tasks:   
  - name: Install nginx  
    yum: 
      name: nginx
      state: present
       
  - name: Start nginx  
    service:
      name: nginx 
      state: started 
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

## Setting up Ansible on WSL
Below are the step necessary to setup Ansible for Windows Subsystem for Linux

### First: Turn on Windows 10 Feature for WSL
```ps1
DISM.exe /Online /Enable-Feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

### Second: Install Ubuntu LTS from Mircosoft Store 
Once the installation completes proceed with setting up a user account. 

### Third: Update Ubuntu LTS and install ansible 
```sh
sudo apt-get update
sudo apt-get install -y python3-pip python3-pip python3-dev
pip install ansible 
```

### Fourth: Install Vagrant for both Windows system and WSL 
Note: Please make sure both versions are identical. 
```sh
curl -O https://releases.hashicorp.com/vagrant/2.2.14/vagrant_2.2.14_x86_x64.deb
sudo apt install ./vagrant_2.2.14_x86_64.deb
vagrant --version

# You will need to export the following variable in order to use Vagrant functionality on your Windows system.
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
```
### Fifth: Proceed with pulling the Vargrant box you which to use:
```rb
Vagrant.configure("2") do |config|
  config.vm.box = "***************"
  config.vm.synced_folder '.', '/vagrant', disabled: true

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "NameOfPlaybook.yml"
  end  
end
```

