#!/bin/bash

NEW_PATH=$(pwd)



#используя sed или awk вставить сюда значения
#read -p "Впиши название 1го ДНС провайдера: " dns_provider1
#read -p "Впиши название 2го ДНС провайдера: " dns_provider2
#read -p "Впиши DNS имя 1го провайдера: " dns_name1
#read -p "Впиши DNS имя 2го провайдера: " dns_name2

#dns1=$(dig +short "$dns_name1")
#dns2=$(dig +short "$dns_name2")


#Здесь думаю после 1ой настройки сервера, обратиться к бд, заранее сохраняя значения в переменные
dns_provider1=$(psql -h localhost -p 5432 -U postgres For_Cron -c "SELECT 'Наименование ДНС Службы' from infa WHERE id = '1';")
dns_provider=2$(psql -h localhost -p 5432 -U postgres For_Cron -c "SELECT 'Наименование ДНС Службы' from infa WHERE id = '2';")

dns_name1=$(psql -h localhost -p 5432 -U postgres For_Cron -c "SELECT 'Имя ДНС Службы' from infa WHERE id = '1';")
dns_name2=$(psql -h localhost -p 5432 -U postgres For_Cron -c "SELECT 'Имя ДНС Службы' from infa WHERE id = '2';")

ip_address1=$(psql -h localhost -p 5432 -U postgres For_Cron -c "SELECT 'IP адрес' from infa WHERE id = '1';")
ip_address2=$(psql -h localhost -p 5432 -U postgres For_Cron -c "SELECT 'IP адрес' from infa WHERE id = '2';")
#ip_pustoe_pole1=$(psql -h localhost -p 5432 -U postgres For_Cron -c "SELECT 'IP адрес' from infa WHERE id = '1';")
#ip_pustoe_pole2=$(psql -h localhost -p 5432 -U postgres For_Cron -c "SELECT 'IP адрес' from infa WHERE id = '2';")

dns1=$(dig +short "$dns_name1")
dns2=$(dig +short "$dns_name2")
ssssssss
#Затем я буду сравнивать dns имя с бд, выводом будет ай пи днс службы, если имя пустое или одинаковое с бд, то ничего не делать

function logika1 {

if [[ $dns1 == $ip_address1 || $dns1 == "" ]]; then
    break



#Если ай пи адрес отличается от того что в бд, то перезаписать ай пи адрес в бд и затем удалить правила в iptables со старыми данными и добавить с новыми

else
    psql -h localhost -p 5432 -U postgres For_Cron -c "UPDATE infa SET 'IP адрес' = '$dns1' WHERE name = '$ip_address1';"
    sudo iptables -D INPUT 4
    sudo iptables -D INPUT 6
    sudo iptables -D INPUT 8
    sudo iptables -D INPUT 10
    sudo iptables -D INPUT 12
    sudo iptables -A INPUT -p tcp -dport ПОРТ-SSH -s "$dns1" -j ACCEPT
    sudo iptables -A INPUT -p tcp -dport 80 -s "$dns1" -j ACCEPT
    sudo iptables -A INPUT -p tcp -dport 443 -s "$dns1" -j ACCEPT
    sudo iptables -A INPUT -p tcp -dport ПОРТ-ДЛЯ-ПРОКСИ -s "$dns1" -j ACCEPT
    sudo iptables -A INPUT -p tcp -dport ПОРТ-ДЛЯ-ПРОКСИ+ВЕБ -s "$dns1" -j ACCEPT

fi
}
logika1


function logika2 {

if [[ $dns2 == $ip_address2 || $dns2 == "" ]]; then
    break



#Если ай пи адрес отличается от того что в бд, то перезаписать ай пи адрес в бд и затем удалить правила в iptables со старыми данными и добавить с новыми

else
    psql -h localhost -p 5432 -U postgres For_Cron -c "UPDATE infa SET 'IP адрес' = '$dns2' WHERE name = '$ip_address2';"
    sudo iptables -D INPUT 5
    sudo iptables -D INPUT 7
    sudo iptables -D INPUT 9
    sudo iptables -D INPUT 11
    sudo iptables -D INPUT 13
    sudo iptables -A INPUT -p tcp -dport ПОРТ-SSH -s "$dns2" -j ACCEPT
    sudo iptables -A INPUT -p tcp -dport 80 -s "$dns2" -j ACCEPT
    sudo iptables -A INPUT -p tcp -dport 443 -s "$dns2" -j ACCEPT
    sudo iptables -A INPUT -p tcp -dport ПОРТ-ДЛЯ-ПРОКСИ -s "$dns2" -j ACCEPT
    sudo iptables -A INPUT -p tcp -dport ПОРТ-ДЛЯ-ПРОКСИ+ВЕБ -s "$dns2" -j ACCEPT
fi
}
logika2


#function Sozdanie_pravil_v_IPTables {



#удалить не актуальные правила iptables!!!


############

#сохранить конфиг iptables правил где то

#}
#Sozdanie_pravil_v_IPTables
