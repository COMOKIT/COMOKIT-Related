/***
* Name: Provinces
* Author: hqngh
* Description: 
* Tags: Tag1, Tag2, TagN
***/
@ no_experiment model retrieve_cases

import "../Constants.gaml"
import "../Parameters.gaml"
import "../species/AdministrativeBound.gaml"

global {

	
	action trigger_color {
		ask AdministrativeBound_1  + AdministrativeBound_2 + AdministrativeBound_3 {
			risk_point <- self.accessment();
		}

		max_risk_point <- max([200, AdministrativeBound_1 max_of each.risk_point]);
		ask AdministrativeBound_1  + AdministrativeBound_2 + AdministrativeBound_3 {
			my_risk_color <- hsb(0, (risk_point > 0 ? 0.05 : 0) + ((risk_point / max_risk_point) < 0.75 ? (risk_point / max_risk_point) : 0.75), 1);
		}

//		write max_risk_point;
	}


}