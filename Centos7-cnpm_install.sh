#!/bin/bash

yum -y update

yum install -y epel-release

yum install -y nginx 

systemctl start nginx

systemctl enable nginx

sed -i "s/root         \/usr\/share\/nginx\/html/root         \/usr\/local\/blog\/public/g" /etc/nginx/nginx.conf

service nginx restart

curl --silent --location https://rpm.nodesource.com/setup_5.x |bash -

yum install -y nodejs

yum install -y npm

npm install -g cnpm --registry=https://registry.npm.taobao.org

cnpm install hexo-cli -g

cd /usr/local/

hexo init blog

cd /usr/local/blog

cnpm install

cnpm install --save hexo-admin

mkdir /usr/local/blog/admin_script/

cat>/usr/local/blog/admin_script/hexo-generate.sh<<EOF
#!/usr/bin/env sh
hexo g
EOF

chmod 777 /usr/local/blog/admin_script/hexo-generate.sh

echo -e "请访问 https://www.devglan.com/online-tools/bcrypt-hash-generator 请将密码转换成bcrypt散列输入"

read -p "请输入转换后的bcrypt密码：" bcrypt

read -p "请输入用户名：" username

cat>>/usr/local/blog/_config.yml<<EOF
admin:
   username: ${username}
   password_hash: ${bcrypt}
   secret: hey hexo
   deployCommand: './admin_script/hexo-generate.sh'
  # expire: 60*1
EOF

hexo g

nohup hexo server -d &

echo -e "admin run in port 4000"
