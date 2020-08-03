  
model CoVid19

global {
	shape_file provinces_shp_file3 <- shape_file("buildings.shp"); 
//	shape_file provinces_shp_file3 <- shape_file("../includes/gadm36_VNM_shp/generated/Wave2_3_.shp"); 
//	shape_file provinces_shp_file3 <- shape_file("../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1.shp");
	//	shape_file provinces_shp_file3 <- shape_file("../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.1_1/VNM.19.1.1_1.shp");
	string file_path <- ""; //"../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.1_1/VNM.19.1.1_1";
	bool loading <- false;
	//mandatory: define the bounds of the studied area
	init {
		create adm3 from: provinces_shp_file3;
		string ds <- "../includes/gadm36_VNM_shp/generated/";
//		ask adm3 where (each.GID_1 in lst_city) {
//			write "image file: \"../includes/gadm36_VNM_shp/generated/" + GID_1 + "/" + GID_2 + "/" + GID_3 + ".png\" refresh: false;";
//		}

		//create iris agents from the CSV file (use of the header of the CSV file), the attributes of the agents are initialized from the CSV files: 
		//we set the header facet to true to directly read the values corresponding to the right column. If the header was set to false, we could use the index of the columns to initialize the agent attributes
//		create Patient from: csv_file("ds.csv", true) with: [x::float(get("x")), y::float(get("y"))];
//		ask Patient { 
////			point pt <-  {106.6780598,10.7766574}; 105.7121776,10.0804831	10.0804831,105.7121776
////			point pt <- {108.21545,16.07294};
//			point pt<-{y,x};
//			location <- to_GAMA_CRS(pt, "4326").location; 
//		}
		string fpath <- "ds02.08.csv";
		if (!file_exists(fpath)) {
			return;
		}

		file pop_csv_file <- csv_file(fpath);
		matrix data <- (pop_csv_file.contents);
		loop i from: 0 to: data.rows - 1 {
			Patient p <- first(Patient where (each.name = data[3, i]));
			if (p != nil) { 

			}

		}
	}

	geometry shape <- envelope(provinces_shp_file3);
	list<string> lst_city <- ["VNM.19_1"];
	list<string> lst_fp <- [];
	int TILE_SIZE <- 256;
	//when downloading google images, the level of zoom
	int zoom <- 18 min: 17 max: 20;
	//a function used to compute the coordinate when retrieving google map images
	reflex aaa {

	//		loop s over: lst_fp {
	//			write s;
	//			create simulation with: [file_path::s, loading::true];
	//		}

	}

}

species Patient {
	float x;
	float y; 
	string name;
	map<date,point> position;
	aspect default {
		draw circle(1000) at: location color:#red;
	}

}
//grid cell width:100 height:150{ 
//	init{
//		color<-rgb(255 * (rnd(100)/100), 0, 0);
//	}
//}
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

	aspect default {
		draw shape  empty: true border: #gray;
	}

}
//grid cell width: 1500 height:1500 use_individual_shapes: false use_regular_agents: false use_neighbors_cache: false;
experiment generateGISdata type: gui {
	output {
		display map type: opengl draw_env: false {
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.1_1/VNM.19.1.1_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.1_1/VNM.19.1.2_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.1_1/VNM.19.1.3_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.1_1/VNM.19.1.4_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.1_1/VNM.19.1.5_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.1_1/VNM.19.1.6_1.png" refresh: false;


		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.1_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.2_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.3_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.4_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.5_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.6_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.7_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.8_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.9_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.10_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.11_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.12_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.2_1/VNM.19.2.13_1.png" refresh: false;


		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.3_1/VNM.19.3.1_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.3_1/VNM.19.3.2_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.3_1/VNM.19.3.3_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.3_1/VNM.19.3.4_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.3_1/VNM.19.3.5_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.3_1/VNM.19.3.6_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.3_1/VNM.19.3.7_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.3_1/VNM.19.3.8_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.3_1/VNM.19.3.9_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.3_1/VNM.19.3.10_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.3_1/VNM.19.3.11_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.4_1/VNM.19.4.1_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.4_1/VNM.19.4.2_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.4_1/VNM.19.4.3_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.4_1/VNM.19.4.4_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.4_1/VNM.19.4.5_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.5_1/VNM.19.5.1_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.5_1/VNM.19.5.2_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.5_1/VNM.19.5.3_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.5_1/VNM.19.5.4_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.6_1/VNM.19.6.1_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.6_1/VNM.19.6.2_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.6_1/VNM.19.6.3_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.6_1/VNM.19.6.4_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.6_1/VNM.19.6.5_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.6_1/VNM.19.6.6_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.6_1/VNM.19.6.7_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.7_1/VNM.19.7.1_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.7_1/VNM.19.7.2_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.7_1/VNM.19.7.3_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.7_1/VNM.19.7.4_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.7_1/VNM.19.7.5_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.7_1/VNM.19.7.6_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.7_1/VNM.19.7.7_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.7_1/VNM.19.7.8_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.7_1/VNM.19.7.9_1.png" refresh: false;
		//			image file: "../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.7_1/VNM.19.7.10_1.png" refresh: false;
			species adm3; //position: {0, 0, 0.001};
			species Patient;
			graphics ss{
				draw envelope(Patient) color:#yellow;
			}
			// 			grid cell  lines:#red transparency:0.8;
		}

	}

}
