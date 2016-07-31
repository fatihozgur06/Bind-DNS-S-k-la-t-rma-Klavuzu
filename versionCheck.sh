#!/bin/bash

vers=$(named -v)
echo ${vers:5:5}
if [ ${vers:5:5}  ==  "9.9.5" ];
        then
                echo "gecti"
else
	echo "gecemedi"
fi

exit 0
