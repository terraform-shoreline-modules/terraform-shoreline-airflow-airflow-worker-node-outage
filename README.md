
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Airflow worker node outage.
---

An Airflow worker node is a component of the Apache Airflow system that performs scheduled tasks and manages workflow execution. When a worker node goes down, it means that the tasks and workflows assigned to that node cannot be executed until the issue is resolved. This can cause delays and disruptions to scheduled processes and may require urgent attention from the system administrators to restore functionality. The incident may occur due to hardware or software failures, connectivity issues, or other technical problems.

### Parameters
```shell
export WORKER_NODE_IP_ADDRESS="PLACEHOLDER"

export WORKER_NODE_PORT="PLACEHOLDER"

export MEMORY_THRESHOLD="PLACEHOLDER"

export CPU_THRESHOLD="PLACEHOLDER"

export NEW_CPU_COUNT="PLACEHOLDER"

export NEW_DISK_SIZE="PLACEHOLDER"

export NODE_ID="PLACEHOLDER"

export NEW_MEMORY_SIZE="PLACEHOLDER"
```

## Debug

### Check if the Airflow worker node is responding to ping requests
```shell
ping ${WORKER_NODE_IP_ADDRESS}
```

### Check if the Airflow worker node is listening on the expected port
```shell
nc -vz ${WORKER_NODE_IP_ADDRESS} ${WORKER_NODE_PORT}
```

### Check if there are any Airflow-related processes running on the worker node
```shell
ps aux | grep airflow
```

### Check the logs of the Airflow worker process
```shell
tail -n 100 /var/log/airflow/worker.log
```

### Check the status of the Airflow worker service
```shell
systemctl status airflow-worker.service
```

### Insufficient resources on the Airflow worker node, leading to memory or CPU exhaustion.
```shell


#!/bin/bash



# Check if the node is running low on memory

if [[ $(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2}') > ${MEMORY_THRESHOLD} ]]; then

    echo "Memory usage is high. Current usage: $(free -m | awk 'NR==2{print $3}') MB"

fi



# Check if the node is running low on CPU

if [[ $(top -bn1 | grep load | awk '{printf "%.2f%%", $(NF-2)}') > ${CPU_THRESHOLD} ]]; then

    echo "CPU usage is high. Current usage: $(top -bn1 | grep load | awk '{printf "%.2f%%", $(NF-2)}')"

fi


```

## Repair

### If the issue persists, consider increasing the resources allocated to the worker node, such as CPU, memory, or disk space.
```shell
bash

#!/bin/bash



# Set the node ID of the affected worker node

NODE_ID=${NODE_ID}



# Increase CPU allocation for the worker node

sudo virsh setvcpus $NODE_ID ${NEW_CPU_COUNT}



# Increase memory allocation for the worker node

sudo virsh setmem $NODE_ID ${NEW_MEMORY_SIZE}



# Increase disk space allocation for the worker node

sudo virsh blockresize $NODE_ID vda --size ${NEW_DISK_SIZE}



echo "Resources updated for worker node $NODE_ID."


```