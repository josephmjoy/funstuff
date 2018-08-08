// Cushion Grabber - see README.md for details.
// Author: Joseph M. Joy

function range(stop, start=0,  step=1) = [start: step: stop-1];

// Coords of an isoceles right triangle
function ir_tri(base) = [[0,0], [0, base], [base, 0]];

// Extruded version
module rt_prism(base, height)  {
    linear_extrude(height) polygon(ir_tri(base));
}

// A row of extruded triangles
module prism_rows(base, height, n) {
    for (i = range(n)) {
         translate([2*base*i, 0, 0]) rt_prism(base, height);
    }
}

// Dome - used for differencing
module dome(width) {
    r = 10;
    ceiling_height = 3; // inner height;
    outer_height = r; // height of top of dome from above
    scale([1, ceiling_height/r, 1])
        difference() {
            translate([-r, -r, -r]) cube([width+2*r, 3*outer_height, width+2*r]);
            translate([r, -r, r]) minkowski() {
                cube([width-2*r, r, width-2*r]);
                sphere(r);
            }
        }
}

// Final grabber structure
module cushion_grabber(width) {
    tri_height = 2;
    base_height = 1;
    n = width / (2*tri_height); // each row is 2*tri_height, including space
    translate([0, width, 0]) rotate([90, 0, 0])
    difference() {
        union() {        
            cube([width, base_height, width]);
            translate([0, base_height, 0]) prism_rows(tri_height, width, n);
        }
        dome(width);
    }
}


cushion_grabber(50);
//dome(100);





