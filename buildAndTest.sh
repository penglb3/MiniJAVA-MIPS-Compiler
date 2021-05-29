#!/bin/bash
cd src
echo "********************* Compilation log ************************"
make
if [ $? -eq 0 ]; then
    count=0
    echo "======================= successful ==========================="
    echo ""
    cd ..
    echo "************************ Test log ***************************"
    regex='.*\/([_a-zA-Z0-9]+).out$'
    for f in $(ls tests/*); do
        if [[ $f =~ $regex ]]; then
            fileName="${BASH_REMATCH[1]}"
            commandStr="src/proj4 < tests/$fileName > results/$fileName.s"
            if eval "$commandStr"; then
                echo "SUCCESSFUL: $commandStr"
                commandStr="spim -asm -file results/$fileName.s < tests/src10.in > results/$fileName.prog.out"
                if eval "$commandStr"; then
                    echo "SUCCESSFUL: $commandStr"
                else 
                    echo "ERROR: $commandStr"
                    let count++
                fi
            else 
                echo "ERROR: $commandStr"
                let count++
            fi 

        fi
    done
    echo "================ finished with $count error(s) ===================="
else
    echo "=================== compilation error ======================="
fi