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
	string file_path <- "";//"../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.1_1/VNM.19.1.1_1";
	bool loading <- false;
	//mandatory: define the bounds of the studied area
	init {
		if (loading) {
			do load_satellite_image(file_path);
			do die;
		}

	}

	file data_file <- loading?shape_file(file_path + ".shp"):shape_file("../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.1_1/VNM.19.1.1_1.shp");
	geometry shape <- envelope(data_file);

	//2344.06886728853 2853.6177374180406 {108.18542480464995,16.037336349477016,0.0} 
	//2344.06886728853 2853.6177374180406 {108.18542480464995,16.037336349477016,0.0}
	action load_satellite_image (string fp) {
		point top_left <- CRS_transform({0, 0}, "EPSG:4326").location;
		point bottom_right <- CRS_transform({shape.width, shape.height}, "EPSG:4326").location;
		write ""+file_path+" "+top_left+" "+bottom_right;
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
		//		write rest_link;
		image_file static_map_request <- image_file(rest_link);
		image_file copy <- image_file(fp + ".png", static_map_request.contents);
		save copy type: image;

		//		ask cell {		
		//			color <-rgb( (static_map_request) at {grid_x,1500 - (grid_y + 1) }) ;
		//		}
		//		//save the image retrieved
		//		save cell to: dataset_path + "/VNM.19.1.1_1.png" type: image;
		//		write "Satellite image retrieved";
		string
		rest_link2 <- "https://dev.virtualearth.net/REST/v1/Imagery/Map/AerialWithLabels/?mapArea=" + bottom_right.y + "," + top_left.x + "," + top_left.y + "," + bottom_right.x + "&mmd=1&mapSize=" + size_x + "," + size_y + "&key=AvZ5t7w-HChgI2LOFoy_UF4cf77ypi2ctGYxCgWOLGFwMGIGrsiDpCDCjliUliln";
		file f <- json_file(rest_link2);
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
	list<string> lst_city <- ["VNM.19_1"];
	list<string> lst_fp <- [];

	reflex aaa {
		create adm3 from: provinces_shp_file3;
		string ds <- "../includes/gadm36_VNM_shp/generated/";
		ask adm3 where (each.GID_1 in lst_city) {
			myself.lst_fp <+ ds + GID_1 + "/" + GID_2 + "/" + GID_3;
		}
		loop s over: lst_fp{
			write s;
			create simulation with:[file_path::s,loading::true];
		}

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
