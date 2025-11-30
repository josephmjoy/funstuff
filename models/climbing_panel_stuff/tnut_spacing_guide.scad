// A spacing guide for 6" spaced holes on a square grid.
// The guide also includes measurement for the diagonal.

$fn = 50;
I2MM = 25.4;
dist = 6 * I2MM; // square spacing.
diag_dist = sqrt(2) * dist; // diagonal
clearance = 1.5 * I2MM; // Min distance from hole center to edge
width = 0.75 * I2MM;
notch_edge = 0.1 * I2MM;
thickness = 2; // ruler thickness

// cuts a v-shape notch if center is positioned on edge of shape
module notch(x, y) {
    linear_extrude(thickness) translate([x, y, 0]) rotate([0,0,45]) square(notch_edge, center=true);
}


module disk(x, r1, r2) {
    translate([x, 0, 0])
        cylinder(h=thickness, r1=r1, r2=r2);
}


// the ruler shape
module ruler_blank() {
    hull() {
        r = width/2;
        union() {
            disk(0, r, r);
            disk(dist, r, r);
            disk(dist + clearance, r, r);
            disk(diag_dist, r, r);
            disk(diag_dist + clearance, r, r);
        }
    }
}

module notch_punchouts(x) {
    r = width/2;
    notch(x, -r);
    notch(x, +r);
    notch(x+r, 0);
    notch(x-r, 0);
}

module ruler_punchouts() {
    r = width/2;
    r1 = 1;
    r2 = 1.3;
    union() {
        disk(0, r1, r2);
        disk(dist, r1, r2);
        disk(dist + clearance, r1, r2);
        disk(diag_dist, r1, r2);
        disk(diag_dist + clearance, r1, r2);
        notch_punchouts(0);
        notch_punchouts(dist);
        notch_punchouts(diag_dist);
    }
}

module ruler() {
    difference() {
        ruler_blank();
        ruler_punchouts();
    }
}

//ruler_punchouts();
//notch(20, 30);
ruler();

