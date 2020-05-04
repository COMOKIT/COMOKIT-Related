/***
* Name: Provinces
* Author: hqngh
* Description: 
* Tags: Tag1, Tag2, TagN
***/
@ no_experiment model retrieve_risk_point

import "../Constants.gaml"
import "../Parameters.gaml"
import "../species/AdministrativeBound.gaml"

global {

	action retrieve_risk_point {
		string fpath <- "../data/riskpoint/risk_" + current_date.day + "_" + current_date.month + ".csv";
		if (!file_exists(fpath)) {
			return;
		}
		file risk_csv_file <- csv_file(fpath);
//		write risk_csv_file;
		matrix data <- (risk_csv_file.contents);
		loop i from: 0 to: data.rows - 1 {
			AdministrativeBound_1 p <- first(AdministrativeBound_1 where (each.VARNAME_1 = data[0, i]));
			if(p=nil){write "retrieve_risk_point cannot find "+p;}
			else{
				p.lst_risk_point<-[float(data[1,i]),float(data[2,i]),float(data[3,i]),float(data[4,i]),float(data[5,i])];
			}

		}

	}

}