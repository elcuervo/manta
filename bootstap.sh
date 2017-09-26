#!/usr/bin/env bash

echo "==== Getting build dependencies ===="

sudo apt update
sudo apt install -y build-essential libusb-1.0.0-dev libgsm1-dev zlib1g-dev wireshark vim subversion libbladerf0 apache2 php5 autoconf

echo "==== Creating yate group ===="

sudo addgroup yate
sudo usermod -a -G yate $USER

echo "==== Downloading yate & yatebts ===="

mkdir -p ~/manta/src/null
cd ~/manta/src/null
svn checkout http://yate.null.ro/svn/yate/trunk yate
svn checkout http://voip.null.ro/svn/yatebts/trunk yatebts

echo "==== Install yate ===="

cd ~/manta/src/null/yate
./autogen.sh
./configure
make -j4
sudo make install-noapi
sudo ldconfig

echo "==== Install yatebts ===="

cd ~/manta/src/null/yatebts
./autogen.sh
./configure
make -j4
sudo make install
sudo ldconfig

cd /var/www/html/
sudo ln -s /usr/local/share/yate/nipc_web nib

sudo chown root:yate /usr/local/etc/yate/*.conf
sudo chmod -R a+rw /usr/local/etc/yate/
