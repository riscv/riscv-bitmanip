#!/bin/bash

# Ref files under 
#     extB/<test>/golden.log
# Result files under 
#     extB/object/<test>/golden.log

declare -i status=0
declare -i rc=0

golden=$(ls extB/*/golden.log)

for g in ${golden}; do
    d1=$(dirname $g)
    d2=$(dirname $d1)
    b1=$(basename $d1)
    t=${d2}/object/${b1}/test.log
    diff=${d2}/object/${b1}/diff.log
    diff $g $t | tee ${diff}
    rc=${PIPESTATUS[0]}
    if [ $rc -eq 0 ]; then
        echo "Test Passed ${b1}"
        rm ${diff}
    else
        echo "Test Failed ${b1}"
        sdiff $g $t > ${diff}
    fi
    status=$(($status + $rc))
done

if [ $status -eq 0 ]; then
    echo "Summary: All Tests Passed"
else
    echo "Summary: ${status} Tests Failed"
fi

exit ${status}