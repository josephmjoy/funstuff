// Countersunk Hole Jig
// A jig to align a forstner bit over an existing
// through hole.
// Main use case: to countersink 3/8 and 1/4 bolts and
// t-nuts for the climbing panels project.
// Author: JMJ

// ------- START OF PARAMETERS ---------------------
i2mm = 25.4; // inch to mm conversion

// Horizontal clearances (mm) so parts drop in easily
clearance = (1/32)*i2mm;

// Diameter of forstner bit used for countersunk hole
forstner_bit_dia = 1.0*i2mm;

// Diameter of hole that guides the bit
bit_guide_dia = 1.0*i2mm + clearance;

// Height of forstner-bit guide. This includes space for
// the spike below the bit.
bit_guide_height = 6/8*i2mm;

// Diameter of through-hole
through_hole_dia = 7/16*i2mm;

// The proxy bolt sticks out below the guide for the forstner bit and 
// sticks into the through_hole
proxy_bolt_dia = through_hole_dia - clearance;

// Height of the proxy bolt
proxy_bolt_height = 1/2 * i2mm;

// Chamfering is used for various purposes:
// - Chamfering the edge of the bolt for easy insertion into hole
// - Negative chamfering of the inner edge of the bit guide for 
//   strength
// - Chamfering the top inner edge of the bolt guide for easy
//   insertion of the bit.
chamfer_width = 1/8 * i2mm;

// Wall thickness of the guide
wall_thickness = 1/8 * i2mm;

// Hole dia for a threaded rod to strengthen the piece.
threaded_rod_dia = 1/8 * i2mm;

// -------  END OF PARAMETERS --------------------
module parameter_end(){} // End of customizer parameters

_EPS = 0.01; // for CSG

// Min arc length (for cylinders and spheres)
// This is perfectly fine for 3D printed circles of dia 1".
$fs = 1; 

total_guide_height = bit_guide_height + wall_thickness;


module guide_hole() {
    dia = bit_guide_dia;
    cylinder(h=bit_guide_height + _EPS, r=dia/2);
}

// The unit without any holes
module guide_stock() {
    dia = bit_guide_dia + 2 * wall_thickness;
    ht = total_guide_height;
    cylinder(h=ht, r=dia/2);
}


module proxy_bolt() {
    dia = proxy_bolt_dia;
    ht = proxy_bolt_height + _EPS;
    cylinder(h=ht, r=dia/2);
}

module threaded_rod_hole() {
    dia = threaded_rod_dia + clearance;
    ht = proxy_bolt_height + wall_thickness + 4 *_EPS;
    cylinder(h=ht, r=dia/2);
}

module combined_hole() {
    union() {
        guide_hole();
        translate([0,0, bit_guide_height - _EPS]) threaded_rod_hole();
    };
}

module combined_stock() {
    union() {
        translate([0, 0, total_guide_height]) {
            proxy_bolt();
        }
        guide_stock();   
    }
}

module whole_unit() {
    difference() {
        combined_stock();
        translate([0, 0, -_EPS]) combined_hole();
    }
}

whole_unit();
//combined_hole();