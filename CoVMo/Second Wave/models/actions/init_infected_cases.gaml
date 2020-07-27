/***
* Name: Provinces
* Author: hqngh
* Description: 
* Tags: Tag1, Tag2, TagN
***/
@ no_experiment model init_infected_cases

import "../Constants.gaml"
import "../Parameters.gaml"
import "../species/AdministrativeBound.gaml"

global {

	action init_infected_cases {
		string fpath <- "../data/VNM_1.csv";
		if (!file_exists(fpath)) {
			return;
		}

		file pop_csv_file <- csv_file(fpath);
		matrix data <- (pop_csv_file.contents);
		loop i from: 0 to: data.rows - 1 {
			AdministrativeBound_1 p <- first(AdministrativeBound_1 where (each.VARNAME_1 = data[0, i]));
			if (p != nil) {
				ask p {
					pop <- int(data[1, i]);
					N <- int(data[1, i]);
					I <- float(data[2, i]);
					if (I > 0) {
						create DetectedCase number: I returns: D {
							name <- "" + int(self);
							recovered <- true;
							confined <- true;
							//						origin1 <- myself;
							origin2 <- first(AdministrativeBound_2 where (each.VARNAME_1 = myself.VARNAME_1));
							//						location <- any_location_in(origin1.circle_bound);
						}

						circle_bound <- circle(size_of_circle_1) at_location location;
						//					detected_cases_F0 <- detected_cases_F0 + D;
					}

				}

			}

		}

	}

}