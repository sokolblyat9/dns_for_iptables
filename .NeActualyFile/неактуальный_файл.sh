#!/bin/bash
function Proverka_BD {
echo "Проверим установлен ли PostgeSQL на системе"
os_release=$(uname -a)
proverka_download_bd=$(psql --version)
if [[ $os_release == *"Ubuntu"* || $os_release == *"Debian"* ]]; then
    if [[ $proverka_download_bd == *"(PostgreSQL)"* ]]; then
        echo "PostgreSQL УСТАНОВЛЕН"

    elif
        echo "Установлю PostgreSQL"
        sudo apt install postgresql -y >/dev/null
    fi
elif [[ $os_release == *"Manjaro"* ]]; then
    if [[ $proverka_download_bd == *"(PostgreSQL)"* ]]; then
        echo "PostgreSQL УСТАНОВЛЕН"
    elif
        echo "Установлю PostgreSQL"
        sudo pacman -S postgresql
    fi
elif
    echo "ты юзаешь какую то другую систему чел"
}
Proverka_BD

function Proverka_Iptables {
echo "Проверим установлен ли IPTables на системе"
os_release=$(uname -a)
proverka_download_iptables=$(iptables --version)
if [[ $os_release == *"Ubuntu"* || $os_release == *"Debian"* ]]; then
    if [[ $proverka_download_iptables == *"iptables v"* ]]; then
        echo "IPTABLES установлен"

    elif
        echo "Установлю IPTABLES"
        sudo apt install iptables -y >/dev/null
    fi
elif [[ $os_release == *"Manjaro"* ]]; then
    if [[ $proverka_download_bd == *"iptables v"* ]]; then
        echo "IPTABLES УСТАНОВЛЕН"
    elif
        echo "Установлю IPTABLES"
        sudo pacman -S iptables
    fi
elif
    echo "Ты точно используешь какой-нибудь фаервол???"
}
Proverka_Iptables


function Proverka_IP {
dns1=$(dig +short shopliz.duckdns.org)
dns2=$(dig +short dns_mikrotika)
#добавит инфу которая будет добавлять ай пи адрес в бд
}
Proverka_IP

function Dobavlenie_infy {
read -e "Впиши название 1го ДНС провайдера" local dns_provider1
read -e "Впиши название 2го ДНС провайдера" local dns_provider2
read -e "Впиши DNS имя 1го провайдера" local dns_name1
read -e "Впиши DNS имя 2го провайдера" local dns_name2

#добавить в скрипт для крон проверку днсов
psql -U postgres -p 5432 -h localhost
CREATE DATABASE For_Cron;
CREATE TABLE infa (id BIGSERIAL NOT NULL PRIMARY KEY, Наименование-ДНС_Службы VARCHAR(30) NOT NULL, Имя_ДНС_Службы VARCHAR(50) NOT NULL, ip_address VARCHAR(16);
INSERT INTO infa ('$dns_provider1', '$dns_name1', '$dns1');
INSERT INTO infa ('$dns_provider2', '$dns_name2', '$dns2');
}
Dobavlenie_infy


function Sozdanie_pravil_v_IPTables {
sudo iptables -nvL --line-numbers
}
Sozdanie_pravil_v_IPTables

function Sozdanie_scripta_dlya_Cron {
touch $HOME/script_dlya_cron.sh
chmod+x script_dlya_cron.sh >> sudo crontab -e
}
Sozdanie_scripta_dlya_Cron


function Peredacha_Dannblh_for_file_cron {
#сюда добавить строки которые будут находиться в файле для проверки ай пи адреса в бд и если такого нет, то перезаписывать данные
}
Peredacha_Dannblh_for_file_cron
