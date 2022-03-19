// Hex Bolt Anchor
// Anchor to prevent a hex bolt (or nut) from
// rotating.
//
$fs=1;

// 5/16" - 24 nut dimensions:
//   nut height: 8.27mm
//   flat diameter: 14.21mm
//   vertex diameter: 16.23mm (measured)
//   vertex diameter: 16.41mm (calculated from flat diameter)
//   Note that the nut has slightly rounded corners.
//   washer thickness: 1.65mm
//   washer diameter: 17.74mm
// Model dimensions below add
clearance = 0.5; // mm
base_dia = 25.5-clearance; // 1 inch
base_height = 8.27;
hex_dia = 16.41+clearance; // Vertex-to-vertex
washer_dia = 17.74+clearance;
washer_height = 1.65+clearance ;
eps=0.1; // for CSG

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