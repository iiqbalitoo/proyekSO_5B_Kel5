#!/bin/bash
umask 002
# Anggota 3: status, PID, dan exit status
JOB=$1
LOG=output/jobs.log
BATAS=5

if [ -z "$JOB" ] || [ ! -f "$JOB" ]; then
  echo "Pakai: bash scripts/status.sh <file.job>"
  exit 2
fi

ID=$(basename $JOB .job)
ISI=$(cat $JOB)

bash scripts/timeout.sh $BATAS $ISI &
PID=$!
echo "$(date +%H:%M:%S)|$ID|RUNNING|$PID|-|berjalan" >> $LOG

bash scripts/monitor.sh $PID $ID

wait $PID
EXIT=$?

if [ $EXIT -eq 0 ]; then
  echo "$(date +%H:%M:%S)|$ID|SUCCESS|$PID|$EXIT|selesai" >> $LOG
elif [ $EXIT -eq 124 ]; then
  echo "$(date +%H:%M:%S)|$ID|FAILED|$PID|$EXIT|melewati timeout, dihentikan" >> $LOG
else
  echo "$(date +%H:%M:%S)|$ID|FAILED|$PID|$EXIT|exit status bukan nol" >> $LOG
fi
exit $EXIT
