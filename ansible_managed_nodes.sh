#!/bin/bash

###################################################################
############################# 함수 파일 #############################
###################################################################
add_ssh_authorized_key() {
    cat <<EOF >> $HOME/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDOOPVpT1ai8sj90YDoCZujYOyff50EA7BJHm5QZcXMQ/670H46UVJXiN3tMTlMu//caKZOBU6HTRCHg5Cg+CDbYjeOBgGCOSEk9kxNmRsE2rChdeQFLhaCcB56EKYyHJ9uYpbe72McWWszTDHpteySlBpE/7Yjne2D9T3TLSnwx3kdIZ1x4J6txwtw3BiSKn/wVxcxX5JmHAf+Fr6Xr1skOtY01ikIafWXs13RFRzLfIvrXUhmcfIpwSLfRiY36uOskSLomzK5ukqKMo8MqFH2rxbJSXWbpB7nq1VKW+8UPeVDblAXj79kun2h8rAT1TwYUEFJielFfl40Dber2pU5 deployment
EOF
    chmod 400 $HOME/.ssh/authorized_keys
}
###################################################################
############################# 함수 파일 #############################
###################################################################



#### COMMON
sudo sed -i.bak "s/\(kr\|archive\).ubuntu.com/mirror.kakao.com/g" /etc/apt/sources.list
sudo apt-get update

# 필수 패키지 설치
if ! dpkg -l | grep -q openssh-server; then
    sudo apt-get install -y lsb-release ca-certificates rsyslog openssh-server vim
    sudo systemctl --now enable rsyslog
    sudo systemctl --now enable ssh.service
    sudo sed -i.bak 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    sudo systemctl restart ssh.service
fi

# tzdata, chrony 패키지 설치
if ! dpkg -l | grep -q chrony; then
    sudo echo "Asia/Seoul" | sudo tee /etc/timezone
    sudo apt-get install -y tzdata chrony
    sudo timedatectl set-timezone Asia/Seoul
    sudo systemctl --now enable chrony
fi

# vagrant 계정이 존재하지 않으면 vagrant_useradd.sh 스크립트 실행
if ! id "vagrant" &>/dev/null; then
    curl -fsSL https://raw.githubusercontent.com/anti1346/zz/main/etc/vagrant_useradd.sh | sudo bash
fi

if [ "$HOSTNAME" == "web01" -o "$HOSTNAME" == "web02" ]; then
    su - vagrant
    if [ ! -f "$HOME/.ssh/authorized_keys" ]; then
        mkdir -m 700 $HOME/.ssh
        # 함수 호출하여 authorized_keys 파일에 공개 키 추가
        add_ssh_authorized_key
        echo "$(whoami):$(whoami)" | chpasswd
    fi
fi

echo -e "\n### rsyslog status"
sudo systemctl status rsyslog.service

echo -e "\n### ssh status"
sudo systemctl status ssh.service


### Shell Execute Command
# curl -fsSL https://raw.githubusercontent.com/anti1346/ubuntu2204_ansible/main/ansible_managed_nodes.sh | bash
