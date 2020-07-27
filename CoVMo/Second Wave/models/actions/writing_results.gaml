/***
* Name: Provinces
* Author: hqngh
* Description: 
* Tags: Tag1, Tag2, TagN
***/
@ no_experiment model writing_results

import "../Constants.gaml"
import "../Parameters.gaml"
import "../species/AdministrativeBound.gaml"

global {
// Action that will be called from the parameter pane
	action writing_results {
		string filename <- GIS_id + "_risk.csv";
		string res <- "";
		list<AdministrativeBound_1> out <- AdministrativeBound_1 sort_by (-each.risk_point);
		ask (AdministrativeBound_1 sort_by (-each.risk_point)) {
			res <- res + current_name + "," + risk_point + "," + F1 + "\n";
		}

//		write res;
		save data: res to: a_file.path + "/" + filename type: "csv" header: false rewrite: true;
	}

}