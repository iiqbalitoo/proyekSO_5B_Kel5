#!/bin/bash
umask 002
# Anggota 1: pengajuan pekerjaan
SCRIPT=$1
PARAM=$2
IZIN=config/allowed.txt

if [ -z "$SCRIPT" ]; then
  echo "Pakai: bash scripts/ajukan.sh <script> [parameter]"
  exit 2
fi

if [ ! -w data/queue ]; then
  echo "Ditolak: kamu tidak punya akses ke antrean"
  exit 5
fi

if ! grep -qx "$SCRIPT" $IZIN; then
  echo "Ditolak: script tidak ada di daftar izin"
  exit 3
fi

if [ ! -f "$SCRIPT" ]; then
  echo "Ditolak: file script tidak ditemukan"
  exit 3
fi

if [ -n "$PARAM" ]; then
  if [[ ! "$PARAM" =~ ^[a-zA-Z0-9]+$ ]]; then
    echo "Ditolak: parameter hanya boleh huruf dan angka"
    exit 4
  fi
fi

ID=$(date +%Y%m%d%H%M%S%N)
echo "$SCRIPT $PARAM" > data/queue/$ID.job
echo "$(date +%H:%M:%S)|$ID|WAITING|-|-|masuk antrean" >> output/jobs.log
echo "Pekerjaan masuk antrean: $ID"
exit 0
