$fn=100;

repair_s=2;
repair=100;

//sirka sroubu 
vzdalenost_sroubu=4*10.16; //jejich stredu

//rozmery diody
di_in_x=34;
di_in_y=20;
di_in_z=2.4;

//stinitko diody
di_out_x=50.2;
di_out_y=24;
di_out_z=di_in_z+5;

nut_d_y_2=26.6+38;
thickness=5;

box_out_y=120;
box_in_y=box_out_y-2*thickness;


//nut
nut_height=2.2+repair_s;//(plate_s_z+plate_s_thickness)-plate_z;
nut_d_in=3.3;
nut_d=6.5;


nut_trans_y=di_out_y/2-5;

nut_zapusteni=3+repair_s;


difference(){
    cube([di_out_x, di_out_y, di_out_z], center=true);
    #translate([0,0,-di_out_z/2+(di_in_z)/2]) cube([di_in_x, di_in_y, di_in_z], center =true);
    
   for(i=[vzdalenost_sroubu/2, -vzdalenost_sroubu/2]){ translate([i,nut_trans_y,-di_out_z-repair_s])cylinder(h=nut_height+repair,d=nut_d_in);
    translate([i,nut_trans_y,di_out_z/2-nut_zapusteni+repair_s]) cylinder(h=nut_zapusteni, d=nut_d, $fn=100);
    }
    
    
}