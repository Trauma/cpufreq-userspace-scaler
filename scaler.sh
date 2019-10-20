#!/bin/bash

# Make script safer
set -euxo pipefail

# Get cpu cores count minus 1, to allow maping from 0
cpucorecount=$(cat /proc/cpuinfo | grep cores | sort -u | awk '{ print $4 - 1 }')

# Set correct cpufreq governor to allow user defined frequency scaling
governor=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
if [ "$governor" != "userspace" ]; then
  for i in $(seq 0 ${cpucorecount})
    do
      echo userspace > /sys/devices/system/cpu/cpu${i}/cpufreq/scaling_governor
  done
fi

# Rereive allowed cpu freq on the system
freqlist=($(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies))

# Set min and max frequencies, this user overidable
scalingminfreq=${scalingminfreq:=${freqlist[-1]}}
scalingmaxfreq=${scalingmaxfreq:=${freqlist[0]}}

# This will set user defined min and max frequencies
if [ "$governor" = "userspace" ]; then
  for i in $(seq 0 ${cpucorecount})
    do
      echo $scalingminfreq > /sys/devices/system/cpu/cpu${i}/cpufreq/scaling_min_freq
      echo $scalingmaxfreq > /sys/devices/system/cpu/cpu${i}/cpufreq/scaling_max_freq
  done
fi

# Frequency scaling function
function main {
  # Get average load over 5m in base10 integer format
  loadavg=$(cat /proc/loadavg | awk -F . '{print $1 substr($2,1,2)}')

  # Frequencies steps definitions
  maxfreq=${freqlist[0]}
  minfreq=${freqlist[-1]}
  midfreq=${freqlist[$((${#freqlist[*]}/2))]}

  # Set load steps to trigger frequencies scaling, this user overidable
  lowload=${lowload:=050}
  midload=${midload:=065}
  highload=${highload:=085}

  for i in $(seq 0 ${cpucorecount})
    do
      if [ "$loadavg" -le $((10#$lowload)) ]; then
        echo $minfreq > /sys/devices/system/cpu/cpu${i}/cpufreq/scaling_setspeed
      elif [ "$loadavg" -ge $((10#$lowload)) ] && [ "$loadavg" -le $((10#$midload)) ]; then
        echo $midfreq > /sys/devices/system/cpu/cpu${i}/cpufreq/scaling_setspeed
      elif [ "$loadavg" -ge $((10#$highload)) ]; then
        echo $maxfreq > /sys/devices/system/cpu/cpu${i}/cpufreq/scaling_setspeed
      fi
  done
}

# Demonize the main function...
while true; do
  main
  sleep 0.5
done
