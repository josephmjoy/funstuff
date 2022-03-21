// Hex Bolt Anchor
// Anchor to prevent a hex bolt (or nut) from
// rotating.
// There are two styles:
// style A: Concentric, with washer (the original). Must
//          be glued.
// style B: Offset, without washer, and with hole for 
//          retraining screw. The offset prevents
//          the bolt from rotating.
//
// 3/4" - 18 nut dimensions:
//   nut height: 8.45mm // this can vary with nut
//   flat diameter: 14.21mm
//   vertex diameter: 16.23mm (measured)
//   vertex diameter: 16.41mm (calculated from flat diameter)
//   Note that the nut has slightly rounded corners.
//   washer thickness: 1.65mm
//   washer diameter: 20.92mm

// ------- START OF PARAMETERS ---------------------
// Horizontal clearances (mm) so parts drop in easily
clearance = 0.5;

// Exact height of nut
nut_height = 8.45;

// Vertex-to-vertex dia of nut
hex_dia = 16.41;

// Exact dia of washer (style A)
washer_dia = 20.92;

// Exact height of washer
washer_height = 1.89;

// Retaining screw shaft dia (style B only)
screw_dia = 3.53; // #6
// Above is for a flat head screw with a
// 45 degree angle for the head conic section.

// Diameter of screw head (style B only)
screw_head_dia = 7;

// Overall diameter
item_dia = 25.4; // 1 inch

// Extra height above nut and screw
extra_height = 0.2;
// Above helps ensure that nothing sticks out
// above the item - so the item can be made
// flush with the surrounding wood.

// Item style (A is glued, B is screwed)
item_style = "A"; // [A, B]

// -------  END OF PARAMETERS --------------------
module parameter_end(){} // End of customizer parameters

_EPS = 0.1; // for CSG

// Min arc length (for cylinders and spheres)
// This is perfectly fine for 3D printed circles of dia 1".
$fs = 1; 
do_A = (item_style == "A");

// Overall height
item_height = nut_height + extra_height + (do_A ? washer_height: 0);

module hex_hole() {
    dia = hex_dia + clearance;
    cylinder(h=item_height + _EPS, r=dia/2, $fn=6);
}

module washer_hole() {
    dia = washer_dia + clearance;
    cylinder(washer_height + _EPS, r=dia/2);
}

module screw_hole() {
    dia1 = screw_dia + clearance;
    dia2 = screw_head_dia + 2*extra_height;
    rdiff = (dia2 - dia1)/2 + clearance;
    cylinder(h=item_height + _EPS, r=dia1/2);
    translate([0, 0, item_height-rdiff+_EPS]) {
    cylinder(h=rdiff, r2=dia2/2, r1=dia1/2);
}
}

// The unit without any holes
module stock() {
    dia = item_dia - clearance;
    cylinder(h=item_height, r=dia/2);
}


module cutout_A() {        
    union() {
        translate([0, 0, -_EPS]) hex_hole();
        translate([0, 0, item_height - washer_height])
            washer_hole();
    }    
}


module cutout_B() {        
    union() {
        // The constants below were obtained by
        // trial-and-error so that the screw hole
        // (with conical section for head) fits
        // within the available space.
        screw_offset = -screw_head_dia*1.24;
        hex_offset = hex_dia*0.14;
        translate([0, hex_offset, -_EPS/2]) hex_hole();
        translate([0, screw_offset, -_EPS/2])screw_hole();
    }    
}


module style_A() {
    difference() {
        stock();
        cutout_A();
    }
}

module style_B() {
    difference() {
        stock();
        cutout_B();
    }
}

if (do_A) {
    style_A();
} else {
    style_B();
}