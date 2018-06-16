# Source-install

Esse script configura repositórios para a versão **estável** do debian, ele usa dialog para mostrar caixas de diálogo e também um checklist para escolha dos repositórios, ele precisa ser executado como root para poder alterar o arquivo sources.list, e quando executado ele vai criar um backup do sources.list atual configurado na maquina, no diretório /etc/apt, nesse formato "sources.list23899.bak". 
Para usá-lo e se mover pelas opções, você pode usar "TAB" os direcionais do teclado, e espaços para marcar as opções, ou se preferir, pode usar o mouse e clicar nas opções. 

#### Obrigado ao Ricardo Lobo pelo testes realizados 
Conheça o https://linuxdicasesuporte.blogspot.com


## Instalação

* **Atenção** Esse script só dever ser usado na versão estável Debian Stretch. 

```
wget https://bit.ly/2HNn6Ut -O sources_install_1.0-1_all.deb
``` 

Logue-se como root:

```
dpkg -i sources_install_1.0-1_all.deb; apt install -f -y
```
## Uso 

```
sources-install
```
## Vídeo de demostração:
https://asciinema.org/a/OLj5Vj7gJdh8o1sBExKuOSdeD
