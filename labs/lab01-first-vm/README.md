
# Lab 1 — Your first virtual machine

Pair: Zhanat Nurtas / Ibraeva Nursaya   
Driver first half: Zhanat Nurtas

Machine: Honor Magicbook X14, Ubuntu Desktop 26.04.1, guest Ubuntu Server 26.04.1

Date: 25.10.2026

## What I did
1. Installed Oracle VM Virtualbox. Version: 7.2.6_Ubuntu r172322 . Licence: https://www.virtualbox.org/wiki/VirtualBox_PUEL
2. Created VM lab01-ubuntu: 2 vCPU, 4 GB RAM, 25 GB dynamic disk, NAT.
3. Installed Ubuntu Server, took snapshot clean-install.
4. Broke it: sudo rm /etc/hostname
5. Rolled back to clean-install: cat /etc/hostname

## Resource justification
Gave 4GB out of 16GB available because host system Ubuntu takes 5GB when idle and i need memory for future Windows guest
Gave 2 CPU cores out of 8 available because i need 2 more for Windows guest and 4 for the host system
## Result
The VM boots; the break-and-rollback cycle is shown in the evidence below.

## What did not work the first time
SSH connection did not work, port forwarding didn't solve the problem

## Evidence
- [evidence/vm-settings-memory-and-cores.png](evidence/vm-settings-memory-and-cores.png) — CPU and memory as configured
- [evidence/vm-settings-storage.png](evidence/vm-settings-storage.png) — Disk as configured
- [evidence/guest-release.png](evidence/guest-release.png) — Ubuntu Server is running in the guest
- [evidence/broken.png](evidence/broken.png) — the guest in its broken state
- [evidence/snapshot-list.png](evidence/snapshot-list.png) — the snapshot, after the rollback
