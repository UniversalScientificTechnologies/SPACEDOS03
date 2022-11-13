$fn=100;

repair=100;
repair_s=2;
toleration=0.4;// if zmena -> zmenit i u boxu
//plate_s
//potreba pro plate_s z ust_box
thickness=5;

box_out_x=90;
box_out_y=120;
box_out_z=61;

box_in_x=box_out_x-2*thickness;
box_in_y=box_out_y-2*thickness;
box_in_z=box_out_z-2*thickness;

box_cor=thickness-2-toleration;

desk_z=5-toleration-1.5;//z ust_desk
////
plate_x= 50.4;//box_in_x+2*box_cor;//
plate_y=92.27;//box_in_y+box_cor+repair_s; //92.27;
plate_z= 4.34-1.5;//desk_z+repair_s;//

//vyrez na "krabicku"
plate_s_x=34;//32.70
plate_s_y=plate_s_x+2;
plate_s_z=6.32+1.3-0.5;

plate_s_z_trans=-0.5;
plate_s_distance=2.22-2/2;
plate_s_thickness=1;

//screw
nut_d_in=3.3;
nut_d_out=6.5;
spacedos_middle_x = 25;
nut_distance_x=spacedos_middle_x - 40.64/2;//1.87+nut_d_out/2;
nut_distance_y=-7+12;
nut_distance_y_2 = nut_distance_y+71.12;
nut_distance_x_2=spacedos_middle_x + 40.64/2;
nut_height=2.2+repair_s;//(plate_s_z+plate_s_thickness)-plate_z;

//nut
nut_d=6.5;
nut_h=3-plate_s_thickness;

//cut_out
c_c_x=35+4;
c_c_y=8;
c_c_z=5;//4.24
c_c_x_trans=-4/2;
c_c_distance_x=2+c_c_x_trans;
c_c_distance_y=plate_y-c_c_y;
c_c_distance_z=plate_s_thickness;
cube_i_y=5;

//translate_all
t_all_y=14;

///////////////////////////
//desk
desk_x=71.90;
desk_y=90.85;
//desk_z=5;//zapsano driv(20)
desk_overlap=3.3;

//nut
nut_diameter=7.05;//6.95;
nut_height_1=4+repair; //3.80
nut_d_x=15.15+desk_overlap+nut_diameter/2-0.77;
nut_d_x_2=(box_in_x+2*box_cor)/2+35.5/2-3;//desk_x+2*desk_overlap-15-nut_diameter/2;
nut_d_y=26.6;//23.01+nut_diameter/2;
nut_d_y_2=26.6+38;//64.69;//desk_y-23.35-nut_diameter/2;

box_nut_in_d=3.3;
box_nut_in_h=repair;

//correction (vycnelky spodni)
cor_diameter=2.97;
cor_d_x=2.09+desk_overlap;
cor_d_x_2=desk_x+2*desk_overlap-cor_d_x;
cor_d_y=26.19;
cor_d_y_2=desk_y-cor_d_y;
cor_height=3;

box_cor_2=thickness-2;

//kvadr pro krystaly
k_x=26.41-box_cor_2-repair_s/2-1;
k_y=box_in_y+box_cor+repair_s-2*box_cor_2-2*repair_s;//box_in_x+2*box_cor-2*box_cor_2-2*repair_s;
k_z=3-2;
k_y_zkrat=(box_in_y+box_cor+repair_s-2*box_cor_2-2*repair_s)/2-nut_d;

k_x_trans=box_in_x+2*box_cor-3-k_x-box_cor_2-repair_s/2+3; //if zmena -> zmenit box
k_y_trans=repair_s/2;
k_z_trans=desk_z+repair_s+(-desk_z-repair_s+plate_z+repair_s);

//kvadr pro krystaly vicko (x,y jako u kvadr pro krystaly)
k_v_z=5;//2;

//otvory pro krystaly
o_k_height=0.8+0.5;
o_k_diameter=4.7+0.75+((4.7+0.75)/2)*0.15425144988;
echo("prumer chlivecku, k opsana", o_k_diameter);
///////////////?
o_k_x_trans=k_x_trans+o_k_diameter;
o_k_y_trans=k_y_trans+k_y/2+((k_y-20)/4)/4;
o_k_z_trans=k_z+k_z_trans-o_k_height;

o_k_x_trans_posun=k_x;
o_k_y_trans_posun=(k_y-20)/8;
   
//koeficient pro posunuta vzdalenosti der pro krystaly
koeficient = 1.1;

//otvory pro krystaly 2.rada
o_k_x_2_trans=k_x_trans-o_k_diameter/2+k_x/2;//k_x_trans+k_x-2*o_k_diameter;
o_k_y_2_trans=k_y_trans+k_y/2;

//nut kvadr pro krystaly
nut_zapusteni=3+repair_s;
nut_zapusteni_trans_z=0;

//otvor pro krystal - cube
o_k_c=11;
o_k_c_height=1.5;

vicko=0;
//krystaly=1;
//tld_box = 1;

//plate
difference(){
    translate([-3,0,0]) union(){
       
        
        //vlozena deska
        //cube([plate_x, plate_y,plate_z+repair_s]);
       
        //velka deska
        translate([0,-3,-desk_z-repair_s+plate_z+repair_s])cube([box_in_x+2*box_cor, box_in_y+box_cor+repair_s, desk_z+repair_s]);
        
        //kvadr pro krystaly
        translate([k_x_trans, k_y_trans+k_y_zkrat, k_z_trans])
            cube([k_x, k_y-k_y_zkrat, k_z]);
        echo([k_x, k_y-k_y_zkrat, k_z]);
        
        
        //kvadr pro krystaly vicko
        translate([k_x_trans, k_y_trans+k_y_zkrat, k_z_trans+k_z+0.5]) cube([k_x, k_y-k_y_zkrat, k_v_z]);

       if(!vicko)
        //nuts_horni, $fn=100
        translate([plate_x+box_cor_2+3, plate_y+t_all_y, 0])rotate([0,0,180])
        for(i=[nut_distance_x, nut_distance_x_2], j=[nut_distance_y, nut_distance_y_2]){
        translate([i,j,plate_z]){
        difference(){
            cylinder(h=nut_height,d=nut_d_out);
            translate([0,0,-repair_s])cylinder(h=nut_height+repair,d=nut_d_in);
        }           
    }
}



        }
    
    
    translate([plate_x+box_cor_2, plate_y+t_all_y, plate_s_thickness])rotate([0,0,180]){
        
        //vyrez na "krabicku"
        translate([(plate_x-plate_s_x)/2, plate_s_distance, plate_s_z_trans]) cube([plate_s_x, plate_s_y, plate_s_z]);
       
       //vyrezy na konektory
        translate([c_c_distance_x, c_c_distance_y, c_c_distance_z]){            cube([c_c_x,c_c_y+repair,c_c_z+repair]);
        translate([0,cube_i_y,-desk_z-repair_s])
            cube([c_c_x,c_c_y+repair,c_c_z+repair]);
    }
   //nut_horni, $fn=6 + dira
    for(i=[nut_distance_x, nut_distance_x_2], j=[nut_distance_y, nut_distance_y_2]){
        translate([i,j,plate_z]){ translate([0,0,-plate_z-repair_s]) rotate([0,0,30]) cylinder(h=nut_h+repair_s, d=nut_d, $fn=6);
        translate([0,0,-4*repair_s])cylinder(h=nut_height+repair,d=nut_d_in);
        }
        }
    }
   translate([0,0,0]){ 
    //nut_spodni
    if(0){
       #for(i=[nut_d_x, nut_d_x_2 ], j=[nut_d_y, nut_d_y_2]){
        translate([i ,j, 1]) union(){
            cylinder(h=nut_height_1, d=nut_diameter, $fn=6);
            translate([0,0,-repair/2]) cylinder(h=box_nut_in_h, d=box_nut_in_d);
            }
        }
    }
        
    //vycnelky_spodni
    if(0) for(i=[cor_d_x, cor_d_x_2], j=[cor_d_y, cor_d_y_2]){
        translate([i, j, -repair_s])cylinder(h=cor_height, d=cor_diameter);
        }       
    }    
    
    translate([-5, -5, -5]) cube(10);
    
    translate([-1.5, 0, 0]){
    //otvor pro krystal - cube
    translate([2+o_k_x_2_trans-o_k_diameter,o_k_y_2_trans-o_k_diameter/2+6.3*o_k_diameter-0.4,o_k_z_trans+o_k_height-o_k_c_height])cube([o_k_c, o_k_c, o_k_c_height]);
    
    translate([1+0.5,k_y/5-0.4*o_k_diameter+0.3,0]){
     //otvory pro krystaly 1.rada
    for(i=[(-1/2*(o_k_y_trans_posun))*koeficient, 1/2 * (o_k_y_trans_posun)*koeficient, -(o_k_y_trans_posun)*koeficient, 0*(o_k_y_trans_posun*koeficient), o_k_y_trans_posun*koeficient]){
        translate([0,i,0]) translate([-o_k_diameter+o_k_x_2_trans+1, o_k_y_2_trans, o_k_z_trans]) cylinder(h=o_k_height, d=o_k_diameter, $fn=6);
    }
    
    //otvory pro krystaly 2.rada
    for(i=[(-1/2*(o_k_y_trans_posun))*koeficient, 1/2 * (o_k_y_trans_posun)*koeficient, -(o_k_y_trans_posun)*koeficient, 0*(o_k_y_trans_posun)*koeficient, o_k_y_trans_posun*koeficient]){
        translate([0,i,0]) translate([o_k_x_2_trans, o_k_y_2_trans-o_k_diameter/2, o_k_z_trans]) cylinder(h=o_k_height, d=o_k_diameter, $fn=6);
    }
     //otvory pro krystaly 3.rada
    for(i=[(-1/2*(o_k_y_trans_posun))*koeficient, 1/2 * (o_k_y_trans_posun)*koeficient, -(o_k_y_trans_posun)*koeficient, 0*(o_k_y_trans_posun)*koeficient, o_k_y_trans_posun*koeficient]){
        translate([0,i,0]) translate([o_k_diameter+o_k_x_2_trans-1, o_k_y_2_trans, o_k_z_trans]) cylinder(h=o_k_height, d=o_k_diameter, $fn=6);
    }
    
    }
}
    

    //nut kvadr pro krystaly    
    for(i=[nut_d+k_y_zkrat, k_y-nut_d/2-2.3]){
        echo("poloha sroubu", i);
        translate([k_x_trans+k_x/2-box_cor, i+0.8, -repair_s/7]){
    translate([0,0,0]) rotate([0,0,30]) cylinder(h=nut_h+repair_s, d=nut_d, $fn=6);
        translate([0,0,-4*repair_s])cylinder(h=nut_height+repair,d=nut_d_in);
        translate([0,0,k_z_trans+k_z+repair_s/7+repair_s]) cylinder(h=nut_zapusteni, d=nut_d, $fn=100);
        }
    }
    
       
   if(vicko){
    translate([-repair/2,-repair/2,-desk_z-repair+desk_z+repair_s+k_z]) cube([desk_x+repair, desk_y+repair, desk_z+repair]);
   }else{
        translate([k_x_trans-repair_s*4+1, k_y_trans+k_y_zkrat-1, k_z_trans+k_z]) cube([desk_x+repair, desk_y+repair, desk_z+repair]);
   }
}






