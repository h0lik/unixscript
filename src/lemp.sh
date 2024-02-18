#!/bin/bash
#Name:Install web server LEMP
#Date:15.02.2023
#Autor:SoraxDev
#Version:0.0.1
NORMAL='\033[0m'
BGRED='\033[41m'
BGGREEN='\033[42m'
BGBROWN='\033[43m'
Black='\033[30m'

sleep 2
echo -e "${BGBROWN}${Black}Обвновление системы.${NORMAL}"
sudo apt update 
sudo apt upgrade -y
echo -e  "${BGBROWN}${Black}Начинаем установку Сервера.${NORMAL}"
echo ""
read   -p "$(echo -en ${BGGREEN}${Black}Install Web server?[Y/N]:${NORMAL}) " Install

if [[ $Install =~ ^[Yy]$ ]];
     then
	  echo -e "Установка web сервера"
	 sudo apt install nginx mariadb-server mariadb-client php php-fpm php-mysql php-common php-cli php-json php-opcache php-readline php-mbstring php-xml php-gd php-curl -y
	  sleep 2
	  echo -e "${BGBROWN}${Black}Добавляем службы в автозагрузку${NORMAL}"
	 sudo systemctl enable nginx
	 sudo systemctl enable php8.2-fpm
	 sudo systemctl enable mariadb
	  sleep 1
	 sudo systemctl stop Apache2 
	 sudo systemctl start nginx 
	 sudo systemctl restart nginx
	 sudo systemctl stop apache2
	 echo -e "${BGBROWN}${Black}Запуск nginx${NORMAL}"
	 sudo systemctl start nginx
	  sleep 1
	  echo -e "${BGBROWN}${Black}Запуск PHP${NORMAL}"
	 sudo systemctl start php8.2-fpm
	  sleep 1
	   echo -e "${BGBROWN}${Black}Запуск MariaDB${NORMAL}"
	 sudo systemctl start mariadb
	  sleep 1
	  #exit 0
fi
echo -e "${BGBROWN}${Black}Проверяем статус сервера nginx!${NORMAL}"

if sudo pidof -x nginx > /dev/null
  then
	  echo -e "${BGGREEN}${Black}Nginx успешно запущен!${NORMAL}"
		#exit 0
else
      echo -e "${BGRED}${Black}Nginx не запустился!${NORMAL}"
		#xit 1
fi
sleep 1
echo -e "${BGBROWN}${Black}Проверка php-fpm!${NORMAL}"
if sudo pidof -x php-fpm8.2 > /dev/null
  then
	  echo -e "${BGGREEN}${Black}PHP-fpm успешно запущен!${NORMAL}"
		#exit 0
else
	  echo -e "${BGRED}${Black}PHP-fpm не запустился!${NORMAL}"
		#exit 1
fi
echo -e "${BGBROWN}${Black}Проверяем статус сервера mariadb!${NORMAL}"
if sudo pidof -x mariadbd > /dev/null
  then
	  echo -e "${BGGREEN}${Black}mariadb успешно запущен!${NORMAL}"
	   #exit 0
else
	  echo -e "${BGRED}${Black}mariadb не запустился!${NORMAL}"
		#exit 1
fi
sleep 1
read   -p "$(echo -en ${BGGREEN}${Black}Настраевам базу данных.?[Y/N]:${NORMAL}) " maria
if [[ $maria =~ ^[Yy]$ ]];
     then
     sudo mysql_secure_installation
		#exit 0
fi
sleep 1
read   -p "$(echo -en ${BGGREEN}${Black}Настраевам php8?[Y/N]:${NORMAL}) " php8
if [[ $php8 =~ ^[Yy]$ ]];
     then
	sudo rm -rf /etc/nginx/sites-enable/default
    sudo touch /etc/nginx/conf.d/default.conf
	sudo cat > /etc/nginx/conf.d/default.conf <<EOF
server {

	listen 80:
	l

	isten [::]:80;
	server_name _;
	root /usr/share/nginx/html/;
	index index.php index.html index.htm index.nginx-debian.html;
	location / {
		try_files $uri $uri/ /index.php;
}

location ~ \.php$ {
	fastcgi_pass unix:/run/php/php8.2-fpm.sock;
	fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_scrip_name;
	include fastcgi_params;
	include snippet/fastcgi-php.conf;
}
#a long browser cache lifetime can speed up repeat visits to your page
	location ~* \.(jpg|jpeg|gif|png|webp|svg|woff|woff2|ttf|css|js|ico|xml)$ {
	access_log 		off;
	log_not+found 	off;
	expires 		360d;
}
#disable access to hidden files
	location ~/\.ht {
	access_log 		off;
	log_not_found 	off;
	deny 			all;
 }
}
EOF

sleep 1
sudo nginx -t
sudo nginx reload nginx

		#exit 0
fi
if sudo pidof -x nginx > /dev/null
  then
	  echo -e "${BGGREEN}${Black}Nginx ok!${NORMAL}"
		#exit 0
else
      echo -e "${BGRED}${Black}Nginx error!${NORMAL}"
		#exit 1
fi
sleep 2
sudo rm -rf ~/deb/sh_install-lemp
echo -e "${BGGREEN}${Black}WEB сервер успешно установлен!${NORMAL}"
echo -e "${BGGREEN}${Black}Довстречи с вами был SoraxDev!${NORMAL}"
sleep 2
