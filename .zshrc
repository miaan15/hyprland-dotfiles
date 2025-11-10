export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"
export VISUAL="nvim"

plugins=(git fzf zsh-autosuggestions zsh-syntax-highlighting)

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

alias vim="nvim"
alias vi="nvim"

ZSH_THEME="candy"

source $ZSH/oh-my-zsh.sh

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

autoload -Uz add-zsh-hook
custom_prompt() {
  PROMPT='%F{green}%n@%m%f %F{blue}[%D{%H:%M:%S}]%f %~
%F{red}$ %f'
  RPROMPT=
}
add-zsh-hook precmd custom_prompt
