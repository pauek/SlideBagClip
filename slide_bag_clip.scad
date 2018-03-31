/*

Esto hay que imprimirlo con material de soporte
Está pensado así!

*/

module square_rod(length, width, point, skew = 0) {
    height = length - point;
    union() {
        linear_extrude(height = height)
            polygon(points = [[width, 0], [0, width], [-width, 0], [0, (1 + skew)*(-width)]]);
        translate([0, 0, height])
            linear_extrude(height = point, scale = 0)
                polygon(points = [[width, 0], [0, width], [-width, 0], [0, (1 + skew)*(-width)]]);
    }
}

module rod(length, width, radius, point = 0, skew = 0) {
    w = width/2 - radius;
    
    translate([radius, 0, 0]) 
    rotate([0, 0, 90])
    rotate([90, 0, 0])
    minkowski() {
        sphere(r = radius, $fn = 30);
        square_rod(length - radius*2, w, point, skew);
    }
}

module hollow_rod(length, width, radius, thickness, skew) {
    difference() {
        rod(length + radius, width, radius, skew);
        translate([thickness*2, 0, 0]) 
            rod(length + radius, width - thickness*2, radius - thickness, 0, skew*1);
        translate([length - radius + 0.1, 0, 0])
            rotate([0, 0, 180])
                rod(6, width + 2, radius, 6, skew + 15.5);
       translate([length - radius - 12, 0, -0.1])
            rotate([0, 0, 180])
                rod(7, width + 2, 1, 30, skew + 15.5);
    }
}

module clip(length, width, radius, thickness, space, skew = 0) {
   outer_width = width;
   inner_width = width - space*2 - thickness*2;
   inner_radius = radius - thickness - space;
   zcut = (width/2 + 0.2 - thickness - space - inner_radius);
   support_size = 0.2;
   
   module stickers() {
      thickness = 0.2;
      separation = 3.7;
      dist_factor = 1.8551;
      W = width/3;
      WW = width/7.5;
      translate([length - width*dist_factor, separation, -zcut])
         cube([width, W, thickness]);
      translate([length - width*dist_factor, -separation - W, -zcut])
         cube([width, W, thickness]);
      translate([length - 6.4, -WW/2, -zcut]) 
         cube([10, WW, thickness]);
   }

   difference() {
      union() {
         hollow_rod(length - 4, outer_width, radius, thickness, skew);
         rod(length, inner_width, radius - space*2, inner_width, skew);
         stickers();
      }
      translate([-1, -width, - width - zcut])
         cube([length + width*2, width*2, width]);
   }
}

clip(
    length = 245,
    width = 11.0,
    radius = 2.8,
    thickness = 1.5,
    space = 1.1,
    skew = 0.25
);
