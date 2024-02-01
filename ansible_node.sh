#!/bin/bash

user_name=vagrant

###################################################################
############################# 함수 파일 #############################
###################################################################
generate_ssh_private_key() {
    sudo cat <<EOF > /home/$user_name/.ssh/id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABFwAAAAdzc2gtcn
NhAAAAAwEAAQAAAQDW0VhWwYC1X6bfM1vIwKk983SdipCWUUOrEFHmKJs2Ug9boiqzB9ZikI
SeTXTnJccqgUuf8NntoFZWuV/X24hJEtqy6JqibJWMTIySDbJW0lp182+RU/hmJEL3tyTBy
nKoWsAQ7ZhER+OTgwNg9FZ6OzQaVY5tL1fIqc+X96Tbk1RYtMOZRKg7NyG9hFCpB1XqkHqe
rsERQiEpF31WTnavjHvc4WCFYdNUDDp0FHd8+Pc3NG7KPtyxIZRrAtvf6Njb/ANJXK9glqF
bFSh6B7mmV//aoHVtk6SWalnhh97WUtK+9d+4TL0qJr7CssW9yaE8+l7E632XeNt7o7X3Kz
HHAAAAAwEAAQAAAQATwIgI4h39j1/+ofBMkzp8kcglPDpzN+Gq9wMw0IcFBaKX4F9gutXB
llw7Wg/nuReJFv5nJHRFXzrRGpZveKYdYfht/ulJCgbuMZOzUkMVrJ3YvpuBl2D9s1PdByA
AGadVR5Lle5NGo/2O8Lr8zTquXoc57Kf97h56OvL1nDWyYrx1DWyhWMyp9vkkg2RH3z0+18
dyPpZOSbCSlePjVX1xyGohWl5Y5VZ9LuAkZtFTQSi+/hperHEIP1Lm+aaZsTKlvtVKP+8Fo
9RohK7zDihsknL1DsS4bKNgMvvi8BghThhwiR8ntNFkNcxnLm6kn1iWkE6JuqDBXq826uMD
R1bBAAAAgQCtIW6HODQgnvaG9Z6W85wi6M9iHMIcsci4n2lJYgBoq4JT84hpFV80gCoYUnVG
c+nsPf2/kzDKjCtAP/lmAgLrMmDMlHzvkBVJyWDv26eIHZjo6htqpIGhQWaVTw+O6PA5dRy
k1GvL5Qqf131DGvhZcqLqDiORLzgvexrYQhzUBgAAAIEA81J7Dgis+cAVK8ugXeovxKCmN7
pp9xOgUp5xNjst87zLSWywCO/0AqF9bCovePB3SYl8BMUqAOnb1Wai9IBExGY1LxUnWdArme
vLejiEWBLd38+m8Yjy5Rmz6hT2p58osSDE0FuIaPMIBrENSv0RN0PIGE/te0u6DijCV6p4U
9EAAACBAOICqXOvHoVTTKaxuBKNwKoYVj1eMTlCB3k5krc1PNtXyMM6jvyIRdKhKr7bDyYN+
Q3wCsW/zOfQbv2J6pW///9vAGQsgm22XH95xvEidDHLbpcD2WhmDp3OLc8iIMLseHrjtjaqg
tvyKadKBxymznQWjmplTyFO6a9DU9HCnYoXAAAACmRlcGxveW1lbnQ=
-----END OPENSSH PRIVATE KEY-----
EOF
    sudo chmod 600 /home/$user_name/.ssh/id_rsa
}

add_ssh_authorized_key() {
    sudo cat <<EOF >> /home/$user_name/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDW0VhWwYC1X6bfM1vIwKk983SdipCWUUOrEFHmKJs2Ug9boiqzB9ZikISeTXTnJccqgUuf8NntoFZWuV/X24hJEtqy6JqibJWMTIySDbJW0lp182+RU/hmJEL3tyTBynKoWsAQ7ZhER+OTgwNg9FZ6OzQaVY5tL1fIqc+X96Tbk1RYtMOZRKg7NyG9hFCpB1XqkHqersERQiEpF31WTnavjHvc4WCFYdNUDDp0FHd8+Pc3NG7KPtyxIZRrAtvf6Njb/ANJXK9glqFbFSh6B7mmV//aoHVtk6SWalnhh97WUtK+9d+4TL0qJr7CssW9yaE8+l7E632XeNt7o7X3KzHH deployment
EOF
    sudo chmod 644 /home/$user_name/.ssh/authorized_keys
}
###################################################################
############################# 함수 파일 #############################
###################################################################



# 필수 패키지 설치
if ! dpkg -l | grep -q ca-certificates; then
    sudo apt-get update
    sudo apt-get install -y lsb-release ca-certificates sshpass vim
fi

# vagrant 계정이 존재하지 않으면 vagrant_useradd.sh 스크립트 실행
if ! id "$user_name" &>/dev/null; then
    curl -fsSL https://raw.githubusercontent.com/anti1346/zz/main/etc/vagrant_useradd.sh | sudo bash
fi

if [ "$HOSTNAME" == "ansible" ]; then
    #ssh-keygen -t rsa -b 2048 -C "deployment" -f /home/vagrant/.ssh/id_rsa -N ""
    if [ ! -f "/home/$user_name/.ssh/id_rsa" ]; then
        sudo mkdir -m 700 /home/$user_name/.ssh
        # 함수 호출하여 id_rsa 파일 생성
        generate_ssh_private_key
    fi
else
    # 필수 패키지 설치
    if ! dpkg -l | grep -q openssh-server; then
        sudo apt-get install -y rsyslog openssh-server
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

    echo -e "\n### rsyslog status"
    sudo systemctl status rsyslog.service

    echo -e "\n### ssh status"
    sudo systemctl status ssh.service
fi

if [ ! -f "/home/$user_name/.ssh/authorized_keys" ]; then
    sudo mkdir -m 700 /home/$user_name/.ssh
    # 함수 호출하여 authorized_keys 파일에 공개 키 추가
    add_ssh_authorized_key
    sudo echo "$user_name:$user_name" | chpasswd
    sudo chown -R "$user_name:$user_name" /home/$user_name/.ssh
fi

if [ "$HOSTNAME" == "ansible" ]; then
    hosts=("172.19.0.11" "172.19.0.12")
    password="$user_name"
    for host in "${hosts[@]}"; do
        echo "$password" | sshpass -p "$password" ssh-copy-id "$user_name@$host"
    done
fi


### Shell Execute Command
# curl -fsSL https://raw.githubusercontent.com/anti1346/ubuntu2204_ansible/main/ansible_node.sh | bash
