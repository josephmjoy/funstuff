// Brass Nut Mount for DIY Jack - see README.md for details.
// Author: Joseph M. Joy

function range(stop, start=0,  step=1) = [start: step: stop-1];
function range(start, stop, step) = [start: step: stop-1];

//module hexagon(base) = [[0,0], [0, base], [base, 0]];

base_thickness = 3;
base_width = 15;
base_corner_radius = 3; // For Minkowski corners
bolt_hole_dia = 4;
cylinder_dia = 10;
hex_bolt_dia = 5; // from corner to corner
hex_hole_dia = hex_bolt_dia + 1;
hex_bolt_height = 5;
EPSILON = 0.01;


// Create {n} bolt holes in a circle centered on ({x},{y}) and with radius r
// Bolt-hole radius is 2*bolt_hole_dia
module bolt_holes(x, y, r) {
    translate([x, y, -EPSILON ]) {
        for (a = range(45, 360, 90)) {
            rotate([0, 0, a]) translate([r, 0, 0])
                cylinder(base_thickness+2*EPSILON, r=bolt_hole_dia/2);

        }
    }
}

// base
module base() {
    reduced_width = base_width - 2*base_corner_radius;
    bolt_circle_radius = reduced_width/2;
    difference() {
        minkowski() {
                
                cube([reduced_width, reduced_width, base_thickness]);
                cylinder(EPSILON/2, r=base_corner_radius);
            }
        bolt_holes(reduced_width/2, reduced_width/2, bolt_circle_radius);
        }
}



module nut_mount() {
    base();
    //bolt_holes(0, 0, cylinder_dia, 4);
    //cylinder(base_thickness, r=bolt_hole_dia/2);
}

nut_mount();

