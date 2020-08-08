/***
* Name: Corona
* Author: hqngh
* Description: 
* Tags: Tag1, Tag2, TagN
***/
model Corona

import "Abstract Experiment.gaml"
experiment Pandemic2020 type: gui parent: AbstractExp autorun: false {

	parameter "Date" var: date_idx <- 0 min: 0 max: 70 on_change: {
		ask world {
			do trigger_fetch_data;
		}

	};
	init {
		gama.pref_display_visible_agents <- true;	
		gama.pref_display_zoom_factor <- 0.25;
		
	} 
	output {
//		layout #split consoles: false editors: false navigator: false tray: false tabs: false toolbars: true;
		display "Mixed" parent: default_mixed_wander_display synchronized: false type: java2D {
		} 
	}

}