// Bumper that goes around climbing hold bolt so it 
// has a more rounder profile
include <BOSL2/std.scad>

I2MM = 25.4;
washer_dia = 1 * I2MM;
gap = (1/16) * I2MM;
base_thickness = (1/16) * I2MM;
hole_dia = washer_dia + 2*gap;
hole_depth = 0.5 * I2MM;
outer_dia = hole_dia + 1.3*I2MM;
outer_rounding_radius = 0.5 * I2MM;
inner_rounding_radius = 0.1 * I2MM;
bolt_hole_dia = 7/16 * I2MM;
$fn = 50; // Set the resolution for smooth curves


// 2D shape to be rotate_extruded, lying 
// in correct position along xy plane
module shape2d() {
    wx2 = (outer_dia - hole_dia)/2;
    wy2 = hole_depth + base_thickness;
    r2 = inner_rounding_radius;
    r1 = outer_rounding_radius;
    union() {
        translate([wx2/2 + hole_dia/2, wy2/2, 0]) {
            rect([wx2,wy2], rounding=[r1,r2,0,0]);
        }
        translate([bolt_hole_dia/2, 0, 0])
            square([(hole_dia - bolt_hole_dia)/2,base_thickness]);
    }
}


module base_plate() {
// Base plate with hole for bolt
    difference() {
        cylinder(h=base_thickness, r=outer_dia/2);
        cylinder(h=base_thickness, r=bolt_hole_dia/2);
    }
}

module final() {
  rotate_extrude() shape2d();
} 
    
final();
        