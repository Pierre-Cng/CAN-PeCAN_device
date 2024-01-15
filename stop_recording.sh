#!/bin/bash

pid_python=$(cat script_pid.txt)
pid_candump=$((pid_python - 1))
kill $pid_python
kill $pid_candump
