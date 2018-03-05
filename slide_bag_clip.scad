skew = 1.6;

module rod(height, width, radius) {
    w = width/2 - radius;
    rotate([0, 0, 90])
    rotate([90, 0, 0])
    minkowski() {
        cylinder(height = 0.1, r = radius, $fn = 30);
        linear_extrude(height = height)
            polygon(points = [[w, 0], [0, w], [-w, 0], [0, -skew*w]]);
    }
}

module hollow_rod(length, width, radius, thickness) {
    difference() {
        rod(length, width, radius);
        translate([thickness*2, 0, 0]) 
            rod(length, width - thickness*2, radius-0.8);
    }
}

module interior(length, width, radius) {
    distance = 4.5;
    angulo_punta = 38;
    difference() {
        rod(length + distance + 5, width, radius);
        /*
        */
        // color("red", 0.5)
        translate([length + width + distance, 0, 0])
            rotate([0, angulo_punta, 0])
                cube([width*5, width*2, width*2], center = true);
        // color("red", 0.3)
        translate([length + distance/2 - width*1.5, -width*2, -width]) 
            rotate([0, 0, 22.5]) 
                cube([width*5, width, width*3]); 
        // color("red", 0.3)
        translate([length + distance/2 - width*1.5, width*2, -width]) 
            rotate([0, 0, -22.5])
                translate([0, -width, 0])
                    cube([width*5, width, width*3]);

    }
}

module exterior(length, width, thickness) {
    distance = 1;
    angulo = 30;
    difference() {
        hollow_rod(length + distance, width, 2.3, thickness);
        translate([length + distance - 3, 0, 0])
            rotate([0, angulo, 0])
                translate([0, -width, -width]) 
                    cube([width*2, width*2, width*2]);
        translate([length-4.5+distance, width/6, 0])
        
        rotate([0, 0, 13])
            translate([-width*.8, 0, -width/2]) 
                cube([width, thickness*1.2, width/2.2]);
        translate([length-4.5+distance, -width/6, 0])
        rotate([0, 0, -13])
            translate([-width*.8, -thickness*1.22, -width/2]) 
                cube([width, thickness*2, width/2.2]);
    } 
}

module clip(length, width, thickness, space) {
    z = -(width-thickness*.1)*.88;
    difference() {
        union() {
            exterior(length, width, thickness);
            interior(length - 0.1, width - 2*thickness - 2*space, 1);
        }
        translate([0, 0, z])
            cube([length*10, width*2, width], center = true);
    }
    translate([length-8, -width*.3, z + width/2])
        cube([15, width*.6, 0.2]);
}

clip(
    length    = 20,
    width     = 11.5, 
    thickness = 1.4,
    space     = 1.2
);