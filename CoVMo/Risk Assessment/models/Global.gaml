/***
* Name: Provinces
* Author: hqngh
* Description: 
* Tags: Tag1, Tag2, TagN
***/ @ no_experiment model RiskEstimate

import "Constants.gaml"
import "Functions.gaml"
import "Parameters.gaml"
import "species/AdministrativeBound.gaml"

global {

	init {
		if (do_init) {
			do initialisation;
			//			do retrieve_risk_point;
			//			do init_infected_cases;
			//			do init_demograph;
			//			do init_transportation;
			do trigger_fetch_data;
			do trigger_color;
		}

	}

	int current_total_case;

	reflex ss {
		do trigger_fetch_data;
		do trigger_color;
	}
	date my_date;
	action trigger_fetch_data {
//		my_date<-current_date 
		my_date <- starting_date plus_days date_idx; 
		string fpath <- "../data/VNM_1_risk-"+my_date.day+"-"+my_date.month+".csv";
		if (!file_exists(fpath)) {
			return;
		}

		file risk_csv_file <- csv_file(fpath);
		//		write risk_csv_file;
		matrix data <- (risk_csv_file.contents); 
		current_total_case<-int(data[1,0]);
		loop i from: 1 to: data.rows - 1 {
			AdministrativeBound_1 p <- first(AdministrativeBound_1 where (each.VARNAME_1 = data[0, i]));
			if (p = nil) {
				write "retrieve_risk_point cannot find " + data[0, i];
			} else {
			//				p.lst_risk_point<-[float(data[1,i]),float(data[2,i]),float(data[3,i]),float(data[4,i]),float(data[5,i])];
				p.risk_point <- float(data[1, i]);
				//				write p.VARNAME_1;
				//				write float(data[1,i]);
			}

		}

	}

	action change_zoom_all {
		ask DetectedCase {
			do change_zoom;
		}

	}

	reflex run {
	//		do retrieve_cases;
	//		do retrieve_risk_point;
	}

}