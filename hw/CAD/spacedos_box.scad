$fn=6;

repair=100;
repair_s=2;

toleration=0.4;// if zmena -> zmenit i u desky
//krabicka
thickness=5;

box_out_x=90;
box_out_y=120;
box_out_z=61;

box_in_x=box_out_x-2*thickness;
box_in_y=box_out_y-2*thickness;
box_in_z=box_out_z-2*thickness;

//nut
box_nut_d=6.78;
box_nut_h=3.3;
box_nut_d_x=-box_nut_d/2+box_out_x-2;
box_nut_d_x_2=box_nut_d/2+2;
box_nut_d_y=box_in_y;
box_nut_d_z=box_nut_d/2+2;
box_nut_d_z_2=box_nut_d/2+2+box_in_z;

box_nut_in_d=3.3;
box_nut_in_h=repair;
box_nut_in_repair=5;

box_nut_screw_d=6;
box_nut_screw_zapusteni=3;


//insertion
box_cor=thickness-2;
box_cor_d_xy=thickness-box_cor;
box_cor_d_z=box_cor_d_xy+36+4;
desk_z=5-1.5;//z ust_desk

//edge
edge_x=thickness-3;
edge_y=box_out_y+repair;
edge_z=repair;

//battery
bat_x=70;
bat_y=box_in_y-15;
bat_z=2+repair_s;

bat_x_trans=box_out_x/2-bat_x/2;
bat_y_trans=thickness-bat_y+box_in_y;
bat_z_trans=thickness-1.5;
/*
battery_d=33.5;
battery_h=80+(box_in_y-80)/2;//64.15
battery_in_h=32.12;
battery_distance=38/2;//19.17;
battery_zapusteni=1.5;
*/


//horni vyrez
h_v_x=46+5;
h_v_y=box_in_y;
h_v_z=1.45+2+repair_s;

h_v_x_trans=30.5;
h_v_y_trans=thickness;
h_v_z_trans=box_out_z-(thickness+repair_s);

//vystuha horni
v_h_x=3;
v_h_y=box_in_y;
v_h_z=box_in_z-box_cor_d_z+h_v_z-repair_s;

v_h_x_trans=h_v_x_trans-v_h_x;
v_h_y_trans=thickness;
v_h_z_trans=box_cor_d_z+desk_z+repair_s;

//vystuha bocni
v_b_x=box_in_x+repair_s;
v_b_y=box_in_y+repair_s;
v_b_z=v_h_x;

v_b_x_trans=-v_b_x/2+box_out_x/2;
v_b_y_trans=thickness-repair_s;
v_b_z_trans=box_out_z/3;

//vyrez vystuhy bocni
v_v_b_x=72;
v_v_b_y=box_in_y;
v_v_b_z=v_h_x+6;

v_v_b_x_trans=-v_v_b_x/2+box_out_x/2;
v_v_b_y_trans=thickness;
v_v_b_z_trans=box_out_z/3-6/2;

//vulcan
vulcan_diameter_1_out=7;
vulcan_diameter_2_out=8.5;

vulcan_diameter_1_in=3;
vulcan_diameter_2_in=4.5;
vulcan_height=1.5+thickness;

vulcan_trans_x=76;
vulcan_trans_y=thickness-box_cor+64.5;
vulcan_trans_z=box_cor_d_z+desk_z+repair_s+7;

//vnitrni opora
tloustka=1;
zapusteni=2;

//vnitrni horni opora vicka
v_o_v_x=36;
v_o_v_y=zapusteni+box_cor_d_xy;
v_o_v_z=tloustka+2;

v_o_v_x_trans=-v_o_v_x/2+h_v_x_trans+h_v_x/2;
v_o_v_y_trans=box_out_y-box_cor-v_o_v_y;
v_o_v_z_trans=box_out_z-thickness-tloustka;

//bocni vnitrni opora vicka +x
b_o_x_x=tloustka;
b_o_x_y=zapusteni+box_cor_d_xy;
b_o_x_z=10;

b_o_x_x_trans=thickness+box_in_x-b_o_x_x;
b_o_x_y_trans=box_out_y-box_cor-b_o_x_y;
b_o_x_z_trans=-b_o_x_z+box_cor_d_z;

//bocni vnitrni opora vicka -x
b_o__x_x=tloustka;
b_o__x_y=zapusteni+box_cor_d_xy;
b_o__x_z=10;

b_o__x_x_trans=thickness;
b_o__x_y_trans=box_out_y-box_cor-b_o_x_y;
b_o__x_z_trans=-b_o_x_z+box_cor_d_z;

//vnitrni dolni opora vicka
v_d_v_x=bat_x-repair_s;
v_d_v_y=zapusteni+box_cor_d_xy;
v_d_v_z=tloustka;

v_d_v_x_trans=-v_d_v_x/2+box_out_x/2;
v_d_v_y_trans=box_out_y-box_cor-v_o_v_y;
v_d_v_z_trans=thickness;

//rozmery diody
di_in_x=34;
di_in_y=22;
di_in_z=2.4;

//pomocne pro diodu z desk
nut_d=6.5;
box_cor_2=thickness-2;
k_x=26.41-box_cor_2-repair_s/2-1;
k_y=box_in_y+box_cor+repair_s-2*box_cor_2-2*repair_s;//box_in_x+2*box_cor-2*box_cor_2-2*repair_s;

k_y_trans=repair_s/2;

k_y_zkrat=(box_in_y+box_cor+repair_s-2*box_cor_2-2*repair_s)/2-nut_d+5;

k_x_trans=box_in_x+2*box_cor-3-k_x-box_cor_2-repair_s/2+3; //if zmena -> zmenit box

plate_s_x=34;//32.70
plate_x= 50.4;//box_in_x+2*box_cor;//

//kvadr pro krystaly
k_z=3-2;
k_v_z=5;//2;

//stinitko = stinici filtr (69x115x5)
stinitko_x = 69;
stinitko_y = 115;
stinitko_z = 5;

//stinitko tloustka uchyceni
stinitko_thick_z = 1.5;
stinitko_rezerva = 0.2;

//stinitko delka v uchaceni
stinitko_le_x = 10;

//baterie
baterie_x = 78.4;
baterie_y = 100.10+2.2;
baterie_z = 23.12+0.5;

//baterie spodni podlozeni
baterie_podl_distance= 55.5;
baterie_podl_x= 3.6;

//dratek
dratek=4.6;


vicko = 0; // zobrazit krabicku nebo vicko

difference(){
    cube([box_out_x, box_out_y, box_out_z]);
    difference(){
        translate([thickness, thickness, thickness]) cube([box_in_x, box_in_y+repair_s, box_in_z]);
        
        for(i=[box_nut_d_x, box_nut_d_x_2], j=[box_nut_d_z, box_nut_d_z_2])
        translate([i, 0, j]) translate([0, -box_nut_in_repair, 0])
            rotate([-90, 90,0]) cylinder(h=box_out_y+repair,d=box_nut_h+2*repair_s, $fn=100);
        
        //stinitko upevneni
        translate([thickness/2,thickness-box_cor,box_cor_d_z-stinitko_z-2*stinitko_thick_z]) cube([box_out_x, stinitko_y, stinitko_z+2*stinitko_thick_z]);
        
        //baterie
        translate([thickness/2, thickness, box_cor_d_z-stinitko_z-2*stinitko_thick_z-baterie_z]) cube([box_out_x, baterie_y, baterie_z]);
        
        //baterie spodni podlozeni
        for(i=[-baterie_podl_distance/2, baterie_podl_distance/2])translate([thickness+box_in_x/2-baterie_podl_x/2+i,thickness,0]) cube([baterie_podl_x,87,10+thickness]);
            
    
        }
   
    //insertion
    translate([box_cor_d_xy-toleration/2, box_cor_d_xy, box_cor_d_z])cube([box_in_x+2*box_cor-toleration, box_in_y+box_cor+repair_s, desk_z+repair_s]);
    
    //stinitko
    translate([-stinitko_x/2+box_out_x/2-stinitko_rezerva,thickness-box_cor-stinitko_rezerva,box_cor_d_z-stinitko_z-stinitko_thick_z-stinitko_rezerva]) cube([stinitko_x+2*stinitko_rezerva, stinitko_y+2*stinitko_rezerva, stinitko_z+2*stinitko_rezerva]);
    
    //stinitko zbaveni desek okolo
    translate([(-stinitko_x+2*stinitko_le_x+box_out_x)/2, thickness-box_cor,box_cor_d_z-stinitko_z-2*stinitko_thick_z])cube([stinitko_x-2*stinitko_le_x, stinitko_y, stinitko_z+2*(stinitko_thick_z)]);
     
    translate([(-stinitko_x+2*(stinitko_le_x-7)+box_out_x)/2, thickness-box_cor,box_cor_d_z-stinitko_z-2*stinitko_thick_z+stinitko_thick_z])cube([stinitko_x-2*(stinitko_le_x-7), stinitko_y, stinitko_z+2*(stinitko_thick_z)]);
    
//baterie
    translate([(-baterie_x+box_out_x)/2, thickness, box_cor_d_z-stinitko_z-2*stinitko_thick_z-baterie_z]) cube([baterie_x, baterie_y, baterie_z]);
    
    translate([55, 90, box_cor_d_z-stinitko_z-2*stinitko_thick_z-baterie_z-8]) cube([15, 25, 15]);
    
    //translate([thickness,thickness, box_cor_d_z-stinitko_z-2*stinitko_thick_z-baterie_z/2-baterie_z/4]) cube([box_in_x, baterie_y, baterie_z/2]);
        
    //dratek
        translate([box_out_x-thickness-dratek, box_out_y-thickness-dratek,box_cor_d_z-stinitko_z-2*stinitko_thick_z]) cube([dratek, dratek, stinitko_z+2*stinitko_thick_z]);    
        
    //screw
    for(i=[box_nut_d_x, box_nut_d_x_2], j=[box_nut_d_z, box_nut_d_z_2]){
        translate([i, box_nut_d_y, j]) 
            union(){
                translate([0, -box_nut_in_repair, 0]) rotate([-90, 90, 0])cylinder(h=box_nut_in_h, d=box_nut_in_d, $fn=100);
               translate([0, 2*thickness,0]) rotate([90,0,0]) cylinder(h=box_nut_screw_zapusteni, d=box_nut_screw_d, $fn=100);
            }
        }
        
     //nut
     hull(){
            translate([box_nut_d_x, box_nut_d_y, box_nut_d_z_2]) rotate([90, 30,0]) cylinder(h=box_nut_h, d=box_nut_d);
            translate([box_nut_d_x_2, box_nut_d_y, box_nut_d_z]) rotate([90, 30,0]) cylinder(h=box_nut_h, d=box_nut_d);      
      }
      
      hull(){
            translate([box_nut_d_x, box_nut_d_y, box_nut_d_z]) rotate([90, 30,0]) cylinder(h=box_nut_h, d=box_nut_d);
            translate([box_nut_d_x_2, box_nut_d_y, box_nut_d_z_2]) rotate([90, 30,0]) cylinder(h=box_nut_h, d=box_nut_d);      
      }
  
    //edge i,j,k
        translate([box_out_x/2,0, box_out_z/2]) for(i=[0:3]) rotate([0,i*90,0])
        translate([box_out_x/2,edge_y/2-repair_s,box_out_z/2]) rotate([0,-45,0]) cube([edge_x, edge_y, edge_z], center=true);  
      
    //cover
    if(vicko){
    translate([-repair_s,box_out_y-thickness,-repair_s]) cube([box_out_x+repair, thickness+repair, box_out_z+repair]);
    }else{
        translate([-repair_s,-thickness,-repair_s]) cube([box_out_x+repair, box_out_y, box_out_z+repair]);

    }
    
    
    
        
    
    //vulcan odecet
    translate([vulcan_trans_x, vulcan_trans_y, vulcan_trans_z]) cylinder(h=vulcan_height, d1=vulcan_diameter_1_in, d2=vulcan_diameter_2_in, $fn=100);
    
    //battery
    //translate([bat_x_trans, bat_y_trans, bat_z_trans]) cube([bat_x, bat_y, bat_z]);
 
    
    //vyrez pro diodu
    translate([(h_v_x_trans+h_v_x)/2-2,box_cor+repair_s+3,box_in_z+thickness])
        cube([di_in_x, di_in_y, di_in_z+2*repair_s]);
    //puvodni trans_x: box_out_x-0.3-(plate_x-plate_s_x)/2)-di_in_x

    //vyrez pro zasunuti krabicky na krystaly
   
    if(vicko) translate([thickness, thickness,box_cor_d_z+desk_z+repair_s]) cube([k_x,k_y+repair,k_z+k_v_z]);
    
    //vyrez pro krabicku na TLD
    translate([thickness+4,thickness+5,box_cor_d_z+desk_z+repair_s])cube([k_x-4, k_y-k_y_zkrat, k_z+k_v_z+repair]);

    //horni vyrez
    translate([h_v_x_trans,h_v_y_trans,h_v_z_trans]) cube([h_v_x, h_v_y, h_v_z]);
}  

if(vicko){
    //vystuha horni
    translate([v_h_x_trans, v_h_y_trans, v_h_z_trans]) cube([v_h_x, v_h_y,v_h_z]);

/*
    //vystuha bocni
    difference(){
        translate([v_b_x_trans, v_b_y_trans, v_b_z_trans]) 
            cube([v_b_x, v_b_y, v_b_z]);
        translate([v_v_b_x_trans, v_v_b_y_trans, v_v_b_z_trans]) 
            translate([0,0,0]) cube([v_v_b_x, v_v_b_y, v_v_b_z]);  
            
        } */
 }
/*        
//vulcan
translate([vulcan_trans_x, vulcan_trans_y, vulcan_trans_z]) difference(){
    #cylinder(h=vulcan_height, d1=vulcan_diameter_1_out, d2=vulcan_diameter_2_out, $fn=100);
    cylinder(h=vulcan_height, d1=vulcan_diameter_1_in, d2=vulcan_diameter_2_in, $fn=100);
       
}
*/

if(!vicko){

//vnitrni horni opora vicka
translate([v_o_v_x_trans, v_o_v_y_trans, v_o_v_z_trans]) cube([v_o_v_x, v_o_v_y, v_o_v_z]); 

//bocni vnitrni opora vicka +x
//translate([b_o_x_x_trans, b_o_x_y_trans, b_o_x_z_trans]) cube([b_o_x_x, b_o_x_y, b_o_x_z]);

//bocni vnitrni opora vicka -x
//translate([b_o__x_x_trans, b_o__x_y_trans, b_o__x_z_trans]) cube([b_o__x_x, b_o__x_y, b_o__x_z]);

//vnitrni dolni opora vicka
translate([v_d_v_x_trans, v_d_v_y_trans, v_d_v_z_trans]) cube([v_d_v_x, v_d_v_y, v_d_v_z]); 

//baterie upevneni 
    translate([thickness*-1+box_in_x/2, thickness+baterie_y,box_cor_d_z-stinitko_z-2*stinitko_thick_z-baterie_z]) cube([thickness*3, box_in_y+box_cor-baterie_y, thickness]);
       
}