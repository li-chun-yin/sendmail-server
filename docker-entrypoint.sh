#!/bin/bash

git clone https://gitee.com/li-chun-yin/sendmail-server.git
cd /srv/sendmail-server
composer install -n

php -S 0.0.0.0:80 -t /srv/sendmail-server/public