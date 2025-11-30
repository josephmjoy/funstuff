// A spacing guide for 6" spaced holes on a square grid.
// The guide also includes measurement for the diagonal.

$fn = 50;
I2MM = 25.4;
dist = 6 * I2MM; // square spacing.
diag_dist = sqrt(2) * dist; // diagonal
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
            disk(diag_dist, r, r);
        }
    }
}

module ruler_punchouts() {
    r = width/2;
    r1 = 1;
    r2 = 1.3;
    union() {
        disk(0, r1, r2);
        disk(dist, r1, r2);
        disk(diag_dist, r1, r2);
        notch(-r, 0);
        notch(0, r);
        notch(0, -r);
        notch(dist, r);
        notch(dist, -r);
        notch(diag_dist, r);
        notch(diag_dist, -r);
        notch(diag_dist + r, 0);
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

