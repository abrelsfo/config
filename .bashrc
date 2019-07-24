#aliases for regular stuff
alias ff="cd ~/projects/HearsayLabs/fanmgmt"
alias cf="cd ~/projects/hearsay-content-feeds"
alias cfc="cd ~/projects/hearsay-content-feeds-client"
alias cs="cd ~/projects/hearsay-crawl-service"
alias ac="cd ~/projects/hearsay-assets-client"
alias c="clear"
alias notes="vi ~/notes"
alias restart_services="sudo service nginx restart && sudo service uwsgi2 restart"
alias ag='ag -p ~/.ignore'
alias color='python ~/colorize.py'
alias color2='python ~/color2.py'
alias fmlogs='ff && tail -f -n50 /var/log/fm/abrelsford.log |& color'
alias gen_ctags='ctags -R . --exclude=*.js'
alias nbk="vi ~/.notebook"

#git aliases
alias gg="git grep"
alias gist="git status"
alias checkout="git checkout"
alias fetch="git fetch upstream"
alias rebase="git rebase upstream/master"
alias fr="fetch && rebase"
alias status="git status"
alias branch="git branch"
alias add="git add ."
alias commit="git commit -m"
alias diff_commit="git diff --cached"
# add -- filename for single file
alias diff_stash0="git diff stash@{0}^1 stash@{0}"

#tmux shortcuts
alias tm="tmux"
alias ta="tmux a -t $1"
alias tnu="tmux new -s $1"
alias td="tmux a -t dev"
alias logs="tmux a -t logs"
alias tls="tmux ls"
alias tkill="tmux kill-session -t $1"
alias trename="tmux rename-session -t $1 $2"

# nvm
#export NVM_DIR="$HOME/.nvm"
#. "$(brew --prefix nvm)/nvm.sh"

#quickly edit and source bashrc
alias vimb="vim ~/.bashrc"
alias sb="source ~/.bashrc"

#tests
alias testv="PYTHONPATH=`pwd`/.. ../.virtualenv/bin/pytest $1 -x -s"
alias testc="PYTHONPATH=`pwd`/.. ../.virtualenv/bin/pytest $1 -x |& color"
              #
#function test#c() {
#  if [ $# -eq# 0 ]
#  then
#    echo "No arguments supplied"
#    exit 1
#  fi
#
#  testv |& color
#  #run test
#}

function testf() {
  if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit 1
  fi

  #turn directory into string
  #Replace / with .
  dc=`echo "$1" | sed 's/\//./g'`
  echo $dc

  if [ $# -eq 2 ]
  then
    echo 'Adding function'
    #Append function to string
  fi

  make test $dc
  #run test
}

# keep ssh auth the same
#setenv -g SSH_AUTH_SOCK $HOME/.ssh/ssh_auth_sock
#set-option -g update-environment “DISPLAY SSH_ASKPASS SSH_AUTH_SOCK SSH_AGENT_PID SSH_CONNECTION WINDOWID XAUTHORITY”

# Fix SSH auth socket location so agent forwarding works with tmux
# Predictable SSH authentication socket location.
SOCK="/tmp/ssh-agent-$USER-screen"
if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $SOCK ]
then
  ln -sf $SSH_AUTH_SOCK $SOCK
  export SSH_AUTH_SOCK=$SOCK
fi

#show current git branch
function current_git_branch {
  echo `git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/'`
}

function setup_dev() {
  tmux new-session -d -s 'asdf'
  tmux split-window -t asdf:1 -h
  tmux new-window -t asdf:2
  tmux send-keys -t asdf:2 'cd projects/HearsayLabs/fanmgmt' C-m
  tmux send-keys -t asdf:2 'make watch' C-m
  tmux split-window -t asdf:2 -h
  tmux send-keys -t asdf:2 'cd projects/HearsayLabs/fanmgmt' C-m
  tmux send-keys -t asdf:2 'make watch' C-m
  tmux select-window -t asdf
  echo 'Tmux session created'
}

fixssh() {
  for key in SSH_AUTH_SOCK SSH_CONNECTION SSH_CLIENT; do
    if (tmux show-environment | grep "^${key}" > /dev/null); then
      value=`tmux show-environment | grep "^${key}" | sed -e "s/^[A-Z_]*=//"`
      export ${key}="${value}"
    fi
  done
}
export -f testf
export -f current_git_branch
export -f setup_dev
export CLICOLOR=1

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
