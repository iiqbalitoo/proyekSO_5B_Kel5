#!/bin/bash
# Anggota 4: batas waktu dan penghentian
# Pakai: bash scripts/timeout.sh <detik> <script> [parameter]
BATAS=$1
shift
# jika lewat batas, timeout menghentikan proses dan exit status = 124
timeout $BATAS bash "$@"
exit $?
