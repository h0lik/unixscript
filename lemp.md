# Установка 
## -Nginx-php-fpm-mariadb-phpmyadmin в Debian
* Автор SoraxLab

## Установка Nginx
Для начало произведем обновления репозитория:
```bash
sudo apt-get update 
```

Далее обновим систему 
```bash
sudo apt upgrade
```

Теперь установим ***Nginx*** 

```bash
sudo apt install nginx
```

Теперь добавим ***nginx*** в автозагрузку 

```bash
sudo systemctl enable nginx
```

Далее запустим ***nginx*** делаем рестарт и проверим работу 

```bash
systemctl start nginx 
systemctl restart nginx
systemctl status nginx 
```

все ***nginx*** у нас уставновлен и как видим он у нас запущен идеем далее.
зайдем в браузер и введем свой локальный айпи и увидим welcome nginx.
Двигаемся далее.


***
## Установка сервера баз данных MariaDB
***MariaDB*** являеться заменой **Mysql**. Он разработан бывшим членами команды **MYSQL**, которые обеспокоены тем, что компания Oracle может превратить **MySQL** в продукт с закрытым исходным кодом.
Устанавливаем базу данных **MariaDB**
```bash
 sudo apt install mariadb-server mariadb-client
```

* После установки базы данных сервер баз данных должен быть запущен,
но для уверенности мы это проверим
введите следующие команды:
```bash
systemctl status mariadb
```
* Если сервер баз данных не запустился,то давай те мы его запусти и добавим в автозагрузку 
```bash
#Запускаем сервер баз данных MariaDB
systemctl start mariadb
#Добавляем сервер баз данных в автозагрузку.
systemctl enable mariadb
```
* Идем далее, теперь нам надо запустить сценарий безопасности после установки баз данных.
```bash
mysql_secure_installation
```

* Когда вас попросят ввести пароль от **root** для **mariadb**, то просто нажмите клавишу Enter, так как пароль для **root** еще не установлен затем вас попросят ввести пароль для пользователя **root** сервера баз данных **MariaDB**.
* Затем  вы можете просто нажать на Enter что бы ответить на все оставшиеся вопросы, что приведет к удалению анонимного пользователя, отключение входа в систему **root** и удалению тестовой базы данных. Этот шаг является основным требованием для обеспечения безопасности баз данных **MariaDB**. (Обратите внимание,что Y пишеться с заглавной буквы что означает ответ по умолчанию.)

_По умолчанию пакет **MariaDB** в **Debian** использует unix_socket для аутентификации пользователя, что в основном означает что вы можете использовать имя и пароль от своей учетной записи OC и входить в консоль сервера баз данных **MariaDB**.
Таким образом вы можете запустить следующую команду для входа в систему не предоставляя **Root-password MariaDB**_
```bash
mariadb -u root
```
* Для выхода из консоли сервера баз данных, введите следующую команду:
```bash
exit;
```
***

## Установка PHP-8.2
* **php-8.2** имеет не значительное улучшение производетельности по сравнение **php-7.Х**
* Установка **PHP-8.2:**
```bash
sudo apt install php php-fpm php-mysql php-common php-cli php-common php-json php-opcache php-readline php-mbstring php-xml
php-gd php-curl
```

_Расширения **PHP** обычно необходимы для систем управления контентом (**CMS**), таких как **wordpress**. 
Например если в вашей установке отсутствует **php8.2-xml** , то некоторые страницы сайта **WP** могут быть пустыми, и вы можете найти ошибку в журнале ошибок сервера **NGINX**, вот вам пример:
**Сообщение PHP:**
 
- _Неустранимая ошибка:_ 
- _php необработанная ошибка:_
- _вызов неопределенной ошибки функции   xml_parser_create()_

Установка этих расширений гарантирует бесперебойную работу вашей **CMS**.

* Теперь мы с вами запустим **PHP8.2-fpm** добавим в автозагрузку и проверим состояние:
```bash
#Запускаем PHP-8.2-fpm
systemctl start php8.2-fpm
#Добавляем в автозагрузку 
systemctl enable php8.2-fpm
#Проверяем статус.
systemctl status php-8.2-fpm
```
* Создадим серверный блок ***NGINX***
что бы блок сервера **NGINX*** был похож на виртуальный хост в **Apache**. Мы не будем использовать блок сервера по умолчанию, потому что он не подходит для запуска **PHP-кода**, и если мы его изменим он превратиться в беспорядок.
По этому удалите символическую ссылку в каталоге поддержки сайтов,выполнив следующую команду.
```bash
rm /etc/nginx/sites-enabled/default
```

_(он по-прежнему будет доступен как /etc/nginx/sites-enabled/default/)_

* Затем используйте текстовый редактор командной строки, такой как **Nano** (для более продвинутых пользователей **VIM** "Я лично предпочитаю **VIM**") далее создайте файл блока сервера в каталоге **/etc/nginx/conf.d/**
Вставьте туда следующий текст.
Конфиг заставит **Nginx** прослушивать порт **80 IPv4** и порт **80 IPv6** с универсальным именем сервера:
```bash
#Создаем файл default.conf
nano /etc/nginx/conf.d/default.conf
``` 

* Структура Конфига.
```nginx

server {
 
	listen 80:
	listen [::]:80;
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
```

Сохраните и закройте файл. (Что бы сохранить файл в текстовом редакторе **NANO**, нажмите  Ctrl+O,затем нажмите Enter дл подтверждения. Чтобы выйти,нажмите Ctrl+X.)
Затем протестируем конфигурацию  командой 
```bash
sudo nginx -t 
```
Если тест прошел успешно перезагрузим сервер **NGINX**
```bash
systemctl reload nginx
```
 Теперь протестируем конфигурацию **PHP**.
```bash
echo "<?php phpinfo;?>" >> | /usr/share/nginx/html/info.php
```

Теперь осталось зайти по адресу **http://127.0.0.1/info.php**
И мы увидим конфигурацию **PHP** нашего сервера, это означает что все работает корректно и сервер готов к работе.
 
*****
будет переписываться!

***
