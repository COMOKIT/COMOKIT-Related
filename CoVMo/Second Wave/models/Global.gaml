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
			do retrieve_risk_point;
			do init_infected_cases;
			do init_demograph;
			do init_transportation;
			do trigger_color;
		}

	}

	action change_zoom_all {
		ask DetectedCase {
			do change_zoom;
		}

	}

	reflex run {
		do retrieve_cases;
		do retrieve_risk_point;
	}

}