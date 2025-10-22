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

spacer_disk_template(0.75*I2MM);
