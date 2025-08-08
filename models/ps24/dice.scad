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

module rotated_dice(width, rx, ry, rz) {
    rotate([rx, ry, rz])
        translate([-width/2, -width/2, -width/2])
            dice(width);
}

module sliced_dice(width, rx, ry, rz) {
    big=2*width;
    intersection() {
        translate([0, -big/2, -big/2]) cube([big, big, big]);
        rotated_dice(width, rx, ry, rz);
    }
}

module sliced_dice_pair(rx, ry, rz) {
    width=10;
    shift = 2*width;
    union() {
        sliced_dice(width, rx, ry, rz);
        translate([shift, 0, shift]) sliced_dice(width, rx, ry, rz+180);
    }
}

module all() {

    
    //sliced_dice_pair(0,0,45);
    //sliced_dice_pair(0,0,45+90);
    
    //sliced_dice_pair(0,45,0);
    //sliced_dice_pair(0,45+90,0);
    
    sliced_dice_pair(45,90,0);
    //sliced_dice_pair(45+90,90,0);


}

all();
