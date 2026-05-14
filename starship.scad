// Stylized starship — original parametric geometry, CC0.
// Classic explorer silhouette: saucer + secondary hull + twin nacelles.
// Designed for the H2D + 0.6 HF nozzle build log in README.md.
//
// Render one part at a time for export, or set part = "assembled"
// for a preview of the whole ship.
//
// Usage:
//   1. Set `part` below to the piece you want to export.
//   2. Render (F6), then File > Export > STL.
//   3. Slice each STL in its assigned filament color (see README §7).
//
// All dimensions in millimetres. Default length ≈ 340 mm (fits H2D bed
// with a 5 mm margin). Scale `length` to taste — every other dimension
// is derived from it.

/* [Master scale] */
length        = 340;     // overall assembled length, mm

/* [Render selection] */
// "assembled" | "saucer" | "hull" | "neck" | "pylon_l" | "pylon_r"
// | "nacelle_l" | "nacelle_r" | "deflector" | "bussard_l" | "bussard_r"
// | "bridge" | "impulse"
part          = "assembled";

/* [Detail] */
$fa           = 2;
$fs           = 0.6;     // matches nozzle line width — fast preview, smooth STL

// ---------- derived proportions ----------
saucer_d      = length * 0.55;   // saucer diameter
saucer_h      = saucer_d * 0.12; // saucer thickness
hull_l        = length * 0.55;   // engineering hull length
hull_d        = saucer_d * 0.28; // engineering hull diameter
neck_h        = saucer_d * 0.18;
nacelle_l     = length * 0.62;
nacelle_d     = hull_d * 0.55;
pylon_t       = nacelle_d * 0.35;
bussard_d     = nacelle_d * 1.05;
deflector_d   = hull_d * 0.85;

// horizontal offset from hull axis to each nacelle axis
nacelle_spread = saucer_d * 0.32;
// vertical offset (nacelles above engineering hull)
nacelle_lift   = hull_d * 0.95;
// hull is shifted aft of saucer center so saucer overhangs the bow
hull_shift_x   = length * 0.18;

// ---------- modules ----------

module saucer() {
    // tapered double-disc: top dome + bottom dish
    color("silver") {
        // main disc — flattened ellipsoid
        scale([1, 1, saucer_h / saucer_d])
            sphere(d = saucer_d);
        // raised inner ring (bridge platform area)
        translate([saucer_d * 0.05, 0, saucer_h * 0.45])
            scale([1, 1, 0.35])
                sphere(d = saucer_d * 0.45);
    }
}

module bridge() {
    // small dome that sits on top of the saucer
    color("red")
        translate([saucer_d * 0.18, 0, saucer_h * 0.55 + saucer_d * 0.05])
            scale([1.2, 1, 0.7])
                sphere(d = saucer_d * 0.09);
}

module impulse() {
    // wedge-shaped impulse engine block at the aft edge of the saucer
    color("red")
        translate([-saucer_d * 0.48, 0, 0])
            rotate([0, 0, 0])
                scale([1, 2.2, 0.5])
                    sphere(d = saucer_d * 0.08);
}

module hull() {
    // engineering hull — elongated ellipsoid, tapered aft
    color("silver")
        translate([-hull_shift_x, 0, -neck_h])
            rotate([0, 90, 0])
                scale([hull_d / hull_l, hull_d / hull_l, 1])
                    sphere(d = hull_l);
}

module neck() {
    // swept connector between saucer underside and hull dorsal
    color("silver")
        translate([hull_d * 0.4, 0, -neck_h * 0.5])
            rotate([0, 15, 0])
                scale([0.45, 0.7, 1])
                    cylinder(h = neck_h, d1 = hull_d * 0.9, d2 = hull_d * 0.7, center = true);
}

module deflector() {
    // dish recessed into the bow of the engineering hull
    color("royalblue")
        translate([hull_l * 0.42 - hull_shift_x, 0, -neck_h])
            rotate([0, 90, 0])
                scale([1, 1, 0.35])
                    sphere(d = deflector_d);
}

module pylon(side = 1) {
    // angled strut from engineering hull dorsal up & out to nacelle
    // side: +1 = port, -1 = starboard (in OpenSCAD's +Y/-Y)
    color("silver") {
        hull() {
            // root: small ellipse on the hull
            translate([-hull_shift_x - hull_l * 0.05, side * hull_d * 0.15, -neck_h + hull_d * 0.25])
                rotate([0, 90, 0])
                    scale([1, 0.4, 1])
                        sphere(d = pylon_t);
            // tip: at the nacelle mount
            translate([-hull_shift_x - hull_l * 0.05,
                       side * nacelle_spread,
                       -neck_h + nacelle_lift])
                rotate([0, 90, 0])
                    scale([1, 0.4, 1])
                        sphere(d = pylon_t * 0.9);
        }
    }
}

module nacelle(side = 1) {
    // cylindrical warp nacelle with tapered tail and bussard cap
    color("silver")
        translate([-hull_shift_x - hull_l * 0.05,
                   side * nacelle_spread,
                   -neck_h + nacelle_lift])
            rotate([0, 90, 0]) {
                // main body
                translate([0, 0, -nacelle_l * 0.5])
                    cylinder(h = nacelle_l, d1 = nacelle_d * 0.7, d2 = nacelle_d);
                // aft cap (smooth dome)
                translate([0, 0, -nacelle_l * 0.5])
                    scale([1, 1, 0.4])
                        sphere(d = nacelle_d * 0.7);
            }
}

module bussard(side = 1) {
    // glowing fore cap on the nacelle — printed in blue
    color("royalblue")
        translate([-hull_shift_x - hull_l * 0.05 + nacelle_l * 0.5,
                   side * nacelle_spread,
                   -neck_h + nacelle_lift])
            rotate([0, 90, 0])
                scale([1, 1, 0.55])
                    sphere(d = bussard_d);
}

// ---------- top-level: assembled vs per-part export ----------

module assembled() {
    saucer();
    bridge();
    impulse();
    neck();
    hull();
    deflector();
    pylon(1);  pylon(-1);
    nacelle(1); nacelle(-1);
    bussard(1); bussard(-1);
}

// Per-part export translates the chosen part to the origin so STL
// bounds make sense in the slicer.

if      (part == "assembled") assembled();
else if (part == "saucer")    saucer();
else if (part == "bridge")    translate([-saucer_d * 0.18, 0, -saucer_h * 0.55 - saucer_d * 0.05]) bridge();
else if (part == "impulse")   translate([ saucer_d * 0.48, 0, 0]) impulse();
else if (part == "hull")      translate([ hull_shift_x, 0, neck_h]) hull();
else if (part == "neck")      translate([-hull_d * 0.4, 0, neck_h * 0.5]) neck();
else if (part == "deflector") translate([-(hull_l * 0.42 - hull_shift_x), 0, neck_h]) deflector();
else if (part == "pylon_l")   translate([ hull_shift_x + hull_l * 0.05, 0, neck_h - nacelle_lift * 0.5]) pylon(1);
else if (part == "pylon_r")   translate([ hull_shift_x + hull_l * 0.05, 0, neck_h - nacelle_lift * 0.5]) pylon(-1);
else if (part == "nacelle_l") translate([ hull_shift_x + hull_l * 0.05, -nacelle_spread, neck_h - nacelle_lift]) nacelle(1);
else if (part == "nacelle_r") translate([ hull_shift_x + hull_l * 0.05,  nacelle_spread, neck_h - nacelle_lift]) nacelle(-1);
else if (part == "bussard_l") translate([ hull_shift_x + hull_l * 0.05 - nacelle_l * 0.5, -nacelle_spread, neck_h - nacelle_lift]) bussard(1);
else if (part == "bussard_r") translate([ hull_shift_x + hull_l * 0.05 - nacelle_l * 0.5,  nacelle_spread, neck_h - nacelle_lift]) bussard(-1);
else assembled();
