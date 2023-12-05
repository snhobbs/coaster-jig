inch=25.4;
laser_bed_size = [29*inch,17*inch];

function get_alignment_pin_diameter() = 1/4*inch;

function calc_plate_size(nx, ny, spacing) = let(outline=inch*3/2) [spacing*(nx)+outline, spacing*(ny)+outline];

function get_alignment_hole(size) = [size.x/2-inch/2, size.y/2-inch/2];
function get_curf() = 1/5*inch;

module make_base_plate(size) {
    alignment_position = get_alignment_hole(size);
    hole_size = get_alignment_pin_diameter();
    difference() {
        square(size, center=true);
        translate([-alignment_position.x, -alignment_position.y])circle(d=hole_size);
        translate([alignment_position.x, alignment_position.y])circle(d=hole_size);
    };
}

module make_body_plate(nx, ny, coaster_diameter) {
    spacing = get_curf()+coaster_diameter;
    size = calc_plate_size(nx, ny, spacing);
    difference() {
        make_base_plate(size);
        for (xi=[-floor(nx/2):nx-floor(nx/2)-1]) {
            for (yi=[-floor(ny/2):ny-floor(ny/2)-1]) {
                 translate([xi*spacing, yi*spacing])circle(d=coaster_diameter);
            }
        };
    };
}

/*
3 circular feet evenly distributed around a circle
*/
module make_foot_outline(d_outline, d_pad) {
    /*
    one at 0, 120, 240
    */
    for (angle=[0,120,240]) {
        x = sin(angle)*d_outline/2;
        y = cos(angle)*d_outline/2;
        translate([x, y])circle(d=d_pad);
    }
}


module make_foot_plate(nx, ny, coaster_diameter, feet_diameter) {
    spacing = get_curf()+coaster_diameter;
    size = calc_plate_size(nx, ny, spacing);
    difference() {
        make_base_plate(size);
        for (xi=[-floor(nx/2):nx-floor(nx/2)-1]) {
            for (yi=[-floor(ny/2):ny-floor(ny/2)-1]) {
                 translate([xi*spacing, yi*spacing])make_foot_outline(d_outline=coaster_diameter*2/3, d_pad=feet_diameter);
            }
        };
    };
}


function get_coaster_diameter()=4*inch;
function get_feet_diameter()=1/2*inch+1;
function get_number() = [5,3];

plate_size_ = calc_plate_size(get_number().x, get_number().y, get_curf()+get_coaster_diameter());
echo(plate_size_.x/inch, plate_size_.y/inch);
assert(plate_size_.x <= laser_bed_size.x);
assert(plate_size_.y <= laser_bed_size.y);

module body_plate() {
    make_body_plate(nx=get_number().x, ny=get_number().y, coaster_diameter=get_coaster_diameter());
};

module foot_plate() {
    make_foot_plate(nx=get_number().x, ny=get_number().y, coaster_diameter=get_coaster_diameter(), feet_diameter=get_feet_diameter());
};

module base_plate() {
    make_base_plate(plate_size_);
};

color("red")linear_extrude(10)body_plate();
color("blue")translate([0,0,-20])linear_extrude(10)foot_plate();
color("darkgrey")translate([0,0,-40])linear_extrude(10)base_plate();
// square(laser_bed_size, center=true);