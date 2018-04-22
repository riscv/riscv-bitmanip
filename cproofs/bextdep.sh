#!/bin/bash
set -ex

# cbmc --trace --function bext32_bext64 bextdep.cc
# cbmc --trace --function bdep32_bdep64 bextdep.cc

gcc -Wall -o bextdep bextdep.cc
./bextdep
rm -f bextdep

echo OK
