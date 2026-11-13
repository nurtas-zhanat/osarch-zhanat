# Lab 4 — Partition, mirror, fail, recover

Pair: Zhanat Nurtas + Ibraeva Nursaya · Date: 13.11.2026 · Hypervisor: VirtualBox / VMware / UTM

## Windows
```
PS C:\WINDOWS\system32> Get-Disk | Select Number, FriendlyName, PartitionStyle, Size

Number FriendlyName  PartitionStyle        Size
------ ------------  --------------        ----
     0 VBOX HARDDISK GPT            85899345920
     1 VBOX HARDDISK GPT             1073741824

PS C:\WINDOWS\system32> Get-Volume | Where FileSystemLabel -eq 'LAB04'

DriveLetter FriendlyName FileSystemType DriveType HealthStatus OperationalStatus SizeRemaining       Size
----------- ------------ -------------- --------- ------------ ----------------- -------------       ----
GPT. I run a laptop supporting GPT, Windows 11 works better with GPT. I don't have any reason to use MBR.
```
## Linux — layout before and after
### Before
```
$ lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS
NAME                       SIZE TYPE FSTYPE      MOUNTPOINTS
loop0                     66.8M loop squashfs    /snap/core24/1643
loop1                     50.1M loop squashfs    /snap/snapd/27710
loop2                      1.5M loop squashfs    /snap/hwctl/123
loop3                      1.5M loop squashfs    /snap/hwctl/131
sda                         25G disk
|-sda1                       1M part
|-sda2                       2G part ext4        /boot
`-sda3                      23G part LVM2_member
  `-ubuntu--vg-ubuntu--lv 11.5G lvm  ext4        /
sdb                          1G disk
sdc                          1G disk
sdd                          1G disk
sr0                       1024M rom
```
### After
```
NAME                       SIZE TYPE  FSTYPE            MOUNTPOINTS
loop0                     66.8M loop  squashfs          /snap/core24/1643
loop1                      1.5M loop  squashfs          /snap/hwctl/123
loop2                     50.1M loop  squashfs          /snap/snapd/27710
loop3                      1.5M loop  squashfs          /snap/hwctl/131
sda                         25G disk
|-sda1                       1M part
|-sda2                       2G part  ext4              /boot
`-sda3                      23G part  LVM2_member
  `-ubuntu--vg-ubuntu--lv 11.5G lvm   ext4              /
sdb                          1G disk
`-sdb1                    1022M part  linux_raid_member
  `-md0                   1021M raid1 ext4
sdc                          1G disk
`-sdc1                    1022M part  linux_raid_member
sdd                          1G disk
`-sdd1                    1022M part  linux_raid_member
  `-md0                   1021M raid1 ext4
sr0                       1024M rom
```
## What I did
Creating disk partitions
```
sudo parted -s /dev/$d mklabel gpt mkpart primary 1MiB 100% set 1 raid 
```
For every disk using a for loop

Building the mirror
```
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
```

Saving healthy state
```
{ echo '$ cat /proc/mdstat'; cat /proc/mdstat; echo; echo '$ sudo mdadm --detail /dev/md0'; sudo mdadm --detail /dev/md0; } > evidence/array-healthy.txt
```

Setting the file system, mounting the disks and getting proof files
```
sudo mkfs.ext4 -L mirror /dev/md0
sudo mkdir -p /mnt/mirror
sudo mount /dev/md0 /mnt/mirror
sudo chown $USER: /mnt/mirror
echo "Lab 4 proof file — <your names> — $(date)" > /mnt/mirror/proof.txt
head -c 20M /dev/urandom > /mnt/mirror/random.bin
cd /mnt/mirror && { echo '$ sha256sum proof.txt random.bin'; sha256sum proof.txt random.bin; } > ~/lab04/evidence/checksum-before.txt; cd ~/lab04
cat evidence/checksum-before.txt
```

Breaking one disk and getting evidence
```
sudo mdadm /dev/md0 --fail /dev/sdc1
sudo mdadm /dev/md0 --remove /dev/sdc1
{ echo '$ cat /proc/mdstat'; cat /proc/mdstat; echo; echo '$ sudo mdadm --detail /dev/md0'; sudo mdadm --detail /dev/md0; } > evidence/array-degraded.txt
cat /proc/mdstat
```

Adding the third disk and rebuilding it
```
sudo mdadm /dev/md0 --add /dev/sdd1
cat /proc/mdstat
```

Saving the mirror
```
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
sudo update-initramfs -u
```

Getting the final layout
```
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS
```
## Three states
| State | What /proc/mdstat showed | File |
| --- | --- | --- |
| Healthy | [2/2] [UU] | evidence/array-healthy.txt |
| Degraded | [2/1] [U_] | evidence/array-degraded.txt |
| Rebuilt | [2/2] [UU], sdd1 replaced sdc1 | evidence/array-rebuilt.txt |
Checksums before and after the failure: do not match

## RAID is not a backup
Your colleague deleted the wrong file from the mirror an hour ago. Does RAID 1 help? Why?

RAID 1 doesn’t help, because it mirrors every change in real time, so the delete was applied to both disks within milliseconds and no untouched copy exists. RAID only protects against a physical disk failure; it doesn’t protect against accidental deletion, ransomware, corruption, or fire, since all of those hit both mirrors equally. A real backup is a separate copy with point-in-time.

## What did not work the first time
Didn't see the sda, sdb, sdc disks and Number 1 disk. Turned out I only created them but never connected them to the VMs. Fixed by adding the disks to the VMs.
