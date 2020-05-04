/***
* Name: Multiscene
* Author: dongh
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model Multiscene

global{
	//import file shp dau vao
	shape_file HCM0_shape_file <- shape_file("../includes/HCM.shp");
	geometry shape <- envelope(HCM0_shape_file);
	csv_file F0_csv_file <- csv_file("../includes/F0.csv");
	
	matrix F0_data <- matrix(F0_csv_file);
	// xac dinh moi buoc bang 15 phut
	float step <- 15 #minute;
	
	//thoi gian khoi dau mo hinh
	date starting_date <- date([2020,3,1,0,0]);
	
	// thoi gian virus ton tai va gay nguy hiem o khu vuc benh nhan di qua (tinh theo gio)
	int v_time_life <- 3;	
	
	// rate lay nhiem
	float P <- 0.0042;
	// hang so ti le tiep xuc, co the thay doi tuy thuoc theo chinh sach cua nha cam quyen
	float C <- 1.0;
	list<int> cases_num;
	
	int scen_num <- 1;

	int count_day <- 1;

	init{
		write starting_date;
		create Districts from: HCM0_shape_file with: [S::float(read('Surface')), pol::int(read('Pol'))];
		int index <- 0;
		loop i over: Districts{
			i.ID <- index;
			index <- index + 1;
		}
		create Districts number: 1 with:[ID::index, name::'cach ly'];
		create Reader from: F0_csv_file;
				
		loop i from: 0 to: length(Reader) - 1{
			Reader(i).ID <- i;
			list<int> tim <- list<int>(string(F0_data[9, i]) split_with '.');
			Reader(i).start <- starting_date add_days(tim[0]-1);
		}			
	}
	
	reflex save when: current_date = starting_date add_days count_day{
		cases_num << length(F0);	
		count_day <- count_day + 1;
		if(count_day = 92 ){
			save cases_num to: '../scen' + scen_num +'.csv' type: csv rewrite:false;
			do pause;
		}		
	}
	
	reflex change_by_scen when: current_date.hour = 0{
		switch scen_num{
			match 1{	C <- 2.2;	}
			match 2{	C <- 1.2;	}
			match 3{	C <- 1.2;	}
			match 4{	C <- 0.5;	}
			match 5{
				if (count_day < 15){ C <- 1.0;}
				else if(count_day >= 15 and count_day < 24){ C <- 0.8;}
				else if(count_day >= 24 and count_day < 28){ C <- 0.65;}
				else if(count_day >= 28 and count_day < 32){ C <- 0.55;}
				else if(count_day >= 32){ C <- 0.5; }
			}
			match 6{
				if (count_day < 15){ C <- 1.0;}
				else if(count_day >= 15 and count_day < 24){ C <- 0.8;}
				else if(count_day >= 24 and count_day < 28){ C <- 0.65;}
				else if(count_day >= 28 and count_day < 32){ C <- 0.55;}
				else if(count_day >= 32 and count_day < 46){ C <- 0.5;}
				else if(count_day >= 46 and count_day < 61){ C <- 0.65;}
				else if(count_day >= 61) {C <- 0.8;}
			}
			default{	C <- 1.0;	}
		}
	}
	
	// tu nuoc ngoai den
	reflex come_from_aboard{
		if (rnd(1, 150) = 1){
			create F0 number: 1{
				dis << Districts first_with (each.ID = 2);
				tim << current_date;
				if(scen_num <= 2){
					loop i from: 1 to: max(int(ceil(gauss(5,2))), 1){
						dis << one_of(Districts);
						tim << current_date add_days i;
					}
					quarantine <- current_date add_days length(dis) - 1;
					tim << quarantine;
				}
				if(scen_num = 3 or scen_num = 4){
					quarantine <- current_date;
					tim << quarantine;
					released <- true;
				}
				if(scen_num = 5 or scen_num = 6){
					loop i from: 1 to: max(int(ceil(gauss(5,2))), 1){
						dis << one_of(Districts);
						tim << current_date add_days i;
					}
					quarantine <- current_date add_days length(dis) - 1;
					tim << quarantine;
					if(count_day < 15){
						loop i from: 1 to: max(int(ceil(gauss(5,2))), 1){
							dis << one_of(Districts);
							tim << current_date add_days i;
						}
						quarantine <- current_date add_days length(dis) - 1;
						tim << quarantine;
					}
					else{
						quarantine <- current_date;
						tim << quarantine;
						released <- true;
					}
				}
				p <- P;
			}
		}
	}
	
	// chuyen doi du lieu thanh F0 khi thoi gian den
	reflex become_patients{
		ask Reader{
			do become_patient;
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
			if(current_date >= end add_hours v_time_life){
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
	
	reflex tell_the_time when: current_date.hour = 0 and current_date.minute = 0{
		write current_date;
	}
	
	// pause and save

}

species Reader{
	int ID;
	date start;
	action become_patient{
		if (current_date = self.start){
				int i <- self.ID;
				create F0 number: 1{
					ID <- F0_data[0, i];
					age <- int(F0_data[1, i]);
					sex <- int(F0_data[2, i]);
					underlying_disease <- int(F0_data[3, i]);
					stat <- int(F0_data[4, i]);
					p <- P;
					come <- (F0_data[5, i] = nil)? nil:(starting_date add_days (int(F0_data[5, i])-1));
					begin <- (F0_data[6, i] = nil)? nil:(starting_date add_days (int(F0_data[6, i])-1));
					quarantine <- (F0_data[7, i] = nil)? nil:(starting_date add_days (int(F0_data[7, i])-1));
					//F0(i).positive <- (F0_data[8, i] = nil)? nil:(starting_date add_days int(F0_data[8, i])-1);
					list<int> dit <- list<int>(string(F0_data[8, i]) split_with '.');
					list<int> tg <- list<int>(string(F0_data[9, i]) split_with '.');
					if(length(dit) > 0){
						loop j from: 0 to: length(dit) - 1{
							dis << Districts first_with (each.ID = dit[j]);
							tim << starting_date add_days (tg[j]-1);	
						}
						tim << quarantine;
					}
					ask dis[0]{
						new <- new + 1;
					}
				}
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
	// ngay cong bo duong tinh
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
	int new <- 0;
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
		R <- #pi*2*2*p*C*pol/S/1000000;
	}
	
	action spread {
		int num <- poisson(R);
		create F0 number: num{
			self.dis << myself;
			self.tim << current_date add_minutes 15;
			self.stat <- rnd(1, 10) > 4 ? 2:1; // ti le nguoi benh khoi phai trieu chung som la 60%
			if(self.stat = 2){
				int day <- max(int(ceil(gauss(3, 1))), 0);
				loop i from: 1 to: day{
					dis << one_of(Districts);
					tim << tim[0] add_days i;
				}
				quarantine <- tim[0] add_days day;
			}
			else if(self.stat = 1){
				int day <- max(int(ceil(gauss(3, 1))), 0);
				loop i from: 1 to: day{
					dis << one_of(Districts);
					tim << tim[0] add_days i;
				}
				quarantine <- tim[0] add_days day;
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

experiment Donothing type: gui{
	float minimum_cycle_duration <- 0.002;
	parameter name: "ti le lay nhiem" var: P;
	parameter name: "Hang so tinh ti le tiep xuc" var: C;
	parameter name: "loai kich ban" var: scen_num <- 1;
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
	}
}
experiment Scene_2 type: gui{
	parameter name: "ti le lay nhiem" var: P;
	parameter name: "Hang so tinh ti le tiep xuc" var: C;
	parameter name: "loai kich ban" var: scen_num <- 2;
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
	}
}
experiment Scene_3 type: gui{
	parameter name: "ti le lay nhiem" var: P;
	parameter name: "Hang so tinh ti le tiep xuc" var: C;
	parameter name: "loai kich ban" var: scen_num <- 3;
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
	}
}
experiment Scene_4 type: gui{
	parameter name: "ti le lay nhiem" var: P;
	parameter name: "Hang so tinh ti le tiep xuc" var: C;
	parameter name: "loai kich ban" var: scen_num <- 4;
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
	}
}
experiment Scene_real1 type: gui{
	parameter name: "ti le lay nhiem" var: P;
	parameter name: "Hang so tinh ti le tiep xuc" var: C;
	parameter name: "loai kich ban" var: scen_num <- 5;
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
	}
}
experiment Scene_real2 type: gui{
	parameter name: "ti le lay nhiem" var: P;
	parameter name: "Hang so tinh ti le tiep xuc" var: C;
	parameter name: "loai kich ban" var: scen_num <- 6;
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
	}
}