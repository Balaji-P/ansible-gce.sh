#! /bin/sh

### Must have Gcloud sdk installed and configured

###Create a micro instance as ansible master
gcloud compute --project "civil-topic-622" instances create "ansible" --zone "us-central1-b" --machine-type "f1-micro" --network "default" --maintenance-policy "MIGRATE" --scopes "https://www.googleapis.com/auth/userinfo.email" "https://www.googleapis.com/auth/compute" "https://www.googleapis.com/auth/devstorage.full_control" --tags "http-server" "https-server" --no-boot-disk-auto-delete

###or a centos like in the tutorial
gcloud compute --project "civil-topic-622" instances create "ansible-master" --zone "us-central1-b" --machine-type "g1-small" --network "default" --maintenance-policy "MIGRATE" --scopes "https://www.googleapis.com/auth/userinfo.email" "https://www.googleapis.com/auth/compute" "https://www.googleapis.com/auth/devstorage.full_control" --tags "http-server" "https-server" --image "https://www.googleapis.com/compute/v1/projects/centos-cloud/global/images/centos-7-v20140926" --no-boot-disk-auto-delete

#### You must a service account and get a p12 certificate. https://developers.google.com/console/help/new/#serviceaccountsOnce you #### have it convert it into a pem
openssl pkcs12 -in gce-key.p12 -passin pass:notasecret -nodes -nocerts | openssl rsa -out gce-key.pem

## upload that key to your ansible master 
gcutil --permit_root push gce-key.pem /root

### Log into the master
gcloud compute ssh ansible


###Install ansible.
apt-get install software-properties-common
#### Two ways : from source or use the debian package
#### I'm using the package mode
apt-add-repository -y ppa:ansible/ansible ##can be skipped if apt-add-repository not available, or add the repos manually to ###/etc/apt/sources.list
apt-get update
apt-get install -y ansible

apt-get install install python-pip git gcc python-devel
pip install paramiko PyYAML jinja2 httplib2


git clone https://github.com/apache/libcloud
cd libcloud; sudo python setup.py install;

#################   ADd this to bash-profile or .bashrc ################
PATH=$PATH:$HOME/bin:$HOME/ansible/bin
export PATH

PYTHONPATH=$HOME/ansible/lib:$HOME
export PYTHONPATH

ANSIBLE_LIBRARY=$HOME/ansible/library
export ANSIBLE_LIBRARY

MANPATH=$HOME/ansible/docs/man:
export MANPATH

ANSIBLE_HOSTS=$HOME/ansible-example/home
export ANSIBLE_HOSTS

ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_HOST_KEY_CHECKING

eval $(ssh-agent)

#################################################


#####config libcloud with gce
cp ~/libcloud/demos/secrets.py-dist secrets.py
#### change the corresponding lines
GCE_PARAMS = ('somelongstringofcharachters@developer.gserviceaccount.com', ‘/path/to/file/gce-key.pem')
GCE_KEYWORD_PARAMS = {'project': 'project-name-123'}

###Setup ssh
#### use gcutil to generate some ssh keys to gce
gcutil --permit_root_ssh ssh ansible date 
ssh-add ~/.ssh/google_compute_engine

#### Now testing 
git clone git://github.com/sharifsalah/ansible-examples.git
ansible -i ~/ansible-examples/hosts all -m ping








