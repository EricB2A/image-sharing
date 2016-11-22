#!/bin/sh

# Création d'un nouvel utilisateur
#echo "Choisissez le nom d'utilisateur à ajouter : "
#read username
#adduser $username
username=$1
# Création du dossier html propre à l'utilisateur
mkdir /home/$username/html
mkdir /home/$username/_logs
mkdir /home/$username/_sessions

chmod 0750 /home/$username/html
chown $username:$username /home/$username/html
chown $username:$username /home/$username/_logs
chown $username:$username /home/$username/_sessions

/etc/php5/fpm/create_pool $username
if [ $? -ne 0 ]; then
  echo "there was an error creating your php settings"
  exit 1;
fi;

# Création de la bdd propre à l'utilisateur
if [ -f /root/.my.cnf ]; then
        mysql -e "CREATE DATABASE ${username} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
        echo  "Veuillez choisir un mot de passe :"
        read  passwddb
        mysql -e "CREATE USER ${username}@localhost IDENTIFIED BY '${passwddb}';"
        mysql -e "GRANT ALL PRIVILEGES ON ${username}.* TO '${username}'@'localhost';"
        mysql -e "FLUSH PRIVILEGES;"
else
        echo  "Enter root password ('root' by default):"
        stty -echo
        read  rootpasswd
        stty echo
        rootpasswd=${rootpasswd:-"root"}
        mysql -uroot -p${rootpasswd} -e "CREATE DATABASE ${username} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
        mysql -uroot -p${rootpasswd} -e "CREATE USER ${username}@localhost IDENTIFIED BY '${passwddb}';"
        mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON ${username}.* TO '${username}'@'localhost';"
        mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"
fi

exit 0
