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

    diff=${d2}/object/${b1}/diff.log
    t=${d2}/object/${b1}/test.log
    
    cat ${d2}/object/${b1}/test.64.log ${d2}/object/${b1}/test.32.log > ${t}
        
    diff $g ${d2}/object/${b1}/test.log > ${diff}
    rc=${PIPESTATUS[0]}
    if [ $rc -eq 0 ]; then
        echo "Test Passed ${bit}Bit ${b1}"
        rm ${diff}
    else
        echo "Test Failed ${bit}Bit ${b1}"
        sdiff -w 180 $g $t > ${diff}
    fi
    status=$(($status + $rc))
done

if [ $status -eq 0 ]; then
    echo "Summary: All Tests Passed"
else
    echo "Summary: ${status} Tests Failed"
fi

exit ${status}