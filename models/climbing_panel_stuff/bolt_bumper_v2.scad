// Bumper that goes around climbing hold bolt so it 
// has a more rounder profile.
// This version (v2) has a smaller diameter - designed to go
// *over* a 1.5" fender washer. 
include <BOSL2/std.scad>

I2MM = 25.4;
bolt_dia = 0.56 * I2MM; // Diameter of bolt head
gap = (1/32) * I2MM;
hole_dia = bolt_dia + 2*gap;
hole_depth = 0.4 * I2MM; // Height of the bolt head
outer_dia = 1.5*I2MM; // MUST match fender washer dia exactly!
inner_rounding_radius = 0.1 * I2MM;
outer_rounding_radius = 1.0 * inner_rounding_radius;
$fn = 50; // Set the resolution for smooth curves


module shape2d() {
    h = hole_depth;
    w = (outer_dia - hole_dia)/2;
    ri = inner_rounding_radius;
    ro = outer_rounding_radius;
    shape = [[0, 0], [0, h], [ri + ri*0.5, h], [w, ro], [w, 0]];
    radii = [0, ri, ri, ro, 0];
    x = round_corners(shape, radius = radii);
    polygon(x);
    //polygon(shape);
}


// 2D shape to be rotate_extruded, lying 
// in correct position along xy plane
module shape2dx() {
    wx2 = (outer_dia - hole_dia)/2;
    wy2 = hole_depth;
    ri = inner_rounding_radius;
    ro = outer_rounding_radius;
    union() {
        // translate([wx2/2 + hole_dia/2, wy2/2, 0]) {
        //    tapered2d();
        //}
        // This is the old version and it won't work because it's hard to specify
        // exact final dimensions.
        // x = round_corners(right_triangle([wx2 + 1.455*ro,wy2]), radius = [ro, 0, ri]);

        translate([hole_dia/2, 0, 0]) {
            % polygon(x);
            square([wx2,ro]);
        }
        
    }
}


module final() {
  rotate_extrude() shape2d();
}

module test() {
  shape2d();
}
    
//final();
test();
       