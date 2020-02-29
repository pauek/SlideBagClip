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
            rod(length + radius, width - thickness*2, radius - thickness, 0, skew);
        translate([length - radius + 0.1, 0, 0])
            rotate([0, 0, 180])
                rod(6, width + 2, radius, 6, skew + 0.5);
    }
}

module clip(length, width, radius, thickness, space, skew = 0) {
   outer_width = width;
   inner_width = width - space*2 - thickness*2;
   inner_radius = radius - thickness - space;
   zcut = (width/2 + skew - thickness - space - inner_radius);
   support_size = 0.2;
   
   // Este cubo es para forzar el material de soporte justo debajo
   // de la parte que se despega normalmente (los laterales del tubo exterior)
   module support() {
      translate([length - width/2, -width/2, - zcut - 2 + support_size])
         rotate([0, 0, 0]) 
             translate([-width, 0, 0]) cube([width*1.5, width, 2]);
   }

   union() {
      difference() {
         union() {
            hollow_rod(length - 4, outer_width, radius, thickness, skew);
            rod(length, inner_width, radius - space*2, inner_width, skew);
         }
         translate([-1, -width, - width - zcut])
            cube([length + width*2, width*2, width]);
      }
      support();
   }
}

clip(
    length = 50,
    width = 11.0,
    radius = 2.7,
    thickness = 1.5,
    space = 1.2,
    skew = 0.3
);
