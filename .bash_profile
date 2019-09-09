# Source settings from .bashrc first
if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

# Avoid duplicates
export HISTCONTROL=ignoreboth:erasedups
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=-1
HISTFILESIZE=-1

# After each command, append to the history file and reread it
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# User specific environment
export GOPATH=/home/alex/Development/Code/Go
export PATH=$PATH:/home/alex/bin:/home/alex/Development:/usr/local/go/bin:$GOPATH/bin:/opt/linaro/gcc-linaro-arm-linux-gnueabihf-4.8-2013.04-20130417_linux/bin/:/opt/CodeSourcery/arm-2013.05/bin:/home/alex/.local/bin

# alias's
alias ls="ls -hF --color"
alias ll="ls -l --group-directories-first"
alias lt='ls -ltr'                         # sort by date, most recent last
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

#--------------------
# File and string related functions
#--------------------

# Find a file with a pattern in name:
function ff() { find . -type f -iname '*'$*'*' -ls ; }

# Find a file with pattern $1 in name and Execute $2 on it:
function fe()
{ find . -type f -iname '*'${1:-}'*' -exec ${2:-file} {} \;  ; }

# Find files with a pattern in name and do a grep on them. Only print the file name
function fg()
{
  find . -type f -name "${2:-*}" -exec grep -q "${1:-}" '{}' \; -print | more
}

# Find all files and do a grep on them. Only print the file name
function fgall()
{
  find . -type f -exec grep -q ${1:-file} '{}' \; -print | more
}

# Find a pattern in a set of files and highlight them:
# (needs a recent version of egrep)
function fstr()
{
    OPTIND=1
    local case=""
    local word=""
    local ignore=""
    local usage="fstr: find string in files.
Usage: fstr [-i][-w][-I][-f] \"pattern\" [\"filename pattern\"]
where -i is case-insensitive and -w is whole word match
-I ignores the specified directory"
    while getopts :iwI: opt
    do
        case "$opt" in
        i) case="-i " ;;
        w) word="-w " ;;
        I) ignore="$OPTARG" ;;
        *) echo "$usage"; return;;
        esac
    done
    shift $(( $OPTIND - 1 ))
    if [ "$#" -lt 1 ]; then
        echo "$usage"
        return;
    fi
    if [ "$ignore" = ""  ]; then
        find . -type f -name "${2:-*}" -print0 | \
        xargs -0 egrep --color=always -sn ${case} ${word} "$1" 2>&- | less -R;
    else
        find . -path "$ignore" -prune -o -type f -name "${2:-*}" -print0 | \
        xargs -0 egrep --color=always -sn ${case} ${word} "$1" 2>&- | less -R;
    fi
}

function extract()      # Handy Extract Program.
{
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xvjf $1     ;;
             *.tar.gz)    tar xvzf $1     ;;
             *.bz2)       bunzip2 $1      ;;
             *.rar)       unrar x $1      ;;
             *.gz)        gunzip $1       ;;
             *.tar)       tar xvf $1      ;;
             *.tbz2)      tar xvjf $1     ;;
             *.tgz)       tar xvzf $1     ;;
             *.zip)       unzip $1        ;;
             *.Z)         uncompress $1   ;;
             *.7z)        7z x $1         ;;
             *)           echo "'$1' cannot be extracted via >extract<" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

export PATH="$HOME/.cargo/bin:$PATH"
