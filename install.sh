#!/bin/bash

# 1. Mise à jour du système (classique)
echo "Mise à jour du système..."
sudo apt update && sudo apt upgrade -y

# 2. Installation des outils vitaux pour Epitech
echo "Installation des outils..."
sudo apt install -y git gcc make valgrind curl zsh terminator code

# 3. Création des liens symboliques (C'est ça qui restaure tes configs)
echo "Restauration des configurations..."

# On supprime les fichiers par défaut s'ils existent et on crée le lien
rm -rf ~/.bashrc
ln -sf ~/dotfiles/.bashrc ~/.bashrc

rm -rf ~/.zshrc
ln -sf ~/dotfiles/.zshrc ~/.zshrc

rm -rf ~/.gitconfig
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig

# 4. Configuration du fond d'écran (Gnome/Ubuntu)
echo "Mise en place du fond d'écran..."
gsettings set org.gnome.desktop.background picture-uri "file://$HOME/dotfiles/wallpapers/background.jpg"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/dotfiles/wallpapers/background.jpg"

# 5. Installation de Oh My Zsh (Optionnel mais probable)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "Installation terminée ! Redémarre ton terminal."
