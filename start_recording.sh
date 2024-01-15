#!/bin/bash

source ~/venv/bin/activate
nohup candump -tz can0 | python ~/CAN-CandumpDecoder/src/main.py --channel $1 > output.log 2>&1 &
echo $! > script_pid.txt
