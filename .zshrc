# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort name
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list ''
zstyle ':completion:*' max-errors 0
zstyle ':completion:*' menu select=long
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/home/cinque/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh/hist
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
unsetopt beep extendedglob nomatch notify
bindkey -v
# End of lines configured by zsh-newuser-install

#export PATH=$PATH:$HOME/.local/bin:$HOME/.local/bin/binary:$HOME/.config/emacs/bin
#export EDITOR=vim
#export QT_QPA_PLATFORMTHEME=qt5ct

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
#(cat ~/.cache/wallust/sequences &)

# Alternative (blocks terminal for 0-3ms)
# cat ~/.cache/wal/sequences

# To add support for TTYs this line can be optionally added.
# source ~/.cache/wal/colors-tty.sh

source $HOME/.zsh/zsh_alias.zsh

### lolcate related aliases
# query the music database
MUSIC_DB=Music
alias music='lolcate --db $MUSIC_DB --type audio'

play(){ mpv --playlist=<(music $1); }
play_shuf(){ mpv --playlist=<(music $1 | shuf); }
###

eval "$(starship init zsh)"
