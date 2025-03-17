#!/bin/bash

if [ "$(whoami)" != "root" ] ; then
   echo " !! Precisa executar como super-usuario !! Por favor executar como super-usuario."
   exit
fi

#================================= INICIO TESTE SE MINT  ================================
if [ -e "/etc/linuxmint/info" ]; then
   versaoMint=$(cat /etc/linuxmint/info | grep 'RELEASE=' | cut -d'=' -f2 | head -1)
   if [ "$versaoMint" = "18.3" ]; then
      if [ -e /opt/mstech/updatemanager.jar ]; then
         echo "run ok on 18.3 Netbook;"
         cd /tmp
         if [ ! -e /media/dados/patrimony.buf ]; then
            echo -e "\e[1;31m NETBOOK NAO ATIVADO. Rodar script 3000.sh primeiro! saindo.\e[0m"
         else
            wget -c www.labmovel.seed.pr.gov.br/Updates/ocs-paramint183_2022-03-09_16-36-41.sh
            bash ocs-paramint183_2022-03-09_16-36-41.sh
         fi
         exit
      fi
   fi
fi
#================================= FIM TESTE SE MINT 18.3  ================================


echo
echo "##################################################"
echo "# Script para padronizacao de computadores LINUX #"
echo "##################################################"
echo
echo "Favor inserir o hostname do computador"
echo "Importante seguir o padrao e12345678-abcdef , onde 12345678 é o número do INEP"
echo "e abcdef sao os ultimos digitos do MAC ADDRESS do equipamento"
echo "Siglas e exemplos abaixo:"
echo "Para educatron favor utilizar o prefixo t"
echo "Para desktops favor utilizar o prefixo e"
echo "Para notebooks favor utilizar o prefixo n"
echo "Ex: t12345678-abcdef, n12345678-abcdef, d12345678-abcdef"

read -p "Hostname: " hostname
echo

echo "# Alterando arquivo Hostname"

echo $hostname > /etc/hostname

#hostline=$(cat /etc/hosts | grep 127.0.1.1 | tr ' ' '\t')
#echo $hostline   
#sed "s/127.0.1.1/127.0.1.11/g" /etc/hosts

echo "# Alterando arquivo Hosts"

echo "127.0.0.1       localhost
127.0.1.1       "$hostname"

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters" > /etc/hosts

hostname "$hostname"
ocsinv
echo "reiniciando em 2segundos"
sleep 2

init 6
