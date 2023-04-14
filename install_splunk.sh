#!/bin/bash -ex
# Install and create logical volumes


exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

hostnamectl set-hostname ${name}

yum install -y lvm2  bash-completion wget
lsblk
pvdisplay  | grep xvd || pvcreate /dev/xvdf
vgdisplay  | grep splunkvg || vgcreate splunkvg /dev/xvdf
lvdisplay | grep -i splunkvg || lvcreate -l 100%FREE -n splunk splunkvg

df -HT /dev/splunkvg/splunk | grep xfs  || mkfs -t xfs /dev/splunkvg/splunk
test -d /opt/splunk  || mkdir -pv /opt/splunk
grep /dev/splunkvg/splunk /etc/fstab || echo "/dev/splunkvg/splunk     /opt/splunk xfs defaults 0 0" >> /etc/fstab
mount /opt/splunk
id splunk || useradd splunk

cd /opt/
wget -O splunk-8.1.0-f57c09e87251-Linux-x86_64.tgz "https://download.splunk.com/products/splunk/releases/8.1.0/linux/splunk-8.1.0-f57c09e87251-Linux-x86_64.tgz"
tar zxvf splunk-8.1.0-f57c09e87251-Linux-x86_64.tgz
chown -R splunk:splunk /opt/splunk/

sleep 10
/opt/splunk/bin/splunk start --no-prompt  --accept-license   --answer-yes

cat <<EOF >/opt/splunk/etc/system/local/user-seed.conf
[user_info]
USERNAME = admin
PASSWORD = Dattatreya2!
EOF
/opt/splunk/bin/splunk stop
/opt/splunk/bin/splunk start --no-prompt  --accept-license   --answer-yes

