/***
* Name: Step2
* Author: dongh
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model Step2

/* Definition of Alert agent, what a move! */

global{
	//import file shp dau vao
	
	shape_file HCM0_shape_file <- shape_file("../includes/HCM.shp");
	geometry shape <- envelope(HCM0_shape_file);
	csv_file F0_csv_file <- csv_file("../includes/F0.csv");


	// xac dinh moi buoc bang 15 phut
	float step <- 15 #minute;
	
	//thoi gian khoi dau mo hinh
	date starting_date <- date([2020,3,1,0,0]);
	
	// thoi gian het nguy co khi benh nhan roi khoi khu vuc (tinh theo gio)
	int call_out <- 24;

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
		ask Districts{
			write self.name;
		}
	}
}

species Districts{
	// so thu tu
	int ID;
	//dien tich
	float S;
	//dan so
	int pol;
	//danh sach benh nhan
	list<Alert> A;
	
	// phan hien thi
	aspect default{
		draw shape color: #lightblue border: #black;
	}
	aspect pie{
		draw circle(length(A)*100+500) color: #red at: location;
	}
	aspect change_color{
		rgb col <- rgb([255, 10, 50]);
		draw shape color: col border: #black;
	}
}

species Wards parent: Districts{}

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
	
	init{
		
	}
	
	// tinh rate lay nhiem tuy thuoc vao tinh trang benh nhan
	float compute_p{
		return 0.4;
	}
	
	// bien kiem soat
	int index <- 0;
	// da bi cach ly?
	bool quarantined <- false;
	
	reflex movement when: quarantined = false and index < length(tim) and current_date >= tim[0]{
		
	}
	
	reflex quarantine when: current_date = quarantine{
		
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
// bao dong khi co 1 benh nhan den 1 dia diem vao 1 thoi gian xac dinh
species Alert{
	F0 root;
	Districts dis;
	date time;
	reflex alert when: current_date = time{
		ask dis{
			self.A << myself;
		}
	}
	reflex call_out when: current_date = time add_hours call_out{
		ask dis{
			remove myself from: self.A;
		}
	}
}

experiment step_2 type: gui{
	float minimum_cycle_duration <- 0.2;
	output{
		display "main"{
			species Districts;
			species Districts aspect: pie;
			species F0;
		}
		display "charts"{
			
		}
		display "monitor"{
			
		}
	}
}