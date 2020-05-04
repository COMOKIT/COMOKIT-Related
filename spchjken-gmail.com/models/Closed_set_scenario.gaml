/***
* Name: Closedsetscenario
* Author: dongh
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model Closedsetscenario

/* special case for 50+ case not in statistic at buddha bar */

global{
	//import file shp dau vao
	shape_file HCM0_shape_file <- shape_file("../includes/HCM.shp");
	geometry shape <- envelope(HCM0_shape_file);
	
	// xac dinh moi buoc bang 15 phut
	float step <- 15 #minute;
	
	//thoi gian khoi dau mo hinh
	date starting_date <- date([2020,3,14,0,0]);
	
	// thoi gian virus ton tai va gay nguy hiem o khu vuc benh nhan di qua (tinh theo gio)
	int v_time_life <- 24;	
	
	// rate lay nhiem
	float P <- 0.0032;
	
	//so luong benh nhan tren tong so ~ 60 truong hop den bar buddha chua thong ke
	int num_pat_start <- 1;

	init{
		write starting_date;
		create Districts from: HCM0_shape_file with: [S::float(read('Surface')), pol::int(read('Pol'))];
		int index <- 0;
		loop i over: Districts{
			i.ID <- index;
			index <- index + 1;
		}
		create F0 number: num_pat_start{
			age <- rnd(20, 60);
			sex <- rnd(1, 0);
			stat <- 0;
			dis << one_of(Districts);
			tim << starting_date add_days 1;
			quarantine <- starting_date add_days max(int(ceil(gauss(14,3))), 14);
			tim << quarantine;
			p <- P;
		}
	}

	// Nguoi benh tha virus ra moi truong
	reflex Release{
		ask F0{
			if(released = false){
				do release_virus;
			}
		}
	}
	// Virus tac dong len khong gian xung quanh
	reflex Alert{
		ask Virus{
			if(current_date = time add_minutes 15){
				do alert;
			}
			if(current_date = end add_hours v_time_life){
				do poop_out;
			}
		}
	}
	reflex Spread{
		ask Districts{
			if(length(self.V) != 0 and ID!= 24){
				do compute_R;
				do spread;
			}
		}
	}
	reflex tell_the_time{
		write current_date;
		if(mod(cycle, 96)=0){
			write length(F0 where (each.qrt = false));
			write length(F0 where (each.stat = 1));
		}
	}
}

species Reader{
	int ID;
	date start;
}

species F0{
	// ID
	string ID;	
	// ten
	string name;
	// tuoi
	int age;
	// gioi tinh
	int sex;
	// noi cu tru
	point home;
	// noi lam viec
	point work_station;
	// benh ly nen
	int underlying_disease;
	// tinh trang benh hien tai
	int stat <- 0;
	// ngay den
	date come;
	// ngay khoi phat trieu chung
	date begin;
	// ngay bat dau cach ly
	date quarantine;
	// ngay xet nghiem duong tinh dau tien
	//date positive;
	// lich su di chuyen
	list<Districts> dis;
	list<date> tim;
	// rate lay nhiem
	float p;
	//bien dieu khien
	bool released <- false;
	bool qrt <- false;
	
	action release_virus {
		loop i from: 0 to: length(dis) - 1{
			create Virus number: 1{
				self.root <- myself;
				self.dis <- myself.dis[i];
				self.time <- myself.tim[i];
				self.end <- myself.tim[i+1];
				//write 'end here ' + self.end;
			}
		}
		released <- true;
	}
	
	// tinh rate lay nhiem tuy thuoc vao tinh trang benh nhan
	// cach ly
	reflex quarantined when: current_date = quarantine{
		qrt <- true;		
	}
	aspect default{
		draw circle(500) at: point(2000, 7000) color: #white;
	}
}

species F1 parent: F0{
	
	F0 source;
	
	date time_met_source;
	
	point location_met_source;
}

species F2 parent: F0{
	
	F1 source;
	
	date time_met_source;
	
	point location_met_source;
}

// Virus
species Virus{
	F0 root;
	Districts dis;
	date time;
	date end;
	action alert {
		ask dis{
			self.V << myself;
		}
	}
	action poop_out{
		ask dis{
			remove myself from: self.V;
		}
		do die;
	}
	aspect default{
		draw circle(1000) at: point(1000 + rnd(1,1000), 8000) color: #white;
	}
}

// quan huyen
species Districts{
	// so thu tu
	int ID;
	//dien tich
	float S;
	//dan so
	int pol;
	//danh sach benh nhan
	list<Virus> V;
	list<F0> pats;
	//Gia tri nguy co
	float R;
	
	action compute_R {
		float p;
		pats <- nil;
		loop i over: V{
			p <- p + i.root.p;
			if (contains(pats, i.root) = false){
				pats << i.root;
			} 
		}
		R <- #pi*2*2*p*pol/S/1000000;
	}
	
	action spread {
		int num <- poisson(R);
		create F0 number: num{
			self.dis << myself;
			self.tim << current_date;
			self.stat <- rnd(1, 10) > 4 ? 1:0; // ti le nguoi benh khoi phai trieu chung som la 60%
			if(self.stat = 1){
				self.quarantine <- current_date add_days max(int(ceil(gauss(3, 1))), 0);
			}
			else{
				self.quarantine <- current_date add_days max(int(ceil(gauss(7, 2))), 0);
			}
			self.tim << self.quarantine;
			self.p <- P;
		}
	}
	
	// phan hien thi
	aspect default{
		draw shape color: #lightblue border: #black;
	}
	aspect pie{
		draw shape color: #lightblue border: #black;
		draw circle(min(length(pats)*100+200, 2000)) color: #red at: location;
	}
	aspect change_color{
		rgb col <- rgb([255, 10, 50]);
		draw shape color: col border: #black;
	}
}

species Wards parent: Districts{}

experiment Closed_set_scenario type: gui{
	float minimum_cycle_duration <- 0.003;
	parameter name: "so lay nhiem ban dau" var: num_pat_start;
	parameter name: "ti le lay nhiem" var: P;
	//parameter name: "ti le lay nhiem nguoi co trang thai 1" var: p1;
	output{
		
		 display "Time series chart" {
        	chart "Time Series" type: series {
        		data "number of patients" value: length(F0) color: #black;
       		 }  
    	 }
    	 display "main"{
			 //species Districts;
			 species Districts aspect: pie;
			 species F0;
			 species Virus;
		 }
		//display "bar chart"{
		//}
	}
}