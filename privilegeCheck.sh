#!/bin/bash



readarray -t lines < <(echo "$(ps aux | grep named)")
echo "${lines[0]:0:4}"



if [ ${lines[0]:0:4} == bind ];
        then
                echo "gecti"
else
	echo "gecemedi"
fi

exit 0

