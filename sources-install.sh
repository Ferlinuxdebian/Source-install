#!/bin/bash

#Variáveis:
#Variável para despejar STDOUT em /etc/apt/sources.list
ESPELHOS=/etc/apt/sources.list

# Função de inicio do script para informar o usuário
# sobre questões importantes, antes de configurar os
# repositório.
function importante ()
{
dialog                                     \
--title '##IMPORTANTE LEIA##'              \
--msgbox '
O script inicia por padrão é configurado
com os repositórios "Main" "Segurity" e
"Updates" que é o mínimo que você deve ter
Porém se você é usuário de "desktop" e
iniciante no debian, para uma experiência
melhor é recomendado marcar todas as
opções. Leia mais sobre como configurar o
arquivo sources.list nesse link abaixo
ttps://bit.ly/2sT2vJM'                      \
0 0

# Se pressionado tecla ESC o programa saí.
(( $? == 255 )) && exit 1

#Chama a função addsources
addsources
}

# Função que chama o checklist dialog para escolha de repositórios.
function addsources ()
{
# Conteúdo gerado pelo dialog é expandido para variável "sources",
# que vai conter o conteúdo escolhido.
sources=$( dialog --stdout			           \
		--title 'Seleção de espelhos APT'          \
		--separate-output			   \
		--checklist 'Adicionar repositórios' 0 0 0 \
		Main 	          'Recomendado' on	   \ 
		Segurity          'Recomendado' on 	   \
		Updates           'Recomendado' on   	   \
		Proposed-updates  'Opcional'    off        \
		Stretch-backports 'Opcional'    off        \
		Non-free	  'Opcional'    off)

# Pressionar cancelar, saí do script.
(( $? == 1)) && exit 1

# adiciona contrib e non-free no espelho, se a opção non-free
# estiver marcada.
echo $sources | grep -q 'Non-free' && NONFREE=non-free CONTRIB=contrib

# O conteúdo de sources, vai ser processado pelo while, linha por linha e -
# em combinação com o case, será chamada uma função que adicionará o repositório escolhido.
 echo "$sources" | while read escolha
 do
  case "$escolha" in
  Main)
  SECTION=Main
  RELEASE_LINK="stretch main"
  main-install
  ;;
  Segurity)
  SECTION=Segurity
  segurity-install
  ;;
  Updates)
  SECTION=Updates
  RELEASE_LINK="stretch-updates main"
  main-install
  ;;
  Proposed-updates)
  COMENTARIO='#'
  SECTION=Proposed-updates
  RELEASE_LINK="stretch-proposed-update main"
  main-install
  ;;
  Stretch-backports)
  COMENTARIO=''
  SECTION=Backports
  RELEASE_LINK="stretch-backports main"
  main-install
  ;;
  esac
done

# Após o fim do loop, as mesagens apareceram e haverá
# a atualização dos repositórios.
dialog                                                                \
   --title 'Aguarde...'                                               \
   --infobox '\nAtualizando os metadados dos pacotes(apt update)...'  \
   0 0

   apt update &>/dev/null

dialog                                               \
   --title 'Finalizado'                              \
   --infobox '\nRepositório configurado e atualizado'\
   0 0
}

# Função que adiciona o repositórios
function main-install ()
{
echo "
### -----------------------------
###Repositório (stretch) $SECTION ###
### -----------------------------
${COMENTARIO}deb http://deb.debian.org/debian/ $RELEASE_LINK $CONTRIB $NONFREE
#deb-src http://deb.debian.org/debian/ $RELEASE_LINK $CONTRIB $NONFREE" >> $ESPELHOS
}

# Função para adicionar o repositório de segurança.
function segurity-install ()
{
echo "
### -----------------------------
###Repositório (stretch) $SECTION ###
### -----------------------------
deb http://deb.debian.org/debian-security/ stretch/updates main $CONTRIB $NONFREE
#deb-src http://deb.debian.org/debian-security/ stretch/updates main $CONTRIB $NONFREE" >> $ESPELHOS
}

# Verifica se o script roda como root, se for
# faz o backup do sources.list da maquina e
# Limpa o arquivo sources.list
[ $(id -u) = 0 ] && \
cp $ESPELHOS $ESPELHOS${$}.bak
ALTERA="> $ESPELHOS"
eval $ALTERA
importante || \        
# mostra dialógo que o user não é root.
	{
		dialog			                    \
		--title "Sem permissões"                    \
		--msgbox "Você precisa logar-se como root." \
		5 40
		clear
		exit 25
	} 1>&2 # Como isso é um aviso de falta de permissões, vai para STDERR.
