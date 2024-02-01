#!/bin/bash

###############################################################################################################################
###############################################################################################################################
###############################################################################################################################
########################################################## 함수 파일 ###########################################################
###############################################################################################################################
###############################################################################################################################
###############################################################################################################################

generate_index_html() {
    cat <<EOF > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
    <head>
        <title>Welcome to nginx!</title>
        <style>
            html { color-scheme: light dark; }
            body { width: 35em; margin: 0 auto; font-family: Tahoma, Verdana, Arial, sans-serif; }
        </style>
    </head>
    <body>
        <h1>Welcome to nginx!</h1>
        <p>node01 - 172.19.0.3</p>
        <p><em>Thank you for using nginx.</em></p>
    </body>
</html>
EOF

    ln -s /usr/share/nginx/html/index.html /var/www/html/index.html
}

add_ssh_authorized_key() {
    cat <<EOF >> $HOME/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDOOPVpT1ai8sj90YDoCZujYOyff50EA7BJHm5QZcXMQ/670H46UVJXiN3tMTlMu//caKZOBU6HTRCHg5Cg+CDbYjeOBgGCOSEk9kxNmRsE2rChdeQFLhaCcB56EKYyHJ9uYpbe72McWWszTDHpteySlBpE/7Yjne2D9T3TLSnwx3kdIZ1x4J6txwtw3BiSKn/wVxcxX5JmHAf+Fr6Xr1skOtY01ikIafWXs13RFRzLfIvrXUhmcfIpwSLfRiY36uOskSLomzK5ukqKMo8MqFH2rxbJSXWbpB7nq1VKW+8UPeVDblAXj79kun2h8rAT1TwYUEFJielFfl40Dber2pU5 deployment
EOF
    chmod 400 $HOME/.ssh/authorized_keys
}

###############################################################################################################################
###############################################################################################################################
###############################################################################################################################
########################################################## 함수 파일 ###########################################################
###############################################################################################################################
###############################################################################################################################
###############################################################################################################################

#### COMMON
sudo sed -i.bak "s/\(kr\|archive\).ubuntu.com/mirror.kakao.com/g" /etc/apt/sources.list
sudo apt-get update

# 필수 패키지 설치
if ! dpkg -l | grep -q openssh-server; then
    sudo apt-get install -y lsb-release ca-certificates vim rsyslog openssh-server
    sudo systemctl restart rsyslog
    sudo systemctl --now enable ssh.service
    sudo sed -i.bak 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    sudo timedatectl set-timezone Asia/Seoul
    sudo systemctl restart ssh.service
fi

if [ "$HOSTNAME" == "web01" -o "$HOSTNAME" == "web02" ]; then
    #### web01, web02
    if [ ! -f "$HOME/.ssh/authorized_keys" ]; then
        mkdir -m 700 $HOME/.ssh
        # 함수 호출하여 authorized_keys 파일에 공개 키 추가
        add_ssh_authorized_key
    fi

    echo "$(whoami):$(whoami)" | chpasswd
fi

# nginx 패키지 설치
if ! dpkg -l | grep -q haproxy; then
    sudo apt-get install -y nginx php-fpm
    sudo systemctl --now enable nginx
    sudo systemctl --now enable php8.1-fpm
    generate_index_html
fi

# vagrant 계정이 존재하지 않으면 vagrant_useradd.sh 스크립트 실행
if ! id "vagrant" &>/dev/null; then
    curl -fsSL https://raw.githubusercontent.com/anti1346/zz/main/etc/vagrant_useradd.sh | bash
fi

# Check nginx configuration
echo -e "\n### nginx restart"
if nginx -t &>/dev/null; then
    sudo systemctl restart nginx.service
    sudo systemctl status nginx.service
fi

# Check php8.1-fpm configuration
echo -e "\n### php8.1-fpm restart"
if php-fpm8.1 -t &>/dev/null; then
    sudo systemctl restart php8.1-fpm.service
    sudo systemctl status php8.1-fpm.service
fi

### Shell Execute Command
# curl -fsSL https://raw.githubusercontent.com/anti1346/ubuntu22_keepalived_haproxy/main/install_webserver.sh | bash
