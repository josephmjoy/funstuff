// ZZ Wall - a simple zig-zag wall, originally intended to exersize the printer 
// because of it's rapid back and forth movements along the y axis.
// Author: Joseph M. Joy

function range(stop, start=0,  step=1) = [start: step: stop-1];

// Coords of an isoceles right triangle
function ir_tri(base) = [[0,0], [base/2, base], [base, 0]];


thickness = 1; // Actually thickness of wall at triangle apex

// Extruded version
module rt_prism(base, height)  {
    linear_extrude(height) polygon(ir_tri(base));
}

// A row of extruded triangles
module prism_rows(tri_height, height, n) {
    for (i = range(n)) {
         translate([(tri_height - thickness)*i, 0, 0]) rt_prism(tri_height, height);
    }
}


// Final grabber structure
module zz_wall(width, height, tri_height = 10) {
    n = width /tri_height; // each row is 3*tri_height, including space
    difference() {
        prism_rows(tri_height, height, n);
        translate([0, 0, -0.5]) scale([1, 1, 1.1]) // to punch holes on ends
        translate([0, - thickness, 0]) prism_rows(tri_height, height, n);

    }
}

scale([1, 2, 1])
zz_wall(25, 50, 5);





