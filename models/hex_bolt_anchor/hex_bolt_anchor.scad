// Hex Bolt Anchor
// Anchor to prevent a hex bolt (or nut) from
// rotating.
//
$fs=1;

base_dia = 25;
washer_dia = 15;
hex_dia = 10;
base_height = 10;
washer_height = 1;
eps=0.1;

module hex(dia=20, h=10) {
    cylinder(h=h, r=dia/2, $fn=6);
}

module washer(dia=20, h=2) {
    cylinder(h=h, r=dia/2);
}


module base() {
    cylinder(h=base_height, r=base_dia/2);
}


module cutout() {        
    union() {
        translate([0, 0, -eps]) hex(hex_dia, base_height+eps);
        translate([0, 0, base_height-washer_height])
            washer(washer_dia, washer_height+eps);
    }    
}


module draw0() {
difference() {
    base();
    cutout();
}
}



draw0();