# SlabLock

A 3D-printed display case for PSA-graded card slabs, designed in OpenSCAD and printed on a Bambu X2D (PLA).

## Features

- Slide-lock lid with 45-degree dovetail rails (no flex parts, nothing breaks)
- Side magnets (8x2mm N52) for case-to-case linking
- Flat stacking with chamfered rim keying
- Single-piece lid (V5) with retaining groove for clear plastic sheet
- Push-out hole for easy slab removal

## Files

- `POLYGENCE_SLIDE_LOCK.scad` — parametric OpenSCAD source (single file, all parts)
- `BUILD_LOG.md` — design iteration history, mistakes, and lessons learned
- `stl/` — exported STL files by version

## Printing

- **Printer**: Bambu X2D (or any FDM)
- **Material**: PLA
- **Export**: Set `export_part` in the SCAD file — `"frame"` or `"lid"`
- **Orientation**: Frame prints back-face down, lid prints mating-face down
- **No supports needed**

## Clear Sheet

Cut a clear plastic sheet (PET or acetate) to the dimensions shown in the OpenSCAD console output. The sheet slides into the lid's C-channel grooves from the top edge.

## Magnets

8x2mm N52 neodymium discs, 3 per side. Use CA glue or 5-minute epoxy (not Gorilla Glue). Mark polarity with Sharpie before installing.
