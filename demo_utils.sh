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
    echo -n "demo> "
    ((demo_prompt_count++))
}

# prints out a nice notice about the demo and how to use it
# example: demo_start "Awesome Demo"
function demo_start
{
    echo ================================================================================ 
    echo "  Welcome to the $1 demo."
    echo "    At the demo> prompt you can press:"
    echo "          q to quit"
    echo "          s to skip a command"
    echo "          or any other key to continue."
    echo ================================================================================ 
    demo_prompt_count=0
}

# await for user to press a key before continuing
#       pressing q will exit
#       any other key will continue
function demo_pause
{
    read -s -n 1 k <&1
    if [[ $k = q ]] ; then
        printf "\nAborting demo\n"
        exit 0;
    fi
    if [[ $k = s ]] ; then
        return 1;
    fi
    return 0;
}

# print out command to be executed and pause
# execute the command when the user presses any key
# exceptions:
#       pressing q will exit
#       pressing s will skip
function demo_command()
{
    if (( $demo_prompt_count==0 )) ; then
        demo_prompt
        demo_pause
    fi
    echo $1
    demo_pause
    if (( $?==0 )) ; then
        eval "$1"
    else
        printf "skipping...\n"
    fi
    demo_prompt
}

