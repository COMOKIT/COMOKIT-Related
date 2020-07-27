/***
* Name: Corona
* Author: hqngh
* Description: 
* Tags: Tag1, Tag2, TagN
***/
model Corona

import "Abstract Experiment.gaml"
experiment "Show 4 zones on 4 views" type: gui parent: AbstractExp {

	action _init_ {
		float simulation_seed <- rnd(2000.0);
		loop id over: lst_GIS_id {
			string filepath <- "../../includes/gadm36_VNM_shp/generated/" + id + ".shp";
			create simulation with: [do_init::true, GIS_id::id, provinces_shp_file::shape_file(filepath)];
		}

	}

	output {
		layout #split consoles: false editors: false navigator: false tray: false tabs: false toolbars: false;
		display "Detected" parent: default_mixed_display synchronized: false {
		}

	}

}

experiment "Show 4 zones on 8 views" type: gui parent: AbstractExp {

	action _init_ {
		float simulation_seed <- rnd(2000.0);
		loop id over: lst_GIS_id {
			string filepath <- "../../includes/gadm36_VNM_shp/generated/" + id + ".shp";
			create simulation with: [do_init::true, GIS_id::id, provinces_shp_file::shape_file(filepath)];
		}

	}

	output {
		layout #split consoles: false editors: false navigator: false tray: false tabs: false toolbars: false;
		//		layout horizontal([vertical([horizontal([0::5000,1::5000])::5000,horizontal([2::5000,3::5000])::5000])::5000,vertical([horizontal([4::5000,5::5000])::5000,horizontal([6::5000,7::5000])::5000])::5000]) tabs:false toolbars:false editors: false;
		display "Detected" parent: default_display synchronized: false {
		}

		display "Risky" parent: default_display_risk synchronized: false {
		}

	}

}