/******************************************************************
* This file is part of COMOKIT, the GAMA CoVid19 Modeling Kit
* Relase 1.0, May 2020. See http://comokit.org for support and updates
* 
* Given a boundary.shp shapefile that defines a zone, this model enables
* to create the GIS file of buildings from OSM, to get additional information
* from GoogleMap (types of buildings) and to download a background satellite image
* 
* Author: Patrick Taillandier
* Tags: covid19,epidemiology, gis
******************************************************************/
model CoVid19

global {
	shape_file provinces_shp_file3 <- shape_file("../includes/gadm36_VNM_shp/gadm36_VNM_3.shp");
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.1_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.2_1";
//		string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.3_1";
//		string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.4_1";
		string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.5_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.6_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.7_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.8_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.9_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.10_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.11_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.12_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.13_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.14_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.15_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.16_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.17_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.18_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.19_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.20_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.21_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.22_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.23_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.24_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.25_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.26_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.27_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.28_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.29_1";
	//	string file_path <- "../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.30_1";
	//	string file_path <- ""; //"../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.1_1/VNM.19.1.1_1";
	//	bool loading <- false;
	bool loading <- true;
	//mandatory: define the bounds of the studied area
	init {
		if (loading) {
			do load_satellite_image(file_path);
			save "" to: "C:\\Users\\hqngh\\gama_workspace1909ssl\\.cache\\dev.virtualearth.net+_++_+REST+_+v1+_+Imagery+_+Map+_+AerialWithLabels+_+";
			do die;
		}

	}

	//	file data_file <- loading ? shape_file(file_path + ".shp") : shape_file("../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.1_1/VNM.19.1.1_1.shp");
	file data_file <- loading ? shape_file(file_path + ".shp") : shape_file("../includes/gadm36_VNM_shp/generated/VNM.27_1/VNM.27.1_1/VNM.27.1.1_1.shp");
	geometry shape <- envelope(data_file);

	//2344.06886728853 2853.6177374180406 {108.18542480464995,16.037336349477016,0.0} 
	//2344.06886728853 2853.6177374180406 {108.18542480464995,16.037336349477016,0.0}
	action load_satellite_image (string fp) {
		point top_left <- CRS_transform({0, 0}, "EPSG:4326").location;
		point bottom_right <- CRS_transform({shape.width, shape.height}, "EPSG:4326").location;
		//		write "" + file_path;
		//		write shape;
		//		write "" + top_left + " " + bottom_right;
		//		write top_left;
		//		write "" + shape.width + " " + shape.height + " " + bottom_right;

		//				file d_file <- shape_file(fp + ".shp");
		//				geometry shp <- envelope(d_file);
		//				point ori<-{min(shp.points collect each.x), min(shp.points collect each.y)};
		//				point tmp <- to_GAMA_CRS(ori).location;
		//				point top_left <- CRS_transform(tmp, "EPSG:3857", "EPSG:4326").location;
		//				tmp <- to_GAMA_CRS({-shp.width, shp.height}).location;
		//				point bottom_right <- CRS_transform({-tmp.x, tmp.y}, "EPSG:3857", "EPSG:4326").location;
		//				write top_left;
		//				write "" + shp.width + " " + shp.height + " " + bottom_right;
		int size_x <- 1500;
		int size_y <- 1500;
		string
		rest_link <- "https://dev.virtualearth.net/REST/v1/Imagery/Map/AerialWithLabels/?mapArea=" + bottom_right.y + "," + top_left.x + "," + top_left.y + "," + bottom_right.x + "&mapSize=" + size_x + "," + size_y + "&key=AvZ5t7w-HChgI2LOFoy_UF4cf77ypi2ctGYxCgWOLGFwMGIGrsiDpCDCjliUliln";
		write rest_link;
		image_file static_map_request <- image_file(rest_link);
		//		loop times: 50000000 {
		//			int i <- 0;
		//		}
		image_file copy <- image_file(fp + ".png", static_map_request.contents);
		save copy type: image;
		static_map_request <- nil;

		//		ask cell {		
		//			color <-rgb( (static_map_request) at {grid_x,1500 - (grid_y + 1) }) ;
		//		}
		//		//save the image retrieved
		//		save cell to: dataset_path + "/VNM.19.1.1_1.png" type: image;
		//		write "Satellite image retrieved";
		string
		rest_link2 <- "https://dev.virtualearth.net/REST/v1/Imagery/Map/AerialWithLabels/?mapArea=" + bottom_right.y + "," + top_left.x + "," + top_left.y + "," + bottom_right.x + "&mmd=1&mapSize=" + size_x + "," + size_y + "&key=AvZ5t7w-HChgI2LOFoy_UF4cf77ypi2ctGYxCgWOLGFwMGIGrsiDpCDCjliUliln";
		write rest_link2;
		file f <- json_file(rest_link2);

		//		loop times:50000000{int i<-0;}
		list<string> v <- string(f.contents) split_with ",";
		int index <- 0;
		loop i from: 0 to: length(v) - 1 {
			if ("bbox" in v[i]) {
				index <- i;
				break;
			}

		}

		float long_min <- float(v[index] replace ("'bbox'::[", ""));
		float long_max <- float(v[index + 2] replace (" ", ""));
		float lat_min <- float(v[index + 1] replace (" ", ""));
		float lat_max <- float(v[index + 3] replace ("]", ""));
		point pt1 <- CRS_transform({lat_min, long_max}, "EPSG:4326", "EPSG:3857").location;
		point pt2 <- CRS_transform({lat_max, long_min}, "EPSG:4326", "EPSG:3857").location;
		float width <- abs(pt1.x - pt2.x) / size_x;
		float height <- (pt2.y - pt1.y) / size_y;
		string info <- "" + width + "\n0.0\n0.0\n" + height + "\n" + min(pt1.x, pt2.x) + "\n" + (height < 0 ? max(pt1.y, pt2.y) : min(pt1.y, pt2.y));

		//save the metadata
		save info to: fp + ".pgw";
		//		write "Satellite image saved with the right meta-data";
	}

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
//grid cell width: 1500 height:1500 use_individual_shapes: false use_regular_agents: false use_neighbors_cache: false;
experiment generateGISdata type: gui {
	list<string> lst_city <- ["VNM.27_1"];
	list<string> lst_fp <- [];

	//	action _init_ {
	//		lst_fp <-
	//		['../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.1_1/VNM.19.1.2_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.1_1/VNM.19.1.1_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.1_1/VNM.19.1.2_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.1_1/VNM.19.1.3_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.1_1/VNM.19.1.4_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.1_1/VNM.19.1.5_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.1_1/VNM.19.1.6_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.1_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.2_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.3_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.4_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.5_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.6_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.7_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.8_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.9_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.10_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.11_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.12_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.13_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.3_1/VNM.19.3.1_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.3_1/VNM.19.3.2_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.3_1/VNM.19.3.3_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.3_1/VNM.19.3.4_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.3_1/VNM.19.3.5_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.3_1/VNM.19.3.6_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.3_1/VNM.19.3.7_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.3_1/VNM.19.3.8_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.3_1/VNM.19.3.9_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.3_1/VNM.19.3.10_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.3_1/VNM.19.3.11_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.4_1/VNM.19.4.1_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.4_1/VNM.19.4.2_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.4_1/VNM.19.4.3_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.4_1/VNM.19.4.4_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.4_1/VNM.19.4.5_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.5_1/VNM.19.5.1_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.5_1/VNM.19.5.2_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.5_1/VNM.19.5.3_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.5_1/VNM.19.5.4_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.6_1/VNM.19.6.1_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.6_1/VNM.19.6.2_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.6_1/VNM.19.6.3_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.6_1/VNM.19.6.4_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.6_1/VNM.19.6.5_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.6_1/VNM.19.6.6_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.6_1/VNM.19.6.7_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.7_1/VNM.19.7.1_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.7_1/VNM.19.7.2_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.7_1/VNM.19.7.3_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.7_1/VNM.19.7.4_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.7_1/VNM.19.7.5_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.7_1/VNM.19.7.6_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.7_1/VNM.19.7.7_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.7_1/VNM.19.7.8_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.7_1/VNM.19.7.9_1', '../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.7_1/VNM.19.7.10_1'];
	//		loop s over: lst_fp {
	//			write s;
	//			//			create simulation with: [file_path::s, shape::envelope(shape_file(s + ".shp")) , loading::true];
	////			create simulation with: [file_path::s, loading::true];
	////			save "" to: "C:\\Users\\hqngh\\gama_workspace1909ssl\\.cache\\dev.virtualearth.net+_++_+REST+_+v1+_+Imagery+_+Map+_+AerialWithLabels+_+";
	////			loop times: 1000000 {
	////				write "";
	////			}
	//
	//		}
	//
	//	}
	reflex aaa {
		create adm3 from: provinces_shp_file3;
		string ds <- "../includes/gadm36_VNM_shp/generated/";
		ask adm3 where (each.GID_1 in lst_city) {
			myself.lst_fp <+ ds + GID_1 + "/" + GID_2 + "/" + GID_3;
		}

		write lst_fp;
		//		loop s over: lst_fp {
		//			write s;
		//			create simulation with: [file_path::s, loading::true];
		//		}

	}
	//	output {
	//		display map type: opengl draw_env: false background: #black {
	//			image (file_exists(dataset_path + "/VNM.19.1.1_1.png") ? (dataset_path + "/VNM.19.1.1_1.png") : "white.png"); //transparency: 0.2;
	//			//			graphics "tile" {
	//			//				if bounds_tile != nil {
	//			//					draw bounds_tile color: #red empty: true;
	//			//				}
	//			//
	//			//			}
	//
	//		}
	//
	//	}

}
