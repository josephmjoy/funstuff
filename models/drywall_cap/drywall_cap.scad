//Outer diameter of cylinder
diameter=18.8;

//Wall thickness
wallThickness=2;

//Height of cylinder
height=15;

//Height/thickness of base (0 for no bottom)
baseHeight= 1.2;

// 18.8, 7.6

// Flange amound - lip width.
flange = 10;

// Diameter of hole in base.
hole_dia = 7.6;


/* [hidden] */
rad=diameter/2;
$fn=200;

union() {
    translate([0,0,-baseHeight]) {
            difference() {
                cylinder(r=flange+rad, h=baseHeight);
                translate([0,0,-2]) cylinder(r=hole_dia/2,h = 2*height);
            }
        }
	difference () {
		cylinder(r=rad, h=height);
		translate([0,0,-1]) cylinder(r=rad-wallThickness, h=height+2);
	}
}