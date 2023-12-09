# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=2000
SAVEHIST=5000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/banzade/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Define color for LS
alias ls='ls --color'

# Enable VI mode
bindkey -v

# Customizing Vi mode cursor
function zle-keymap-select {
  if [[ $KEYMAP == 'vicmd' ]]; then
    echo -ne '\e[2 q'  # Set the cursor to a block in normal mode
  else
    echo -ne '\e[6 q'  # Set the cursor to a line in insert mode
  fi
}

# Set block cursor on each new prompt
function zle-line-init {
  echo -ne '\e[2 q'  # Set the cursor to a block
}
zle -N zle-keymap-select
# Initialize cursor shape
zle-keymap-select