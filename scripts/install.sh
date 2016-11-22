#!/bin/bash
if [ "$(id -u)" != "0" ]; then
    echo "This script should not be run using sudo or as the root user"
    exit 1
fi
chown root:root /tmp
chmod 777 /tmp
LSB="/usr/bin/lsb_release -sc"
CURRENT_DIR=`dirname $0`
LOG="/var/log/install.log"
echo "Starting install " > $LOG
echo "Installing misc tools"
apt-get install -y sudo openssh-server git build-essential curl wget  &> /dev/null
#update debian key
echo "Adding repositories"
wget http://www.dotdeb.org/dotdeb.gpg -q -O- | apt-key add - &> $LOG
#update nginx repository
sh -c "echo 'deb http://nginx.org/packages/debian/ $($LSB) nginx' >> /etc/apt/sources.list"
sh -c "echo 'deb-src http://nginx.org/packages/debian/ $($LSB) nginx' >> /etc/apt/sources.list"
curl http://nginx.org/keys/nginx_signing.key | apt-key add - &> $LOG
#update mariadb repositories
apt-get install software-properties-common -y &> $LOG
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db &> $LOG
sudo add-apt-repository 'deb [arch=amd64,i386] http://ams2.mirrors.digitalocean.com/mariadb/repo/10.1/debian $($LSB) main'
echo "updating .... "
apt-get update &> /dev/null
apt-get upgrade -y --force-yes &> /dev/null
#usermod -a -G sudo cpnv #adds the user CPNV to the sudoeurs

#php fpm for fast cgi and nginx
apt-get install -y --force-yes php5 php5-fpm &> $LOG
if [ $? -ne 0 ]; then
  echo "error while installing PHP..."
  echo "check log at $LOG"
  exit 1;
fi;
#php modules
apt-get install -y --force-yes php5-mysql php5-dev php5-cli php5-mcrypt php5-json &> $LOG
if [ $? -ne 0 ]; then
  echo "error while installing PHP modules..."
  echo "check log at $LOG"
  exit 1;
fi;
#php confs
cp $CURRENT_DIR/php.ini /etc/php5/fpm/php.ini
#echo "cgi.fix_pathinfo=0" >> /etc/php5/fpm/php.ini

#mysql
echo "Installing mysql ... "
echo "Mysql root password default will be set to 'root' "
echo "To change this, google it (http://lmgtfy.com/?q=change+root+password+mysql)"
PASSWORD="root"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"


apt-get install mariadb-server libssl-dev mariadb-client -y --force-yes &> $LOG
mysql_install_db &> $LOG
chown -R mysql /var/lib/mysql &> $LOG
chgrp -R mysql /var/lib/mysql &> $LOG
echo "innodb_buffer_pool_size = 256M" >> /etc/my.ini
echo "innodb_log_file_size    = 256M" >> /etc/my.ini
echo "innodb_thread_concurrency   = 16" >> /etc/my.ini
echo "innodb_flush_log_at_trx_commit = 2" >> /etc/my.ini
echo "innodb_flush_method=normal" >> /etc/my.ini
mv /var/lib/mysql/ib* /tmp/mysql
service mysql restart
if [ $? -ne 0 ]; then
  echo "error while installing mariadb"
  echo "check log at $LOG"
  exit 1;
fi;
#nginx
echo "Insalling nginx ... "
apt-get install -y nginx --force-yes &> $LOG
if [ $? -ne 0 ]; then
  echo "error while installing nginx"
  echo "check log at $LOG"
  exit 1;
fi
#nginx confs
cp $CURRENT_DIR/nginx_default_site.conf /etc/nginx/conf.d/main.conf

service nginx restart &> /dev/null

echo "umask 0027" >> /etc/profile
chmod chmod 0755 -R /home
chmod 0755 -R /home/*

mkdir /home/**/html
chmod 750 /home/**/html
chmod 750 -R /home/**/html

#adduser
cp $CURRENT_DIR/pool.conf.template /etc/php5/fpm/pool.conf.template
cp $CURRENT_DIR/create_php_pool.sh /etc/php5/fpm/create_pool
chmod 755 /etc/php5/fpm/create_pool
cp $CURRENT_DIR/add_user.sh /usr/local/sbin/adduser.local
chmod 755 /usr/local/sbin/adduser.local

echo "We will now change your default user, and add him PHP yes?"
echo "Please enter the username >"
read USERNAME
$CURRENT_DIR/add_user.sh $USERNAME
usermod -a -G sudo $USERNAME
echo "Just for some sugar, we added the user $USERNAME to the sudoeurs. For this to take effect you might need to reboot"
exit 0;
