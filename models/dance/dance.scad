// Dance wall ornaments
// Author: JMJ
wall_thickness = 1;
base_thickness = 1.5;
wall_height = 5;
dpi = 884/4; // Map 864 pixel or original to 4"

module dance2d() {
    union() {
        //import("hh10.svg", dpi=dpi);
        //import("hh10orig.svg", dpi=dpi);
        //import("rect.svg");
        translate([0, 0, 0]) import("hh10_upper.svg", dpi=dpi);
        import("hh10_lower.svg", dpi=dpi);
    }
}

module expanded_dance2d_mink() {
    minkowski() {
        circle(wall_thickness);
        dance2d();
    };
}

module expanded_dance2d() {
    import("hh10dia.svg", dpi=dpi);
}



module artwork() {
    wh = wall_height;
    bt = base_thickness;
    union() {
        //linear_extrude(bt+wh) outline();
        linear_extrude(bt+wh) outline();
        linear_extrude(bt) expanded_dance2d_mink();
        //cube([10, 10, 1]);
        // cube([10, 10, 1]);
    }
}
        

module outline() {
    difference() {
        expanded_dance2d_mink();
        dance2d();
    };
}

module outline2() {
    minkowski() {
        outline();
        circle(0.5);
    }
}


artwork();
//cube([10, 10, 10]);
//linear_extrude(10) dance2d();
//linear_extrude(10) dance2d();
//dance2d();