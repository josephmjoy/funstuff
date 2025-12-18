// This is for drawing a fixed distance around
// a shape (like a climbing hold).
// {r} is the radius.

$fn = 50;
I2MM = 25.4;

module spacer_disk_template(r) {
    difference() {
        cylinder(h=2, r1=r, r2=r);
        cylinder(h=2, r1=1, r2=1.3);
    }
}

translate([0, 0, 0]) spacer_disk_template(0.75*I2MM);
translate([0, 2*I2MM, 0]) spacer_disk_template(0.5*I2MM);
translate([0, 4*I2MM, 0]) spacer_disk_template(0.5*I2MM);
