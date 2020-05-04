/***
* Name: Step3
* Author: dongh
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model Step3

/* Change name Alert to Virus and debug */

global{
	//import file shp dau vao
	
	shape_file HCM0_shape_file <- shape_file("../includes/HCM.shp");
	geometry shape <- envelope(HCM0_shape_file);
	csv_file F0_csv_file <- csv_file("../includes/F0.csv");

	// xac dinh moi buoc bang 15 phut
	float step <- 15 #minute;
	
	//thoi gian khoi dau mo hinh
	date starting_date <- date([2020,3,10,0,0]);
	
	// thoi gian virus ton tai va gay nguy hiem o khu vuc benh nhan di qua (tinh theo gio)
	int v_time_life <- 24;
	
	//cac bien thong ke
	list<int> list_pats;

	init{
		write starting_date;
		create Districts from: HCM0_shape_file with: [S::float(read('Surface')), pol::int(read('Pol'))];
		int index <- 0;
		loop i over: Districts{
			i.ID <- index;
			index <- index + 1;
		}
		create F0 from: F0_csv_file;
		matrix F0_data <- matrix(F0_csv_file);
		loop i from: 0 to: length(F0)-1{
			F0(i).ID <- F0_data[0, i];
			F0(i).age <- int(F0_data[1, i]);
			F0(i).sex <- int(F0_data[2, i]);
			F0(i).underlying_disease <- int(F0_data[3, i]);
			//F0(i).stat <- int(F0_data[4, i]);
			F0(i).come <- (F0_data[5, i] = nil)? nil:(starting_date add_days int(F0_data[5, i])-1);
			F0(i).begin <- (F0_data[6, i] = nil)? nil:(starting_date add_days int(F0_data[6, i])-1);
			F0(i).quarantine <- (F0_data[7, i] = nil)? nil:(starting_date add_days int(F0_data[7, i])-1);
			F0(i).positive <- (F0_data[8, i] = nil)? nil:(starting_date add_days int(F0_data[8, i])-1);
			list<int> dis <- list<int>(string(F0_data[10, i]) split_with '.');
			list<int> tim <- list<int>(string(F0_data[11, i]) split_with '.');
			loop j from: 0 to: length(dis) - 1{
				F0(i).dis << Districts first_with (each.ID = dis[j]);
				F0(i).tim << starting_date add_days (tim[j]-1);	
			}
		}
	}
	reflex tell_the_time{
		write current_date;
		ask Districts{
			list_pats << length(self.pats);
		}
	}
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
	date positive;
	// lich su di chuyen
	list<Districts> dis;
	list<date> tim;
	// rate lay nhiem
	float p;
	//bien dieu khien
	bool released <- false;
	
	reflex release_virus when: released = false{
		loop i from: 0 to: length(dis) - 1{
			create Virus number: 1{
				self.root <- myself;
				self.dis <- myself.dis[i];
				self.time <- myself.tim[i];
				self.end <- (i + 1 < length(dis))? date(myself.dis[i]):myself.quarantine;
			}
		}
		released <- true;
	}
	
	// tinh rate lay nhiem tuy thuoc vao tinh trang benh nhan
	reflex compute_p{
		p <- 0.012;
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
	reflex alert when: current_date = time{
		ask dis{
			self.V << myself;
		}
	}
	reflex poop_out when: current_date = end add_hours v_time_life{
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
	
	reflex compute_R when: length(V) != 0{
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
	
	reflex spread{
		int num <- poisson(R);
		create F0 number: num{
			self.dis << myself;
			self.tim << current_date;
			self.quarantine <- current_date add_days rnd(1, 14);
		}
	}
	
	// phan hien thi
	aspect default{
		draw shape color: #lightblue border: #black;
	}
	aspect pie{
		draw circle(min(length(pats)*100+200, 2000)) color: #red at: location;
	}
	aspect change_color{
		rgb col <- rgb([255, 10, 50]);
		draw shape color: col border: #black;
	}
}

species Wards parent: Districts{}

experiment step_3 type: gui{
	float minimum_cycle_duration <- 0.01;
	output{
		display "main"{
			species Districts;
			species Districts aspect: pie;
			species F0;
			species Virus;
		}
		 display "Time series chart" {
        	chart "Time Series" type: series {
        		data "number of patients" value: length(F0) color: #black;
        }
    }
		//display "bar chart"{
		//}
	}
}