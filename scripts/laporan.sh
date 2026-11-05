#!/bin/bash
umask 002
# Anggota 5: laporan status
L=output/laporan.txt
echo "LAPORAN STATUS ANTREAN" > $L
echo "Dibuat: $(date)" >> $L
echo "Menunggu : $(ls data/queue | wc -l)" >> $L
echo "Berjalan : $(ls data/running | wc -l)" >> $L
echo "Berhasil : $(ls data/done | wc -l)" >> $L
echo "Gagal    : $(ls data/failed | wc -l)" >> $L
echo "" >> $L
echo "5 baris log terakhir:" >> $L
tail -n 5 output/jobs.log >> $L
cat $L
