



#This files et a double line prompt
BLACK="\[\033[0;30m\]"
RED="\[\033[0;31m\]"
GREEN="\[\033[0;32m\]"
BROWN="\[\033[0;33m\]"
BLUE="\[\033[0;34m\]"
PURPLE="\[\033[0;35m\]"
CYAN="\[\033[0;36m\]"
LIGHT_GREY="\[\033[0;37m\]"
GREY="\[\033[1;30m\]"
LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
YELLOW="\[\033[1;33m\]"
LIGHT_BLUE="\[\033[1;34m\]"
LIGHT_PURPLE="\[\033[1;35m\]"
LIGHT_CYAN="\[\033[1;36m\]"
WHITE="\[\033[1;37m\]"
NO_COLOUR="\[\033[0m\]"

hostnam=${HOSTNAME%%.*}
usernam=$(whoami)
#ERROR_CODE=""
temp="$(tty)"
#   Chop off the first five chars of tty (ie /dev/):
cur_tty="${temp:5}"

# Set Default color for each username and host
case $hostnam in
    pc-couturier)
       DEFAULT_HOST_COLOR=LIGHT_BLUE
       ;;
#    dev-clg)
#       DEFAULT_HOST_COLOR=GREEN
#       ;;
    *|dev-serveur)
       DEFAULT_HOST_COLOR=RED
       ;;
esac
case $usernam in
    root)
       DEFAULT_USERNAME_COLOR=RED
       ;;
    ccouturi)
       DEFAULT_USERNAME_COLOR=LIGHT_BLUE
       ;;
    *|dev-serveur)
       DEFAULT_USERNAME_COLOR=GREEN
       ;;
esac

# Set color with default or defined values
# these values may redifined in ~/.bashrc before including the current files
host_color=${host_color:=$DEFAULT_HOST_COLOR}
login_color=${login_color:=$DEFAULT_USERNAME_COLOR}
pwd_color=${pwd_color:=LIGHT_PURPLE}
time_color=${time_color:=BROWN}
sep_color=${sep_color:=CYAN}

#Defines colors
Pty_CL="$LIGHT_GREY"
Code_CL="$RED"
Seperateur_CL=$(eval echo \$$sep_color)
Login_CL=$(eval echo \$$login_color)
Host_CL=$(eval echo \$$host_color)
PWD_CL=$(eval echo \$$pwd_color)
Time_CL=$(eval echo \$$time_color)

unset temp
function prompt_command {
    local err=$?
    prompt_pwd=${PWD/${HOME}/\~}
    if [ $err -eq 0 ] ; then
        ERROR_CODE=""
    else
        ERROR_CODE="$err "
    fi
    #   Find the width of the prompt:
    TERMWIDTH=${COLUMNS}
    #   Add all the accessories below ...
    local temp="[${usernam}@${hostnam}:${cur_tty}]___[${prompt_pwd}]"
    let fillsize=${TERMWIDTH}-${#temp}
    if [ "$fillsize" -gt "0" ]; then
fill="__________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________"
        #   It's theoretically possible someone could need more
        #   dashes than above, but very unlikely! HOWTO users,
        #   the above should be ONE LINE, it may not cut and
        #   paste properly
        fill="${fill:0:${fillsize}}"
        newPWD="${prompt_pwd}"
    fi
    if [ "$fillsize" -lt "0" ]; then
        fill=""
        let cut=3-${fillsize}
        newPWD="...${prompt_pwd:${cut}}"
    fi
}
function print_error {
    printf "${ERROR_CODE}"
}
function twtty {

    case $TERM in
        xterm*|rxvt*)
            TITLEBAR='\[\033]0;\u@\h:\w\007\]'
            ;;
        *)
            TITLEBAR=""
            ;;
    esac
    #check for last command errort code and dispay it
    if [ "${usernam}" = "root" ]; then
        LOGIN_CL="\[\033[1;33m\]\[\033[1;41m\]"
    else
        LOGIN_CL="${Login_CL}"
    fi

    PS1="\
${Seperateur_CL}[\
${LOGIN_CL}\$usernam${NO_COLOUR}${Seperateur_CL}@${Host_CL}\$hostnam${Seperateur_CL}:${Pty_CL}\$cur_tty\
${Seperateur_CL}]__\${fill}_[\
${PWD_CL}\${newPWD}\
${Seperateur_CL}]\
\n\
${Seperateur_CL}[\
${Code_CL}\$(print_error)\
${Time_CL}\$(date \"+%a %d-%H:%M\")\
${Seperateur_CL}:${Pty_CL}\$${Seperateur_CL}]-\
$NO_COLOUR "
    PS2="$LIGHT_BLUE-$YELLOW-$YELLOW-$NO_COLOUR "
}

PROMPT_COMMAND=prompt_command
twtty
