set fish_greeting  # Clear greeting
set PATH $PATH /usr/local/go/bin $GOPATH/bin

# Some aliases
alias rm="rm -i"
alias cp="cp -i"

starship init fish | source
