# The following will need to be install when setting up ansible on RHEL systems. 

yum install -y python3
alternatives --set python /usr/bin/python3
yum -y install python3-pip

# Create an ansible admin account and grant access to that account. 
useradd ansadmin
passwd ansadmin

# This will grant the "ansadmin" account sudo access. 
echo "ansadmin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Change the password authentication from "no" to "yes"
sed -ie 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo service sshd reload

# Switch to ansadmin account 
su - ansadmin
pip3 install ansible --user
ansible --version

# Generate ssh key
ssh-keygen
ssh-copy-id @target-server


# Validation test 
ansible all -m ping 
