cd
mkdir -p ~/Scripts
curl -L  https://raw.githubusercontent.com/jellene4eva/laptop/master/setup_laptop.sh -o ~/Scripts/setup_laptop.sh
wait
chmod 700 ~/Scripts/*
source ~/.bashrc
~/Scripts/setup_laptop.sh
