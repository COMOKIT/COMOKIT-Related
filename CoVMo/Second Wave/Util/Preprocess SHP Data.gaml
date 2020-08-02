/***
* Name: Corona
* Author: hqngh
* Description: 
* Tags: Tag1, Tag2, TagN
***/
model Parameters

import "../models/Constants.gaml"

global {
	shape_file provinces_shp_file1 <- shape_file("../includes/gadm36_VNM_shp/gadm36_VNM_1.shp");
	shape_file provinces_shp_file2 <- shape_file("../includes/gadm36_VNM_shp/gadm36_VNM_2.shp");
	shape_file provinces_shp_file3 <- shape_file("../includes/gadm36_VNM_shp/gadm36_VNM_3.shp");
	shape_file provinces_shp_file4 <- shape_file("../data/HanhChinh_All/ProvinceIsLands_WGS84.shp");
	//	shape_file provinces_shp_file <- shape_file("../includes/gadm36_VNM_shp/gadm36_VNM.shp");
	geometry shape <- envelope(provinces_shp_file1);

	init {
		create iris from: csv_file("ds.csv", true) with: [x::float(get("tx")), y::float(get("ty"))];
		ask iris {
			write " " + x + " " + y;
			location<-({x,y});
//		location <- CRS_transform({x, y},  "EPSG:3857").location;  
			location <- to_GAMA_CRS({x,y}, "EPSG:4326").location;//to_GAMA_CRS({x, y}).location
			write location;
		}
			save iris crs: 4326 to: "isir.shp" type: "shp";
//		do split;
	}

	action tmp {
		shape_file p3 <- shape_file("../includes/gadm36_VNM_shp/gadm36_VNM_2.shp");
		//		shape_file p3 <- shape_file("../includes/gadm36_VNM_shp/generated/gadm36_VNM_1.shp"); 
		list<string>
		bb <- ['office', 'admin', 'industry', 'store', 'shop', 'bookstore', 'gamecenter', 'restaurant', 'coffeeshop', 'caphe', 'caphe-karaoke', 'farm', 'repairshop', 'hostel'];
		create building from: p3 {
			type <- "";
		}

		loop b over: bb {
			any(building where (each.type = "")).type <- b;
			any(building where (each.type = "")).type <- b;
			any(building where (each.type = "")).type <- b;
			any(building where (each.type = "")).type <- b;
		}

		save building crs: 3857 to: "buildings.shp" type: "shp" attributes:
		["ID"::int(self), "NAME_1"::NAME_1, "GID_1"::GID_1, "NAME_2"::NAME_2, "GID_2"::GID_2, "NAME_3"::NAME_3, "GID_3"::GID_3, "VARNAME_1"::VARNAME_1, "VARNAME_2"::VARNAME_2, "VARNAME_3"::VARNAME_3, "type"::type];
	}

	action split {
	//		shape_file longlbienshp <- shape_file("../includes/gadm36_VNM_shp/generated/VNM.27.16_1.shp");
	//		create adm3 from: longlbienshp;
	//		ask adm3 {
	//			save [self] to: "../includes/gadm36_VNM_shp/generated/VNM.27.16_1/"+VARNAME_3+"/boundary.shp" type: "shp" attributes:
	//			["ID"::int(self), "NAME_1"::NAME_1, "GID_1"::GID_1, "NAME_2"::NAME_2, "GID_2"::GID_2, "NAME_3"::NAME_3, "GID_3"::GID_3, "VARNAME_1"::VARNAME_1, "VARNAME_2"::VARNAME_2, "VARNAME_3"::VARNAME_3];
	//		}
	//		list<string> lst_city <- ["VNM.54_1", "VNM.19_1", "VNM.47_1"];
		list<string> lst_city <- ["VNM.19_1"];
		//		create adm1 from: provinces_shp_file1;
		//		ask adm1 where (each.GID_1 in lst_city) {
		//			shape<-CRS_transform(shape, "EPSG:4326"  );
		//			save [self] to: "../includes/gadm36_VNM_shp/generated/" + GID_1 + ".shp" type: "shp" attributes:
		//			["ID"::int(self), "NAME_1"::NAME_1, "GID_1"::GID_1, "NAME_2"::NAME_2, "GID_2"::GID_2, "NAME_3"::NAME_3, "GID_3"::GID_3, "VARNAME_1"::VARNAME_1, "VARNAME_2"::VARNAME_2, "VARNAME_3"::VARNAME_3];
		//		}
		//
		create adm2 from: provinces_shp_file2;
		ask adm2 where (each.GID_1 in lst_city) {
//			shape <- CRS_transform(shape, "EPSG:4326");
			save [self] crs: 3857 to: "../includes/gadm36_VNM_shp/generated/" + GID_1 + "/" + GID_2 + ".shp" type: "shp" attributes:
			["ID"::int(self), "NAME_1"::NAME_1, "GID_1"::GID_1, "NAME_2"::NAME_2, "GID_2"::GID_2, "NAME_3"::NAME_3, "GID_3"::GID_3, "VARNAME_1"::VARNAME_1, "VARNAME_2"::VARNAME_2, "VARNAME_3"::VARNAME_3];
		}

		create adm3 from: provinces_shp_file3;
		ask adm3 where (each.GID_1 in lst_city) {
		//			write shape;
		//			shape<-CRS_transform(shape, "EPSG:3857", "EPSG:4326" );
		//			shape<-CRS_transform(shape, "EPSG:32648" , "EPSG:3857");
		//			write shape;
		//			shape<-to_GAMA_CRS(shape);
			save [self] crs: 3857 to: "../includes/gadm36_VNM_shp/generated/" + GID_1 + "/" + GID_2 + "/" + GID_3 + ".shp" type: "shp" attributes:
			["ID"::int(self), "NAME_1"::NAME_1, "GID_1"::GID_1, "NAME_2"::NAME_2, "GID_2"::GID_2, "NAME_3"::NAME_3, "GID_3"::GID_3, "VARNAME_1"::VARNAME_1, "VARNAME_2"::VARNAME_2, "VARNAME_3"::VARNAME_3];
		}

	}

	action generate_demograph {
		string old_gid <- "";
		string csv <- "";
		create adm2 from: provinces_shp_file2 {
			if (old_gid = "") {
				old_gid <- GID_1;
				csv <- ""; // "district,commune,extern,foreigner,moving,high_contact,low_contact,social_distancing,traffic_in,emphasize\n";
			}

			if (old_gid != GID_1) {
				save csv to: "../data/demographie/generated/" + old_gid + ".csv" type: "csv" rewrite: true;
				old_gid <- GID_1;
				csv <- ""; //"district,commune,extern,foreigner,moving,high_contact,low_contact,social_distancing,traffic_in,emphasize\n";
			}

			csv <-
			csv + VARNAME_1 + "," + VARNAME_2 + "," + rnd(100) + "," + rnd(100) + "," + rnd(100) + "," + rnd(100) + "," + rnd(100) + "," + rnd(100) + "," + rnd(100) + "," + rnd(100) + "\n";
		}

		old_gid <- "";
		create adm3 from: provinces_shp_file3 {
			if (old_gid = "") {
				old_gid <- GID_2;
				csv <- ""; // "district,commune,extern,foreigner,moving,high_contact,low_contact,social_distancing,traffic_in,emphasize\n";
			}

			if (old_gid != GID_2) {
				save csv to: "../data/demographie/generated/" + old_gid + ".csv" type: "csv" rewrite: true;
				old_gid <- GID_2;
				csv <- ""; //"district,commune,extern,foreigner,moving,high_contact,low_contact,social_distancing,traffic_in,emphasize\n";
			}

			csv <-
			csv + VARNAME_2 + "," + VARNAME_3 + "," + rnd(100) + "," + rnd(100) + "," + rnd(100) + "," + rnd(100) + "," + rnd(100) + "," + rnd(100) + "," + rnd(100) + "," + rnd(100) + "\n";
		}

	}

	action convertprojdata {
		create adm1 from: provinces_shp_file1 {
			VARNAME_1 <- first(adm1 where (each.GID_1 = GID_1)).VARNAME_1;
		}

		create adm1bis from: provinces_shp_file4 {
			if (NAME_EN = "Ba Ria Vung Tau") {
				NAME_EN <- "Ba Ria - Vung Tau";
			}

			adm1 a <- first(adm1 where (each.VARNAME_1 = NAME_EN));
			if (a = nil) {
				write NAME_EN + " " + a;
				return;
			}

			NAME_1 <- a.NAME_1;
			NAME_2 <- a.NAME_2;
			NAME_3 <- a.NAME_3;
			GID_1 <- a.GID_1;
			GID_2 <- a.GID_2;
			GID_3 <- a.GID_3;
			VARNAME_1 <- a.VARNAME_1;
			VARNAME_2 <- a.VARNAME_2;
			VARNAME_3 <- a.VARNAME_3;
			GIS_X <- a.location.x;
			GIS_Y <- a.location.y;
		}
		//		create adm2 from: provinces_shp_file2{
		//			VARNAME_2 <- first(adm2 where (each.GID_2 = GID_2)).VARNAME_2;
		//			VARNAME_1 <- first(adm1 where (each.GID_1 = GID_1)).VARNAME_1;
		//		}
		//		create adm3 from: provinces_shp_file3 {
		//			VARNAME_2 <- first(adm2 where (each.GID_2 = GID_2)).VARNAME_2;
		//			VARNAME_1 <- first(adm1 where (each.GID_1 = GID_1)).VARNAME_1;
		//		}
		save adm1bis to: "../includes/gadm36_VNM_shp/generated/gadm36_VNM_1.shp" type: "shp" attributes:
		["ID"::int(self), "NAME_1"::NAME_1, "GID_1"::GID_1, "NAME_2"::NAME_2, "GID_2"::GID_2, "NAME_3"::NAME_3, "GID_3"::GID_3, "VARNAME_1"::VARNAME_1, "VARNAME_2"::VARNAME_2, "VARNAME_3"::VARNAME_3, "GIS_X"::GIS_X, "GIS_Y"::GIS_Y];
		//		save adm2 to: "../includes/gadm36_VNM_shp/generated/gadm36_VNM_2.shp" type: "shp" attributes:
		//		["ID"::int(self), "NAME_1"::NAME_1, "GID_1"::GID_1, "NAME_2"::NAME_2, "GID_2"::GID_2, "NAME_3"::NAME_3, "GID_3"::GID_3, "VARNAME_1"::VARNAME_1, "VARNAME_2"::VARNAME_2, "VARNAME_3"::VARNAME_3];
	}

	action mergedata {
		create adm1 from: provinces_shp_file1;
		create adm2 from: provinces_shp_file2;
		create adm3 from: provinces_shp_file3 {
			VARNAME_2 <- first(adm2 where (each.GID_2 = GID_2)).VARNAME_2;
			VARNAME_1 <- first(adm1 where (each.GID_1 = GID_1)).VARNAME_1;
		}

		save adm3 to: "../includes/gadm36_VNM_shp/gadm36_VNM.shp" type: "shp" attributes:
		["ID"::int(self), "NAME_1"::NAME_1, "GID_1"::GID_1, "NAME_2"::NAME_2, "GID_2"::GID_2, "NAME_3"::NAME_3, "GID_3"::GID_3, "VARNAME_1"::VARNAME_1, "VARNAME_2"::VARNAME_2, "VARNAME_3"::VARNAME_3];
	}

}

species iris {
	float x;
	float y; 

}
species building {
	string NAME_1;
	string NAME_2;
	string NAME_3;
	string GID_1;
	string GID_2;
	string GID_3;
	string VARNAME_1;
	string VARNAME_2;
	string VARNAME_3;
	string type;
}

species adm1bis {
	string NAME_VN;
	string NAME_EN;
	string NAME_1;
	string NAME_2;
	string NAME_3;
	string GID_1;
	string GID_2;
	string GID_3;
	string VARNAME_1;
	string VARNAME_2;
	string VARNAME_3;
	float GIS_X;
	float GIS_Y;
}

species adm1 {
	string NAME_1;
	string NAME_2;
	string NAME_3;
	string GID_1;
	string GID_2;
	string GID_3;
	string VARNAME_1;
	string VARNAME_2;
	string VARNAME_3;
}

species adm2 {
	string NAME_1;
	string NAME_2;
	string NAME_3;
	string GID_1;
	string GID_2;
	string GID_3;
	string VARNAME_1;
	string VARNAME_2;
	string VARNAME_3;
}

species adm3 {
	string NAME_1;
	string NAME_2;
	string NAME_3;
	string GID_1;
	string GID_2;
	string GID_3;
	string VARNAME_1;
	string VARNAME_2;
	string VARNAME_3;
}

experiment "Merge data" type: gui {
//	output {
//		display "SS" {
//			species adm1;
//		}
//
//	}

}