#!/bin/bash
umask 002
# Anggota 5: monitoring CPU dan memori
PID=$1
ID=$2
sleep 1
{
  echo "== Job $ID (PID $PID) jam $(date +%H:%M:%S) =="
  echo "-- 3 proses terbesar CPU --"
  ps -eo pid,ppid,pcpu,pmem,rss,comm --sort=-pcpu | head -n 4
  echo "-- 3 proses terbesar memori --"
  ps -eo pid,ppid,pcpu,pmem,rss,comm --sort=-rss | head -n 4
  echo "-- memori sistem (MB) --"
  free -m
  echo
} >> output/monitor.log
