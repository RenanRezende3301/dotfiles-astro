#!/bin/bash

# --- Script de Instalação Completa do Ambiente ---

echo "Iniciando a configuração do ambiente..."
BASEDIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# --- 1. INSTALAÇÃO DE PACOTES ---
echo "Instalando pacotes essenciais via Pacman..."
sudo pacman -S --noconfirm git fastfetch imagemagick chafa ttf-jetbrains-mono-nerd kvantum

echo "Verificando e instalando Yay (para pacotes do AUR)..."
if ! command -v yay &> /dev/null
then
    echo "Yay não encontrado. Instalando..."
    sudo pacman -S --needed --noconfirm base-devel
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
else
    echo "Yay já está instalado."
fi

echo "Instalando pacotes do AUR com Yay..."
yay -S --noconfirm oh-my-posh-bin

# --- 2. INSTALAÇÃO DO TEMA DRACULA (MODIFICADO) ---
echo "Instalando o tema 'Dracula' para o KDE..."
if [ -d "/tmp/dracula-kde" ]; then
    rm -rf /tmp/dracula-kde
fi
git clone https://github.com/dracula/kde.git /tmp/dracula-kde
# Criando todas as pastas necessárias para temas do Plasma
mkdir -p ~/.local/share/aurorae/themes/ ~/.local/share/color-schemes/ ~/.local/share/plasma/desktoptheme/ ~/.local/share/plasma/look-and-feel/
# O tema Dracula tem uma estrutura de pastas um pouco diferente, vamos copiar corretamente
cp -r /tmp/dracula-kde/aurorae/* ~/.local/share/aurorae/themes/
cp -r /tmp/dracula-kde/color-schemes/* ~/.local/share/color-schemes/
cp -r /tmp/dracula-kde/plasma/* ~/.local/share/plasma/desktoptheme/
cp -r /tmp/dracula-kde/look-and-feel/* ~/.local/share/plasma/look-and-feel/
# O tema Dracula também vem com temas para Kvantum e Konsole, vamos aproveitar!
cp -r /tmp/dracula-kde/Kvantum/* ~/.config/Kvantum/
cp -r /tmp/dracula-kde/konsole/* ~/.local/share/konsole/
echo "Tema 'Dracula' instalado."

# --- 3. CRIAÇÃO DOS LINKS SIMBÓLICOS (A MÁGICA) ---
echo "Criando links simbólicos para os arquivos de configuração..."

# Terminal e Bash
ln -sfv "$BASEDIR/.bashrc" ~
ln -sfv "$BASEDIR/.local/share/konsole" ~/.local/share/
ln -sfv "$BASEDIR/.config/fastfetch" ~/.config/

# KDE e Kvantum
ln -sfv "$BASEDIR/.config/Kvantum" ~/.config/
ln -sfv "$BASEDIR/.config/kdeglobals" ~/.config/
ln -sfv "$BASEDIR/.config/kwinrc" ~/.config/

# --- 4. COPIANDO AS IMAGENS ---
echo "Copiando imagens de personalização..."
mkdir -p ~/Imagens/Fotos_terminal
cp -v "$BASEDIR/imagens/astolfo.png" ~/Imagens/Fotos_terminal/

# --- FINALIZAÇÃO ---
echo ""
echo "-----------------------------------------------------------"
echo "  Configuração completa do ambiente!"
echo "  Por favor, FAÇA LOGOUT E LOGIN NOVAMENTE para que"
echo "  todas as alterações visuais do KDE sejam aplicadas."
echo ""
echo "  Se o tema não carregar 100%, vá em"
echo "  'Configurações do Sistema > Aparência > Temas Globais'"
echo "  e selecione 'Dracula' e aplique."
echo "-----------------------------------------------------------"
