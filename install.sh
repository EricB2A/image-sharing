sudo apt-get install build-essential tcl
read -p "Install PHP 7? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  sudo add-apt-repository ppa:ondrej/php
  sudo apt-get update &> /dev/null
  sudo apt-get install -y php7.0 php7.0-dev php7.0-mbstring php7.0-json php7.0-cli &> /dev/null
  sudo apt-get install -y php php-dev php-mbstring php-json php-cli &> /dev/null
else
  sudo apt-get install -y php5 php5-dev php5-mbstring php5-json php5-cli &> /dev/null
fi
#
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === 'aa96f26c2b67226a324c27919f1eb05f21c248b987e6195cad9690d5c1ff713d53020a02ac8c217dbf90a7eacc9d141d') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --filename=composer
php -r "unlink('composer-setup.php');"
#phpunit
wget https://phar.phpunit.de/phpunit.phar
chmod +x phpunit.phar
sudo mv phpunit.phar /usr/local/bin/phpunit

cp .env.example .env
composer install
php artisan key:generate

read -p "Install redis? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  #install redis
  #https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-redis-on-ubuntu-16-04
  echo "installing redis"
  cd /tmp
  curl -O http://download.redis.io/redis-stable.tar.gz
  tar xzvf redis-stable.tar.gz
  cd redis-stable
  make
  sudo make install
  sudo mkdir /etc/redis
  sudo cp /tmp/redis-stable/redis.conf /etc/redis
  sudo adduser --system --group --no-create-home redis
  echo "
  [Unit]
  Description=Redis In-Memory Data Store
  After=network.target
  [Service]
  User=redis
  Group=redis
  ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf
  ExecStop=/usr/local/bin/redis-cli shutdown
  Restart=always
  [Install]
  WantedBy=multi-user.target
  " > /etc/systemd/system/redis.service
  sudo mkdir /var/lib/redis
  sudo chown redis:redis /var/lib/redis
  sudo chmod 770 /var/lib/redis
  sudo systemctl start redis

  sed -i.bak s/QUEUE_DRIVER=\w*/QUEUE_DRIVER=redis/g .env
fi

sudo apt-get install -y mysql-server
sudo mysql_secure_installation
sudo service mysql start


read -p "Create a database? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Database name :"
    read databasename -p  -n 1 -r
    echo
    echo  "Enter mysql user name('root' by default):"
    stty -echo
    read  username
    stty echo
    username=${username:-"root"}
    echo  "Enter mysql user password ('root' by default):"
    stty -echo
    read  rootpasswd
    stty echo
    rootpasswd=${rootpasswd:-"root"}
    mysql -u${username} -p${rootpasswd} -e "CREATE DATABASE ${databasename} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
    sed -i.bak s/DB_DATABASE=\w*/DB_DATABASE=$databasename/g .env
    sed -i.bak s/DB_USERNAME=\w*/DB_USERNAME=$username/g .env
    sed -i.bak s/DB_PASSWORD=\w*/DB_PASSWORD=$rootpasswd/g .env
fi

echo "DO NOT FORGET TO MODIFY YOUR .env"
echo "Do not forget to edit the config either .... "
