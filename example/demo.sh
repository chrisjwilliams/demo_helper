#/bin/bash
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


# load in demo utility modules
DIR="$( dirname "${BASH_SOURCE[0]}" )"
source $DIR/../demo_utils.sh

# the demo
demo_start "Hello World!"
demo_command "echo Hello World!"
demo_pause


