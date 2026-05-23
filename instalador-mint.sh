#!/bin/bash

# --- DIRETÓRIO BASE DINÂMICO ---
# Descobre o caminho absoluto exato de onde esta pasta foi extraída
DIR_ATUAL="$(cd "$(dirname "$0")" && pwd)"

# Garante que o script do painel principal tenha permissão para rodar
if [ -f "$DIR_ATUAL/painel_p2n.sh" ]; then
    chmod +x "$DIR_ATUAL/painel_p2n.sh"
else
    zenity --error --title="Erro de Instalação" --text="O arquivo 'painel_p2n.sh' não foi encontrado na pasta.\nCertifique-se de que o instalador está na mesma pasta do projeto."
    exit 1
fi

# --- O NOVO PASSO: DOWNLOAD VISUAL DOS CONTÊINERES ---
zenity --question --title="Download de Componentes" \
    --text="Deseja baixar os componentes principais do sistema agora?\n\nIsso pode levar vários minutos dependendo da sua internet, mas garantirá que o Patent2Net inicie instantaneamente no dia a dia.\n\n(Recomendado: Clique em Sim)"

# Se o usuário clicar em Sim (código 0)
if [ $? -eq 0 ]; then
    # Abre um terminal visível, faz o download (pull) e só fecha quando o usuário der ENTER
    x-terminal-emulator -e "bash -c 'echo \"[Instalador Patent2Net]\"; echo \"Baixando os contêineres oficiais... Isso pode demorar um pouco.\"; echo \"Por favor, não feche esta janela.\"; echo \"--------------------------------------------------------------\"; cd \"$DIR_ATUAL\" && docker compose pull; echo \"\"; echo \"--------------------------------------------------------------\"; echo \"Download concluído com sucesso!\"; echo \"Pressione ENTER para continuar a instalação...\"; read'"
fi
# ------------------------------------------------------

# Define o conteúdo mágico do atalho (.desktop)
DESKTOP_FILE_CONTENT="[Desktop Entry]
Version=1.0
Name=Patent2Net
Comment=Motor de Extração e Análise (NIT Materiais)
Exec=$DIR_ATUAL/painel_p2n.sh
Icon=$DIR_ATUAL/icone.png
Terminal=false
Type=Application
Categories=Education;Science;"

# Descobre o caminho correto da Área de Trabalho (funciona em PT-BR ou EN)
DESKTOP_DIR=$(xdg-user-dir DESKTOP)
# Caminho padrão do Menu Iniciar do Linux
MENU_DIR="$HOME/.local/share/applications"

# 1. Instala no Menu Iniciar
mkdir -p "$MENU_DIR"
echo "$DESKTOP_FILE_CONTENT" > "$MENU_DIR/Patent2Net.desktop"
chmod +x "$MENU_DIR/Patent2Net.desktop"

# 2. Instala na Área de Trabalho
if [ -d "$DESKTOP_DIR" ]; then
    echo "$DESKTOP_FILE_CONTENT" > "$DESKTOP_DIR/Patent2Net.desktop"
    chmod +x "$DESKTOP_DIR/Patent2Net.desktop" # Evita aviso de atalho "não confiável" no Mint
fi

# Mensagem de Sucesso Visual
zenity --info --title="Instalação Concluída" \
    --text="Os atalhos do Patent2Net foram configurados com sucesso!\n\nVocê já pode iniciar o sistema através do <b>Menu Iniciar</b> (na categoria Educação) ou dando um duplo clique no <b>ícone da sua Área de Trabalho</b>."
