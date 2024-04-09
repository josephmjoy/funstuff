/* */

module pip() {
    cylinder(1, 1, 1);
}

module face1(width) {
    translate([width/2, width/2, 0]) pip();
}

module face2(width) {
    translate([width*1/3, width*1/3, 0]) pip();
    translate([width*2/3, width*2/3, 0]) pip();
}

module face3(width) {
    translate([width*1/3, width*1/3, 0]) pip();
    translate([width*2/3, width*2/3, 0]) pip();
    translate([width/2, width/2, 0]) pip();
}

module face4(width) {
    translate([width*1/3, width*1/3, 0]) pip();
    translate([width*2/3, width*2/3, 0]) pip();
    translate([width*1/3, width*2/3, 0]) pip();
    translate([width*2/3, width*1/3, 0]) pip();
}

module dice() {
    cube(10);
}

module all() {
    face4(10);
}

all();
