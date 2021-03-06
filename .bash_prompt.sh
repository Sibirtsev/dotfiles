#!/bin/bash

# The various escape codes that we can use to color our prompt.
        RED="\[\033[0;31m\]"
     YELLOW="\[\033[1;33m\]"
YELLOW_DARK="\[\033[0;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[1;34m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_VENV="\[\033[0;46;37m\]"
 COLOR_USER="\[\033[0;47;32m\]"
 COLOR_AT="\[\033[0;47;95m\]"
 COLOR_IP="\[\033[0;47;36m\]"
 COLOR_PATH="\[\033[5;47;34m\]"
 COLOR_BRANCH_GREEN="\[\033[7;100;32m\]"
 COLOR_BRANCH_YELLOW="\[\033[7;100;33m\]"
 COLOR_BRANCH_RED="\[\033[7;47;91m\]"
 COLOR_NONE="\[\e[0m\]"

# Detect whether the current directory is a git repository.
function is_git_repository {
  git branch > /dev/null 2>&1
}

# Determine the branch/state information for this git repository.
function set_git_branch {
  # Capture the output of the "git status" command.
  git_status="$(git status 2> /dev/null)"

  # Set color based on clean/staged/dirty.
  if [[ ${git_status} =~ "othing to commit" ]]; then
    state="${COLOR_BRANCH_GREEN}"
  elif [[ ${git_status} =~ "hanges to be committed" ]]; then
    state="${COLOR_BRANCH_YELLOW}"
  else
    state="${COLOR_BRANCH_RED}"
  fi

  # Set arrow icon based on status against remote.
  remote_pattern="Your branch is (.*)"
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
      remote="↑"
    elif [[ ${BASH_REMATCH[1]} == "behind" ]]; then
      remote="↓"
    else 
      remote=""
    fi
  else
    remote=""
  fi
  diverge_pattern="Your branch and (.*) have diverged"
  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="↕"
  fi

  # Get the name of the branch.
  branch_pattern="^On branch ([^${IFS}]*)"
  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${BASH_REMATCH[1]}
  fi

  # Set the final branch string.
  BRANCH="${state}(${branch})${remote}${COLOR_NONE} "
}

# Return the prompt symbol to use, colorized based on the return value of the
# previous command.
function set_prompt_symbol () {
  if test $1 -eq 0 ; then
      PROMPT_SYMBOL="\$"
  else
      PROMPT_SYMBOL="${LIGHT_RED}\$${COLOR_NONE}"
  fi
}

# Determine active Python virtualenv details.
function set_virtualenv () {
  if test -z "$VIRTUAL_ENV" ; then
      PYTHON_VIRTUALENV=""
  else
      PYTHON_VIRTUALENV="${COLOR_VENV}[`basename \"$VIRTUAL_ENV\"`]${COLOR_NONE} "
  fi
}

function set_ip () {
  THEIP=$(ifconfig | grep "inet " | grep -v 127.0.0. | awk '{print $2}' | sed -n -e 'H;${x;s/\n/,/g;s/^,//;p;}')
}

# Set the full bash prompt.
function set_bash_prompt () {
  # Set the PROMPT_SYMBOL variable. We do this first so we don't lose the
  # return value of the last command.
  set_prompt_symbol $?

  # Set the PYTHON_VIRTUALENV variable.
  set_virtualenv

  set_ip

  # Set the BRANCH variable.
  if is_git_repository ; then
    set_git_branch
  else
    BRANCH=''
  fi

  # Set the bash prompt variable.
  PS1="
${PYTHON_VIRTUALENV}${COLOR_USER}\u${COLOR_AT}@${COLOR_IP}${THEIP}:${COLOR_PATH}\w ${COLOR_NONE}${BRANCH}
${PROMPT_SYMBOL} "
}

# Tell bash to execute this function just before displaying its prompt.
PROMPT_COMMAND=set_bash_prompt
