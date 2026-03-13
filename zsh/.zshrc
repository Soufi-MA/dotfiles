PROMPT='%F{4}%n%f %F{2}%~%f %F{1}%#%f '

source ~/.local/share/zsh/plugins/zsh-shift-select/zsh-shift-select.plugin.zsh

bindkey '^[[1;5C' forward-word          
bindkey '^[[1;5D' backward-word         
bindkey '^[[H' beginning-of-line        
bindkey '^[[F' end-of-line              

autoload -Uz compinit
compinit