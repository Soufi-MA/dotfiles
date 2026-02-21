PROMPT='%n %~ %# '

bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;2C' forward-char
bindkey '^[[1;2D' backward-char
bindkey '^[[1;2A' up-line-or-history
bindkey '^[[1;2B' down-line-or-history

autoload -Uz compinit
compinit
