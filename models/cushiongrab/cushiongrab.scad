// Cushion Grabber - see README.md for details.
// Author: Joseph M. Joy

function range(stop, start=0,  step=1) = [start: step: stop-1];

// Coords of an isoceles right triangle
function ir_tri(base) = [[0,0], [0, base], [base, 0]];

// Extruded version
module rt_prism(base, height)  {
    linear_extrude(height) polygon(ir_tri(base));
}

// A row of them
module prism_rows(base, height, n) {
    for (i = range(n)) {
         translate([2*base*i, 0, 0]) rt_prism(base, height);
    }
}

// 

prism_rows(10, 40, 10);





