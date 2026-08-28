alias ll="ls -alh"
alias ..="cd .."
alias jfu="journalctl -f -u"
alias ssr="sudo systemctl restart"
alias gac="git add . && git commit -m"

eval "$(mise activate zsh)"
eval "$(starship init zsh)"
eval "$(atuin init zsh)"
eval "$(direnv hook zsh)"

alias nhx='nix develop --command hx'
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/.npm-global/bin
export EDITOR=hx
export VISUAL=hx
