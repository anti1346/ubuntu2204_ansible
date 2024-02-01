#!/bin/bash

###################################################################
############################# 함수 파일 #############################
###################################################################
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
###################################################################
############################# 함수 파일 #############################
###################################################################



#### COMMON
sudo sed -i.bak "s/\(kr\|archive\).ubuntu.com/mirror.kakao.com/g" /etc/apt/sources.list
sudo apt-get update

# 필수 패키지 설치
if ! dpkg -l | grep -q lsb-release; then
    sudo apt-get install -y lsb-release ca-certificates vim
fi

# tzdata 패키지 설치
if ! dpkg -l | grep -q tzdata; then
    sudo echo "Asia/Seoul" | sudo tee /etc/timezone
    sudo apt-get install -y tzdata
    sudo timedatectl set-timezone Asia/Seoul
fi

# vagrant 계정이 존재하지 않으면 vagrant_useradd.sh 스크립트 실행
if ! id "vagrant" &>/dev/null; then
    curl -fsSL https://raw.githubusercontent.com/anti1346/zz/main/etc/vagrant_useradd.sh | bash
fi

if [ "$HOSTNAME" == "ansible" ]; then
    #### ansible
    #ssh-keygen -t rsa -b 2048 -C "deployment" -f $HOME/.ssh/id_rsa -N ""
    if [ ! -f "$HOME/.ssh/id_rsa" ]; then
        mkdir -m 700 $HOME/.ssh
        # 함수 호출하여 id_rsa 파일 생성
        generate_ssh_private_key
        echo "$(whoami):$(whoami)" | chpasswd
    fi

    if [ ! -f "$HOME/.ssh/authorized_keys" ]; then
        mkdir -m 700 $HOME/.ssh
        # 함수 호출하여 authorized_keys 파일에 공개 키 추가
        add_ssh_authorized_key
    fi

    # if [ ! -d "/etc/ssl/ha_sangchul_kr" ]; then
    #     mkdir -p /etc/ssl/ha_sangchul_kr
    #     cd /etc/ssl/ha_sangchul_kr
    #     openssl req \
    #     -newkey rsa:4096 \
    #     -x509 \
    #     -sha256 \
    #     -days 3650 \
    #     -nodes \
    #     -out ha_sangchul_kr.crt \
    #     -keyout ha_sangchul_kr.key \
    #     -subj "/C=KR/ST=Seoul/L=Jongno-gu/O=SangChul Co., Ltd./OU=Infrastructure Team/CN=ha.sangchul.kr"
    #     cat ha_sangchul_kr.key ha_sangchul_kr.crt > unified_ha_sangchul_kr.pem
    # fi

    # echo -e "\n### SSL CERT DATES"
    # openssl x509 -in /etc/ssl/ha_sangchul_kr/ha_sangchul_kr.crt -noout -subject -dates

    # echo -e "\n### SSL CERT COPY"
    # echo "scp -o StrictHostKeyChecking=no /etc/ssl/ha_sangchul_kr/unified_ha_sangchul_kr.pem root@172.19.0.3:/etc/ssl/ha_sangchul_kr/unified_ha_sangchul_kr.pem"
fi


### Shell Execute Command
# curl -fsSL https://raw.githubusercontent.com/anti1346/ubuntu22_keepalived_haproxy/main/install_haproxy.sh | bash
