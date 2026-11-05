#!/bin/bash
# bersihkan kondisi uji
rm -f data/queue/* data/running/* data/done/* data/failed/*
rm -f output/jobs.log output/monitor.log output/laporan.txt
echo "Kondisi uji dibersihkan"
