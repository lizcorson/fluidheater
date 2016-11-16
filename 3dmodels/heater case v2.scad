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
usb2height = 11.5;
usb2x = -15-usb2width;
usb2y = 0;
usb2z = 19;

leftcasewidth = boardwidth + 3;
leftcasedepth = case_bottom_depth;
leftcaseheight = case_bottom_height;

case_bottom();
*case_top();

*translate([-boardwidth,boardoffsety,0]) cube([boardwidth,boarddepth,boardheight]);

module case_bottom() {
    union() {
        leftcase();
        rightcase();
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
    
    //underneath
    translate([0,wallthick+tolerance,case_bottom_height-wallthick]) cube([case_bottom_width-wallthick-tolerance,case_bottom_depth-wallthick*2-tolerance*2,wallthick], center=false);
    translate([-leftcasewidth+wallthick+tolerance,wallthick+tolerance,case_bottom_height-wallthick]) cube([leftcasewidth-wallthick-tolerance,case_bottom_depth-wallthick*2-tolerance*2,wallthick], center=false);
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



