// Corner connectors for the "fence" of our kitchen shelves.
// These are used to connected carbon-fiber poles that make
// up the fence.
// Author: JMJ


inner_dia = 4;
connector_height = 6;
hole_height = connector_height;
thickness = 1;

// Min arc length (for cylinders and spheres)
// This is perfectly fine for 3D printed circles of dia 1".
$fs = 1; 

module pipe() {
    difference() {
        cylinder(d=inner_dia + thickness, connector_height);
        cylinder(d=inner_dia, connector_height);
    }
    ring();
}


module ring() {
    translate([0, 0, hole_height/2]) {
        difference() {
            cylinder(d=inner_dia + thickness, thickness);
            cylinder(d=inner_dia - thickness/2, thickness);
        }
    }
}


module hole_punch() {
    translate([-connector_height/2,0, hole_height]) {
        rotate([0, 90, 0])
            cylinder(d=inner_dia, connector_height);
    }
}




module center_connector() {
    difference() {
        pipe();
        hole_punch();
    }
}

module corner_connector() {
    shift = connector_height/2;
    difference() {
        pipe();
        union() {
        translate([0, -shift, 0]) rotate([0, 0, 90])
            hole_punch();
            translate([shift, 0, 0]) hole_punch();
        }
    }
}

spacing = inner_dia + 2 * thickness;
//center_connector();
//translate([spacing,0,0]) corner_connector();
translate([0,0,0]) corner_connector();
//hole_punch();
