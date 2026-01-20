#!/bin/bash

echo "🚀 Démarrage de l'installation Epitech Ultimate..."

# ----------------------------------------------------------------------
# 1. Epitech Dump & Système
# ----------------------------------------------------------------------
echo "🎓 [1/6] Installation des outils Epitech (Dump)..."
wget -O - "http://dumpscript.epitest.eu" | sudo bash -s

echo "🔄 [2/6] Mise à jour du système..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git wget build-essential

# ----------------------------------------------------------------------
# 2. Les Apps via SNAP (Spotify, Discord, VSCode, Teams)
# ----------------------------------------------------------------------
echo "📦 [3/6] Installation des logiciels via Snap..."

# VS Code (Classic pour avoir accès aux fichiers système)
sudo snap install code --classic

# Spotify
sudo snap install spotify

# Discord
sudo snap install discord

# Teams (Microsoft a tué l'app officielle, on utilise le client communautaire stable)
sudo snap install teams-for-linux

# ----------------------------------------------------------------------
# 3. Les Apps spécifiques (.deb / PPA)
# ----------------------------------------------------------------------
echo "🛠️ [4/6] Installation de Warp et OpenRGB..."

# --- WARP TERMINAL ---
if ! command -v warp-terminal &> /dev/null; then
    echo "  -> Téléchargement de Warp..."
    wget -O warp.deb "https://app.warp.dev/download?package=deb"
    echo "  -> Installation de Warp..."
    sudo apt install ./warp.deb -y
    rm warp.deb
else
    echo "  -> Warp est déjà installé."
fi

# --- OPENRGB ---
# On ajoute le PPA officiel pour avoir la dernière version (supporte plus de matériel)
if ! command -v openrgb &> /dev/null; then
    echo "  -> Ajout du repo OpenRGB..."
    sudo add-apt-repository ppa:thopiekar/openrgb -y
    sudo apt update
    echo "  -> Installation de OpenRGB..."
    sudo apt install openrgb -y
    
    # Installation des règles udev pour ne pas avoir besoin de lancer en sudo
    echo "  -> Configuration des droits USB pour OpenRGB..."
    wget https://openrgb.org/releases/release_0.9/60-openrgb.rules
    sudo mv 60-openrgb.rules /etc/udev/rules.d/
    sudo udevadm control --reload-rules && sudo udevadm trigger
else
    echo "  -> OpenRGB est déjà installé."
fi

# ----------------------------------------------------------------------
# 4. Dotfiles & Config
# ----------------------------------------------------------------------
echo "🔗 [5/6] Configuration des Dotfiles..."

# Suppression des vieux fichiers par défaut
rm -rf ~/.bashrc ~/.zshrc ~/.gitconfig

# Création des liens symboliques (adapte le chemin si besoin)
ln -sf ~/dotfiles/.bashrc ~/.bashrc
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig

# Fond d'écran
if [ -f "$HOME/dotfiles/wallpapers/background.jpg" ]; then
    gsettings set org.gnome.desktop.background picture-uri "file://$HOME/dotfiles/wallpapers/background.jpg"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/dotfiles/wallpapers/background.jpg"
fi

# ----------------------------------------------------------------------
# 5. Bonus : Extensions VS Code
# ----------------------------------------------------------------------
echo "🧩 [6/6] Installation des extensions VS Code..."
# Installe automatiquement les extensions vitales pour Epitech
code --install-extension ms-vscode.cpptools       # C/C++
code --install-extension epitest.epitech-c-cpp-headers # Header Epitech
code --install-extension pkief.material-icon-theme # Icônes jolies
# Ajoute ici d'autres extensions si tu veux (ex: github.copilot)

echo "✅ TERMINÉ ! Redémarre ta session pour que OpenRGB et les groupes fonctionnent."
