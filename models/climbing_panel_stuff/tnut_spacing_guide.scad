// A spacing guide for 6" spaced holes on a square grid.
// The guide also includes measurement for the diagonal.

$fn = 50;
I2MM = 25.4;
AFTER_DRILLING = true; // To make after-drilling check guide

// This is to make the whole thing wider since the holes are 
// larger
extra_width = AFTER_DRILLING ? 0.25 * I2MM : 0;


dist = 6 * I2MM; // square spacing.
diag_dist = sqrt(2) * dist; // diagonal
clearance = 1.5 * I2MM; // Min distance from hole center to edge of plywood
width = 0.75 * I2MM + extra_width;
notch_edge = 0.1 * I2MM;
thickness = 2; // ruler thickness
small_hole_dia = 2;
big_hole_dia = 7/16 * I2MM;

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
            // Don't care about clearance holes for after drilling
            // guide
            if (AFTER_DRILLING)
                disk(diag_dist, r, r);
            else
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
    guide_r1 = small_hole_dia/2;
    guide_r2 = guide_r1 + 0.3; // slight flaring on top end for pencil-point
    bolt_r1 = AFTER_DRILLING ? big_hole_dia/2 : guide_r1;
    bolt_r2 = AFTER_DRILLING ? bolt_r1 : guide_r2;  
    
    union() {
        disk(0, bolt_r1, bolt_r2);
        disk(dist/2, guide_r1, guide_r2);
        disk(dist, bolt_r1, bolt_r2);
        disk(dist + clearance, guide_r1, guide_r2);
        disk(diag_dist, bolt_r1, bolt_r2);
        disk(diag_dist + clearance, guide_r1, guide_r2);
        notch_punchouts(0);
        notch_punchouts(dist/2);
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

