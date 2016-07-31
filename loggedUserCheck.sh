#!/bin/bash
(getent passwd | \
grep -vE '(nologin|false)$' | \
awk -F: -v min=`awk '/^UID_MIN/ {print $2}' /etc/login.defs` \
-v max=`awk '/^UID_MAX/ {print $2}' /etc/login.defs` \
'{if(($3 >= min)&&($3 <= max)) print $1}' |  wc -l)
