export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '

# some more ls aliases
alias ll='ls -alF'
alias la='ls -la'
alias l='ls -CF'

# git aliases
# alias gl='git log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short --tags --color'
alias gl='git lg1'
alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias gco='git checkout '
alias gk='gitk --all&'
alias gx='gitx --all'
alias gf='git fetch'
alias gfr='git forest --all --sha | less -R'

alias logs='ssh ngs@logs.in.ngs.ru'
alias rlogs='ssh ngs@logs-realtime.in.ngs.ru'


alias urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])"'

alias urldecode_s='python -c "import sys, urllib as ul; [sys.stdout.write(ul.unquote_plus(l)) for l in sys.stdin]"'
alias urlencode_s='python -c "import sys, urllib as ul; [sys.stdout.write(ul.quote_plus(l)) for l in sys.stdin]"'

. ~/.bash_prompt.sh

# virtualenv wrapper
export WORKON_HOME=~/.pyenvs
mkdir -p $WORKON_HOME
source /usr/local/bin/virtualenvwrapper.sh

# golang
# export GOPATH=/Users/alexeysibirtsev/go
# export PATH=$PATH:/usr/local/go/bin


_pipenv_completion() {
    local IFS=$'\t'
    COMPREPLY=( $( env COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   _PIPENV_COMPLETE=complete-bash $1 ) )
    return 0
}

complete -F _pipenv_completion -o default pipenv

