# Ticket 1 — New developer starts Monday, needs a test machine

## 1. What was asked

> **From:** Aigerim T. (Office Manager)
> **Subject:** test machine for new dev
>
> Hi, we have someone starting on Monday and he needs a test computer
> set up. Nothing special, just so he can try things without breaking
> anything. Can you write down how to do it so I can do the next one
> myself? Thanks

## 2. What was actually needed

**What the request says versus what the job is**

| The request says | What it actually requires |
|---|---|
| "a test computer" | Not a purchase. A *virtual* machine on hardware the company already has. A second physical computer for "trying things" is costly, slow to restore and unnecessary. |
| "nothing special" | Two decisions that are easy to get wrong: how much of the host to give away, and how the guests connect to the network. The defaults of the hypervisor get the network wrong for this job (see below). |
| "without breaking anything" | Two separate promises: (a) the developer cannot damage the host or the office network → isolation by NAT; (b) he can undo his own mistakes → a snapshot that has actually been restored once. |
| "write down how to do it so I can do the next one myself" | **The document is the deliverable, not the machine.** The reader is a non-technical office manager. The document must work for somebody who does not know what a hypervisor is, which is why it has a glossary, a "check" after steps, and a troubleshooting table. |
| "Monday" | There is a deadline, so the guide must not depend on knowledge I have in my head. It has to be rebuilt by someone else from the text alone (peer review, week 5). |

**What the request left out, and what I assumed instead**

I could not ask Aigerim, so each gap is a stated assumption. Any of them can be wrong, and the BUILD.md would need a change if so.

| Missing detail | What I assumed | Reason |
|---|---|---|
| Which operating system the developer needs | **Both** Linux and Windows | "Test machine" for an unknown stack; a pair covers both, and the course asks for both. |
| Which Linux, which Windows | Ubuntu Server LTS; Windows 11 Enterprise **evaluation** | Supplied on the local share. LTS gets five years of fixes; evaluation avoids a licence the company did not buy. |
| Which hypervisor | VirtualBox from Oracle's repository (RPM Fusion as the fallback) | Free, same screens on every host OS, has NAT Network and reliable snapshots of a Windows 11 guest with a virtual TPM. |
| What the host computer is | **Fedora Linux** host (Workstation, GNOME), Intel 12450H. Honor Magicbook X14, Fedora 42, 16GB RAM, 12 threads, 8 cores, 512GB SSD | Taken from my own machine's measurements (section 3). Aigerim's real machine must be measured with Part 1 of BUILD.md before she copies my numbers. If her computer runs Windows or macOS instead of Fedora, Parts 1 and 2 of BUILD.md do not apply to it and must be rewritten. |
| Whether the guest needs the internet | Yes, and also needs to reach the other guest | A developer cannot install packages or test client–server software otherwise. |
| How long the machine lives | Long enough to need an expiry reminder | The Windows evaluation stops being valid after **90 days**; the guide says when and what to do. A "nothing special" request hides a time limit the requester does not know about. |
| Does the host contain anything valuable | I assumed it is a shared work computer. | So the design has to protect the host first (isolation, resource limits), not only the guest. |
| Who administers it afterwards | Aigerim (non-technical) | Drives the wording of BUILD.md and the choice of GUI-first instructions with commands only as a second way. |

**What I would have asked Aigerim:** (1) What does he develop in: web, desktop, servers? (2) Does he need Windows, Linux or both? (3) Which computer will host it and how much memory does it have? (4) Should he be able to keep his work if the guest is restored, and where? (5) How many such machines will you need, and for how long?

## 3. What I did

Steps are in [BUILD.md](BUILD.md). In short:

1. **Measured the host** from the Fedora Terminal, not with the graphical "About" screen, so the plan rests on facts (the full output is in `evidence/00-host-check.txt`):

   | What | My value | Command |
   |---|---|---|
   | CPU / threads | Intel Core I5 12450H / 12 Threads | `lscpu`, `nproc` |
   | Total RAM | 16 GB | `free -h`, `/proc/meminfo` |
   | Free RAM before | 12 GB | `MemAvailable` in `/proc/meminfo` |
   | RAM modules | 8 Modules, 4267MT/s | `sudo dmidecode -t memory` |
   | Disk type / free on VM drive | SSD NVMe / 512 GB | `lsblk -d -o NAME,SIZE,ROTA,TRAN,MODEL`, `df -h ~` |
   | Virtualization enabled | Enabled | `grep -c -E '(vmx\|svm)' /proc/cpuinfo`, `ls /dev/kvm` |
   | Secure Boot | Enabled | `mokutil --sb-state` |

2. **Installed VirtualBox** on Fedora (kernel headers first, then Oracle's repository, `vboxusers` group, kernel modules built with `vboxconfig`) and created one NAT Network, `osarch-net` (10.0.50.0/24).
3. **Built `ubuntu-test`**, took the snapshot `clean-install`, broke `/etc/hostname`, restored, and confirmed the repair.
4. **Built `win11-test`** with EFI, TPM 2.0 and Secure Boot (without them Windows 11 refuses to install), from the evaluation ISO and with no product key.
5. **Connected both** to `osarch-net`, found the firewall blocks ping, added a narrow ICMP rule instead of switching the firewall off, and proved both directions.
6. **Ran the over-allocation experiment** and returned memory to the plan. On Fedora the first stage of overload is zram (compressed swap in memory), and then `systemd-oomd` or the kernel OOM killer; the kernel log was checked for either.

### Resources allocated, calculated from the host

Rules used (explained in BUILD.md Part 3): each guest ≤ half the host's threads; both guests together ≤ half the host's RAM; disk limits fit in the free space with ≥ 20% left.

| Resource | Host total | Rule | `ubuntu-test` | `win11-test` | Combined | Share of host |
|---|---|---|---|---|---|---|
| vCPUs | 12 threads | each ≤ ½ | 2 | 2 | 4 | 33 % |
| RAM | 16 GB | together ≤ ½ | 4 GB | 4 GB | 8 GB | 50% |
| Disk (max) | 512 GB free | ≥ 20% left | 25 GB | 80 GB | 105 GB | 20% of free |

Each guest gets enough resources to run smoothly while the host doesn't suffer from resource deficit. Third guest is not expected, but the values would have to change if the third guest is going to be.

### Every setting that differs from the default, and why

| Setting | Default | What I set | Why |
|---|---|---|---|
| Skip Unattended Installation | off | **on** | The automatic installer hides every choice; the document needs them visible. |
| Network adapter, both guests | NAT | **NAT Network `osarch-net`** | Plain NAT puts each guest in its own bubble: they reach the internet but **not each other**. |
| Not Bridged | – | – | The campus network filters by MAC address; a bridged guest would get no network and no error. |
| Virtual disk | – | **Dynamically allocated** | Takes only the space actually used; a fixed 80 GB disk would take 80 GB immediately. |
| Linux install type | – | Ubuntu **Server**, not minimized | Course assumes a console guest; minimized lacks later tools. |
| Host: kernel headers and update before install | – | `kernel-devel` for the running kernel, then reboot | VirtualBox's kernel modules are built against the running kernel; a mismatch makes the build fail. |
| Host: Secure Boot | Enabled | Disabled | Linux refuses unsigned kernel modules under Secure Boot. |
| Host: user group | – | Added my user to `vboxusers` | Required for non-root use of VirtualBox. |
| OpenSSH server | off | **on** | Lets me copy command output files out of the text-only guest with `scp`. |
| Windows: EFI / TPM / Secure Boot | off / none / off | **on / v2.0 / on** | Windows 11 will not install without all three. |
| Windows: video memory | 16–32 MB | **128 MB** | Smoother desktop. |
| Windows: no product key | – | "I don't have a product key" | Evaluation edition only. No own key, no "pre-activated" downloads. |
| Windows firewall | on | **on**, plus one rule: ICMPv4 echo from the local subnet | Fixes ping without removing protection. |
| Guest Additions (Windows) | not installed | **installed** | Window resizing, clipboard, mouse. |
| Shared Clipboard (Windows guest) | off | **bidirectional** | Moves evidence text between the guest and the Fedora host. |

### Alternatives I considered

* **Plain NAT** — simplest, but the guests cannot see each other. Rejected.
* **Bridged** — guests are visible on the office network, but blocked by MAC filtering here. Rejected
* **Host-only + NAT (two adapters)** — works, but two adapters per guest is harder for a non-technical reader to reproduce than one NAT Network.
* **KVM / QEMU with `virt-manager`** — Fedora's own tooling, no kernel modules to rebuild and works with Secure Boot on. Rejected because snapshots of a Windows 11 guest with a virtual TPM and UEFI are less straightforward, and the snapshot is the core of the "cannot break anything" promise.

### What went wrong and how I resolved it

Guest tools didn't work at first because they weren't installed. Fixed by mounting a CD and setting up the tools

## 4. Evidence

Files marked ★ are the six named in the ticket. Screenshots with a `steps/` prefix are the per-step images referenced from BUILD.md.

| File | What it proves |
|---|---|
| ★ `evidence/01-new-vm-wizard.png` | VM creation settings for the Linux guest. |
| ★ `evidence/02-disk-settings.png` | The virtual disk size and type as configured. |
| ★ `evidence/03-network-adapter.png` | Adapter attached to the NAT Network `osarch-net`. |
| ★ `evidence/04-guest-uname.txt` | Output of `lsb_release -a` and `uname -a` inside the Linux guest. |
| ★ `evidence/05-ping-between-guests.txt` | Ping works Linux → Windows and Windows → Linux. |
| ★ `evidence/06-snapshot-list.png` | The `clean-install` snapshot exists, after the rollback. |

## 5. What I would do differently

I would take a snapshot of the Windows guest before installing Guest Additions. Guest tools can bring problems with themselves
