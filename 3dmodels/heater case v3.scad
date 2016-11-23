wallthick = 1.5;

peg_r = 2.4/2;
peg_placelow = 0;
peg_placehigh = peg_placelow + 45.72;
fnval = 100;
peg_h = 6;
peg_spread = 17.78;

case_bottom_width = 30;
case_bottom_depth = 60;
case_bottom_height = 40;

pegs_xtranslate = (case_bottom_width-peg_spread)/2;
//pegs_ytranslate = 
//pegs_ztranslate = 

feather_depth = 50.8;
feather_width = 22.86;
feather_height = 1;

um232_width = 17.9;
um232_depth = 38;
um232_height = 1.6;
um232_offset_x = -2;

u_usb_height = 10.7;
u_usb_width = 12;
u_usb_depth = 16.2;
u_usb_offset_y = -8;
u_usb_offset_x = 3.2;

uheader_height = 8.7;
uheader_depth = 30.2;
uheader_width = 2.5;
uheader_offset_y = 3.9;
uheader_offset_x1 = 0;
uheader_offset_x2 = um232_width - uheader_width;

feather_xtranslate = (case_bottom_width-feather_width)/2;
feather_ytranslate = wallthick+.5;
feather_ztranslate = wallthick+1;


tc_cutout_xtranslate = case_bottom_width-wallthick;
tc_cutout_ytranslate = feather_ytranslate+30;
tc_cutout_ztranslate = wallthick+16;


tc_cutout_width = wallthick;
tc_cutout_depth = 24;
tc_cutout_height = case_bottom_height-tc_cutout_ztranslate;

tc_cover_height = 15;

usb_width = 11.5;
usb_height = 8;
usb_depth = wallthick;

usb_xtranslate = (case_bottom_width-usb_width)/2;
usb_ytranslate = 0;
usb_ztranslate = wallthick;

dcjack_r = 8.1/2;

dcjack_xtranslate = (case_bottom_width-2*dcjack_r)/2+dcjack_r;
dcjack_ytranslate = 0;
dcjack_ztranslate = feather_ztranslate+16+dcjack_r;

tolerance = .1;

boardwidth = 33.5;
boarddepth = 49;
boardheight = 1.2;
boardoffsety = 5;
usb2width = 13;
usb2height = u_usb_height+(case_bottom_height-um232_height-uheader_height);
usb2x = -usb2width-u_usb_offset_x+um232_offset_x+1;
usb2y = 0;
usb2z = uheader_height+um232_height+wallthick;

leftcasewidth = um232_width + 5;
leftcasedepth = case_bottom_depth;
leftcaseheight = case_bottom_height;

module um232() {
    cube([um232_width,um232_depth,um232_height]);
    translate([u_usb_offset_x,u_usb_offset_y,um232_height]) cube([u_usb_width,u_usb_depth,u_usb_height]);
    translate([uheader_offset_x1,uheader_offset_y,-uheader_height]) cube([uheader_width,uheader_depth,uheader_height]);
    translate([uheader_offset_x2,uheader_offset_y,-uheader_height]) cube([uheader_width,uheader_depth,uheader_height]);
}

case_bottom();
*case_top();

shell_width = 1;
*translate([-um232_width+um232_offset_x,wallthick+tolerance,uheader_height+wallthick]) um232();

module um232holder() {
    difference() {
        color([1,0,0]) translate([um232_offset_x-um232_width+uheader_offset_x2-shell_width,uheader_offset_y+tolerance+wallthick-shell_width,wallthick]) cube([uheader_width+shell_width*2,uheader_depth+shell_width*2,uheader_height]);
        translate([uheader_offset_x2-um232_width+um232_offset_x-tolerance*4,uheader_offset_y+wallthick-tolerance*4,-uheader_height+uheader_height+wallthick]) cube([uheader_width+tolerance*8,uheader_depth+tolerance*8,uheader_height]);
    }
    difference() {
        color([1,0,0]) translate([um232_offset_x-um232_width+uheader_offset_x1,uheader_offset_y+tolerance+wallthick-shell_width,wallthick]) cube([uheader_width+shell_width,uheader_depth+shell_width*2,uheader_height]);
        translate([uheader_offset_x1-um232_width+um232_offset_x,uheader_offset_y+wallthick-tolerance*4,-uheader_height+uheader_height+wallthick]) cube([uheader_width+tolerance*4,uheader_depth+tolerance*8,uheader_height]); 
    }
}



*translate([-boardwidth,boardoffsety,0]) cube([boardwidth,boarddepth,boardheight]);

module case_bottom() {
    union() {
        leftcase();
        rightcase();
        um232holder();
    }
}

module leftcase() {
    difference () {
        translate([-leftcasewidth,0,0]) cube([leftcasewidth,leftcasedepth,leftcaseheight],center=false);
        translate([-leftcasewidth+wallthick,wallthick,wallthick]) cube([leftcasewidth-wallthick*2,leftcasedepth-wallthick*2,leftcaseheight],center=false);
        translate([-wallthick,wallthick,wallthick]) cube([wallthick,case_bottom_depth-wallthick*2,case_bottom_height]);
        translate([usb2x,usb2y,usb2z]) cube([usb2width,wallthick,usb2height]);
        
    }
}


module case_top() {
    //top
    translate([-leftcasewidth,0,case_bottom_height]) cube([case_bottom_width+leftcasewidth,case_bottom_depth,wallthick], center=false);
    
    //side panel
    translate([case_bottom_width-wallthick,tc_cutout_ytranslate+tolerance,case_bottom_height-tc_cover_height]) cube([wallthick,tc_cutout_depth-tolerance*2,tc_cover_height], center=false);
    
    //underneath -- got rid of most of this to reduce material used
    difference () {
        translate([0,wallthick+tolerance,case_bottom_height-wallthick]) cube([case_bottom_width-wallthick-tolerance,case_bottom_depth-wallthick*2-tolerance*2,wallthick], center=false);
        translate([0,wallthick*2+tolerance,case_bottom_height-wallthick]) cube([case_bottom_width-wallthick*2-tolerance,case_bottom_depth-wallthick*4-tolerance*2,wallthick], center=false);
    }
    difference() {
        translate([-leftcasewidth+wallthick+tolerance,wallthick+tolerance,case_bottom_height-wallthick]) cube([leftcasewidth-wallthick-tolerance,case_bottom_depth-wallthick*2-tolerance*2,wallthick], center=false);
        translate([-leftcasewidth+wallthick*2+tolerance,wallthick*2+tolerance,case_bottom_height-wallthick]) cube([leftcasewidth-wallthick*2-tolerance,case_bottom_depth-wallthick*4-tolerance*2,wallthick], center=false);
    }
    
    //usb cover
    cutout_height = case_bottom_height-wallthick-um232_height-uheader_height-u_usb_height-2;
    translate([usb2x-tolerance,0,case_bottom_height-cutout_height]) cube([usb2width-tolerance*2,wallthick,cutout_height]);
    
}

module rightcase() {
    difference() {
        cube([case_bottom_width,case_bottom_depth,case_bottom_height], center=false);
        translate([wallthick,wallthick,wallthick]) cube([case_bottom_width-2*wallthick,case_bottom_depth-2*wallthick,case_bottom_height], center=false);
        translate([tc_cutout_xtranslate,tc_cutout_ytranslate,tc_cutout_ztranslate]) cube([tc_cutout_width,tc_cutout_depth,tc_cutout_height], center=false);
        translate([usb_xtranslate,usb_ytranslate,usb_ztranslate]) cube([usb_width, usb_depth, usb_height],center=false);
        translate([dcjack_xtranslate,dcjack_ytranslate,dcjack_ztranslate]) rotate([270,0,0]) cylinder(wallthick*1.1, dcjack_r, dcjack_r, false, $fn=fnval);
        translate([0,wallthick,wallthick]) cube([wallthick,case_bottom_depth-wallthick*2,case_bottom_height]);
    }
    translate([(case_bottom_width-peg_spread)/2,feather_ytranslate+2.54,0]) pegs();
}


*translate([feather_xtranslate,feather_ytranslate,feather_ztranslate]) feather();

module pegs() {
    translate([0,peg_placelow,wallthick])cylinder(peg_h, peg_r, peg_r, false, $fn=fnval);
    translate([peg_spread,peg_placelow,wallthick]) cylinder(peg_h, peg_r, peg_r, false, $fn=fnval);

    translate([0,peg_placehigh,wallthick])cylinder(peg_h, peg_r, peg_r, false, $fn=fnval);
    translate([peg_spread,peg_placehigh,wallthick]) cylinder(peg_h, peg_r, peg_r, false, $fn=fnval);
}

module feather() {
    cube([feather_width, feather_depth, feather_height], center = false);
}



