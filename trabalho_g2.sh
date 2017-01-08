#!/bin/bash

#criacao de variaveis globais
now=$(date +%d/%m/%Y" - "%H:%M)

#cricao das funcoes que serao utilizadas no trabalho
#essa funcao se encarrega de fazer a criacao do menu principal com todas opções e escolhas
function menu_principal(){
	#op=$(dialog --title "Menu Principal" --menu 'Escolha a operação que a realizar:' 20 40 20  \ 1 "Monitoramento de rede"  \ 2 "Realizar backup"  \ 3 "Executar comando" \ 4 "Realizar conexão" \ 5 "Pegar IPS da rede" \ 6 "Gerenciar usuários" \ 7 "Performance de enlace" \ 8 "Instalar pacotes necessários" \ 9 "Sobre o programa"  --stdout)
	op=$(dialog --title "Menu Principal" --menu 'Escolha a operação que a realizar:' 20 40 20  \ 1 "Monitoramento de rede"  \ 2 "Realizar backup" \ 6 "Gerenciar usuários" \ 7 "Performance de enlace" \ 8 "Instalar pacotes necessários"  --stdout)
  case $op in
    ' 1') #carregar o menu dos servicos de rede
		  load_options
		  manage_services
      ;;
	  ' 2') #carregar o menu do backup
		  load_options
		  manage_backup
      ;;
	  ' 3')#carregar tela de execuçaõ de um script aleatorio
		  load_exec_screen
		  execute
      ;;
	  ' 4')#carregar tela para realizar conexão remota
		  load_options
		  connections
      ;;
	  ' 5')#carregar a tela de monitormanto de ips
		  load_options
		  watch_ips
      ;;
	  ' 6')#carregar tela de gerencia de usuarios
		  load_options
		  manage_users
      ;;
	  ' 7')#carregar tela de gerencia de enlace
		  load_options
		  manage_enlace
      ;;
	  ' 8')#instalar pacotes
		  installing_packages
		  install_packages
      ;;
	  ' 9')#carregar a tela de sobre o programa
		  about
      ;;
		*)#encerra o programa
      #echo "Opção: $op"
		  close
      ;;
	esac
}

#
function manage_users(){
	op=$(dialog --title "Gerenciar usuários" --menu "Escolha o que deseja fazer: " 20 40 20 \ 1 "Criar usuário" \ 2 "Modificar usuário" \ 3 "Excluir usuário" \ 4 "Listar usuários" \ 5 "Pesquisar por usuário" \ 6 "Gerência remota - SSH" \ 7 "Ver histórico de modificações" --stdout)
  
  case $op in
	  ' 1')#carregar a tela de criacao de usuarios
		  load_options
		  create_user
      ;;
	  ' 2')#carregar a tela de modificar usuarios
		  load_options
		  update_user
      ;;
	  ' 3')#carregar tela de deletar usuarios
		  load_options
		  delete_user
      ;;
	  ' 4')#carregar tela de listagem de usuarios
		  load_options
		  list_users
      ;;
	  ' 5')#carregar tela de pesquisa de usuarios
		  load_options
		  search_user
      ;;
	  ' 6')#carrega tela de ssh
		  load_options
		  load_menu_remote_users
      ;;
	  ' 7')#carrega funcao de listar historico
		  load_options
		  list_historic_users
      ;;
    *)#carrega novamente o menu
		  load_menu
      ;;
	esac
}

function load_menu_remote_users(){
	op=$(dialog --title "Gerenciar usuários" --menu "Escolha o que deseja fazer: " 20 40 20 \ 1 "Criar usuário" \ 2 "Modificar usuário" \ 3 "Excluir usuário" \ 4 "Listar usuários" \ 5 "Pesquisar por usuário" --stdout)
  
  case $op in
	  ' 1')#carregar a tela de criacao de usuarios
		  load_options
		  create_remote_user
      ;;
	  ' 2')#carregar a tela de modificar usuarios
		  load_options
		  update_remote_user
      ;;
	  ' 3')#carregar tela de deletar usuarios
		  load_options
		  delete_remote_user
      ;;
	  ' 4')#carregar tela de listagem de usuarios
		  load_options
		  list_remote_users
      ;;
	  ' 5')#carregar tela de pesquisa de usuarios
		  load_options
		  search_remote_user
      ;;
	  ' 7')#carrega funcao de listar historico
		  load_options
		  list_historic_users
      ;;
    *)#carrega novamente o menu
		  load_menu
      ;;
	esac
}

#como usei esse codigo mais de uma vez decidi fazer como uma funcao
function burn_users(){
	#grava o conteudo do passwd em um arquivo, ou seja, grava todos os usuarios do sistema em users.txt
	getent passwd | cut -d \: -f1 > "users.txt"
}

#funcao enmcarregada de criar um usuario remotamente
function create_remote_user(){
	user=$(dialog --inputbox "Digite o nome do usuário" 10 25 --stdout)
	bashh=$(dialog --inputbox "Digite o interpretador de comando" 10 25 --stdout)
	directory=$(dialog --inputbox "Digite o diretório padrão" 10 25 --stdout)
	folder=$(dialog --inputbox "Digite a pasta do /home" 10 25 --stdout)
	
	echo "Foi adicionado o usuário $user ao sistema - em $now" >> "user_historic.txt"

	#funcao para criar usuario, passo o interpretador de comandos, diretorio padrao, comentario sobreo o user e o nome
	ssh -X root@10.70.1.101 "useradd -s $bashh -d $directory -c $user -m $folder"

	#carrega o menu de usuarios denovo
	manage_users
}

#funcao enmcarregada de criar um usuario
function create_user(){
	user=$(dialog --inputbox "Digite o nome do usuário" 10 25 --stdout)
	bashh=$(dialog --inputbox "Digite o interpretador de comando" 10 25 --stdout)
	directory=$(dialog --inputbox "Digite o diretório padrão" 10 25 --stdout)
	folder=$(dialog --inputbox "Digite a pasta do /home" 10 25 --stdout)
	
	echo "Foi adicionado o usuário $user ao sistema - em $now" >> "user_historic.txt"

	#funcao para criar usuario, passo o interpretador de comandos, diretorio padrao, comentario sobreo o user e o nome
	sudo useradd -s $bashh -d $directory -c $user -m $folder

	#carrega o menu de usuarios denovo
	manage_users
}

#
function update_remote_user(){
	user=$(dialog --inputbox "Digite o nome do usuário" 10 25 --stdout)
	new_user=$(dialog --inputbox "Digite o novo nome do usuário" 10 25 --stdout)
	bashh=$(dialog --inputbox "Digite o interpretador de comando" 10 25 --stdout)

	echo "Foi modificado o usuário $user - em $now" >> "user_historic.txt"

	ssh -X root@10.70.1.101 "usermod -s $bashh -c $new_user $user"

	manage_users
}

#
function update_user(){
	user=$(dialog --inputbox "Digite o nome do usuário" 10 25 --stdout)
	new_user=$(dialog --inputbox "Digite o novo nome do usuário" 10 25 --stdout)
	bashh=$(dialog --inputbox "Digite o interpretador de comando" 10 25 --stdout)

	echo "Foi modificado o usuário $user - em $now" >> "user_historic.txt"

	sudo usermod -s $bashh -c $new_user $user

	manage_users
}

#
function delete_remote_user(){
	user=$(dialog --inputbox "Digite o nome do usuário" 10 25 --stdout)

	echo "Foi excluido o usuário $user - em $now" >> "user_historic.txt"

	ssh -X root@10.70.1.101 "deluser --remove-home $user"
	manage_users
}

#
function delete_user(){
	burn_users
	user=$(dialog --inputbox "Digite o nome do usuário" 10 25 --stdout)

	echo "Foi excluido o usuário $user - em $now" >> "user_historic.txt"

	sudo deluser --remove-home $user
	manage_users
}

#
function list_remote_users(){
	ssh -X root@10.70.1.101 "getent passwd | cut -d \: -f1" > "users.txt"

	echo "Foram listados todos usuários - em $now" >> "user_historic.txt"

	dialog --title "Usuário do sistema" --textbox users.txt 20 100
	manage_users
}

#
function list_users(){
	burn_users

	echo "Foram listados todos usuários - em $now" >> "user_historic.txt"

	dialog --title "Usuário do sistema" --textbox users.txt 20 100
	manage_users
}

#
function search_remote_user(){
	user=$(dialog --inputbox "Digite o nome do usuário" 10 25 --stdout)
	ssh -X root@10.70.1.101 "cat /etc/passwd | grep $user | cut -d: -f1,7" > "search_users.txt"

	echo "Foi realizad uma pesquisa pelo usuário $user - em $now" >> "user_historic.txt"

	dialog --title "Resultados da pesquisa:" --textbox search_users.txt 20 100
	manage_users
}

#
function search_user(){
	user=$(dialog --inputbox "Digite o nome do usuário" 10 25 --stdout)
	cat /etc/passwd | grep $user | cut -d: -f1,7 > "search_users.txt"

	echo "Foi realizad uma pesquisa pelo usuário $user - em $now" >> "user_historic.txt"

	dialog --title "Resultados da pesquisa:" --textbox search_users.txt 20 100
	manage_users
}

#
function list_historic_users(){
	op=$(dialog --title "Digitar informações" --inputbox "Filtrar informações? [s] - Sim [n] - Não " 10 10 --stdout)

	if [ $op == "s" ]
		then
			filtro=$(dialog --title "Digitar informações" --inputbox "Digite o conteudo que será posto no grep" 10 10 --stdout)

			conteudo=$(cat user_historic.txt | grep $filtro)
			
			echo $conteudo > "aux.txt"

			dialog --title "Histórico de modificações" --textbox aux.txt 20 100
	else
		dialog --title "Histórico de modificações" --textbox user_historic.txt 20 100
	fi

	manage_users
}

#essa funcoa vai ser trocada quando eu souber oq tem que fazer
function manage_services(){
	op=$(dialog --title "Menu Principal" --menu 'Escolha a operação que a realizar:' 20 50 20 \ 1 "Inserir IP para monitorar" \ 2 "Inserir porta para monitorar" \ 3 "Inserir interface para monitorar" \ 4 "Verificar status de monitoramento" \ 5 "Ver histórico de monitoramento" \ 6 "Configurar agendamento" --stdout)
	
	case $op in
    ' 1')#carrega tela para funcao de monitorar ips
		  load_options
		  watch_ip
      ;;
	  ' 2')#carrega tela para funcao de monitorar porta
		  load_options
		  watch_port
      ;;
	  ' 3')#
		  load_options
		  watch_interface
      ;;
	  ' 4')#
		  load_options
		  verify_status
      ;;
	  ' 5')#
		  load_options
		  list_historic
      ;;
	  ' 6')#
		  load_options
		  config_appointment
      ;;
	  *)#
		  load_menu
      ;;
  esac
}

# - Instalar SNMP e SNPMD--> sudo apt-get install snmp - sudo apt-get install snmpd
# - Editar -> /etc/snmp/snmpd.conf
#

# TODO: Unir watch_ip e watch_interface
# TODO: SNMP ao invés de tcpdump
#function watch_ip(){
#	ip=$(dialog --title "Digitar informações" --inputbox "Digite o IP para monitorar: " 10 25 --stdout)

#	echo "Foi adicionado o IP $ip para ser monitorado - em $now" >> "service_historic.txt"

#	warning_stop
#	clear
#	sudo tcpdump dst host $ip	
#	manage_services
#}

#
function watch_interface(){
	ip=$(dialog --title "Digitar informações" --inputbox "Digite o IP para monitorar: " 10 25 --stdout)
	iface=$(dialog --title "Digitar informações" --inputbox "Digite o índice da interface de rede: " 10 25 --stdout)
	time=$(dialog --title "Digitar informações" --inputbox "Digite o intervalo de monitoramento: " 10 25 --stdout)
	snmp_version=$(dialog --title "Digitar informações" --radiolist "Versão do SNMP: " 0 0 0 \
    1 'v1' off \
    2c 'v2c' on \
    --stdout)
	snmp_comm=$(dialog --title "Digitar informações" --inputbox "Digite a comunidade SNMP: " 10 25 --stdout)

	echo "Foi adicionada a interface $ip para ser monitorada - em $now" >> "service_historic.txt"

  # Consulta informações sobre o sistema
  snmpwalk -v$snmp_version -c $snmp_comm $ip .1.3.6.1.2.1.1 > /tmp/query 2>&1
  # Primeira consulta ao dispositivo.
  snmpwalk -v$snmp_version -c $snmp_comm $ip .1.3.6.1.2.1.2.2 >> /tmp/query 2>&1
  PROG=0
  SECS=1
  ( while [ $SECS -ne $time ]
    do
      PROG=$(( $PROG + (100 / $time) ))
      echo $PROG
      sleep 1
      SECS=$(( $SECS + 1 ))
    done 
    echo "100" ) | dialog --title "Aguarde..." --gauge "Executando monitoramento...\n" 7 35 0
  # Segunda consulta ao dispositivo
  snmpwalk -v$snmp_version -c $snmp_comm $ip .1.3.6.1.2.1.2.2 >> /tmp/query 2>&1
  # Processamento das informações obtidas do dispositivo através de programa AWK e exibição
  dialog --title "Estatísticas da interface" --msgbox "$(gawk -f trabalho_g2.awk -v iface_idx=$iface -v mon_time=$time /tmp/query)" 15 70 
	manage_services
}

#
function watch_port(){
	#interface=$(dialog --title "Digitar informações" --inputbox "Digite a interface a ser monitorada: " 10 25 --stdout)
	ip=$(dialog --title "Digitar informações" --inputbox "Digite o endereço IP a ser monitorado: " 10 25 --stdout)
	port=$(dialog --title "Digitar informações" --inputbox "Digite a porta a ser monitorada: " 10 25 --stdout)
  proto=$(dialog --title "Digitar informações" --radiolist "Protocolo da porta: " 0 0 0 \
    tcp 'TCP' on \
    udp 'UDP' off \
    --stdout)

	echo "Foi adicionada a porta $port para ser monitorada na interface $interface - em $now" >> "service_historic.txt"

	warning_stop
	clear
	#sudo tcpdump -i $interface dst port $port
  if [ $proto == 'tcp' ]
  then
    hping3 -S -c 5 -p $port $ip
  elif [ $proto == 'udp' ]
  then
    hping3 -2 -c 5 -p $port $ip
  fi
  read
	manage_services
}

#
function verify_status(){
	ip=$(dialog --title "Digitar informações" --inputbox "Digite o IP para verificar status: " 10 25 --stdout)
	dialog --title "AVISO" --infobox "\nVerificando status do IP\n" 8 35; sleep 3; clear
	retorno=$(ping -q -c5 $ip | grep 'received' | cut -d " " -f 4)

	if [ $retorno == 1 ]
	then
	  dialog --title "AVISO" --infobox "\nIP ativo na rede\n" 8 35; sleep 3; clear
		echo "Realizado teste no IP: $ip - Teste com sucesso - em $now" >> "service_historic.txt"
	else
		dialog --title "AVISO" --infobox "\nIP não ativo na rede\n" 8 35; sleep 3; clear
		echo "Realizado teste no IP: $ip - Teste com falha - em $now" >> "service_historic.txt"
	fi
	manage_services	
}

#
function list_historic(){
	op=$(dialog --title "Digitar informações" --inputbox "Filtrar informações? [s] - Sim [n] - Não " 10 10 --stdout)

	if [ $op == "s" ]
	then
    filtro=$(dialog --title "Digitar informações" --inputbox "Digite o conteudo que será posto no grep" 10 10 --stdout)
    conteudo=$(cat service_historic.txt | grep $filtro)
    echo $conteudo > "aux.txt"
    dialog --title "Histórico de monitoramento" --textbox aux.txt 20 100
	else
		dialog --title "Histórico de monitoramento" --textbox service_historic.txt 20 100
	fi
	manage_services
}

#
function config_appointment(){
	echo "config"
}

#
function manage_backup(){
	op=$(dialog --title "Menu Principal" --menu 'Escolha a operação que a realizar:' 20 50 20 \ 1 "Escolher pastas para backup remoto" \ 2 "Configurar rotina de backup" \ 3 "Visualizar diretório do backup" --stdout)

  case $op in
	  ' 1')#
		  load_options
		  choose_folder
      ;;

	  ' 2')#
		  load_options
      ;;

	  ' 3')#
		  load_options
		  list_directory
      ;;
	  *)#
		  load_menu
      ;;
	esac
}

function choose_folder(){
	#criando meu diretório para guardar o backup
	user=$(whoami)
	mkdir "/home/$user/Downloads/backup/"
	dir_backup="/home/$user/Downloads/backup/"

	diretorios=("")
	diretorios_zipados=("")
	dialog --title "text" --fselect "/" height width
	dir=$(dialog --stdout --title "Escolha o diretório" --fselect $HOME/ 14 48)
	diretorios=("${diretorios[@]}" "$dir")
	
	dialog --title 'Escolher diretório' --yesno '\nDeseja adicionar mais algum diretoório?\n\n' 0 0
	response=$?
	
	while [ $response != 1 ]
		do
			dialog --title "text" --fselect "/" height width
			dir=$(dialog --stdout --title "Escolha o diretório" --fselect $HOME/ 14 48)		
			diretorios=("${diretorios[@]}" "$dir")

			dialog --title 'Escolher diretório' --yesno '\nDeseja adicionar mais algum diretoório?\n\n' 0 0
			response=$?
		done

	qtd=$((${#diretorios[@]} - 1))

	dialog --title "Aguarde..." --infobox "\nRealizando backup das pastas escolhidas!" 5 35; sleep 2; clear

	for i in `seq 1 $qtd`
	do
		dir_name=$(date +"%Y-%m-%d_%H-%M-%S")"-"$(whoami)".tgz"
		tar -zcf $dir_name ${diretorios[$i]}
		cp $dir_name $dir_backup
		diretorios_zipados=("${diretorios_zipados[@]}" "$dir_name")
	done

	dialog --title "Parabéns!" --infobox "\nBackup realizado com sucesso!" 5 35; sleep 2; clear

	dialog --title 'Backup remoto' --yesno '\nDeseja enviar este bakup remotamente?\n\n' 0 0
	response2=$?

	if [ $response2 == 0 ]; then
		qtdz=$((${#diretorios_zipados[@]} - 1))

		dialog --title "Aguarde..." --infobox "\nEnviando os arquivos para o usuário!" 5 35; sleep 2; clear

		#executando o scp


		for i in `seq 1 $qtdz`
			do
				scp ${diretorios_zipados[$i]} root@10.70.1.101:"/home/pi/Downloads/"
			done

		dialog --title "Aguarde..." --infobox "\nArquivos enviados!" 5 35; sleep 2; clear

		load_options
		manage_backup
	else
		load_options
		manage_backup
	fi
}

#
function config_routine(){
	echo "config routine"
}

#
function list_directory(){
	dialog --title 'Escolher diretório' --yesno '\nExibir diretório remoto?\n\n' 0 0
	response=$?

	if [ $response == 0 ];
		then
			ssh -X root@10.70.1.101 'ls -a' > "dir_backup_ssh.txt"
			dialog --title "List file of directory /home" --msgbox "dir_backup_ssh.txt" 100 100
	else
		user=$(whoami)
		dir_backup="/home/$user/Downloads/backup/"
		dialog --title "List file of directory /home" --msgbox "$(ls $dir_backup)" 100 100
	fi

	load_options
	manage_backup
}

#
#essa funcao se encarrega de exibir os dados sobre o programa
function about(){
	dialog --title "Sobre o programa" --textbox about.txt 20 50
	load_menu
}

#essa funcoa se encarrega de encerrar o programa
function close(){
	dialog --title "Aguarde..." --infobox "\nEncerrando o programa" 5 35; sleep 2; clear
}

#
function warning_stop(){
	dialog --title "Aguarde..." --infobox "\nPara encerrar pressione: \nCTRL + C\n" 5 35; sleep 2; clear	
}

#essa funcao se encarrega de ler o comando, executar o comando e gravar o resuktado em um arquivo, exibir o comando e apagar o arquivo e chamar o menu
function execute(){
	comand=$(dialog --inputbox "Digite seu comando" 10 25 --stdout)
	$comand >> 'comando.txt'
	dialog --title "Resultados do comando" --textbox comando.txt 20 100
	rm -rf comando.txt
	load_menu
}

#essa funcao se encarrega de carregar novamente o menu principal
function load_menu(){
	dialog --title "Aguarde..." --infobox "\nCarregando o menu" 5 35; sleep 4; clear	
	menu_principal
}

#
function load_options(){
	dialog --title "Aguarde..." --infobox "\nCarregando lista de opções" 5 35; sleep 3; clear
}

#
function load_infos(){
	dialog --title "Aguarde..." --infobox "\nCarregando informações" 5 35; sleep 3; clear	
}

#
function load_exec_screen(){
	dialog --title "Aguarde..." --infobox "\nCarregando tela de execução" 5 35; sleep 3; clear
}

#
function warning_remote_connect(){
	dialog --title "AVISO" --infobox "\nAssim que qualquer conexão remota for realizada, você perdera a interface gráfica até encerrar a sessão!\n" 8 35; sleep 6; clear
}

#
function installing_packages(){
	dialog --title "Aguarde..." --infobox "\nInstalando programas!" 5 35; sleep 3; clear
}

#
function connections(){
	warning_remote_connect
	op=$(dialog --title "Lista de opções de conexão" --menu "Escolha o tipo de conexão" 20 40 20 \ 1 "SSH" \ 2 "Telnet" \ 3 "FTP" --stdout)

  case $op in
	  ' 1')#
		  load_infos
		  connect_ssh
      ;;
	  ' 2')#
		  load_infos
		  connect_telnet
      ;;
	  ' 3')		#
		  load_infos
		  connect_ftp
	  ;;
	  *)#
		  load_menu
	  ;;
	esac
}

#
function connect_ssh(){
	ip=$(dialog --inputbox "Digite o ip a conectar" 10 25 --stdout)
	user=$(dialog --inputbox "Digite o nome do usuário" 10 25 --stdout)

	#realizar a conexao ssh aqui ainda
	ssh $user@$ip
}

#
function connect_telnet(){
	info=$(dialog --inputbox "Digite o ip a conectar" 10 25 --stdout)

	#realizar a conexao ssh aqui ainda
	telnet $info
}

#
function connect_ftp(){
	url=$(dialog --inputbox "Digite o endereço FTP a conectar" 10 25 --stdout)	

	#realizar a conexao ssh aqui ainda
	ftp $url
}

#
function install_packages(){
	#terminar de ver a lista que de programas que irão ser instalados
	apt-get install tcpdump
	apt-get install nmap
	apt-get install netstat
  apt-get install hping3
}

#
function watch_ips(){
	range=$(dialog --inputbox "Digite o endereço IP a varrer (pode ser uma range)" 10 25 --stdout)
	dialog --title "Aguarde..." --infobox "\nVarrendo a rede, o NMAP irá executar!" 5 35; sleep 3; clear	
	nmap -sP $range -T5 > "ips.txt"
	dialog --title "IPs do range buscado" --textbox ips.txt 20 100
	load_menu
}

function now(){
	echo $(date +%d/%m/%Y" - "%H:%M)
}

#chamada das funcoes que serao criadas acima
menu_principal
