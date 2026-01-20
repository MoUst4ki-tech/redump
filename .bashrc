# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
# Fonction pour lancer l'environnement OSINT complet (4 Fenêtres)
osint() {
    SESSION="enquete"

    # Vérifie si la session existe déjà
    tmux has-session -t $SESSION 2>/dev/null

    if [ $? != 0 ]; then
        # --- FENÊTRE 1 : DaProfiler ---
        tmux new-session -d -s $SESSION -n 'DaProfiler'
        tmux send-keys -t $SESSION:0 "cd ~/Daprofiler" C-m
        tmux send-keys -t $SESSION:0 "source venv/bin/activate" C-m
        tmux send-keys -t $SESSION:0 "clear" C-m
        tmux send-keys -t $SESSION:0 "echo '👻 DaProfiler est prêt'" C-m
        tmux send-keys -t $SESSION:0 "echo '👉 Python : python profiler.py -n Prénom -ln Nom'" C-m

        # --- FENÊTRE 2 : Sherlock ---
        tmux new-window -t $SESSION -n 'Sherlock'
        tmux send-keys -t $SESSION:1 "cd ~/sherlock" C-m
        tmux send-keys -t $SESSION:1 "source venv/bin/activate" C-m
        tmux send-keys -t $SESSION:1 "clear" C-m
        tmux send-keys -t $SESSION:1 "echo '🔍 Sherlock est prêt'" C-m
        # Commande corrigée pour éviter le bug "command not found"
        tmux send-keys -t $SESSION:1 "echo '👉 Python : python3 -m sherlock_project pseudo'" C-m

        # --- FENÊTRE 3 : Ignorant ---
        tmux new-window -t $SESSION -n 'Ignorant'
        tmux send-keys -t $SESSION:2 "cd ~" C-m
        # Active le venv à la racine s'il existe
        tmux send-keys -t $SESSION:2 "source venv/bin/activate 2>/dev/null" C-m
        tmux send-keys -t $SESSION:2 "clear" C-m
        tmux send-keys -t $SESSION:2 "echo '📱 Ignorant est prêt'" C-m
        tmux send-keys -t $SESSION:2 "echo '👉 Commande : ignorant +33612345678'" C-m

        # --- FENÊTRE 4 : Labo Analyse (Email & Media) ---
        tmux new-window -t $SESSION -n 'Analyse'
        tmux send-keys -t $SESSION:3 "cd ~/osint_tools" C-m
        tmux send-keys -t $SESSION:3 "source venv/bin/activate" C-m
        tmux send-keys -t $SESSION:3 "clear" C-m
        tmux send-keys -t $SESSION:3 "echo '🧪 Labo d Analyse Prêt !'" C-m
        tmux send-keys -t $SESSION:3 "echo '-----------------------------------'" C-m
        tmux send-keys -t $SESSION:3 "echo '📧 Email (Sites)  : holehe email@gmail.com'" C-m
        tmux send-keys -t $SESSION:3 "echo '📧 Email (Google) : ghunt email adresse@gmail.com'" C-m
        tmux send-keys -t $SESSION:3 "echo '📸 Insta Scraper  : instaloader profile_name'" C-m
        tmux send-keys -t $SESSION:3 "echo '🖼️ Photo Analysis : exiftool image.jpg'" C-m

        # Retourne sur la première fenêtre pour commencer
        tmux select-window -t $SESSION:0
    fi

    # Attache la session pour l'afficher
    tmux attach-session -t $SESSION
}
alias connect_serv="ssh -p 22222 moustaki@88.120.221.133"
export GEMINI_API_KEY="AIzaSyCjEb_1bWr-z2VSivuy96VDrLFPXRTaZIo"
alias gemini='python3 ~/.gemini_chat.py'
alias connect_fedora="ssh-keygen -f \"/home/$USER/.ssh/known_hosts\" -R \"[127.0.0.1]:4242\" && ssh -p 4242 -i id_rsa pierre@127.0.0.1"
alias connect_arch="ssh-keygen -f \"/home/$USER/.ssh/known_hosts\" -R \"[127.0.0.1]:4242\" && ssh -p 4242 -i id_rsa pierre@127.0.0.1"
alias connect_marchal-pc="ssh marchal@192.168.1.124"
