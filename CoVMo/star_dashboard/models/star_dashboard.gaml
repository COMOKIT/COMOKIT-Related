/***
* Name: stardashboard
* Author: dongh
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model stardashboard

/* Insert your model definition here */
species Reader{
	int ID;
	date start;
	action become_F0{
		create F0 number: 1{
			ID <- 'BN' + string(myself.ID);
			start <- myself.start;
			relevant << Diease_location first_with (each.name = F0_mat[4, myself.ID]);
			relevant << Diease_location first_with (each.name = F0_mat[5, myself.ID]);
			relevant << Diease_location first_with (each.name = F0_mat[6, myself.ID]);
			ask relevant{
				patients << myself;
				dd <- dd+1;
			}
		}
	}
}

species Timer{
	aspect default{
		draw string(current_date) at: point([40, 25]) font: font('Arial', 20, #plain) color: #black;
	}
}

species F0{
	string ID;
	date start;
	date quarantine;
	date recovered;
	list<Diease_location> relevant;
	point location;
	bool computed <- false;
}

species Diease_location{
	string name;
	list<F0> patients;
	point location;
	int plus <- 0;
	int dd <- 0;
	
	action compute_location(int i){
		switch i{
			match 1{
				location <- point([50, 50]);
			}
			match_between[2, 9]{
				location <- point([50+10*sin((i-2)*45), 50+10*cos((i-2)*45)]);
			}
			match_between[10, 21]{
				location <- point([50+20*sin((i-10)*30 + 10), 50+20*cos((i-10)*30 + 10)]);
			}
			match_between[22, 36]{
				location <- point([50+30*sin((i-10)*24 + 20), 50+30*cos((i-10)*24 + 20)]);
			}
			match_between[37, 51]{
				location <- point([50+40*sin((i-10)*24 + 30), 50+40*cos((i-10)*24 + 30)]);
			}
			default{
				do die;
			}
		}
		loop j over: patients where (each.computed = false){
			j.location <- self.location + point([(1.7 + plus*0.08)*(sin(30*plus - div(plus, 12)* 7)),
												 (1.7 + plus*0.08)*(cos(30*plus - div(plus, 12)* 7))]);
			j.computed <- true;
			plus <- plus + 1;
		}
	}
	
	aspect star_draw{
			
		ask patients{
			draw circle(0.4) at: self.location color: #blue;
			//draw ID at: location font: font('Arial', 12, #plain) color: #black;
			draw line(location, myself.location) color:#blue;
		}
		if(dd > 0) {
			draw circle(div(length(patients), 10)*0.2 + 0.5) at: location color: #red;
			draw name at: location font: font('Arial', 14, #plain) color: #black;
		}
		else { draw circle(div(length(patients), 10)*0.2 + 1) at: point([1000,1000]) color: #white;}
		
	}
}

global{	
	csv_file F00_csv_file <- csv_file("../includes/F0.csv");
	csv_file Local0_csv_file <- csv_file("../includes/Local.csv");
	matrix F0_mat <- matrix(F00_csv_file);
	matrix local_mat <- matrix(Local0_csv_file);
	date starting_date <- date([2020, 1, 18]);
	list<Diease_location> d;
	int index <- 1;
	float step <- 6 #h;
	init{
		create Timer number: 1;
		create Diease_location from: Local0_csv_file;
		create Reader from: F00_csv_file;
		loop i from: 1 to: length(Diease_location) - 1{
			Diease_location(i).name <- local_mat[0, i];
		}
		loop j from: 1 to: length(Reader) - 1{
			Reader(j).ID <- int(F0_mat[0, j]);
			Reader(j).start <- date(F0_mat[3, j]);
		}
	}
	
	reflex appear{
		ask Reader{
			if (current_date = start){
				do become_F0;
				do die;
			}
		}
	}
	
	reflex show{
		index <- 1;
		ask Diease_location where (each.dd > 0) {
			do compute_location(index);
			index <- index + 1;
		}
	}
}
experiment Star_dashboard type: gui{
	 
	float minimum_cycle_duration <- 0.002;
	output{
		display "main"{
			 species Timer;
			 species Diease_location aspect: star_draw;
		}
	}
}
