#!/bin/bash

user_name=vagrant

###################################################################
############################# 함수 파일 #############################
###################################################################
generate_ssh_private_key() {
    sudo cat <<EOF > /home/$user_name/.ssh/id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABFwAAAAdzc2gtcn
NhAAAAAwEAAQAAAQEA1tFYVsGAtV+m3zNbyMCpPfN0nYqQllFDqxBR5iibNlIPW6IqswfW
YpCEnk105yXHKoFLn/DZ7aBWVrlf19uISRLasuiaomyVjEyMkg2yVtJadfNvkVP4ZiRC97
ckwcpyqFrAEO2YREfjk4MDYPRWejs0GlWObS9XyKnPl/ek25NUWLTDmUSoOzchvYRQqQdV
6pB6nq7BEUIhKRd9Vk52r4x73OFghWHTVAw6dBR3fPj3NzRuyj7csSGUawLb3+jY2/wDSV
yvYJahWxUoege5plf/2qB1bZOklmpZ4Yfe1lLSvvXfuEy9Kia+wrLFvcmhPPpexOt9l3jb
e6O19ysxxwAAA8BKoNulSqDbpQAAAAdzc2gtcnNhAAABAQDW0VhWwYC1X6bfM1vIwKk983
SdipCWUUOrEFHmKJs2Ug9boiqzB9ZikISeTXTnJccqgUuf8NntoFZWuV/X24hJEtqy6Jqi
bJWMTIySDbJW0lp182+RU/hmJEL3tyTBynKoWsAQ7ZhER+OTgwNg9FZ6OzQaVY5tL1fIqc
+X96Tbk1RYtMOZRKg7NyG9hFCpB1XqkHqersERQiEpF31WTnavjHvc4WCFYdNUDDp0FHd8
+Pc3NG7KPtyxIZRrAtvf6Njb/ANJXK9glqFbFSh6B7mmV//aoHVtk6SWalnhh97WUtK+9d
+4TL0qJr7CssW9yaE8+l7E632XeNt7o7X3KzHHAAAAAwEAAQAAAQATwIgI4h39j1/+ofBM
kzp8kcglPDpzN+Gq9wMw0IcFBaKX4F9gutXBllw7Wg/nuReJFv5nJHRFXzrRGpZveKYdYf
ht/ulJCgbuMZOzUkMVrJ3YvpuBl2D9s1PdByAAGadVR5Lle5NGo/2O8Lr8zTquXoc57Kf9
7h56OvL1nDWyYrx1DWyhWMyp9vkkg2RH3z0+18dyPpZOSbCSlePjVX1xyGohWl5Y5VZ9Lu
AkZtFTQSi+/hperHEIP1Lm+aaZsTKlvtVKP+8Fo9RohK7zDihsknL1DsS4bKNgMvvi8Bgh
ThhwiR8ntNFkNcxnLm6kn1iWkE6JuqDBXq826uMDR1bBAAAAgQCtIW6HODQgnvaG9Z6W85
wi6M9iHMIcsci4n2lJYgBoq4JT84hpFV80gCoYUnVGc+nsPf2/kzDKjCtAP/lmAgLrMmDM
lHzvkBVJyWDv26eIHZjo6htqpIGhQWaVTw+O6PA5dRyk1GvL5Qqf131DGvhZcqLqDiORLz
gvexrYQhzUBgAAAIEA81J7Dgis+cAVK8ugXeovxKCmN7pp9xOgUp5xNjst87zLSWywCO/0
AqF9bCovePB3SYl8BMUqAOnb1Wai9IBExGY1LxUnWdArmevLejiEWBLd38+m8Yjy5Rmz6h
T2p58osSDE0FuIaPMIBrENSv0RN0PIGE/te0u6DijCV6p4U9EAAACBAOICqXOvHoVTTKax
uBKNwKoYVj1eMTlCB3k5krc1PNtXyMM6jvyIRdKhKr7bDyYN+Q3wCsW/zOfQbv2J6pW///
9vAGQsgm22XH95xvEidDHLbpcD2WhmDp3OLc8iIMLseHrjtjaqgtvyKadKBxymznQWjmpl
TyFO6a9DU9HCnYoXAAAACmRlcGxveW1lbnQ=
-----END OPENSSH PRIVATE KEY-----
EOF
    sudo chmod 600 /home/$user_name/.ssh/id_rsa
}

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
if ! dpkg -l | grep -q lsb-release; then
    sudo apt-get install -y lsb-release ca-certificates vim
    sudo timedatectl set-timezone Asia/Seoul
fi

# vagrant 계정이 존재하지 않으면 vagrant_useradd.sh 스크립트 실행
if ! id "vagrant" &>/dev/null; then
    curl -fsSL https://raw.githubusercontent.com/anti1346/zz/main/etc/vagrant_useradd.sh | sudo bash
fi

if [ "$HOSTNAME" == "ansible" ]; then
    #### ansible
    #ssh-keygen -t rsa -b 2048 -C "deployment" -f /home/$user_name/.ssh/id_rsa -N ""
    if [ ! -f "/home/$user_name/.ssh/id_rsa" ]; then
        sudo mkdir -m 700 /home/$user_name/.ssh
        # 함수 호출하여 id_rsa 파일 생성
        generate_ssh_private_key
        echo "$user_name:$user_name" | chpasswd
    fi

    if [ ! -f "/home/$user_name/.ssh/authorized_keys" ]; then
        sudo mkdir -m 700 /home/$user_name/.ssh
        # 함수 호출하여 authorized_keys 파일에 공개 키 추가
        add_ssh_authorized_key
        sudo chown -R "$user_name:$user_name" /home/$user_name/.ssh
    fi
fi


### Shell Execute Command
# curl -fsSL https://raw.githubusercontent.com/anti1346/ubuntu2204_ansible/main/ansible_control_node.sh | bash
