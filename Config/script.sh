#!/bin/bash
function Proverka_BD {
echo "Проверим установлен ли PostgeSQL на системе"
os_release=$(uname -a)
proverka_download_bd=$(psql --version)
if [[ $os_release == *"Ubuntu"* || $os_release == *"Debian"* ]]; then
    if [[ $proverka_download_bd == *"(PostgreSQL)"* ]]; then
        echo "PostgreSQL УСТАНОВЛЕН"

    else
        echo "Установлю PostgreSQL"
        sudo apt install postgresql -y >/dev/null
    fi
elif [[ $os_release == *"MANJARO"* ]]; then
    if [[ $proverka_download_bd == *"(PostgreSQL)"* ]]; then
        echo "PostgreSQL УСТАНОВЛЕН"
    else
        echo "Установлю PostgreSQL"
        sudo pacman -S postgresql
    fi
else
    echo "ты юзаешь какую то другую систему чел"
fi
}
Proverka_BD

function Proverka_Iptables {
echo "Проверим установлен ли IPTables на системе"
os_release=$(uname -a)
proverka_download_iptables=$(iptables --version)
if [[ $os_release == *"Ubuntu"* || $os_release == *"Debian"* ]]; then
    if [[ $proverka_download_iptables == *"iptables v"* ]]; then
        echo "IPTABLES установлен"

    else
        echo "Установлю IPTABLES"
        sudo apt install iptables -y >/dev/null
    fi
elif [[ $os_release == *"MANJARO"* ]]; then
    if [[ $proverka_download_iptables == *"iptables v"* ]]; then
        echo "IPTABLES УСТАНОВЛЕН"
    else
        echo "Установлю IPTABLES"
        sudo pacman -S iptables
    fi
else
    echo "Ты точно используешь какой-нибудь фаервол???"
fi
}
Proverka_Iptables


#function Proverka_IP {
#read -p "Введи DNS имя своего провайдера DDNS1: " provider_dns1
#read -p "Введи DNS имя своего провайдера DDNS2: " provider_dns2

#dns1=$(dig +short google.com)
#dns2=$(dig +short duckdns.org)





#добавит инфу которая будет добавлять ай пи адрес в бд
#}
#Proverka_IP

function Dobavlenie_infy {
read -p "Впиши название 1го ДНС провайдера: " dns_provider1
read -p "Впиши название 2го ДНС провайдера: " dns_provider2
read -p "Впиши название 3го ДНС провайдера: " dns_provider3

read -p "Впиши DNS имя 1го провайдера: " dns_name1
read -p "Впиши DNS имя 2го провайдера: " dns_name2
read -p "Впиши DNS имя 3го провайдера: " dns_name3


dns1=$(dig +short "$dns_name1")
dns2=$(dig +short "$dns_name2")
dns3=$(dig +short "$dns_name3")


#Создание бд без подключения к ней:
#createdb -h <хост_базы_данных> -p <порт_базы_данных> -U <имя_пользователя> <имя_базы_данных>

createdb -h localhost -p 5432 -U postgres For_Cron


psql -h localhost -p 5432 -U postgres For_Cron -c 'CREATE TABLE infa (id BIGSERIAL NOT NULL PRIMARY KEY, "Наименование ДНС Службы" VARCHAR(30) NOT NULL, "Имя ДНС Службы" VARCHAR(50) NOT NULL, "IP адрес" VARCHAR(160));'





#добавить в скрипт для крон проверку днсов
#psql -U postgres -p 5432 -h localhost

#CREATE TABLE infa (id BIGSERIAL NOT NULL PRIMARY KEY, "Наименование ДНС Службы" VARCHAR(30) NOT NULL, "Имя ДНС Службы" VARCHAR(50) NOT NULL, "IP адрес" VARCHAR(16));



#MY_VALUE="Hello, world!"
#psql -c "INSERT INTO my_table (column1) VALUES ('$MY_VALUE');"
#ИЛИ
#psql -c "\set my_variable \"Hello, world!\""  -c "INSERT INTO my_table (column1) VALUES ($my_variable);"
#ИЛИ
#psql -c "INSERT INTO my_table (column1) VALUES ('$MY_VALUE');" -c "INSERT INTO my_table (column1) VALUES ('$MY_VALUE');"




#psql -h localhost -p 5432 -U postgres For_Cron -c 'INSERT INTO infa "Наименование ДНС Службы" VALUES ('$dns_provider1');'
#psql -h localhost -p 5432 -U postgres For_Cron -c 'INSERT INTO infa "Имя ДНС Службы" VALUES ('$dns_name1');'
#psql -h localhost -p 5432 -U postgres For_Cron -c 'INSERT INTO infa "IP адрес" VALUES ('$dns1');'


#psql -h localhost -p 5432 -U postgres For_Cron -c 'INSERT INTO infa "Наименование ДНС Службы" VALUES ('$dns_provider2');'
#psql -h localhost -p 5432 -U postgres For_Cron -c 'INSERT INTO infa "Имя ДНС Службы" VALUES ('$dns_name2');'
#psql -h localhost -p 5432 -U postgres For_Cron -c 'INSERT INTO infa "IP адрес" VALUES ('$dns2');'


psql -h localhost -p 5432 -U postgres For_Cron -c "INSERT INTO infa (\"Наименование ДНС Службы\", \"Имя ДНС Службы\", \"IP адрес\") VALUES ('$dns_provider1', '$dns_name1', '$dns1'), ('$dns_provider2', '$dns_name2', '$dns2'), ('$dns_provider3', '$dns_name3', '$dns3');"


#psql -h localhost -p 5432 -U postgres For_Cron -c "INSERT INTO infa ($dns_provider2, $dns_name2, $dns2);"

}
Dobavlenie_infy


###function Sozdanie_pravil_v_IPTables {
###sudo iptables -nvL --line-numbers
#добавить правило для нормальной работы ping
#добавить правило для инвалидных пакетов, которые будут отбрасываться
#добавить правило для открытия порта только для интерфейса loopback
#добавить правило для работы 80,443, ПОРТ-ДЛЯ-SSH, ПОРТ-ДЛЯ-РАБОТЫ-PROXY + WEB-FACE портов для dns1
#добавить правило для работы 80,443 ПОРТ-ДЛЯ-SSH, ПОРТ-ДЛЯ-РАБОТЫ-PROXY + WEB-FACE портов для dns2
###sudo iptables -A INPUT -p tcp --dport ПОРТ-SSH -s "$dns1" -j ACCEPT
###sudo iptables -A INPUT -p tcp --dport ПОРТ-SSH -s "$dns2" -j ACCEPT
###sudo iptables -A INPUT -p tcp --dport ПОРТ-SSH -s "$dns3" -j ACCEPT
###sudo iptables -A INPUT --dport ПОРТ-SSH -j DROP

###sudo iptables -A INPUT -p tcp --dport 80 -s "$dns1" -j ACCEPT
###sudo iptables -A INPUT -p tcp --dport 80 -s "$dns2" -j ACCEPT
###sudo iptables -A INPUT -p tcp --dport 80 -s "$dns3" -j ACCEPT
###sudo pitables -A INPUT --dport 80 -j DROP

###sudo iptables -A INPUT -p tcp --dport 443 -s "$dns1" -j ACCEPT
###sudo iptables -A INPUT -p tcp --dport 443 -s "$dns2" -j ACCEPT
###sudo iptables -A INPUT -p tcp --dport 443 -s "$dns3" -j ACCEPT
###sudo iptables -A INPUT --dport 443 -j DROP

###sudo iptables -A INPUT -p tcp --dport ПОРТ-ДЛЯ-ПРОКСИ -s "$dns1" -j ACCEPT
###sudo iptables -A INPUT -p tcp --dport ПОРТ-ДЛЯ-ПРОКСИ -s "$dns2" -j ACCEPT
###sudo iptables -A INPUT -p tcp --dport ПОРТ-ДЛЯ-ПРОКСИ -s "$dns3" -j ACCEPT
###sudo iptables -A INPUT --dport ПОРТ-ДЛЯ-ПРОКСИ -j DROP

###sudo iptables -A INPUT -p tcp --dport ПОРТ-ДЛЯ-ПРОКСИ+ВЕБ -s "$dns1" -j ACCEPT
###sudo iptables -A INPUT -p tcp --dport ПОРТ-ДЛЯ-ПРОКСИ+ВЕБ -s "$dns2" -j ACCEPT
###sudo iptables -A INPUT -p tcp --dport ПОРТ-ДЛЯ-ПРОКСИ+ВЕБ -s "$dns3" -j ACCEPT
###sudo iptables -A INPUT --dport ПОРТ-ДЛЯ-ПРОКСИ+ВЕБ -j DROP


#закрыть политику цепочки INPUT
###sudo iptables -P INPUT DROP
#сохранить правила iptables в файлик
###}
###Sozdanie_pravil_v_IPTables
###УБРАТЬ #  ГДЕ 3 ШТУКИ




#сохранить конфиг


NEW_PATH=$(pwd)
sudo chmod +x $NEW_PATH/script_dopolnenie.sh


function Shablon {
echo -e "################################################\nВставь в службу Crontab следующую команду:\n################################################\n*/1 * * * * $NEW_PATH/script_dopolnenie.sh\n################################################\n\nn################################################\nУ тебя есть 1 минута на сохранение команды\nn################################################"
}
Shablon

sleep 1m


#Запуск скрипта 2го файла
"$NEW_PATH/script_dopolnenie.sh"
