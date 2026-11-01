# Lab 2 — A Windows guest, and a network between them

Pair: Nurtas / Nursaya   
Driver first half: Nurtas

Machine: Honor Magicbook X14, Linux Fedora, 16  GB, 8 cores>, guests Ubuntu Server + Windows 11 Enterprise eval

Date: 1.11.2026

## What I did
1. Downloaded Windows 11 Enterprise evaluation. Licence: [<Evaluation Center link>](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-11-enterprise)
2. Created lab02-windows: 2 vCPU, 4 GB, 64 GB thin, UEFI + Secure Boot, vTPM.
3. Network mode: NAT Network, both guests. Why: Because that's the way host and both guests can interact with each other while having connection to the internet
4. Ping Ubuntu → Windows timed out because firewall was blocking pings. Fixed with: New-NetFirewallRule -DisplayName "Allow ping in (ICMPv4)" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow

5. Overcommitment: set 10 GB + 10 GB on a 16 GB host.

## Network diagram
```
              Internet
                 |
      Host laptop 192.168.1.207
                 |
     [Virtualbox NAT network]
          /                        \
lab01-ubuntu                  lab02-windows
10.0.2.3                      10.0.2.15
```
## Result
| | Before | After |
|---|---|---|
| Host RAM in use | 5.4GB | 13GB |
| Available | 6.2GB | 340MB |
| Committed / Swap used | 276KB | 1.5GB |
| What I noticed | — | All three systems lag. Windows froze. Using any of three systems was impossible |

## What did not work the first time
Copy and paste between guest Windows and host Fedora didn't work at first. Guest tools weren't installed. Fixed it by installing guest tools.
SSH connection didn't work at first. Virtualbox NAT Network requires a different command. "ssh -p 2222 koldyn@127.0.0.1" instead of "ssh koldyn@10.0.2.3"

## Evidence
- [evidence/ipconfig-windows.txt](evidence/ipconfig-windows.txt) — Windows address
- [evidence/ip-addr-linux.txt](evidence/ip-addr-linux.txt) — Ubuntu address
- [evidence/ping-both-ways.txt](evidence/ping-both-ways.txt) — both directions and the internet
- [evidence/host-memory-before.png](evidence/host-memory-before.png) — host memory, guests off
- [evidence/host-memory-after.png](evidence/host-memory-after.png) — host memory, both guests overcommitted
