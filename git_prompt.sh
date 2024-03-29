#PS1='\[\033]0;$TITLEPREFIX:${PWD//[^[:ascii:]]/?}\007\]' # set window title
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[01;35m\]@\[\033[00m\]\[\033[01;33m\]\h\[\033[00m\]\[\033[34m\]:\[\033[01;34m\]\w\[\033[32m\]\$\[\033[00m\]'
START="\[\e[01;37m\]["
END="\[\e[01;37m\]]"
ARROW="\[\e[01;32m\]➜ "
USR_HOST="\[\033[01;35m\]\u\[\033[01;35m\]@\[\033[00m\]\[\033[01;35m\]\h\[\033[00m\]"
YOUNG="\[\e[01;33m\]R03602 \[\033[00m\]"
USR="\[\e[01;32m\][\u]\[\e[01;35m\]"

PS1="$START"'\[\033]0;${PWD//[^[:ascii:]]/?}\007\]'
#显示用户名及主机
PS1="$PS1$USR_HOST$END "

#显示箭头
PS1="$ARROW$PS1"

# 显示工号
#PS1="$PS1$YOUNG"

#PS1="$PS1"'\[\033[01;35m\] ^___^ '                     # new line

PS1="$PS1"'\[\033[01;32m\]'         # change to green        32 green
#显示日期
#PS1="$PS1"'$(date +"%Y-%m-%d") '                   # time

#显示时间
#PS1="$PS1"'\[\033[01;36m\]\t'                       #37 white
PS1="$PS1"''
#PS1="$PS1"'\[\033[01;33m\]'        # change to purple
#PS1="$PS1"'\h'                     # show MSYSTEM
PS1="$PS1"'\[\033[01;34m\]'         # change to brownish yellow
PS1="$PS1"'\w \$ '                     # current working directory
PS1="$PS1"'\[\033[0m\]'             # change color
#PS1="$PS1"'\n'                     # new line
#PS1="$PS1"'$ '                     # prompt: always $

function rd {
  git branch > /dev/null 2>&1 || return 1
  cd "$(git rev-parse --show-cdup)"
}

function set_git_prompt {
    local branch
    local svn_branch

    branch=$(git branch --no-color 2> /dev/null | grep '*' | sed 's/\*//g' | sed 's/ //g' | sed 's/(//g' | sed 's/)//g' | awk -F / '{print $NF}')
    svn_branch=$(svn info 2> /dev/null | grep "Repository Root" | awk -F / '{print $NF}')

    if [ $branch ] || [ $svn_branch  ]; then
        if [ $branch ]; then
            branch="\[\e[1;31m\]${branch}\[\e[0m\]"
        else
            if [ $svn_branch ]; then
                svn_branch=`echo ${svn_branch} | tr '[A-Z]' '[a-z]'`
                branch="\[\e[1;35m\]${svn_branch}\[\e[0m\]"
            else
                branch="\[\e[1;31m\]^_^\[\e[0m\]"
            fi
        fi
        PS1="${BGP_ORIGINAL_PS1/\\$ /}<${branch}\[\e[0m\]>$BGP_GIT_REMOTE_STATUS \$ "
    else
        PS1=$BGP_ORIGINAL_PS1
        #不要换行
        #PS1="${BGP_ORIGINAL_PS1/\\$ /}\n\$ "
    fi
}

function set_git_prompt_new {
    if [ -f "./.git/HEAD" ]; then 
        branch=`cat ./.git/HEAD 2>/dev/null | awk -F '/' '{print $NF}'`
        if [ -n "${branch}" ]; then
            branch="\[\e[1;31m\]${branch}\[\e[0m\]"
        else
            branch="\[\e[1;31m\]^_^\[\e[0m\]"
        fi
        PS1="${BGP_ORIGINAL_PS1/\\$ /}<${branch}\[\e[0m\]>$BGP_GIT_REMOTE_STATUS \$ "
    else
        PS1=$BGP_ORIGINAL_PS1
    fi    
}

BGP_ORIGINAL_PS1=$PS1
PROMPT_COMMAND=set_git_prompt
