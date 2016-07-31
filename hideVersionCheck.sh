#!/bin/bash

vers=$(named -v)
echo ${vers:0:4}
if [ ${vers:0:4}  ==  "BIND" ];
        then
                echo "gecemedi"
else
	echo "gecti"
fi

exit 0
