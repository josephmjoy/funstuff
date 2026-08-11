// A spacing guide for 6" spaced holes on a square grid.
// The guide also includes measurement for the diagonal.

$fn = 50;
I2MM = 25.4;

thread_dia = 0.3006  * I2MM; // Minor dia of 3/8-20 bolt.
drill_dia = (7/16) * I2MM; // For T-Nuts
hole_dia = (1/4) * I2MM; // For reinforcing threaded rod.
height = 1 * I2MM; 

module rod() {
    difference() {
        union() {
            cylinder(h=height, r1=drill_dia, r2=drill_dia);
            translate([0, 0, height])
                cylinder(h=2, r1=drill_dia, r2=0.9 * drill_dia);
        }
        cylinder(h=2*height, r1=hole_dia, r2=hole_dia);
    }
}

rod();