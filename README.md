# Antrean Pekerjaan dan Monitoring Proses Linux (Proyek 5B)

Anggota: Harsya (1), Nanda (2), Iqbal (3), Fathir (4), Rifqi (5), Waldan (6)

## Pembagian
| No | Script | Tugas |
|----|--------|-------|
| 1 | scripts/ajukan.sh | Pengajuan dan validasi pekerjaan |
| 2 | scripts/worker.sh | Antrean FIFO dan lock worker |
| 3 | scripts/status.sh | Status, PID, exit status |
| 4 | scripts/timeout.sh | Batas waktu dan penghentian |
| 5 | scripts/monitor.sh, scripts/laporan.sh | Monitoring CPU/memori dan laporan status |
| 6 | Persiapan akses (grup, permission), Docker | Pembatasan akses dan aktivitas Docker |

## Persiapan (sekali saja)
    cd ~/proyek-so
    chmod +x scripts/*.sh tests/*.sh
    sudo groupadd lab
    sudo useradd -m petugas
    sudo useradd -m tamu
    sudo usermod -aG lab $USER
    sudo usermod -aG lab petugas
    sudo chgrp -R lab data output
    sudo chmod -R 770 data output
    sudo chmod g+s data output data/queue data/running data/done data/failed
    chmod o+x ~          # supaya akun tamu bisa masuk folder, tapi data tetap tertutup
Tutup terminal dan buka lagi. Cek dengan perintah groups, harus ada lab. Kalau belum ada, jalankan wsl --shutdown di PowerShell lalu buka Ubuntu lagi.

## Menjalankan
    bash scripts/ajukan.sh tests/ok.sh
    bash scripts/ajukan.sh tests/tidur.sh 3
    bash scripts/worker.sh
    bash scripts/laporan.sh
    cat output/jobs.log

## Menguji
Positif:
- ajukan tests/ok.sh, jalankan worker, log harus SUCCESS exit 0
- ajukan beberapa job, urutan di log harus sama dengan urutan pengajuan (FIFO)

Negatif:
- bash scripts/ajukan.sh tests/rm.sh        -> ditolak, exit 3
- bash scripts/ajukan.sh tests/tidur.sh "5;ls" -> ditolak, exit 4
- ajukan tests/gagal.sh -> log FAILED exit 1
- ajukan tests/tidur.sh 10 -> log FAILED exit 124 (timeout 5 detik)
- jalankan worker di dua terminal -> yang kedua ditolak
- sudo -u tamu bash scripts/ajukan.sh tests/ok.sh -> ditolak, exit 5

Beban CPU dan memori:
- ajukan tests/beban_cpu.sh dan tests/beban_mem.sh, jalankan worker, lihat output/monitor.log

## Docker (anggota 6)
Siapkan image dulu: docker pull alpine:3.20 (catat tag-nya)

Positif:
    bash scripts/laporan.sh
    docker run --rm --mount type=bind,src="$(pwd)/output",dst=/data,readonly alpine:3.20 cat /data/laporan.txt
    echo $?

Negatif:
    sha256sum output/laporan.txt
    docker run --rm --mount type=bind,src="$(pwd)/output",dst=/data,readonly alpine:3.20 sh -c 'echo uji >> /data/laporan.txt'
    echo $?
    sha256sum output/laporan.txt
Penulisan harus ditolak, exit bukan nol, dan checksum sama.

## Pemulihan
    bash scripts/reset.sh
