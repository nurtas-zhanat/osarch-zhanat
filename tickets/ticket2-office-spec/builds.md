# Custom Office PC Builds

### Build 1 — Sales Manager
**Load:** Cloud CRM in Chrome (35–45 open tabs), Microsoft Excel spreadsheets, WhatsApp/Telegram desktop, and 3–4 hours of Zoom/Teams video calls daily—frequently running simultaneously.
**Bottleneck:** System memory (RAM) and browser responsiveness, not multi-core CPU throughput. Running 40+ browser tabs alongside video conferencing consumes 11–13 GB of RAM; on an 8 GB machine Windows begins swapping mid-call, causing audio stutter and UI freezes.
**Trade-off:** Chose a 4-core Intel Core i3-12100 (OEM + ID-COOLING SE-802-SD V3 cooler) on an entry-level ASUS Prime H610M-K D4 board with integrated UHD 730 graphics and a compact 21.5" AOC 22B15H2/01 monitor instead of a 6-core i5 or 32 GB RAM kit, saving ~115,000 KZT to absorb high 2026 DDR4 (97,998 KZT for 16 GB) and 1 TB NVMe SSD (82,299 KZT) prices while staying well under budget. Closing unused tabs keeps usage under 14 GB.
**Total:** 422,009 KZT (budget.csv, rows 2–10)

### Build 2 — Accountant
**Load:** 1C:Enterprise accounting database client, large multi-sheet Excel workbooks (50k+ rows), banking portals, PDF/document scanning, and government tax portals (e-Salyq / SONO) for 8 hours daily.
**Bottleneck:** Single-thread CPU responsiveness and fast random storage IOPS. Large 1C databases and tax crypto-token software (NCALayer) require snappy NVMe reads and a responsive multi-core CPU so ledger queries and tax filings do not stall.
**Trade-off:** Upgraded to a 6-core Intel Core i5-12400 (OEM + ID-COOLING SE-802-SD V3 cooler) and an MSI PRO B760M-P DDR4 motherboard (with 4 DIMM slots for easy future RAM expansion), while keeping memory at 16 GB (2×8 GB DDR4-3200) and using the same 21.5" AOC 22B15H2/01 monitor and PCcooler C3 B310 chassis as the Sales build to simplify office spare-parts standardization and save ~50,000 KZT.
**Total:** 454,410 KZT (budget.csv, rows 12–20)

### Build 3 — Web Developer
**Load:** Docker Desktop (4–6 running containers), local PostgreSQL/Redis instances, VS Code with language servers, Node.js/Webpack builds, and two browser windows (30+ tabs + DevTools) for 8–9 hours daily.
**Bottleneck:** Memory capacity and multi-core compile throughput. Docker containers, local databases, and multiple Node.js watchers rapidly exhaust 16 GB of RAM, while `npm install` and container builds bottleneck on CPU threads and NVMe I/O.
**Trade-off:** Chose an LGA1700 DDR4 platform (10-core Intel Core i5-13400 + Gigabyte B760M DS3H DDR4) instead of AM5/DDR5, omitted a discrete GPU (using integrated UHD 730 graphics), kept the budget 21.5" AOC monitor, and selected Ubuntu 26.04.1 LTS instead of Windows 11 Pro. Staying on DDR4 plus Linux saved ~240,000 KZT, funding 32 GB (2×16 GB) DDR4-3200 RAM, a Deepcool AK400 cooler, and a 750W Gold PSU while leaving two DIMM slots free for 64 GB later.
**Total:** 524,048 KZT (budget.csv, rows 22–30)

### Build 4 — Designer
**Load:** Adobe Photoshop (multi-layer 4K PSDs), Illustrator, Figma, and occasional Premiere Pro / After Effects 1080p–4K video exports for 8 hours daily.
**Bottleneck:** Color accuracy of the display and GPU VRAM/CUDA acceleration. Standard office monitors have poor sRGB coverage (~72% NTSC), making print and brand color work inaccurate, while GPU-accelerated filters and video encoding stall without dedicated VRAM.
**Trade-off:** Chose an LGA1700 DDR4 platform (14-core Intel Core i5-14600KF + Deepcool AK620 + ASUS PRIME B760-PLUS D4 + 32 GB DDR4-3200 at 159,996 KZT) in a Zalman S2 ATX Mid-Tower case instead of DDR5 (~327,000 KZT) and paired it with an MSI RTX 5050 8G VENTUS 2X instead of a higher-tier GPU, saving ~250,000 KZT so the budget could fund a factory-calibrated ASUS ProArt PA278QV (27" 1440p, 100% sRGB) monitor and an MSI MAG A850GL PCIE5 850W Gold PSU for future GPU upgrades.
**Total:** 1,039,556 KZT (budget.csv, rows 32–41)