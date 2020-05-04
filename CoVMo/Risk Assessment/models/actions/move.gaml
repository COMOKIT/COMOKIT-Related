/***
* Name: Provinces
* Author: hqngh
* Description: 
* Tags: Tag1, Tag2, TagN
***/
@ no_experiment model move

import "../Constants.gaml"
import "../Parameters.gaml"
import "../species/AdministrativeBound.gaml"

global {

	action when_mouse_move {
		info_target1 <- zone1 at_location #user_location;
		info_target2 <- zone2 at_location #user_location;
		info_target3 <- zone3 at_location #user_location;
		under_mouse_agent <- nil;
		if (c_zoom <= zoom1) {
			under_mouse_agent <- first(AdministrativeBound_1 where (info_target1 overlaps each.shape));
		}

		if (c_zoom > zoom1 and c_zoom <= zoom2) {
			under_mouse_agent <- first(AdministrativeBound_2 where (info_target2 overlaps each.shape));
		}

		if (c_zoom > zoom2) {
			under_mouse_agent <- first(AdministrativeBound_3 where (info_target3 overlaps each.shape));
		}

		if (under_mouse_agent != nil) { 						
			info_text <-(under_mouse_agent.parent_varname != "Viet Nam" ? (under_mouse_agent.parent_varname + ", ") : "") + under_mouse_agent.current_varname;
			info_text <- info_text + ": " + (length(under_mouse_agent.detected_cases_F0)+length(DetectedCase where (each.origin1=under_mouse_agent)));
		}

	}

}