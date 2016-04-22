function rd {
  git branch > /dev/null 2>&1 || return 1
  cd "$(git rev-parse --show-cdup)"
}

function set_git_prompt {
  local last_commit_in_unix_time
  local now_in_unix_time
  local tmp_flags
  local flags
  local seconds_since_last_commit
  local minutes_since_last_commit
  local days_since_last_commit
  local minutes_so_far_today
  local branch
  local seconds_since_last_remote_check
  local svn_branch
  #last_commit_in_unix_time=$(git log "HEAD" --pretty=format:%ct 2> /dev/null | sort | tail -n1)
  last_commit_in_unix_time=""
  #now_in_unix_time=$(date +%s)
  #seconds_since_last_remote_check=$((now_in_unix_time - $BGP_LAST_REMOTE_CHECK))
  branch=$(git branch --no-color 2> /dev/null | grep '*' | sed 's/\*//g' | sed 's/ //g')
  svn_branch=$(svn info 2> /dev/null | grep "Repository Root" | awk -F / '{print $NF}')
  tmp_flags=$(git status --porcelain 2> /dev/null | cut -c1-2 | sed 's/ //g' | cut -c1 | sort | uniq)
  flags="$(echo $tmp_flags | sed 's/ //g')"
  # 不计算上次提交时间
  #if [ $last_commit_in_unix_time ]; then
  #  seconds_since_last_commit=$(($now_in_unix_time - $last_commit_in_unix_time))
  #  minutes_since_last_commit="$(($seconds_since_last_commit/60))"
  #  if ((minutes_since_last_commit < 60)); then
  #    minutes_since_last_commit="\[\e[0;32m\]${minutes_since_last_commit}m\[\e[0m\]|"
  #  elif ((minutes_since_last_commit < 120)); then
  #    minutes_since_last_commit="\[\e[0;33m\]${minutes_since_last_commit}m\[\e[0m\]|"
  #  elif ((minutes_since_last_commit < 1440)); then
  #    minutes_since_last_commit="\[\e[0;31m\]${minutes_since_last_commit}m\[\e[0m\]|"
  #  else
  #    days_since_last_commit=$(($minutes_since_last_commit/1440))
  #    minutes_so_far_today=$(($minutes_since_last_commit - $days_since_last_commit*1440))
  #    minutes_since_last_commit="\[\e[0;31m\]${days_since_last_commit}d \[\e[0;31m\]${minutes_so_far_today}m\[\e[0m\]|"
  #  fi
  #else
  #  minutes_since_last_commit=""
  #fi
  #'
  if [ $branch ] || [ $flags  ] || [ $svn_branch  ]; then
    #
    #if [[ "$BGP_GIT_ROOT_DIRECTORY" != $(git rev-parse --show-toplevel 2> /dev/null) ]]; then
    #  BGP_GIT_ROOT_DIRECTORY=$(git rev-parse --show-toplevel 2> /dev/null)
    #  BGP_LAST_REMOTE_CHECK=$((`date +%s` - 300))
    #  BGP_GIT_BRANCH=""
    #  BGP_GIT_REMOTE=""
    #  BGP_GIT_REMOTE_STATUS=""
    #fi
    #if [[ -e "$BGP_TMP_FILE" ]]; then
    #    source "$BGP_TMP_FILE"
    #    rm $BGP_TMP_FILE
    #fi
    # If shell function git_remote_check does not exist then skip remote check
    #if [[ "" != "$(type git_remote_check 2>/dev/null)" ]]; then
    #  if ((seconds_since_last_remote_check > 60)); then
    #    BGP_LAST_REMOTE_CHECK=$(date +%s)
    #    set +m
    #    git_remote_check &
    #  fi
    #fi
    
    if [ $branch ]; then
      branch="\[\e[1;31m\]GIT:${branch}\[\e[0m\]"
    else
      if [ $svn_branch ]; then
        branch="\[\e[1;31m\]SVN:${svn_branch}\[\e[0m\]"
      else
        branch="\[\e[1;31m\]^_^\[\e[0m\]"
      fi
    fi
    if [ $flags ]; then
      PS1="${BGP_ORIGINAL_PS1/\\$ /}[${minutes_since_last_commit}${branch}\[\e[0m\]]$BGP_GIT_REMOTE_STATUS\$ "
    else
      PS1="${BGP_ORIGINAL_PS1/\\$ /}[${minutes_since_last_commit}${branch}]$BGP_GIT_REMOTE_STATUS\$ "
    fi
  else
    PS1=$BGP_ORIGINAL_PS1
  fi
}

BGP_LAST_REMOTE_CHECK=$((`date +%s` - 300))
BGP_GIT_ROOT_DIRECTORY=""
BGP_TMP_FILE="/tmp/BGP_$BASHPID"
export BGP_TMP_FILE

BGP_ORIGINAL_PS1=$PS1
PROMPT_COMMAND=set_git_prompt
