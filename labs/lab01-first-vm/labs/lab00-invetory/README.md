
# Lab 0 - Inventory your own machine
## Zhanat Nurtas CYB26-6
### CPU Info 

| What | Value | Where I got it |
|---|---|---|
| CPU model | 12th Gen Intel(R) Core(TM) i5-12450H | `lscpu`, `cpu.txt` line 9 |
| Core count | 8 | `cpu.txt` line 13 |
| Thread count | 12 | `cpu.txt`, 2 threads per core, line 12 |

### Memory info

| What | Value | Where I got it |
|---|---|---|
| Total memory | 15199 megabytes | `free -m`, `memory.txt` line 3 |
| Number of modules | 8 modules, 2 GB each | `sudo dmidecode --type 17` |
| Form factor | Row of Chips | `sudo dmidecode --type 17`; memory is not upgradeable |
| Speed | 4266 MT/s | `memory.txt` line 32 |

### Disk info

| What | Value | Where I got it |
|---|---|---|
| Type | M.2 NVMe | `lsblk -d -o NAME,MODEL,ROTA,TRAN`; `disk.txt`, line 42 |
| Model| YMTC PC411-512GB | `lsblk -d -o NAME,MODEL,ROTA,TRAN`; `disk.txt`, line 42 |
| Free space | 237 GB | `df -hT`; `disk.txt`, line 4 |

### Firmware info

| What | Value | Where I got it |
|---|---|---|
| Type | UEFI | `[ -d /sys/firmware/efi ] && echo "UEFI" || echo "BIOS"`; bios.txt, line 2 |
| Version | 1.05 | `sudo dmidecode -s bios-version`; `bios.txt`, line 5 |
| Date | 03/16/2025 | `sudo dmidecode -s bios-release-date`; `bios.txt`, line 7 |

### Virtualization info

| What | Value | Where I got it |
|---|---|---|
| Status | Enabled | `lscpu \| grep Virtualization`; `virtualization.txt`, line 2 |

