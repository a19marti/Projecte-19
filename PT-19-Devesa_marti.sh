#!/bin/bash
#*******************************************************************************************************
#
#	File: PT-19-Devesa_Marti.sh
#
#	Descripció: Analitzar el contingut d'un fitxer d'atacs a una empresa
#
#	Author: By9Marti
#
#	Creat: 15-12-2020
#
#*******************************************************************************************************

#Fem que es pari si no detecta el argument amb el arxiu.
if [ -z $1 ];then
	echo "Has de pasar un arxiu per poder llegir-lo"
	exit 1
fi

#Lleguim tot el arxiu i el filtrem per les ips.
arxiu=`cat $1 | grep Failed | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sort`

#Creem una array per poder guardar totes les ips
declare -A llistaip

#Agafem totes les ips anterior i fem un recompte guardan també el numero de cops que han atacat.
contaip(){
	for i in $arxiu;do
		if [ -z "${llistaip[$i]}" ];then
			llistaip[$i]=1
		else
			llistaip[$i]+=1
		fi
	done
}

#Fem un print de la array que em creat abans amb les ips / cops / paisos.
mostrartotalip(){
	echo "Recompte:	Ip:			Pais:"
	for i in "${!llistaip[@]}";do
		intents=`echo "${llistaip[$i]}" | wc -m`
		ip=`geoiplookup $i | awk '{print $NF}'`
		echo "$intents		$i		$ip"
	done
}

contaip
mostrartotalip
