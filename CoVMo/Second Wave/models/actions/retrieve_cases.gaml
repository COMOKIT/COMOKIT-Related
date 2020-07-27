/***
* Name: Provinces
* Author: hqngh
* Description: 
* Tags: Tag1, Tag2, TagN
***/
@ no_experiment model retrieve_cases

import "trigger_color.gaml"
import "../Constants.gaml"
import "../Parameters.gaml"
import "../species/AdministrativeBound.gaml"

global {

	action retrieve_cases {
		string fpath <- "../data/VNM_1_statistic.csv";
		if (!file_exists(fpath)) {
			return;
		}

		file statistic_csv_file <- csv_file(fpath, true);
		matrix statistic_cases <- (statistic_csv_file.contents);
		bool new<-false;
		loop while: ((row_idx < statistic_cases.rows) and (current_date.day_of_year >= date(statistic_cases[3, row_idx]).day_of_year)) {
			if (!(statistic_cases_added contains row_idx)) {
				new<-true;
			//				string str <- "" + (statistic_cases[0, row_idx]) + " " + (statistic_cases[1, row_idx]) + " " + (statistic_cases[2, row_idx]) + " " + date(statistic_cases[3, row_idx]);
			//				write "xxxx " + row_idx + " " + str;
			//				ask (AdministrativeBound_1 where (each.GID_2 = GIS_id2 and each.VARNAME_3 = statistic_cases[2, row_idx])) {
				list<AdministrativeBound_1> adm1;
				list<AdministrativeBound_2> adm2;
				list<AdministrativeBound_3> adm3;
				//				write ""+statistic_cases[2, row_idx]+" "+statistic_cases[4, row_idx]+" "+statistic_cases[5, row_idx];
				if (statistic_cases[2, row_idx] = "" or statistic_cases[2, row_idx] = "cach ly") {
					adm1 <- (first(map_adm_1.values));
//					write statistic_cases[2, row_idx];
				} else {
					adm1 <- AdministrativeBound_1 where (each.VARNAME_1 = statistic_cases[2, row_idx]);
				}

				if (statistic_cases[4, row_idx] = "" or statistic_cases[4, row_idx] = "cach ly") {
					adm2 <- (AdministrativeBound_2 where (each.VARNAME_1 = statistic_cases[2, row_idx]));
				} else {
					adm2 <- map_adm_2["" + statistic_cases[2, row_idx] + " " + statistic_cases[4, row_idx]];
				}

				if (statistic_cases[5, row_idx] = "" or statistic_cases[5, row_idx] = "cach ly") {
					adm3 <- (AdministrativeBound_3 where (each.VARNAME_2 = statistic_cases[4, row_idx]));
				} else {
					adm3 <- map_adm_3["" + statistic_cases[4, row_idx] + " " + statistic_cases[5, row_idx]];
				}
				//				list D;
				ask adm1 {
				//					write VARNAME_2;
				//					infected <- true;
				//					I <- I + 1;
				//					S <- S - 1;
					create DetectedCase returns: D {
						if (statistic_cases[2, row_idx] = "" or statistic_cases[2, row_idx] = "cach ly") {
							confined <- true;
						}else{							
							origin1 <- myself;
						}

						name <- (statistic_cases[0, row_idx]);
						if (length(adm2) > 0) {
							origin2 <- first(adm2);
							origin2.circle_bound <- circle(origin2.size_of_circle_2) at_location origin2.location;
						}

						if (first(adm3) != nil) {
							origin3 <- first(adm3);
							origin3.circle_bound <- circle(origin3.size_of_circle_3) at_location origin3.location;
						}

						detected_date <- date(statistic_cases[3, row_idx]);
					}

					//					write ""+int(first(D));
					D <- D where (!each.confined);
					if(!empty(D)){ 
					I <- 1.0;
					S <- float(20 + rnd(80));
					N <- int(S + I);
					do solving;
					F1 <- int(F1 + I);
					//					write self.VARNAME_1;
					circle_bound <- circle(size_of_circle_1) at_location location;
					ask D {
						do change_zoom;
					}
 
						detected_cases_F0 << first(D);
						ask neighbors {
							high_contact <- high_contact + 0.5;
						}

						if (length(adm2) > 0) {
							first(adm2).detected_cases_F0 << first(D);
							ask first(adm2).neighbors {
								high_contact <- high_contact + 0.5;
							}

//							ask adm2 {
//								risk_point <- self.accessment();
//			max_risk_point <- max([200,AdministrativeBound_1 max_of each.risk_point]);
//								my_risk_color <- hsb(0, (risk_point > 0 ? 0.05 : 0) + ((risk_point / max_risk_point) < 0.75 ? (risk_point / max_risk_point) : 0.75), 1);
//							}

						}

						if (length(adm3) > 0) {
							first(adm3).detected_cases_F0 << first(D);
							ask first(adm3).neighbors {
								high_contact <- high_contact + 0.5;
							}

//							ask adm3 {
//								risk_point <- self.accessment();
//								}
//
//							ask adm3 {
//								my_risk_color <- hsb(0, (risk_point > 0 ? 0.05 : 0) + ((risk_point / max_risk_point) < 0.75 ? (risk_point / max_risk_point) : 0.75), 1);
//							}

						} 

					}
				}
				statistic_cases_added << row_idx;
			}

			row_idx <- row_idx + 1;
		}
		if(new){
			
				do trigger_color;
		}

	}

}