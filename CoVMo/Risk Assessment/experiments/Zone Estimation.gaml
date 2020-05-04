/***
* Name: Corona
* Author: hqngh
* Description: 
* Tags: Tag1, Tag2, TagN
***/
model Corona

import "Abstract Experiment.gaml"
experiment Pandemic2020 type: gui parent: AbstractExp {

	action _init_ {
	/* 
		 * Ha noi 		VNM.27_1
		 * Long Bien	VNM.27.16_1
		 */
//		string GIS_id <- "VNM.27.16_1";
		int index <- -1;
		string question <- "Chọn vùng :\n 0 - Việt Nam \n 1 - Hà Nội \n 2 - Long Biên \n 3 - Hổ Chí Minh";
		index <- int(user_input(question, ["Your choice"::2])["Your choice"]);
		string filepath <- "../../includes/gadm36_VNM_shp/generated/" + lst_GIS_id[index] + ".shp";
		if (!file_exists(filepath)) {
			write "generate sub_shp";
			create simulation with: [do_init::false, GIS_id::lst_GIS_id[index]]{
				if (length(GIS_id) = 8) {
					provinces_shp_file <- shape_file("../includes/gadm36_VNM_shp/gadm36_VNM_2.shp");
					create AdministrativeBound from: provinces_shp_file;
					save (AdministrativeBound where (each.GID_1 = GIS_id)) to: filepath type: "shp" attributes:
					["ID"::int(self), "NAME_1"::NAME_1, "GID_1"::GID_1, "NAME_2"::NAME_2, "GID_2"::GID_2, "NAME_3"::NAME_3, "GID_3"::GID_3, "VARNAME_1"::VARNAME_1, "VARNAME_2"::VARNAME_2, "VARNAME_3"::VARNAME_3];
				}
				if (length(GIS_id) = 11) {
					create AdministrativeBound from: provinces_shp_file;
					save (AdministrativeBound where (each.GID_2 = GIS_id)) to: filepath type: "shp" attributes:
					["ID"::int(self), "NAME_1"::NAME_1, "GID_1"::GID_1, "NAME_2"::NAME_2, "GID_2"::GID_2, "NAME_3"::NAME_3, "GID_3"::GID_3, "VARNAME_1"::VARNAME_1, "VARNAME_2"::VARNAME_2, "VARNAME_3"::VARNAME_3];
				}
				do die;
			}

		}

		create simulation with: [do_init::true, GIS_id::lst_GIS_id[index], provinces_shp_file::shape_file(filepath)];
	}

	output {
		layout #split consoles: false editors: false navigator: false tray: false tabs: false toolbars: false;
		display "Mixed" parent: default_mixed_display {
			
		}
//		display "Detected" synchronized: false background: background  draw_env: false {
//			image file: "../images/satellite_" + GIS_id + ".png" refresh: false;
//			overlay position: {100, 0} size: {700 #px, 200 #px} transparency: 0 {
//				draw (""+map_GIS_name[GIS_id] + " | Infected") font: default at: {20 #px, 50 #px} anchor: #top_left color: text_color;
//				draw (""+current_date) font: default at: {20 #px, 80 #px} anchor: #top_left color: text_color;
//			}
//
//			species AdministrativeBound aspect: default;
//			
//			event mouse_move action: move;
//			
//			graphics "Info" 
//			{
//				if (under_mouse_agent!=nil)
//				{
//					string str<-under_mouse_agent.VARNAME_1+","+under_mouse_agent.VARNAME_2+","+under_mouse_agent.VARNAME_3+"\n"+length(under_mouse_agent.detected_cases_F0);
//					draw str at:target empty: false border: false color: #wheat;
//				}
//
//			}
//		}

//		display "Risky" parent: default_display_risk {
//		}

	}

}