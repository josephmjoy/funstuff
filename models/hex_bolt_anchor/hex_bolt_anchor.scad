// Hex Bolt Anchor
// Anchor to prevent a hex bolt (or nut) from
// rotating.
//
$fs=1;

// 3/4" - 24 nut dimensions:
//   nut height: 8.27mm
//   flat diameter: 14.21mm
//   vertex diameter: 16.23mm (measured)
//   vertex diameter: 16.41mm (calculated from flat diameter)
//   Note that the nut has slightly rounded corners.
//   washer thickness: 1.65mm
//   washer diameter: 20.92mm
// Model dimensions below add
clearance = 0.5; // mm
nut_height = 8.27;
hex_dia = 16.41+clearance; // Vertex-to-vertex
washer_dia = 20.92+clearance;
washer_height = 1.89; // no vertical clearance - so washer is flush
base_dia = 25.5-clearance; // 1 inch
base_height = nut_height + washer_height;

eps=0.1; // for CSG

module hex(dia, h) {
    cylinder(h=h, r=dia/2, $fn=6);
}

module washer(dia, h) {
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