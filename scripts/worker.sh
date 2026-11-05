#!/bin/bash
umask 002
# Anggota 2: antrean FIFO dan lock worker
exec 200> data/worker.lock
if ! flock -n 200; then
  echo "Ditolak: worker lain sedang berjalan"
  exit 1
fi

while true; do
  # ls mengurutkan nama file, jadi yang paling lama ada di atas (FIFO)
  JOB=$(ls data/queue | head -n 1)
  if [ -z "$JOB" ]; then
    echo "Antrean kosong"
    break
  fi

  mv data/queue/$JOB data/running/$JOB
  bash scripts/status.sh data/running/$JOB

  if [ $? -eq 0 ]; then
    mv data/running/$JOB data/done/$JOB
  else
    mv data/running/$JOB data/failed/$JOB
  fi
done
exit 0
