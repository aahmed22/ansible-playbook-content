# Ansible Playbooks
This repo contains playbooks written in yaml that deploys several web servers on Red Hat Enterprise Linux servers. 

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
