/***
* Name: Buddha
* Author: dongh
* Description: new_scene about buddha bar, this model using new construct: F0 -> contacts -> infect. 
* Tags: Tag1, Tag2, TagN
***/

model Buddha

global{
	//import file shp 
	shape_file HCM0_shape_file <- shape_file("../includes/HCM.shp");
	geometry shape <- envelope(HCM0_shape_file);
	
	float step <- 15 #minute;
	
	//time start
	date starting_date <- date([2020,3,14,0,0]);
	//constant time
	date mydate <- date([2020,3,1,0,0]);
	
	// rate lay nhiem
	float P <- 0.0088;
	// rate tiep xuc ngoai xa hoi (khi bat dau da thuc hien cho nghi toan bo truong hoc)
	float C <- 0.4;
	int count_day <- 14;
	int count <- 10;
	bool gs_enable <- true;
	
	//parameter
	//number of input F0s
	int f0 <- 10;
	//proportion of normals
	float n1 <- 0.7;
	//proportion of sex workers but do not engage in group sex
	float n2 <- 0.2;
	init{
		create Timer number: 1;
		write current_date;
		create Districts from: HCM0_shape_file with: [S::float(read('Surface')), pol::int(read('Pol')), stat::int(read('stat'))];
		loop i from: 0 to: length(Districts)-1{
			Districts(i).ID <- i;
		}
		create F0 number: f0;
		ask F0{
			quarantine <- mydate add_days 41;
			int i <- rnd(1, 100);
			if(i < 100*n1){type <- 0;}
			else if(i < 100*(n1 + n2)){type <- 1;}
			else {type <- 2;}
			home <- one_of(Districts where (each.stat = 0));
			if(type = 1){
				work <- one_of(Districts where(each.stat = 0 or each.stat = 1));
			}
		}
	}
	
	reflex save when: current_date = mydate add_days count_day{
		write current_date;
		write length(F0)/count;
		count <- length(F0);
		count <- length(F0);
		count_day <- count_day +1;	
	}
	
	reflex change_policies{
		if (count_day = 21){
			C <- 0.3;
		}
		if (count_day = 28){
			C <- 0.1;
		}
		if (count_day = 32){
			C <- 0.05;
		}
	}
	
	reflex group_sex when: current_date.day in [14, 15] and gs_enable{
		ask (F0 where (each.type = 2)){
			gs <- true;
			do group_sex;
		}
	}
	
	reflex create_contact{
		ask (F0 where (each.qrt = false and each.gs = false)){
			do compute_rate_contact(current_date.hour);
			do create_contact;
			gs <- false;
		}
	}
	
	reflex spread{
		ask Contacts{
			if (gs = false and rnd(1.0) < P){
				do infect_normal;
			}
			if (gs = true and rnd(1.0) < P){
				do infect_group_sex;
				root.gs <- false;
			}
			do die;	
		}
		ask Districts{
			pats <- length(F0 where (each.home = self and each.qrt = false));
		}
	}		
}

species F0{
	// ID
	string ID;
	// tinh trang benh
	int stat <- 0;
	//dia chi nha
	Districts home;
	//dia chi noi lam viec
	Districts work;
	// ngay bat dau cach ly
	date quarantine;
	// rate infect
	float p <- P;
	//type of F0: normal, sex worker, group sex participant ~ 0, 1, 2
	int type;
	//number of fam members
	int fam <- max(0, int(ceil(gauss(3, 1))));
	//number of fam members infected
	int infected_fam <- 0;
	//rate of contacts
	float rhc;//rate_home_contact;
	float rwc;//rate_work_contact;
	float rsc;//rate_sex_contact (only sex worker vs sex buyer);
	float roc;//rate_other_contact;
	bool gs <- false;
	// quarantined
	bool qrt;
		
	action compute_rate_contact(int hours){	
		switch type{
			match 0{
				switch hours{
					match_one [22, 23, 0, 1, 2, 3, 4, 5, 6] { rhc <- 3/36; rwc <- C*0.1/36; rsc <- C*C*0.01/36; roc <- C*0.4/36;}
					match_one [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17] {rhc <- 2/44; rwc <- C*18/44; rsc <- 0.0; roc <- C*3/44;}
					match_one [18, 19, 20, 21] {rhc <- 4/16; rwc <- C*1/16; rsc <- 0.0; roc <- C*2/16;}
				}
			}
			
			match_one [1, 2]{
				switch hours{
					match_one [22, 23, 0, 1, 2, 3, 4, 5, 6] { rhc <- 0.3/36; rwc <- 0.0; rsc <- C*C*10/36; roc <- C*2/36;}
					match_one [7, 8, 9, 10, 11, 12, 13, 14, 15] {rhc <- 4/36; rwc <- 0.0; rsc <- C*C*0.2/36; roc <- C*3/36;}
					match_one [16, 17, 18, 19, 20, 21] {rhc <- 4/24; rwc <- 0.0; rsc <- C*C*0.4/24; roc <- C*2/24;}
				}
			}
			
			default{rhc <- 10/96; rwc <- 20/96; rsc <- 1/192; roc <- 10/96;}
		}
	}
	
	action create_contact{
		
		create Contacts number: poisson(rhc) {
			root <- myself;
			type <- 0;
			place <- myself.home;
		}	

		create Contacts number: poisson(rwc) {
			root <- myself;
			type <- 1;
			place <- myself.work;
		}
		
		create Contacts number: poisson(rsc) {
			root <- myself;
			type <- 2;	
			place <- one_of(Districts where (each.stat = 0));
		}
		
		create Contacts number: poisson(roc) {
			root <- myself;
			type <- 3;
			place <- one_of(Districts);
		}
	}
	
	action group_sex{
		create Contacts number: poisson(10/96){
			root <- myself;
			type <- 2;
			place <- Districts first_with (each.ID = 2);
		}
	}
	
	reflex quarantine when: current_date = quarantine{
		qrt <- true;
	}
	
	aspect default{
		draw circle(500) at: point(2000, 7000) color: #white;
	}
}

// Virus
species Contacts{
	F0 root;
	// type of contact: in house, work, sex, other - 0, 1, 2, 3
	int type;
	Districts place;
	bool gs <- false;
	
	action infect_normal{
		create F0 number: 1{
			date temp_date <- current_date add_days int(max(0, ceil(gauss(5,2))));
			if(mydate add_days 41 < temp_date){
				quarantine <- temp_date;
			}
			else{
				quarantine <- mydate add_days 41;
			}
			switch myself.type{
				// when contact type is in house
				match 0{
					if(myself.root.fam < myself.root.infected_fam){
						home <- myself.place;
						work <- one_of(Districts);
						type <- 0;
						fam <- myself.root.fam;
						myself.root.infected_fam <- myself.root.infected_fam + 1;
						infected_fam <- myself.root.infected_fam;
					}
				}
				// when contact type is 'work'
				match 1{
					home <- one_of(Districts);
					work <- myself.place;
					type <- 0;
					fam <- int(max(0, ceil(gauss(3,1))));
					infected_fam <- 0;
				}
				// when contact_type is 'sex'
				match 2{
					home <- myself.place;
					work <- one_of(Districts);
					if(myself.root.type = 0){
						type <- 1;
					}
					else{
						type <- 0;
					}
					fam <- int(max(0, ceil(gauss(3,1))));
					infected_fam <- 0;
				}
				// when contact_type is 'other'
				match 3{
					home <- one_of(Districts);
					work <- one_of(Districts);
					type <- 0;
					fam <- int(max(0, ceil(gauss(3,1))));
					infected_fam <- 0;
				}
				default{
					ask myself{
						do die;
					}
				}
			}	
		}
	}
	action infect_group_sex{
		create F0 number: 1{
			date temp_date <- current_date add_days int(max(0, ceil(gauss(5,2))));
			if(mydate add_days 41 < temp_date){
				quarantine <- temp_date;
			}
			else{
				quarantine <- mydate add_days 41;
			}
			home <- one_of(Districts where (each.stat = 0));
			work <- one_of(Districts where (each.stat in [0, 1]));
			int t <- rnd(1, 10);
			if(t <= 7){ type <- 0;}
			else {type <- 2;}
			fam <- int(max(0, ceil(gauss(3,1))));
			infected_fam <- 0;
		}
	}
}

// quan huyen
species Districts{
	// so thu tu
	int ID;
	//dien tich
	int stat;
	float S;
	//dan so
	int pol;
	//danh sach benh nhan
	int pats;
		
	// phan hien thi
	aspect default{
		draw shape color: #lightblue border: #black;
	}
	aspect pie{
		draw shape color: #lightblue border: #black;
		draw circle(min(pats*100+200, 2000)) color: #red at: location;
	}
}
species Timer{
	aspect default{
		draw string(current_date) at: point([40000, 5000]) font: font('Arial', 20, #plain) color: #black;
	}
}

experiment Buddha type: gui{
	 
	float minimum_cycle_duration <- 0.002;
	parameter name: "so nguoi input" var: f0;
	parameter name: "ti le nguoi binh thuong" var: n1;
	parameter name: "ti le nhom 'tiep vien'" var: n2;
	output{
		layout horizontal([0::5000,vertical([1::5000,2::5000])::5000]) tabs:true editors: false;
		display "main"{
			 //species Districts;
			 species Districts aspect: pie;
			 species F0;
			 species Timer;
		}
		display "Time series chart" {
        	chart "Time Series" type: series {
        		data "number of patients" value: length(F0) color: #black;
       		}  
    	}    	 
		display "bar chart"{
			chart "Histogram" type: histogram{
				loop i from:0 to: 23{
					data string(Districts(i).ID) value: Districts(i).pats;
				}
			}
		}
	}
}
