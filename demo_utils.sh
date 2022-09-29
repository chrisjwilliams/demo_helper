# -------------------------------------------------------------------------
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#   Copyright Chris Williams 2018
# -------------------------------------------------------------------------

declare -i demo_prompt_count;
demo_prompt_count=0

function demo_prompt
{
    printf "demo> "
    ((demo_prompt_count++))
}

DEMO_HISTFILE=/tmp/demo_bash_history

# prints out a nice notice about the demo and how to use it
# example: demo_start "Awesome Demo"
function demo_start
{
    echo ================================================================================
    echo "  Welcome to the $1 demo."
    echo "    At the demo> prompt you can press:"
    echo "          q to quit"
    echo "          s to skip a command"
    echo "          Enter to execute a command at the prompt"
    echo "          Space or any other key to continue"
    echo ================================================================================
    demo_prompt_count=0
    if [[ -f "${DEMO_HISTFILE}" ]] ; then
        rm "${DEMO_HISTFILE}"
    fi
}

# await for user to press a key before continuing
#       pressing q will call exit
#       pressing s will return 1
#       pressing any other ket returns 0
# usage:
#    demo_keypress key_pressed
# where:
#    key_pressed: the variable to set with the value of the key pressed
#
demo_keypress()
{
    local __key_pressed=$1
    IFS= read -s -n 1 k <&1
    eval $__key_pressed="'$k'" # the this form allows us to preserve spaces
    if [[ $k = q ]] ; then
        printf "\nAborting demo\n"
        exit 0;
    elif [[ $k = s ]] ; then
        return 1;
    fi
    return 0;
}

# await for user to press a key before continuing
#       pressing q will exit
#       pressing enter will print a new demo prompt
#       any other key will continue
#       
function demo_pause()
{
    while true; do
        demo_keypress key
        if (( $?==1 )) ; then
            return 1
        fi

        if [[ $key = "" ]] ; then
            # Enter Key
            printf "\n"
            demo_prompt
        else
            break
        fi
    done
    return 0;
}

# print out command to be executed and pause
# execute the command when the user presses any key
# exceptions:
#       pressing q will exit
#       pressing s will skip
#
function demo_command()
{
    if (( $demo_prompt_count==0 )) ; then
        demo_prompt
        demo_pause
    fi
    printf "$1"
    demo_keypress key
    echo "$1" >> ${DEMO_HISTFILE}
    if (( $?==0 )) ; then
        printf "\n"
        eval "$1"
    else
        printf "skipping...\n"
    fi
    demo_prompt
}

# print out a message anouncing the end of the demo
# with an option to quit or launch a subshell (retaining the demo env)
#
demo_end()
{
    printf "\n"
    echo "------------------ end of demo -------------------------------------------------"
    echo "  Thanks for watching"
    echo ""
    echo " q to quit, any other key to continue in a shell"
    echo "--------------------------------------------------------------------------------"
    demo_pause

    # - launch a shell with the demo cmds in the history buffer
    sync
    HISTFILE=${DEMO_HISTFILE} PS1="demo> " /bin/bash
    if [[ -f "${DEMO_HISTFILE}" ]] ; then
        rm "${DEMO_HISTFILE}"
    fi
}
