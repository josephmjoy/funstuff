/* */
$fn=20;
pip_height = 0.01;
epsilon = pip_height/2;

module pip() {
    color("black") cylinder(pip_height, 0.75, 0.75);
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

module face5(width) {
    union() {
        face1(width);
        face4(width);
    }
}

module face6(width) {
    union() {
        face4(width);
        translate([width*1/3, width*1/2, 0]) pip();
        translate([width*2/3, width*1/2, 0]) pip();
    }
}

module blank(width) {
    r0 = width/20;
    translate([r0,r0,r0]) {
        minkowski() {
            cube(width-2*r0);
            sphere(r=r0);
        }
    }
}

module dice(width) {
    union() {
        blank(width);
        translate([0, 0, width]) face1(width);
        rotate([90,0,0]) face2(width);
        translate([width+epsilon, 0, 0]) rotate([0, -90, 0]) face3(width);
        translate([0, 0, 0]) rotate([0, -90, 0]) face4(width);
        translate([0, width+epsilon, 0]) rotate([90,0,0]) face5(width);
        translate([0, 0, -epsilon]) face6(width);
    }
}

module all() {
    dice(10);
}

all();
