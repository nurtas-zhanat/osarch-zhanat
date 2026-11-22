# Lab 6 — Live processes and memory pressure

Pair: Nurtas + Nursaya · Date: 22.11.26 · Guests: Ubuntu 26.04.1 LTS, Windows 11 Enterprise LTSC Evaluation 24H2. Memory: 4GB for Ubuntu, 4GB for Windows. Temporarily lowered to 2GB

## Part 1 — One process, three tools
Process chosen: VBoxService — why: It's already installed on both systems

| | Task Manager | Process Explorer | htop |
| :--- | :--- | :--- | :--- |
| PID | 1940 | 1940 | 3067 |
| Parent (name and PID) | — (not shown) | svchost.exe PID:1660 | /usr/lib/systemd/systemd PID:1|
| "Memory" as shown by default | 768K | 2348K | 0.1% |
| Private memory | — | 2348K | —  |
| Working set / RES | — | 9264K | 3788 |
| Virtual size | — | 2,151,779,352K | 285M |
| Handles / file descriptors | "VirtualBox Guest Additions Service" | 196 | — |
| Threads | — | 14 | — |

### Where the tools disagree
PID: Both windows tools disagree with htop. This is because linux and windows set PIDs differently
Working set: Linux uses less memory
Virtual size: Linux's service weighs more because programs for Windows and Linux are different
Memory: Task Manager and Process Explorer show memory by kilobytes, htop shows it by percents. Windows tools give better raw number, htop helps with understanding how much program takes relative to your whole memory


## Part 2 — Memory pressure
Guest RAM: 1.6GB · swap: 2GB
Steps:
```
free -h
cd ~ && mkdir -p lab06 && cd lab06
{ echo "=== BEFORE $(date) ==="; free -h; } > memory-pressure.txt
while true; do echo "=== $(date +%T) ==="; free -h; sleep 3; done | tee -a memory-pressure.txt
stress-ng --vm 2 --vm-bytes 70% --timeout 60s
stress-ng --vm 2 --vm-bytes 90% --timeout 60s
stress-ng --vm 2 --vm-bytes 120% --timeout 90s
```
| | Before | During (worst) | After |
| Available | 1.6GB | 117MB | 1.6GB |
| Swap used | 0GB | 43MIB | 0GB |
What happened: 
After using 
```
stress-ng --vm 2 --vm-bytes 70% --timeout 60s
```
The available memory started to drop
The system runs okay

After using
```
stress-ng --vm 2 --vm-bytes 90% --timeout 60s
```
The system was noticeably short of RAM, resorting to the swap file
Htop is updating rarer

After using
```
stress-ng --vm 2 --vm-bytes 120% --timeout 90s

```
The available memory dropped to almost zero, system actively uses the swap file
SSH connection is lagging


### What the kernel did
```
Nov 22 14:49:15 lab01-zhanat kernel: [   7378]  1000  7378    14119      339       16      32>
Nov 22 14:49:15 lab01-zhanat kernel: [   7775]  1000  7775   455041   108278   108139      13>
Nov 22 14:49:15 lab01-zhanat kernel: [   7776]  1000  7776   455041   259307   259168      13>
Nov 22 14:49:15 lab01-zhanat kernel: oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),cpus>
Nov 22 14:49:15 lab01-zhanat kernel: Out of memory: Killed process 7775 (stress-ng-vm) total->
```
The kernel killed stress-ng-vm with a PID of 7775 at 14:49:15 because the process was taking way too much memory

### Windows
```
Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Microsoft-Windows-Resource-Exhaustion-Detector'} -MaxEvents 5 |
>> Format-List TimeCreated, Id, Message
```
No output. Windows didn't kill any process to get memory back

## What did not work the first time
The kernel didn't kill the process, so i increased the --vm-bytes to 300%
