// ============================================================
// PSA Slab Display — V5: SINGLE-PIECE LID
// ============================================================
// The lid SLIDES into the frame from the top edge, like a
// battery cover:
//   - Frame side walls extend up into dovetail RAILS that wrap
//     over the lid's chamfered edges (captures it vertically)
//   - A raised STOP WALL at the bottom edge ends the travel
//   - A tiny detent bump clicks into a divot in the lid at the
//     seated position
// NOTHING flexes more than a few hundredths of a mm -> nothing
// breaks, in any material.
//
// The lid is ONE PIECE (5.3mm) with a rabbet (shallow recess)
// on the mating face for the clear sheet. No sandwich, no pins,
// no second plate.
//
// PRINT (all flat, no supports):
//   "frame" - rails print with 45-degree self-supporting undersides
//   "lid"   - prints mating-face-DOWN (chamfers slope inward = safe)
//
// CLEAR SHEET: see echo() output for dimensions.
// ============================================================

// ---- EXPORT MODE ----
// "frame" | "lid" | "assembled"
export_part = "assembled";

// ---- Slab + fit ----
slab_w = 81;  slab_h = 136;  slab_t = 6.5;
fit = 0.3;  mag_tol = 0.15;

// ---- Walls ---- (original proportions — the slim pass was reverted)
back_t = 2.0;  wall_t = 4.0;  bot_t = 3.5;  top_t = 3.5;  corner_r = 3;

// ---- Slab pocket rim ----
rim_w = 2.0;  rim_extra = 0.3;

// ---- Side magnets (case-to-case linking; flush mount) ----
// 6x2 (not 6x3): a 2mm-deep seat can sit CENTERED on the tall wall
// without breaking into the dovetail channel behind it.
// Bore is 0.4 oversize so printed-hole shrinkage can't block the
// magnet — the crush ribs (sized off mag_d, not the bore) do the
// actual gripping.
// 8x2: biggest disc that sits CENTERED on the wall — the thin 2mm
// profile keeps the seat shallow enough to clear the lid channel.
mag_d = 8;  mag_t = 2;  mags_per_side = 3;
mag_hole_d = mag_d + 0.5;
mag_seat_depth = mag_t + 1.0;   // 3mm bore — magnet at back, 1mm gap for superglue plug

// ---- Closure magnets (lid <-> frame, optional helpers now) ----
cmag_d = 5;  cmag_t = 2;  cmag_tol = 0.2;
cmag_hole_d = cmag_d + cmag_tol;

// ---- Lid (single piece with rabbet for clear sheet) ----
lid_border = 6;
sheet_t       = 0.8;
sheet_clear   = 0.25;
back_plate_t  = 2.8;         // tuck tongue height (matches frame groove)
lid_t         = 5.3;         // total thickness — matches frame channel
lip_t         = 0.4;         // retaining lip on mating face (holds sheet in)
capture       = 3.0;         // sheet overlap past window edge
thumb_notch_r = 8;

// ---- [V4] Slide-lock geometry ----
rail_w    = 2.0;    // rail footprint on top of each side wall
rail_h    = 2.0;    // dovetail height (45-degree faces)
slide_clr = 0.25;   // sliding clearance per side
// Full-height channel: the whole lid nests inside the frame rim, which
// stands 0.6 proud of the lid face — that proud rim doubles as the
// stacking key (nests into the back recess of the case above)
rim_proud = 0.6;
chan_h    = lid_t + rim_proud;       // channel height above frame face
stop_clr  = 0.3;    // lid-to-stop-wall end clearance

// [STACK] GradedGuard-style flat stacking: a recessed CHANNEL ring in
// the back receives the chamfered rim crest of the case below.
// A 0.7 skirt at the outer edge keeps the border anchored to the bed
// (the v1 full-ring recess left the whole border starting mid-air —
// unprintable, caused repeated print failures).
stack_recess_depth = rim_proud + 0.15;
stack_skirt = 0.7;     // outer edge strip that still touches the bed
rim_cham    = 1.0;     // 45-degree chamfer on the rim crest (entry guide)

// [TUCK] Undercut pocket in the stop wall: a tongue on the lid's
// bottom edge slides in, fully capturing the bottom edge
tuck_depth = 0.9;            // how far the tongue enters the wall
tuck_groove = tuck_depth + 0.3;
tuck_hw = 39.7;              // tongue half-width (groove is 40)

// Detent (click at seated position)
det_bump_r = 0.9;   det_bump_protrude = 0.3;
det_divot_r = 1.5;  det_divot_depth = 0.4;


// ---- Derived ----
pocket_w = slab_w + 2*fit;
pocket_h = slab_h + 2*fit;
inner_w  = slab_w - 2*rim_w + 2*fit;
inner_h  = slab_h - 2*rim_w + 2*fit;
outer_w  = pocket_w + 2*wall_t;
outer_h  = pocket_h + top_t + bot_t;
frame_d  = back_t + slab_t + fit;
open_w   = slab_w - 2*lid_border + 2*fit;
open_h   = slab_h - 2*lid_border + 2*fit;
yoff     = (top_t - bot_t) / 2;

// [V4] channel / lid outline
chan_base_hw = outer_w/2 - rail_w;        // 42.8 channel floor half-width
chan_top_hw  = chan_base_hw - rail_h;     // 40.8 between rail tips
lidb_base_hw = chan_base_hw - slide_clr;  // 42.55 back plate at mating face
lidb_top_hw  = lidb_base_hw - rail_h;     // 40.55 back plate above chamfer
stop_y   = -(outer_h/2) + bot_t + yoff;   // inner face of bottom stop wall
lid_y0   = stop_y + stop_clr;             // lid bottom edge
lid_y1   = outer_h/2 + yoff;              // lid top edge (flush w/ frame)
lid_len  = lid_y1 - lid_y0;
lid_yc   = (lid_y0 + lid_y1) / 2;

// Sheet groove area (C-channel behind retaining lip)
rabbet_w   = open_w + 2*capture;
rabbet_bot = yoff - open_h/2 - capture;
rabbet_top = lid_y1 + 1;

sheet_w = rabbet_w - 2*sheet_clear;
sheet_h = lid_y1 - rabbet_bot - 1;

// Detent positions
det_y  = lid_yc;                          // centered vertically on the lid
det_x  = (pocket_w/2 + chan_base_hw)/2;   // centered on the side ledges (41.7)

// Side magnet height: centered in the frame body (not the channel area)
// so the full 4mm wall is behind the seat — no breakthrough into the
// dovetail channel. Magnets stay fully captured.
smag_z = frame_d / 2;

// [V5] Stacking magnet x positions (must sit in the solid part of the
// top edge band, i.e. below frame_d — any x inside the walls works)
stackmag_x = 30;

// Push-out hole in the back floor (centered on the slab)
push_hole_d = 18;


// Closure magnet corner positions (unchanged)
cmag_inset = 6 + cmag_d/2;
cmag_xy = [
    [-(outer_w/2) + cmag_inset, -(outer_h/2) + cmag_inset + yoff],
    [ (outer_w/2) - cmag_inset, -(outer_h/2) + cmag_inset + yoff],
    [-(outer_w/2) + cmag_inset,  (outer_h/2) - cmag_inset + yoff],
    [ (outer_w/2) - cmag_inset,  (outer_h/2) - cmag_inset + yoff]
];

$fn = 96;
module rrect(w,h,r) { offset(r) offset(-r) square([w,h], center=true); }


echo(str("=== CUT CLEAR SHEET TO: ", sheet_w, " x ", sheet_h,
         " mm, thickness <= ", sheet_t, " mm ==="));


// ============================================================
// FRAME with slide rails + bottom stop
// ============================================================
module frame() {
    difference() {
        // Full outline up to rail top; the channel cut leaves
        // rails on the sides, a stop wall at the bottom, and an
        // open insertion mouth at the top edge.
        linear_extrude(frame_d + chan_h)
            rrect(outer_w, outer_h, corner_r);

        // [V4] Lid slide channel — dovetail profile, open at top edge
        translate([0, lid_y1 + 5, 0])
            rotate([90, 0, 0])
                linear_extrude(lid_y1 + 5 - stop_y)
                    polygon([
                        [-chan_base_hw, frame_d],
                        [ chan_base_hw, frame_d],
                        [ chan_top_hw,  frame_d + rail_h],
                        [ chan_top_hw,  frame_d + chan_h + 5],
                        [-chan_top_hw,  frame_d + chan_h + 5],
                        [-chan_top_hw,  frame_d + rail_h]
                    ]);

        // Outer slab pocket
        translate([0, yoff, back_t])
            linear_extrude(slab_t + fit + 0.1)
                rrect(pocket_w, pocket_h, 1.5);

        // Inner pocket (stepped ledge)
        translate([0, yoff, back_t - rim_extra])
            linear_extrude(slab_t + fit + rim_extra + 0.1)
                rrect(inner_w, inner_h, 1);

        // Side magnets L — 3mm bore from outside. Push magnet to the back
        // with a stick, then fill the remaining 1mm with superglue. The
        // glue bonds to the PLA bore walls (strong) and blocks the magnet.
        for (i = [0:mags_per_side-1]) {
            yp = (i+1)*pocket_h/(mags_per_side+1) - pocket_h/2 + yoff;
            translate([-(outer_w/2) - 0.01, yp, smag_z])
                rotate([0, 90, 0])
                    cylinder(d = mag_hole_d, h = mag_seat_depth + 0.01);
        }
        // Side magnets R
        for (i = [0:mags_per_side-1]) {
            yp = (i+1)*pocket_h/(mags_per_side+1) - pocket_h/2 + yoff;
            translate([(outer_w/2) + 0.01, yp, smag_z])
                rotate([0, -90, 0])
                    cylinder(d = mag_hole_d, h = mag_seat_depth + 0.01);
        }
        // (Top/bottom edge stacking-magnet holes removed per final design.)

        // Push-out hole — thumb through the back pops the slab out of
        // the pocket without prying
        translate([0, yoff, -0.1])
            cylinder(d = push_hole_d, h = back_t + 0.2);

        // [TUCK] Undercut groove in the stop wall for the lid's tongue
        translate([-(tuck_hw + 0.3), stop_y - tuck_groove, frame_d])
            cube([2*(tuck_hw + 0.3), tuck_groove + 0.1, back_plate_t + 0.4]);

        // [STACK] Channel-ring recess in the back (between the outer
        // skirt and the central plateau): the rim crest of the case
        // below keys into it. Roof bridges skirt-to-plateau — printable.
        difference() {
            translate([0, 0, -0.05])
                linear_extrude(stack_recess_depth + 0.05)
                    rrect(outer_w - 2*stack_skirt, outer_h - 2*stack_skirt, 2.3);
            translate([0, 0, -0.1])
                linear_extrude(stack_recess_depth + 0.2)
                    rrect(2*(chan_base_hw - 0.4), 2*(-(stop_y) - 0.3), 2);
        }

        // [STACK] 45-degree chamfer around the rim crest — narrows the
        // rim to fit the recess channel above and self-centers the stack
        translate([0, 0, frame_d + chan_h - rim_cham])
            difference() {
                translate([0, 0, 0.001])
                    linear_extrude(rim_cham + 0.15)
                        rrect(outer_w + 0.2, outer_h + 0.2, corner_r);
                translate([0, 0, -0.05])
                    linear_extrude(rim_cham + 0.25,
                        scale = [(outer_w - 2*(rim_cham + 0.15))/outer_w,
                                 (outer_h - 2*(rim_cham + 0.15))/outer_h])
                        rrect(outer_w, outer_h, corner_r);
            }

        // (Corner closure-magnet pockets REMOVED: on the frame side they
        // always landed inside the slab pocket — no solid material there.
        // Closure is the slide-lock + detent; side magnets remain for
        // case-to-case linking.)

    }

    // Grip bumps inside slab pocket. Side bumps sit at pocket_h/3 —
    // clear of the through-wall magnet holes (at 0 and ±pocket_h/4),
    // which would otherwise erase the wall they attach to.
    bump_r = 0.4;
    for (s = [-1, 1]) for (i = [-1, 1])
        translate([s*(pocket_w/2 - bump_r + 0.05),
                   i*pocket_h/3 + yoff,
                   back_t + slab_t/2])
            sphere(r = bump_r, $fn = 16);
    for (i = [-1, 1]) {
        translate([i*pocket_w/4,
                   -(pocket_h/2) + bump_r - 0.05 + yoff,
                   back_t + slab_t/2])
            sphere(r = bump_r, $fn = 16);
        translate([i*pocket_w/4,
                   (pocket_h/2) - bump_r + 0.05 + yoff,
                   back_t + slab_t/2])
            sphere(r = bump_r, $fn = 16);
    }


    // [V4] Detent bumps on the side ledges near the stop — click
    // into the lid's divots in the last 2mm of travel. (Must sit on
    // the ledges: the channel center is open slab pocket below.)
    for (sx = [-1, 1])
        translate([sx*det_x, det_y, frame_d - det_bump_r + det_bump_protrude])
            sphere(r = det_bump_r, $fn = 32);
}


// ============================================================
// V5 LID — single piece, 5.3mm thick
// z=0 is the mating face (rides the channel floor); z=lid_t is
// the outer face. Dovetail-chamfered sides match the frame rails.
// A shallow rabbet on the mating face holds the clear sheet.
// Prints mating-face-DOWN: chamfers slope inward going up = safe.
// ============================================================
module lid() {
    difference() {
        union() {
            // Chamfered section (z=0 to rail_h): wide base tapers to narrow
            hull() {
                translate([0, lid_yc, 0])
                    linear_extrude(0.01)
                        rrect(2*lidb_base_hw, lid_len, 2);
                translate([0, lid_yc, rail_h])
                    linear_extrude(0.01)
                        rrect(2*lidb_top_hw, lid_len, 2);
            }
            // Straight section (rail_h to lid_t)
            translate([0, lid_yc, rail_h])
                linear_extrude(lid_t - rail_h)
                    rrect(2*lidb_top_hw, lid_len, 2);

            // [TUCK] Bottom-edge tongue — slides into the stop-wall groove
            translate([-tuck_hw, lid_y0 - tuck_depth, 0])
                cube([2*tuck_hw, tuck_depth + 2, back_plate_t]);
        }

        // Viewing window — through-cut
        translate([0, yoff, -0.1])
            linear_extrude(lid_t + 0.2)
                rrect(open_w, open_h, 2);

        // Sheet grooves behind retaining lip — C-channel (left, right, bottom).
        // Each groove is only ~3.25mm wide so the slicer bridges them easily.
        // The lip (0.4mm at z=0) keeps the sheet from falling out.
        groove_h = sheet_t + sheet_clear;
        groove_w = capture + sheet_clear;

        // Left edge groove
        translate([-rabbet_w/2, rabbet_bot, lip_t])
            cube([groove_w, rabbet_top - rabbet_bot, groove_h + 0.05]);
        // Right edge groove
        translate([rabbet_w/2 - groove_w, rabbet_bot, lip_t])
            cube([groove_w, rabbet_top - rabbet_bot, groove_h + 0.05]);
        // Bottom edge groove
        translate([-rabbet_w/2, rabbet_bot, lip_t])
            cube([rabbet_w, groove_w, groove_h + 0.05]);

        // Entry slot at top — remove lip so sheet slides in from above
        translate([-rabbet_w/2, lid_y1 - 1, -0.05])
            cube([rabbet_w, 5, lip_t + groove_h + 0.1]);

        // Detent divots in mating face (over the frame's ledge bumps)
        for (sx = [-1, 1])
            translate([sx*det_x, det_y, -(det_divot_r - det_divot_depth)])
                sphere(r = det_divot_r, $fn = 32);

        // Thumb notch at top edge — grip the sheet AND the lid
        translate([0, lid_y1, -0.1])
            cylinder(r = thumb_notch_r, h = lid_t + 0.2);
    }
}



// ============================================================
// EXPORT / DISPLAY ROUTING
// ============================================================
if (export_part == "frame") {
    frame();
}
else if (export_part == "lid") {
    // Prints mating-face-down (chamfers slope inward = safe)
    lid();
}
else if (export_part == "section") {
    difference() {
        union() {
            frame();
            translate([0, 0, frame_d]) lid();
        }
        translate([-200, 0, -200]) cube([400, 400, 400]);
    }
}
else {
    // "assembled" — lid seated on frame
    frame();
    color("LightBlue", 0.7) translate([0, 0, frame_d])
        lid();
}
