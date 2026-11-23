# Ticket 2 — Kitting out the new office

## Ticket made with AI assistance
## 1. What was asked
> **From:** Daniyar K. (Director)  
> **Subject:** computers for the new office  
> We are opening the second office and need four computers — accountant, sales, web developer, designer. Budget 3,000,000 tenge for everything. Everyone says we should just buy the same four machines, is that right? Make sure they last a few years. Monitors included.

## 2. What was actually needed
**No, buying four identical machines is the wrong approach.** At 750,000 KZT per machine (3,000,000 / 4), identical mid-range PCs would overpay for unused CPU/cooler/PSU hardware on the sales and accounting desks while starving the designer of a color-accurate 1440p monitor and dedicated GPU, and starving the web developer of the 32 GB RAM needed for local containers.

**What the request left out:**
* **Software & OS requirements:** Accounting in Kazakhstan relies on 1C:Enterprise and Windows-only banking/tax cryptographic plugins (NCALayer), whereas web development runs faster and cheaper on Linux.
* **Peripherals & infrastructure:** Keyboards, mice, surge protectors/UPS units, Ethernet patch cables, and webcams/headsets for the sales manager's video calls.
* **Lifespan target & upgrade path:** "A few years" implies a 3–5 year lifecycle, requiring platforms with free RAM slots (4-DIMM B760 boards for Accountant, Developer, and Designer) and headroom on power supplies rather than dead-end configurations.
* **Assembly labor:** Whether internal IT will assemble the self-built components or if vendor assembly fees apply.

**What I would ask Daniyar:**
1. Does the designer edit 4K video/3D assets in After Effects/Blender, or primarily 2D UI/print graphics in Figma and Photoshop?
2. Does the 3,000,000 KZT cap need to cover keyboards, mice, headsets, and UPS units, or strictly the four towers, OS licenses, and monitors?
3. Will the accountant work locally on a standalone 1C file, or connect over VPN/RDP to the main office server?

**What I assumed instead:**
* Assumed a **4-year service life**, using 4-slot DDR4 motherboards on the Accountant, Web Developer, and Designer builds for simple RAM upgrades.
* Assumed **Windows 11 Pro** is mandatory for Sales, Accountant (1C + NCALayer), and Designer (Adobe Creative Cloud), while **Ubuntu 26.04.1 LTS** is optimal for the Web Developer.
* Assumed the 3,000,000 KZT budget covers the **4 custom-built towers, 4 monitors, and OS licenses**, leaving **559,977 KZT** unspent buffer to cover keyboards, mice, headsets, and UPS units.
* Assumed standard 21.5" 1080p monitors suffice for Sales, Accountant, and Developer within budget, while the Designer requires a color-calibrated 27" 1440p IPS display.

## 3. What I did
I mapped each employee's daily software stack to its primary hardware bottleneck (RAM for Sales, single-thread CPU and NVMe IOPS for Accountant, 32 GB RAM and multi-core compile speed for Web Developer, color-accurate 1440p monitor and dedicated GPU for Designer) and designed four tailored, self-built PCs using parts in stock on Kaspi.kz (`2026-11-23`). Every build meets the hard baseline of ≥16 GB RAM, a 1 TB NVMe SSD (`Kingston NV3 SNV3S/1000G`), a licensed OS, and a dedicated monitor.

* Detailed load, bottleneck, and trade-off reasoning: [builds.md](builds.md)
* Full itemized pricing and vendor dates: [budget.csv](budget.csv) (Grand Total: **2,440,023 KZT**, leaving **559,977 KZT** under budget)

### Answers to the Director's Three Questions

1. **Which of the four machines will you upgrade first, eighteen months from now, and why?**  
   The **Designer's machine**, specifically adding a **secondary 2 TB NVMe scratch SSD** and upgrading **System Memory from 32 GB to 64 GB DDR4**. The `ASUS PRIME B760-PLUS D4` has two open DDR4 DIMM slots and extra M.2 slots; as creative project assets and Adobe AI features grow over 18 months, a single 1 TB drive holding both Windows and active project scratch files will fill up first.

2. **Price the same four as pre-built machines from a vendor. What does the company gain and what does it lose by not building them?**  
   Comparable pre-built towers from local vendors on Kaspi.kz (priced `2026-11-23`) plus matching monitors and Windows 11 Pro licenses cost roughly **2,850,000 KZT** total (~295,000 KZT for Sales i3-12100/16GB, ~410,000 KZT for Accountant i5-12400/16GB, ~745,000 KZT for Developer i5-13400/32GB + bundled Windows license, and ~1,150,000 KZT for Designer i5-14600KF/RTX 5050, plus ~250,000 KZT for the ProArt monitor upgrade).  
   * **What the company gains:** Single-point vendor warranty on the whole tower, zero internal IT assembly time, and immediate out-of-the-box deployment.  
   * **What the company loses:** Part selection control (pre-builts routinely bundle low-tier PSUs, single-channel RAM, slower QLC SSDs, and uncalibrated monitors), ~410,000 KZT in extra cost, and restricted upgradeability due to warranty seals.

3. **One of these four people will complain about performance within a month. Which one, and about what?**  
   The **Accountant or Web Developer**, complaining about **screen workspace on the compact 21.5" 1080p AOC monitor** (viewing wide multi-column Excel ledgers or splitting code editor + browser DevTools side-by-side on 21.5 inches requires constant horizontal scrolling and window switching). Because I standardized on the 38,990 KZT 21.5" monitor for three roles to absorb high 2026 RAM and SSD prices, screen real estate is the first compromise they will notice daily.

## 4. Evidence
* [evidence/pcpartpicker-links.md](evidence/pcpartpicker-links.md) — Contains PCPartPicker build links verifying socket, DDR4 memory, M.2 slot, case form-factor, and PSU wattage compatibility for all four custom builds.
* [evidence/vendor-quotes/](evidence/vendor-quotes/) — Contains dated screenshots of every component price from `kaspi.kz` captured on `2026-11-23`.

## 5. What I would do differently
I would use ~150,000 KZT of the remaining **559,977 KZT** budget buffer to upgrade the **Accountant and Web Developer monitors from 21.5" 1080p to 27" 1440p IPS displays** and add a **secondary 1 TB/2 TB NVMe scratch drive** to the Designer's workstation.