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
elif [[ $os_release == *"MANJARO"* || $os_release == *"archlinux"* ]]; then
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
elif [[ $os_release == *"MANJARO"* || $os_release == *"archlinux"* ]]; then
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



function Proverka_Iptables-Persistent {
echo "Проверим установлен ли IPTables на системе"
os_release=$(uname -a)
#proverka_download_iptables_persistent=$(iptables-persistent --version)
proverka_download_iptables_save=$(iptables-save --version)
if [[ $os_release == *"Ubuntu"* || $os_release == *"Debian"* ]]; then
    if [[ $proverka_download_iptables_persistent == *"iptables v"* ]]; then
        echo "IPTABLES установлен"

    else
        echo "Установлю IPTABLES"
        sudo apt install iptables-persistent -y >/dev/null
    fi

else
    echo "Ты точно используешь какой-нибудь фаервол???"
fi
}
Proverka_Iptables-Persistent

function Proverka_DIG {
os_release=$(uname -a)
proverka_download_dig=$(dig -v)
if [[ $os_release == *"MANJARO"* || $os_release == *"archlinux"* ]]; then
    if [[ $proverka_download_dig == *"DiG"* ]]; then
        echo "Утилита DIG в составе пакета BIND установлена"
    else
        sudo pacman -Sy bind
    fi
else
    echo "Ты юзаешь другую систему"
fi
}
Proverka_DIG


#Рабочий код:
function DNS_Provider_And_Plus_BD_And_Plus_Firewall {
massiv_ip_addresov=()
echo "Создам базу данных для хранения значений"
createdb -h localhost -p 5432 -U postgres For_Cron
psql -h localhost -p 5432 -U postgres For_Cron -c 'CREATE TABLE infa (id BIGSERIAL NOT NULL PRIMARY KEY, "Наименование ДНС Службы" VARCHAR(30) NOT NULL, "Имя ДНС Службы" VARCHAR(50) NOT NULL, "IP адрес" VARCHAR(160));'
read -p "Сколько хочешь добавить днс провайдеров?   " kolichestvo
for (( a=1; a<=$kolichestvo; a++ ));
do
    read -p "Введи название провайдера:   " dns_provider
    read -p "Введи название DNS имя провайдера:   " dns_name_provider
    massiv_ip_addresov+=$(dig +short $dns_name_provider)
    echo ${massiv_ip_addresov[@]}

   echo "Внесу значения в базу данных"
    for IP_and_DNS in $massiv_ip_addresov
    do
        psql -h localhost -p 5432 -U postgres For_Cron -c "INSERT INTO infa (\"Наименование ДНС Службы\", \"Имя ДНС Службы\", \"IP адрес\") VALUES ('$dns_provider', '$dns_name_provider', '$IP_and_DNS');"
    done

    massiv_ip_addresov=""


done

}
DNS_Provider_And_Plus_BD_And_Plus_Firewall

massiv_dns_name=($(psql -h localhost -p 5432 -U postgres -d For_Cron -t -c "select distinct \"Наименование ДНС Службы\" from infa;"))



iptables65505() {
for ip_address in ${massiv_dns_name[@]}; do

    #Рабочий код:
    massiv_ip_addresov2=($(psql -h localhost -p 5432 -U postgres -d For_Cron -t -c "select \"IP адрес\" from infa where \"Наименование ДНС Службы\" = '$ip_address';"))
    echo ${massiv_ip_addresov2[@]}

    for ip in ${massiv_ip_addresov2[@]}; do
        #user=$(whoami)
        #echo $user
        if [[ $(whoami) == "root" ]]; then
            #echo $(whoami)
            iptables -A INPUT -p tcp --dport 65505 -s $ip -j ACCEPT
        else
            #echo $(whoami)
            sudo iptables -A INPUT -p tcp --dport 65505 -s $ip -j ACCEPT
        fi

    done

done

#Рабочий код:
if [[ $(whoami) == "root" ]]; then
    iptables -A INPUT -p tcp --dport 65505 -j DROP
    iptables -A INPUT -p udp --dport 65505 -j DROP
else
    sudo iptables -A INPUT -p tcp --dport 65505 -j DROP
    sudo iptables -A INPUT -p udp --dport 65505 -j DROP
fi


}
iptables65505





iptables80() {
#Рабочий код:
#massiv_dns_name=($(psql -h localhost -p 5432 -U postgres -d For_Cron -t -c "select distinct \"Наименование ДНС Службы\" from infa;"))
#echo ${massiv_dns_name[@]}
for ip_address in ${massiv_dns_name[@]}; do

    #Рабочий код:
    #echo $(psql -h localhost -p 5432 -U postgres -d For_Cron -t -c "select \"IP адрес\" from infa where \"Наименование ДНС Службы\" = '$ip_address';")

    #Рабочий код:
    massiv_ip_addresov2=($(psql -h localhost -p 5432 -U postgres -d For_Cron -t -c "select \"IP адрес\" from infa where \"Наименование ДНС Службы\" = '$ip_address';"))
    echo ${massiv_ip_addresov2[@]}

    for ip in ${massiv_ip_addresov2[@]}; do
        #user=$(whoami)
        #echo $user
        if [[ $(whoami) == "root" ]]; then
            #echo $(whoami)
            iptables -A INPUT -p tcp --dport 80 -s $ip -j ACCEPT
        else
            #echo $(whoami)
            sudo iptables -A INPUT -p tcp --dport 80 -s $ip -j ACCEPT
        fi

    done

done

#Рабочий код:
if [[ $(whoami) == "root" ]]; then
    iptables -A INPUT -p tcp --dport 80 -j DROP
    iptables -A INPUT -p udp --dport 80 -j DROP
else
    sudo iptables -A INPUT -p tcp --dport 80 -j DROP
    sudo iptables -A INPUT -p udp --dport 80 -j DROP
fi












#for ip in $ip_address; do
#    iptables -A INPUT -p tcp --dport 80 -s $ip -j ACCEPT

#done




#ips=($(psql -h localhost -p 5432 -U postgres -d For_Cron -t -c "select \"IP адрес\" from infa where \"Наименование ДНС Службы\" = 'ya';"))
#for ip in ${ips[@]}; do
#    echo $ip
#done
}
iptables80





iptables443() {
#Рабочий код:
#massiv_dns_name=($(psql -h localhost -p 5432 -U postgres -d For_Cron -t -c "select distinct \"Наименование ДНС Службы\" from infa;"))
#echo ${massiv_dns_name[@]}
for ip_address in ${massiv_dns_name[@]}; do

    #Рабочий код:
    massiv_ip_addresov2=($(psql -h localhost -p 5432 -U postgres -d For_Cron -t -c "select \"IP адрес\" from infa where \"Наименование ДНС Службы\" = '$ip_address';"))
    echo ${massiv_ip_addresov2[@]}

    for ip in ${massiv_ip_addresov2[@]}; do
        #user=$(whoami)
        #echo $user
        if [[ $(whoami) == "root" ]]; then
            #echo $(whoami)
            iptables -A INPUT -p tcp --dport 443 -s $ip -j ACCEPT
        else
            #echo $(whoami)
            sudo iptables -A INPUT -p tcp --dport 443 -s $ip -j ACCEPT
        fi

    done

done

#Рабочий код:
if [[ $(whoami) == "root" ]]; then
    iptables -A INPUT -p tcp --dport 443 -j DROP
    iptables -A INPUT -p udp --dport 443 -j DROP
else
    sudo iptables -A INPUT -p tcp --dport 443 -j DROP
    sudo iptables -A INPUT -p udp --dport 443 -j DROP
fi


}
iptables443


sohranenie_pravil_iptables() {
os_release=$(uname -a)
#if [[ $os_release == *"Ubuntu"* || $os_release == *"Debian"* ]]; then

if [[ $os_release == *"MANJARO"* ]]; then
    sudo su - root -c "iptables-save > /etc/iptables/iptables.rules"
else
    echo "ты юзаешь какую то другую систему чел"
fi
}
sohranenie_pravil_iptables
