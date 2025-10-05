// End stop for Woodpeckers Story Stick

i2mm = 25.4; // inch to mm conversion
block_x = 28.0;
block_y = 1.0 * i2mm;
block_z = 19.5;

gap_x = 44.6;

wedge_x = 8;
wedge_z = 1.2;
wedge_y = block_y;

plate_x = 2 * block_x + gap_x;
plate_y = block_y;
plate_z = 4.6;

center_x = plate_x/2.0;
center_y = plate_y/2.0;

hole_dia = 1/4.0 * i2mm;
$fs = 0.1;

// The rectangular prism block on each end
module stop_block() {
    cube([block_x, block_y, block_z]);
}

// The flat plate on top
module top_plate() {
    cube([plate_x, plate_y, plate_z]);
}


module wedge_trapezoid_2D() {
    top_x = wedge_x - 2.0 * wedge_z; // 45 degree angle
    dx = wedge_z;
    polygon([[0.0, 0.0],
            [dx, wedge_z], [dx + top_x, wedge_z],
            [wedge_x, 0.0]]);
}

// The trapezoid tab in the center, below the top plate
module wedge() {
    translate([0, wedge_y, 0])
        rotate([90, 0, 0])
            linear_extrude(height = wedge_y)
                wedge_trapezoid_2D();
}

module stop() {
    top_plate();
    translate([0, 0, plate_z]) stop_block();
    translate([block_x + gap_x, 0, plate_z]) stop_block();
    translate([center_x - wedge_x/2.0, 0, plate_z])
        wedge();
}

module hole() {
    cylinder(h = plate_z + wedge_z, d = hole_dia);
}
module stop_with_hole() {
    difference() {
        stop();
        translate([center_x, center_y, 0])
            hole();
    }
}


stop_with_hole();
