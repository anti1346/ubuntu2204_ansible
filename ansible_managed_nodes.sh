#!/bin/bash

user_name=vagrant

###################################################################
############################# 함수 파일 #############################
###################################################################
add_ssh_authorized_key() {
    sudo cat <<EOF >> /home/$user_name/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDW0VhWwYC1X6bfM1vIwKk983SdipCWUUOrEFHmKJs2Ug9boiqzB9ZikISeTXTnJccqgUuf8NntoFZWuV/X24hJEtqy6JqibJWMTIySDbJW0lp182+RU/hmJEL3tyTBynKoWsAQ7ZhER+OTgwNg9FZ6OzQaVY5tL1fIqc+X96Tbk1RYtMOZRKg7NyG9hFCpB1XqkHqersERQiEpF31WTnavjHvc4WCFYdNUDDp0FHd8+Pc3NG7KPtyxIZRrAtvf6Njb/ANJXK9glqFbFSh6B7mmV//aoHVtk6SWalnhh97WUtK+9d+4TL0qJr7CssW9yaE8+l7E632XeNt7o7X3KzHH deployment
EOF
    sudo chmod 400 /home/$user_name/.ssh/authorized_keys
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
    if [ ! -f "/home/$user_name/.ssh/authorized_keys" ]; then
        sudo mkdir -m 700 /home/$user_name/.ssh
        # 함수 호출하여 authorized_keys 파일에 공개 키 추가
        add_ssh_authorized_key
        sudo echo "$user_name:$user_name" | chpasswd
        sudo chown -R "$user_name:$user_name" /home/$user_name/.ssh
    fi
fi

echo -e "\n### rsyslog status"
sudo systemctl status rsyslog.service

echo -e "\n### ssh status"
sudo systemctl status ssh.service


### Shell Execute Command
# curl -fsSL https://raw.githubusercontent.com/anti1346/ubuntu2204_ansible/main/ansible_managed_nodes.sh | bash
