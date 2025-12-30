#!/bin/bash
function Proverka_BD {
echo "=============================="
echo -e "\nПроверим установлен ли PostgeSQL на системе\n"
os_release=$(uname -a)
if [[ $os_release == *"Ubuntu"* || $os_release == *"Debian"* ]]; then
    proverka_download_bd=$(psql --version 2>/dev/null)
    if [[ $proverka_download_bd == *"(PostgreSQL)"* ]]; then
        echo -e "\nPostgreSQL УСТАНОВЛЕН\n"
        echo "=============================="

    else
        echo -e "\nУстановлю PostgreSQL\n"
        sudo apt update && sudo apt install postgresql -y
        echo -e "\nPostgreSQL установлен\n"
        echo "=============================="
    fi
elif [[ $os_release == *"MANJARO"* || $os_release == *"archlinux"* ]]; then
    proverka_download_bd=$(psql --version)
    if [[ $proverka_download_bd == *"(PostgreSQL)"* ]]; then
        echo -e "\nPostgreSQL УСТАНОВЛЕН\n"
        echo "=============================="
    else
        echo -e "\nУстановлю PostgreSQL\n"
        sudo pacman -Sy postgresql
        echo -e "\nPostgreSQL установлен\n"
        echo "=============================="
    fi
else
    echo -e "ты юзаешь какую то другую систему чел\n"
fi
}
Proverka_BD

function Proverka_Iptables {
echo "=============================="
echo -e "\nПроверим установлен ли IPTables на системе\n"
os_release=$(uname -a)
if [[ $os_release == *"Ubuntu"* || $os_release == *"Debian"* ]]; then
    proverka_download_iptables=$(sudo iptables --version 2>/dev/null)
    if [[ $proverka_download_iptables == *"iptables v"* ]]; then
        echo -e "\nIPTABLES установлен\n"
        echo "=============================="

    else
        echo -e "\nУстановлю IPTABLES\n"
        sudo apt install iptables -y
        echo -e "\nIPTABLES установлен\n"
        echo "=============================="
    fi
elif [[ $os_release == *"MANJARO"* || $os_release == *"archlinux"* ]]; then
    proverka_download_iptables=$(iptables --version)
    if [[ $proverka_download_iptables == *"iptables v"* ]]; then
        echo -e "\nIPTABLES УСТАНОВЛЕН\n"
        echo "=============================="
    else
        echo -e "\nУстановлю IPTABLES\n"
        sudo pacman -S iptables
        echo -e "\nIPTABLES установлен\n"
        echo "=============================="
    fi
else
    echo -e "Ты точно используешь какой-нибудь фаервол???\n"
fi
}
Proverka_Iptables



function Proverka_Iptables-Persistent {
echo "=============================="
echo -e "\nПроверим установлена ли утиkита IPTables-Persistent/Save на системе, для сохранения внесенных изменений в IPTABLES\n"
os_release=$(uname -a)
 #proverka_download_iptables_persistent=$(iptables-persistent --version)
if [[ $os_release == *"Ubuntu"* || $os_release == *"Debian"* ]]; then
    proverka_download_iptables_save=$(dpkg -s iptables-persistent 2>/dev/null | grep Version )
    if [[ $proverka_download_iptables_save == *"Version:"* ]]; then
        echo -e "\nУтилита для сохранения правил IPTABLES установлена\n"
         echo "=============================="

     else
         echo -e "\nУстановлю пакет IPTables-Persistent\n"
         sudo apt install iptables-persistent -y
         echo -e "\nПакет IPTables-Persistent установлен\n"
         echo "=============================="
     fi
# # # elif [[ $os_release == *"MANJARO"* || $os_release == *"archlinux"* ]]; then
# # #      proverka_download_iptables_save=$(iptables-save --version)
# # #      if [[ $proverka_download_iptables_save == *"iptables-save v"* ]]; then
# # #          echo -e "\nУтилита для сохранения правил IPTABLES установлена\n"
# # #          echo "=============================="
# # #      else
# # #          echo -e "\nУстановлю пакет IPTABLES\n"
# # #          sudo pacman -S iptables
# # #          echo -e "\nПакет IPTABLES установлен\n"
# # #          echo "=============================="
# # #      fi
else
     echo -e "Ты точно используешь какой-нибудь фаервол???\n"
fi
}
Proverka_Iptables-Persistent

function Proverka_DIG {
echo "=============================="
echo -e "\nПроверим установлена ли утиита DIG в составе пакета BIND\n"
os_release=$(uname -a)
if [[ $os_release == *"Ubuntu"* || $os_release == *"Debian"* ]]; then
    proverka_download_dig=$(dig -v 2>&1)
    if [[ $proverka_download_dig == *"DiG"* ]]; then
        echo -e "\nУтилита DIG в составе пакета BIND установлена\n"
        echo "=============================="
    else
        echo -e "\nУстановлю пакет BIND, в который входит утилита DIG\n"
        sudo apt install bind9 bind9-utils
        echo -e "\nУтилита DIG в составе пакета BIND установлена\n"
        echo "=============================="
    fi
elif [[ $os_release == *"MANJARO"* || $os_release == *"archlinux"* ]]; then
    proverka_download_dig=$(dig -v)
    if [[ $proverka_download_dig == *"DiG"* ]]; then
        echo -e "\nУтилита DIG в составе пакета BIND установлена\n"
        echo "=============================="
    else
        echo -e "\nУстановлю пакет BIND, в который входит утилита DIG\n"
        sudo pacman -S bind
        echo -e "\nУтилита DIG в составе пакета BIND установлена\n"
        echo "=============================="
    fi
else
    echo -e "Ты юзаешь другую систему\n"
fi
}
Proverka_DIG


#Рабочий код:
function DNS_Provider_And_Plus_BD_And_Plus_Firewall {

os_release=$(uname -a)
if [[ $os_release == *"Ubuntu"* || $os_release == *"Debian"* ]]; then
    echo ""
    read -p "Какой пароль для ПОЛЬЗОВАТЕЛЯ POSTGRES ты хочешь установить? Это обязательно нужно сделать для Ubuntu/Debian:   " parol_postgres
    #sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '$parol_postgres';"
    sudo -iu postgres psql -c "ALTER USER postgres WITH PASSWORD '$parol_postgres'; " >/dev/null

fi

massiv_ip_addresov=()
echo -e "Создам базу данных для хранения значений\n"
createdb -h localhost -p 5432 -U postgres For_Cron
psql -h localhost -p 5432 -U postgres For_Cron -c 'CREATE TABLE infa (id BIGSERIAL NOT NULL PRIMARY KEY, "Наименование ДНС Службы" VARCHAR(30) NOT NULL, "Имя ДНС Службы" VARCHAR(50) NOT NULL, "IP адрес" VARCHAR(160));' >/dev/null
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
        psql -h localhost -p 5432 -U postgres For_Cron -c "INSERT INTO infa (\"Наименование ДНС Службы\", \"Имя ДНС Службы\", \"IP адрес\") VALUES ('$dns_provider', '$dns_name_provider', '$IP_and_DNS');" >/dev/null
    done

    massiv_ip_addresov=""


done

}
DNS_Provider_And_Plus_BD_And_Plus_Firewall


pervichnaya_nastroyka_iptables() {
if [[ $(whoami) == "root" ]]; then
    #echo $(whoami)
    iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
    iptables -A INPUT -i lo -j ACCEPT
else
    #echo $(whoami)
    sudo iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    sudo iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
    sudo iptables -A INPUT -i lo -j ACCEPT
fi

}
pervichnaya_nastroyka_iptables


massiv_dns_name=($(psql -h localhost -p 5432 -U postgres -d For_Cron -t -c "select distinct \"Наименование ДНС Службы\" from infa;"))



iptables1() {
for ip_address in ${massiv_dns_name[@]}; do

    #Рабочий код:
    massiv_ip_addresov2=($(psql -h localhost -p 5432 -U postgres -d For_Cron -t -c "select \"IP адрес\" from infa where \"Наименование ДНС Службы\" = '$ip_address';"))
    echo ${massiv_ip_addresov2[@]}

    for ip in ${massiv_ip_addresov2[@]}; do
        #user=$(whoami)
        #echo $user
        if [[ $(whoami) == "root" ]]; then
            #echo $(whoami)
            iptables -A INPUT -s $ip -p icmp -j ACCEPT
        else
            #echo $(whoami)
            sudo iptables -A INPUT -s $ip -p icmp -j ACCEPT
        fi

    done

done

#Рабочий код:
if [[ $(whoami) == "root" ]]; then
    iptables -A INPUT -p icmp -j DROP
else
    sudo iptables -A INPUT -p icmp -j DROP
fi


}
iptables1













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




iptables65506() {
for ip_address in ${massiv_dns_name[@]}; do

    #Рабочий код:
    massiv_ip_addresov2=($(psql -h localhost -p 5432 -U postgres -d For_Cron -t -c "select \"IP адрес\" from infa where \"Наименование ДНС Службы\" = '$ip_address';"))
    echo ${massiv_ip_addresov2[@]}

    for ip in ${massiv_ip_addresov2[@]}; do
        #user=$(whoami)
        #echo $user
        if [[ $(whoami) == "root" ]]; then
            #echo $(whoami)
            iptables -A INPUT -p tcp --dport 65506 -s $ip -j ACCEPT
        else
            #echo $(whoami)
            sudo iptables -A INPUT -p tcp --dport 65506 -s $ip -j ACCEPT
        fi

    done

done

#Рабочий код:
if [[ $(whoami) == "root" ]]; then
    iptables -A INPUT -p tcp --dport 65506 -j DROP
    iptables -A INPUT -p udp --dport 65506 -j DROP
else
    sudo iptables -A INPUT -p tcp --dport 65506 -j DROP
    sudo iptables -A INPUT -p udp --dport 65506 -j DROP
fi


}
iptables65506












###Рабочий код:
### <- означает то что рабочую функцию для 80 порта выключил, стоит убрать только ###
###iptables80() {
#Рабочий код:
#massiv_dns_name=($(psql -h localhost -p 5432 -U postgres -d For_Cron -t -c "select distinct \"Наименование ДНС Службы\" from infa;"))
#echo ${massiv_dns_name[@]}
###for ip_address in ${massiv_dns_name[@]}; do

    #Рабочий код:
    #echo $(psql -h localhost -p 5432 -U postgres -d For_Cron -t -c "select \"IP адрес\" from infa where \"Наименование ДНС Службы\" = '$ip_address';")

    #Рабочий код:
###    massiv_ip_addresov2=($(psql -h localhost -p 5432 -U postgres -d For_Cron -t -c "select \"IP адрес\" from infa where \"Наименование ДНС Службы\" = '$ip_address';"))
###    echo ${massiv_ip_addresov2[@]}

###     for ip in ${massiv_ip_addresov2[@]}; do
        #user=$(whoami)
        #echo $user
###         if [[ $(whoami) == "root" ]]; then
            #echo $(whoami)
###             iptables -A INPUT -p tcp --dport 80 -s $ip -j ACCEPT
###         else
            #echo $(whoami)
###             sudo iptables -A INPUT -p tcp --dport 80 -s $ip -j ACCEPT
###         fi

###     done

### done

#Рабочий код:
### if [[ $(whoami) == "root" ]]; then
###     iptables -A INPUT -p tcp --dport 80 -j DROP
###     iptables -A INPUT -p udp --dport 80 -j DROP
### else
###     sudo iptables -A INPUT -p tcp --dport 80 -j DROP
###     sudo iptables -A INPUT -p udp --dport 80 -j DROP
### fi












#for ip in $ip_address; do
#    iptables -A INPUT -p tcp --dport 80 -s $ip -j ACCEPT

#done




#ips=($(psql -h localhost -p 5432 -U postgres -d For_Cron -t -c "select \"IP адрес\" from infa where \"Наименование ДНС Службы\" = 'ya';"))
#for ip in ${ips[@]}; do
#    echo $ip
#done
### }
### iptables80






#Рабочий код:
### <- означает то что рабочую функцию для 80 порта выключил, стоит убрать только ###
###iptables443() {
#Рабочий код:
#massiv_dns_name=($(psql -h localhost -p 5432 -U postgres -d For_Cron -t -c "select distinct \"Наименование ДНС Службы\" from infa;"))
#echo ${massiv_dns_name[@]}
###for ip_address in ${massiv_dns_name[@]}; do

    #Рабочий код:
###    massiv_ip_addresov2=($(psql -h localhost -p 5432 -U postgres -d For_Cron -t -c "select \"IP адрес\" from infa where \"Наименование ДНС Службы\" = '$ip_address';"))
###    echo ${massiv_ip_addresov2[@]}

###    for ip in ${massiv_ip_addresov2[@]}; do
        #user=$(whoami)
        #echo $user
###        if [[ $(whoami) == "root" ]]; then
            #echo $(whoami)
###            iptables -A INPUT -p tcp --dport 443 -s $ip -j ACCEPT
###        else
            #echo $(whoami)
###            sudo iptables -A INPUT -p tcp --dport 443 -s $ip -j ACCEPT
###        fi

###    done

###done

#Рабочий код:
###if [[ $(whoami) == "root" ]]; then
###    iptables -A INPUT -p tcp --dport 443 -j DROP
###    iptables -A INPUT -p udp --dport 443 -j DROP
###else
###    sudo iptables -A INPUT -p tcp --dport 443 -j DROP
###    sudo iptables -A INPUT -p udp --dport 443 -j DROP
###fi


###}
###iptables443


smena_policy_input_and_block_all() {
if [[ $(whoami) == "root" ]]; then
            #echo $(whoami)
            iptables -P INPUT DROP
            iptables -A INPUT -j DROP
        else
            #echo $(whoami)
            sudo iptables -P INPUT DROP
            sudo iptables -A INPUT -j DROP
        fi

}
smena_policy_input_and_block_all




sohranenie_pravil_iptables() {
os_release=$(uname -a)
if [[ $os_release == *"Ubuntu"* || $os_release == *"Debian"* ]]; then
    sudo su - root -c "iptables-save > /etc/iptables/rules.v4"
elif [[ $os_release == *"MANJARO"* || $os_release == *"archlinux"* ]]; then
    sudo su - root -c "iptables-save > /etc/iptables/iptables.rules"
else
    echo "ты юзаешь какую то другую систему чел"
fi
}
sohranenie_pravil_iptables
