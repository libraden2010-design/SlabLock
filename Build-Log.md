# SlabLock Build Log

PSA slab display case — designed in OpenSCAD, printed on Bambu X2D (PLA).

---

## V1 — Initial Frame + Two-Piece Lid

**Goal**: A slim frame that holds a PSA-graded card slab, with a slide-on lid and side magnets for case-to-case linking.

**Design decisions**:
- Frame with recessed slab pocket (81 x 136 x 6.5mm slab, 0.3mm fit tolerance)
- Slide-lock lid in two pieces (back plate + front plate) that sandwiches a clear plastic sheet
- Side magnets: 3 per side, Total Element 8x2mm N52 neodymium
- Closure magnets in corners for lid retention
- Push-out hole in back face so you can pop the slab out with your thumb

**What worked**:
- Frame printed cleanly on first try
- Slide-lock mechanism engages and holds
- Slab fits in the pocket with good tolerance

**What didn't work**:
- Magnet bores punched through into the lid channel wall (only ~2mm thick at that Z height)
- Glue leaked into the lid channel through the bore-through
- N52 magnets pulled each other out of their bores despite superglue — the glue bond on the smooth magnet surface was too weak

---

## V2 — Magnet Position Fix

**Problem**: Magnet bores at the original Z height (near the lid channel) bored through only 2mm of wall.

**Fix**: Moved `smag_z` from channel area to `frame_d / 2` — centers the bore in the full 4mm wall body. No more bore-through.

**Result**: Bores no longer leak into the channel. But magnets still pulled out.

---

## V3 — "Stepped Bore" Attempt (Failed)

**Problem**: Magnets still get yanked out by adjacent magnets.

**Attempted fix**: Designed a "stepped bore" — wide 8.5mm chamber inside with a narrow 6.5mm mouth at the entrance. Idea was that the magnet presses past the step during assembly and is physically trapped.

**What actually happened**: The OpenSCAD code was buggy. Both cylinder cuts used the same diameter (`mag_hole_d = 8.5mm`), so there was literally no step. Just a straight 2.8mm hole. The "retention mechanism" never existed.

**Lesson**: Always verify generated geometry in the preview — don't assume the code does what the comments say.

---

## V4 — Deep Bore + Glue Plug (Current)

**Problem**: Need actual magnet retention that works.

**Fix**: Simple 3mm deep bore (was 2.2mm). The magnet (2mm thick) gets pushed to the back of the bore, leaving 1mm of empty space at the entrance. Fill that gap with adhesive.

**Why this works**: The adhesive bonds to the PLA bore walls all around (PLA-to-adhesive = strong bond), not to the magnet's smooth surface (weak bond). The cured plug physically blocks the magnet from exiting.

**Adhesive findings**:
- Gorilla Glue (polyurethane): BAD — expands and foams, leaves white residue around the bore entrance
- Superglue (CA): Better — cures clear, no foam, but works best in thin layers
- 5-minute epoxy: Best — fills gaps well, cures rigid, strong PLA bond

**Polarity tip**: Stack all magnets, mark the same face with Sharpie before installing. All marked faces point the same direction so cases attract.

---

## Kickstand — Attempted and Abandoned

Tried 6+ designs for a fold-flat kickstand recessed into the back face:

1. **Clip-on bar** — rejected
2. **Hinge pin** — too tight, wouldn't rotate
3. **Snap-in posts** — couldn't snap into place
4. **Slide-out strip** — extended below frame edge, ugly
5. **Built-in shelf** — terrible
6. **Drop-in U-cradle with nubs** — nubs were too small (1.6mm plate), retaining bumps (0.3mm spheres) did nothing. Kickstand looked "just floating" with no convincing mechanical connection
7. **Pivot pins with slots** — 1.2mm pins on frame walls, matching slots in kickstand. Geometrically sound but plate too thin (1.6mm) for reliable pin engagement

**Core constraint**: The back wall is only 2mm thick (`back_t`), and the kickstand pocket overlaps with the slab pocket in Z, limiting pocket depth. A 1.6mm plate is too thin for any robust pivot mechanism (pin holes, snap fits, etc.).

**Decision**: Removed the kickstand entirely. A separate stand or easel is simpler and more reliable.

**Lesson**: Don't force a mechanism into geometry that can't support it. The 2mm back wall was never enough for a integrated hinge.

---

## Lid — V4 Two-Piece (Replaced)

The V4 lid was two printed plates that sandwiched a hand-cut clear plastic sheet:
- `lid_back`: sat on the frame's front face, had the slide-lock tongue
- `lid_front`: clipped over lid_back, trapped the clear sheet between them

**Problems**:
- Two separate parts + a cut sheet = 3 components for one lid
- Assembly was fiddly (alignment pins, gluing two plates together)
- Overkill for just holding a clear window

---

## Lid — V5 Single Piece (Current)

**Problem**: Two-piece lid was unnecessarily complex.

**Fix**: Merged `lid_back` and `lid_front` into a single `lid()` module. Same 5.3mm total thickness so it fits the existing frame channel without reprinting.

**Design**:
- Same dovetail-chamfered XZ profile as old `lid_back` (wide base 42.55mm, narrow top 40.55mm)
- Rabbet (shallow recess, ~1.05mm deep) on the mating face holds the clear sheet
- Through-cut viewing window
- Tuck tongue at bottom edge (same as before)
- Detent divots (same as before)
- Thumb notch at top edge for gripping
- No pins, no second plate, no glue sandwich

**Removed**: `lid_front` module, alignment pins (`pin_d`, `pin_h`, `pin_xy`), `slot_gap`, `front_plate_t`, `front_web_t`, `lidf_hw`. Old `slot_w`/`slot_y_bot` renamed to `rabbet_w`/`rabbet_bot`.

**Export**: `export_part="lid"` (replaces "lid_back", "lid_front", "lid_both")

**Status**: STLs exported (V5_frame.stl, V5_lid.stl). Frame unchanged — only the lid was redesigned.

---

## Printing Notes

- **Printer**: Bambu X2D
- **Material**: PLA
- **Orientation**: Frame prints back-face down. Lid prints mating-face down.
- **FDM hole shrinkage**: Printed holes come out 0.2-0.5mm smaller than designed. The 8.5mm magnet bore (`mag_d + 0.5`) accounts for this.
- **Clear sheet**: Cut to 75.1 x 136.1mm, thickness 0.8mm or less. X-Acto knife.

---

## Open Items

- [x] Redesign lid as single piece with rabbet for clear sheet (V5)
- [ ] Print V5 lid and test fit
- [ ] Test epoxy vs CA glue for magnet retention long-term
- [ ] Evaluate whether a separate stand/easel is needed
- [ ] Cut clear plastic sheet to size (75.1 x 136.1mm, <=0.8mm thick)
