# Ze zuper image sharing

![logo](https://media.giphy.com/media/K68xWrKuS5aTe/giphy.gif)

This project is built in PHP with the [Laravel framework](http://laravel.com) (5.3). It is aimed for a cloud use.

Please, please, please use either vagrant and/or an ubuntu machine, this will save you a baaaad headache.

## Installation

The installation script is meant to be used on an ubuntu 14.04 (Trusty Tahr) or ubuntu 16.04 (Xenial Xerus).

If you install this on a windows, god save your soul but it may be possible. This installation script will therefor not help you, you will need to refer to the [laravel docs](http://laravel.com/docs/installation).

It is strongly recommended if you are using [vagrant](https://www.vagrantup.com/) to install [Homestead](http://https://laravel.com/docs/homestead).

## Install Homestead

If you do use vagrant (please make youself a favor and do so), then to install Homestead you will need git.

### On linux
On a bash
```bash
vagrant box add laravel/homestead
cd ~
git clone https://github.com/laravel/homestead.git Homestead
cd Homestead
bash init.sh
```
After that you will need to edit your ``` Homestead.yaml ``` file in your homestead home directory with your favorite editor (``` nano ~/.homestead/Homestead.yaml ```). This file will define all your virtual machines.

### On windows

On a cmd
```
cd %USERPROFILE%
git clone https://github.com/laravel/homestead.git Homestead
cd Homestead
init.bat
```

After that you will need to edit your ``` Homestead.yaml ``` file in your homestead home directory with your favorite editor (``` notepad %USERPROFILE%\.homestead\Homestead.yaml ```). This file will define all your virtual machines.

### Configuration of your Homestead.yaml

This is an example of my own Homestead.yaml file.

```
---
ip: "192.168.10.10"
memory: 2048
cpus: 1
provider: virtualbox

authorize: ~/.ssh/id_rsa.pub

keys:
    - ~/.ssh/id_rsa

folders:
    - map: C:/dev/
      to: /home/vagrant/Code

sites:
    - map: homestead.app
      to: /home/vagrant/Code/image-sharing/public
      schedule: true
databases:
    - homestead

```

On windows, you will need to put drive letters in capital letters.

### Using homestead

After installing your vagrant homestead box, you will need to execute the following command to up your machine ``` cd ~/Homestead ```(``` cd %USERPROFILE%\Homestead ```) and execute the command ``` vagrant up ```

## Install on Ubuntu

If you posses a virtual machine with ubuntu 14.04, or higher, you can use this script.
```bash
wget -O - https://raw.githubusercontent.com/CPNV-ES/image-sharing/installation_script/install.sh | sudo bash  
```

If you have any problems with this install script, please create an [issue](https://github.com/CPNV-ES/image-sharing/issues/new) on the project.

## Install manually

If you do not use homestead, nor a virtual machine (hang in there), then you may install all needed tools for this, such as:

### Requirements

 * PHP >= 5.6 (php version 5.6 or higher)
 * OpenSSL PHP Extension
 * PDO PHP Extension
 * Mbstring PHP Extension
 * Tokenizer PHP Extension
 * XML PHP Extension

After installing php, don't forget to add it to your path, you will need it later.

Linux/Mac ```$ PATH:$PATH: ```

Windows/wamp ```> set PATH=%PATH%;C:\wamp\php ```


That is only for the PHP part, then you will need to install [composer](http://getcomposer.org/download).

```bash
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === 'aa96f26c2b67226a324c27919f1eb05f21c248b987e6195cad9690d5c1ff713d53020a02ac8c217dbf90a7eacc9d141d') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
```

After installing composer, execute the following commands to setup the project environnement ``` cp .env.example .env && php artisan key:generate ``` . Then edit the ```.env``` file to suite your needs, please refer to the [laravel documentation](https://laravel.com/docs/configuration) for that.

# Sources

Some sources to help you set up

https://laravel.com/docs

https://scotch.io/tutorials/understanding-laravel-environment-variables

https://git-for-windows.github.io/

https://getcomposer.org/download/

http://www.wikihow.com/Install-Laravel-Framework-in-Windows

https://24ways.org/2014/what-is-vagrant-and-why-should-i-care/

http://www.wikihow.com/Hack-a-Computer
