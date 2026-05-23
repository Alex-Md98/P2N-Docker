#!/bin/bash

# --- DIRETÓRIO BASE DINÂMICO ---
# Descobre magicamente a pasta onde este script está salvo e entra nela.
# Isso torna o script 100% agnóstico (pode rodar de qualquer lugar do PC).
cd "$(dirname "$0")" || exit

# Cria o menu visual e guarda a escolha na variável 'acao'
acao=$(zenity --list \
    --title="Painel de Controle - Patent2Net" \
    --text="Selecione a ação desejada e clique em OK\n(ou clique em Cancelar para fechar):" \
    --radiolist \
    --column="Seleção" --column="Ação" \
    TRUE "Iniciar o Sistema" \
    FALSE "Parar o Sistema" \
    FALSE "Monitorar Processo (Avançado)")

# Se o usuário clicou no botão "Cancelar" ou fechou a janela no 'X' (Código 1), o script encerra sem fazer nada
if [ $? -ne 0 ]; then
    exit 0
fi

# Executa o comando correspondente à escolha
case $acao in
    "Iniciar o Sistema")
        zenity --info --title="Aguarde" --text="Ligando os contêineres do Patent2Net..." &
        docker compose up -d
        zenity --info --title="Sucesso" --text="Sistema online!\n\nVocê já pode abrir o navegador e acessar:\nhttp://localhost:5000"
        ;;
        
    "Parar o Sistema")
        zenity --info --title="Aguarde" --text="Desligando e salvando o estado do Patent2Net..." &
        docker compose down
        zenity --info --title="Sucesso" --text="O sistema foi encerrado com segurança."
        ;;
        
    "Monitorar Processo (Avançado)")
        # Abre o terminal padrão do Linux Mint e roda o log em tempo real (-f)
        x-terminal-emulator -e "bash -c 'echo \"[Monitor de Extração P2N]\"; echo \"Pressione Ctrl+C para sair desta tela.\"; echo \"-----------------------------------------------------\"; docker compose logs -f p2nv3; exec bash'"
        ;;
esac
