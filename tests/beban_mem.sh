#!/bin/bash
# beban memori aman: sekitar 40 MB selama 3 detik
X=$(head -c 40000000 /dev/zero | tr '\0' 'a')
sleep 3
exit 0
