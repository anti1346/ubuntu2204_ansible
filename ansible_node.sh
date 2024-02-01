#!/bin/bash

###############################################################################################################################
###############################################################################################################################
###############################################################################################################################
########################################################## 함수 파일 ###########################################################
###############################################################################################################################
###############################################################################################################################
###############################################################################################################################

generate_ssh_private_key() {
    cat <<EOF > $HOME/.ssh/id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABFwAAAAdzc2gtcn
NhAAAAAwEAAQAAAQEAzjj1aU9WovLI/dGA6Ambo2Dsn3+dBAOwSR5uUGXFzEP+u9B+OlFS
V4jd7TE5TLv/3GimTgVOh00Qh4OQoPgg22I3jgYBgjkhJPZMTZkbBNqwoXXkBS4WgnAeeh
CmMhyfbmKW3u9jHFlrM0wx6bXskpQaRP+2I53tg/U90y0p8Md5HSGdceCerccLcNwYkip/
8FcXMV+SZhwH/ha+l69bJDrWNNYpCGn1l7Nd0RUcy3yL611IZnHyKcEi30YmN+rjrJEi6J
syubpKijKPDKhR9q8WyUl1m6Qe56tVSlvvFD3lQ25QF4+/ZLp9ofKwE9U8GFBBSYnpRX5e
NA23q9qVOQAAA8AhJ4/TISeP0wAAAAdzc2gtcnNhAAABAQDOOPVpT1ai8sj90YDoCZujYO
yff50EA7BJHm5QZcXMQ/670H46UVJXiN3tMTlMu//caKZOBU6HTRCHg5Cg+CDbYjeOBgGC
OSEk9kxNmRsE2rChdeQFLhaCcB56EKYyHJ9uYpbe72McWWszTDHpteySlBpE/7Yjne2D9T
3TLSnwx3kdIZ1x4J6txwtw3BiSKn/wVxcxX5JmHAf+Fr6Xr1skOtY01ikIafWXs13RFRzL
fIvrXUhmcfIpwSLfRiY36uOskSLomzK5ukqKMo8MqFH2rxbJSXWbpB7nq1VKW+8UPeVDbl
AXj79kun2h8rAT1TwYUEFJielFfl40Dber2pU5AAAAAwEAAQAAAQAF3wLu+xvFKt1Ztepn
cMfraFnZlqQClmpL7UpduUVe3JFhiSeMLdQxesuQB7E7w98ecs+dSV25e2eyO/wqS7Yqbi
A/x7Wo8/XDcXcC/zi7iXsINcIxUDptf0IBiVIkpheh6GZRituLAJQNPf5DyvKlH635yJVH
wU90TM9JoQULKPg6+2u50dJOgKvqocXM29MK+XRazm9yesC6f4lP7X5PzqDpaQ+Oicvf7H
X9W3yOpE3uD8wnvsUQ7lPtMyZ2dD34q+4CqtDQnf5UPv6LJxVrPYfbLgdsNzmKLxdjqltG
6XeZD9eWL4MAsqDZJ7wOZvhuP6XkddkGaj3bbnnQGjhpAAAAgCCs3SgG1ppxgnJcVqgHf/
RchKxhgoq0o81YIiPvlVunYrdd9FtZyTGX2gSVRIfTRPMwEyakN/7v0Y1HxQKL43BZxJj8
qf1edpxY7pMF0IDN0Cbq8aDU2fXgUgTLc3ZBMM8kFzMWPR9DYFKOmh97YWWLAvyWSMmMOh
My4WnTpVGiAAAAgQD3PWqavEDIKnjwN40k/i4ulbELu2bc7pPltAcQ7U4kO5Li/DcgaYbv
npCLMdIfgbZxiYOyy/8LI3/i5Ov334BMusg6NdH17PRKNOjI6l4X5wUKg2eY7dBo0E34k8
6uYV/TJ1nSfp05oFR1Jh7bmH3wvgK4Xngxj/ppF9CLLNO4rQAAAIEA1Yd+qOY2A2z3eRkz
FeJKCNixncDSgioNd8GBvm6nbh13B5c0UPWY2oSUsPDJe+jzGJ3v34cRTr797NQVq8gG1G
DGDGdktw7XNHXxseYne0HdcMTbiVzPg65ojp7CRGOk8l2mIqCYK6/SpZD9wziWaIY4YtRI
goGjeiD4+QLUZD0AAAAKZGVwbG95bWVudAE=
-----END OPENSSH PRIVATE KEY-----
EOF
    chmod 600 $HOME/.ssh/id_rsa
}

add_ssh_authorized_key() {
    cat <<EOF >> $HOME/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDOOPVpT1ai8sj90YDoCZujYOyff50EA7BJHm5QZcXMQ/670H46UVJXiN3tMTlMu//caKZOBU6HTRCHg5Cg+CDbYjeOBgGCOSEk9kxNmRsE2rChdeQFLhaCcB56EKYyHJ9uYpbe72McWWszTDHpteySlBpE/7Yjne2D9T3TLSnwx3kdIZ1x4J6txwtw3BiSKn/wVxcxX5JmHAf+Fr6Xr1skOtY01ikIafWXs13RFRzLfIvrXUhmcfIpwSLfRiY36uOskSLomzK5ukqKMo8MqFH2rxbJSXWbpB7nq1VKW+8UPeVDblAXj79kun2h8rAT1TwYUEFJielFfl40Dber2pU5 deployment
EOF
    chmod 400 $HOME/.ssh/authorized_keys
}

generate_keepalived_config() {
    cat <<EOF >> /etc/keepalived/keepalived.conf

global_defs {
    notification_email {
        admin@example.com
    }
    notification_email_from admin@example.com
    #smtp_server smtp.example.com
    #smtp_connect_timeout 30
    router_id LVS_DEVEL
    enable_script_security
    script_user root
}

vrrp_script haproxy_check {
    script "/etc/keepalived/haproxy_check.sh"
    interval 2
    weight 2
}

vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 51
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        172.19.0.10/24 dev eth0 label eth0:1
    }
    track_script {
        haproxy_check
    }
}
EOF
}

generate_haproxy_config() {
    cat <<EOF > /etc/haproxy/haproxy.cfg

global
    log         127.0.0.1 local2
    pidfile     /var/run/haproxy.pid
    chroot /var/lib/haproxy
    stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
    stats timeout 30s
    maxconn     4000
    user        haproxy
    group       haproxy
    daemon

defaults
    log                     global
    mode                    http
    option                  httplog
    option                  dontlognull
    option http-server-close
    option forwardfor       except 127.0.0.0/8
    option                  redispatch
    retries                 3
    timeout http-request    10s
    timeout queue           1m
    timeout connect         10s
    timeout client          1m
    timeout server          1m
    timeout http-keep-alive 10s
    timeout check           10s
    maxconn                 3000

frontend http-in
    bind *:80
    acl url_admin       path_beg       /admin
    use_backend bk_admin     if url_admin
    default_backend             bk_web

frontend https-in
    bind *:443 ssl crt /etc/ssl/ha_sangchul_kr/unified_ha_sangchul_kr.pem
    acl url_admin       path_beg       /admin
    use_backend bk_admin     if url_admin
    default_backend             bk_web

backend bk_web
    balance     roundrobin
    server      web1 172.19.0.11:80 check
    server      web2 172.19.0.12:80 check

backend bk_admin
    balance     roundrobin
    server      web1 172.19.0.11:80 check
    server      web2 172.19.0.12:80 check

listen stats
    #bind *:1936
    bind *:9000
    stats enable
    stats uri /haproxy_stats
    stats refresh 10s
EOF
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

# keepalived 패키지 설치
if ! dpkg -l | grep -q keepalived; then
    sudo apt-get install -y keepalived
    sudo systemctl --now enable keepalived.service
    sudo systemctl restart keepalived.service
    generate_keepalived_config
fi

# haproxy 패키지 설치
if ! dpkg -l | grep -q haproxy; then
    sudo apt-get install -y haproxy
    sudo systemctl --now enable haproxy.service
    sudo systemctl restart haproxy.service
    generate_haproxy_config
fi

# vagrant 계정이 존재하지 않으면 vagrant_useradd.sh 스크립트 실행
if ! id "vagrant" &>/dev/null; then
    curl -fsSL https://raw.githubusercontent.com/anti1346/zz/main/etc/vagrant_useradd.sh | bash
fi

if [ "$HOSTNAME" == "haproxy01" ]; then
    #### haproxy01
    #ssh-keygen -t rsa -b 2048 -C "deployment" -f $HOME/.ssh/id_rsa -N ""
    if [ ! -f "$HOME/.ssh/id_rsa" ]; then
        mkdir -m 700 $HOME/.ssh
        # 함수 호출하여 id_rsa 파일 생성
        generate_ssh_private_key
        echo "$(whoami):$(whoami)" | chpasswd
    fi
    
    if [ ! -d "/etc/ssl/ha_sangchul_kr" ]; then
        mkdir -p /etc/ssl/ha_sangchul_kr
        cd /etc/ssl/ha_sangchul_kr
        openssl req \
        -newkey rsa:4096 \
        -x509 \
        -sha256 \
        -days 3650 \
        -nodes \
        -out ha_sangchul_kr.crt \
        -keyout ha_sangchul_kr.key \
        -subj "/C=KR/ST=Seoul/L=Jongno-gu/O=SangChul Co., Ltd./OU=Infrastructure Team/CN=ha.sangchul.kr"
        cat ha_sangchul_kr.key ha_sangchul_kr.crt > unified_ha_sangchul_kr.pem
    fi

    echo -e "\n### SSL CERT DATES"
    openssl x509 -in /etc/ssl/ha_sangchul_kr/ha_sangchul_kr.crt -noout -subject -dates

    echo -e "\n### SSL CERT COPY"
    echo "scp -o StrictHostKeyChecking=no /etc/ssl/ha_sangchul_kr/unified_ha_sangchul_kr.pem root@172.19.0.3:/etc/ssl/ha_sangchul_kr/unified_ha_sangchul_kr.pem"
fi

if [ "$HOSTNAME" == "haproxy02" ]; then
    #### haproxy02
    if [ ! -f "$HOME/.ssh/authorized_keys" ]; then
        mkdir -m 700 $HOME/.ssh
        # 함수 호출하여 authorized_keys 파일에 공개 키 추가
        add_ssh_authorized_key
        echo "$(whoami):$(whoami)" | chpasswd
    fi

    if [ ! -d "/etc/ssl/ha_sangchul_kr" ]; then
        mkdir -p /etc/ssl/ha_sangchul_kr
    fi

    sudo sed -i.bak "s/state MASTER/state BACKUP/g" /etc/keepalived/keepalived.conf
    sudo sed -i "s/priority 100/priority 99/g" /etc/keepalived/keepalived.conf
fi

echo -e "\n### rsyslog status"
sudo systemctl status rsyslog.service

echo -e "\n### ssh status"
sudo systemctl status ssh.service

# Check keepalived configuration
echo -e "\n### keepalived restart"
if keepalived -t &>/dev/null; then
    sudo systemctl restart keepalived.service
    sudo systemctl status keepalived.service
fi

# Check HAProxy configuration
echo -e "\n### haproxy restart"
if haproxy -c -f /etc/haproxy/haproxy.cfg -V &>/dev/null; then
    sudo systemctl restart haproxy.service
    sudo systemctl status haproxy.service
fi


### Shell Execute Command
# curl -fsSL https://raw.githubusercontent.com/anti1346/ubuntu22_keepalived_haproxy/main/install_haproxy.sh | bash
