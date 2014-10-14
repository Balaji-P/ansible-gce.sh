#! /bin/sh

### Must have Gcloud sdk installed and configured

###Create a micro instance as ansible master
gcloud compute --project "civil-topic-622" instances create "ansible" --zone "us-central1-b" --machine-type "f1-micro" --network "default" --maintenance-policy "MIGRATE" --scopes "https://www.googleapis.com/auth/userinfo.email" "https://www.googleapis.com/auth/compute" "https://www.googleapis.com/auth/devstorage.full_control" --tags "http-server" "https-server" --no-boot-disk-auto-delete

#### You must a service account and get a p12 certificate. https://developers.google.com/console/help/new/#serviceaccountsOnce you #### have it convert it into a pem
openssl pkcs12 -in gce-key.p12 -passin pass:notasecret -nodes -nocerts | openssl rsa -out gce-key.pem

## upload that key to your ansible master 
gcutil --permit_root push gce-key.pem /root

### Log into the master
gcloud compute ssh ansible


###Install ansible.
#### Two ways : from source or use the debian package
#### I'm using the package mode
apt-add-repository -y ppa:ansible/ansible ##can be skipped if apt-add-repository not available, or add the repos manually to ###/etc/apt/sources.list
apt-get update
apt-get install -y ansible

apt-get install install python-pip git gcc python-devel
pip install paramiko PyYAML jinja2 httplib2


git clone https://github.com/apache/libcloud
cd libcloud; sudo python setup.py install;








