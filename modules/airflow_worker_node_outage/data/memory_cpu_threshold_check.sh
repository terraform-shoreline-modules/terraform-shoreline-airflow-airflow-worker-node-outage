

#!/bin/bash



# Check if the node is running low on memory

if [[ $(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2}') > ${MEMORY_THRESHOLD} ]]; then

    echo "Memory usage is high. Current usage: $(free -m | awk 'NR==2{print $3}') MB"

fi



# Check if the node is running low on CPU

if [[ $(top -bn1 | grep load | awk '{printf "%.2f%%", $(NF-2)}') > ${CPU_THRESHOLD} ]]; then

    echo "CPU usage is high. Current usage: $(top -bn1 | grep load | awk '{printf "%.2f%%", $(NF-2)}')"

fi