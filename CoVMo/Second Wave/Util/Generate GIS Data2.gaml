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

	init {
		do
		load_satellite_image("../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.1_1/VNM.19.1.1_1", "https://dev.virtualearth.net/REST/v1/Imagery/Map/AerialWithLabels/?mapArea=16.037336349477016,108.1643676757448,16.061971664418156,108.18542480464995&mapSize=500,500&key=AvZ5t7w-HChgI2LOFoy_UF4cf77ypi2ctGYxCgWOLGFwMGIGrsiDpCDCjliUliln", "https://dev.virtualearth.net/REST/v1/Imagery/Map/AerialWithLabels/?mapArea=16.037336349477016,108.1643676757448,16.061971664418156,108.18542480464995&mmd=1&mapSize=500,500&key=AvZ5t7w-HChgI2LOFoy_UF4cf77ypi2ctGYxCgWOLGFwMGIGrsiDpCDCjliUliln");
		save "" to:"C:\\Users\\hqngh\\gama_workspace1909ssl\\.cache\\dev.virtualearth.net+_++_+REST+_+v1+_+Imagery+_+Map+_+AerialWithLabels+_+";
		loop times:1000000 {write "";}
		do
		load_satellite_image("../includes/gadm36_VNM_shp/generated/VNM.19_1/VNM.19.1_1/VNM.19.1.2_1", "https://dev.virtualearth.net/REST/v1/Imagery/Map/AerialWithLabels/?mapArea=16.014179229725443,108.1643676757448,16.042131423939413,108.19940185543001&mapSize=500,500&key=AvZ5t7w-HChgI2LOFoy_UF4cf77ypi2ctGYxCgWOLGFwMGIGrsiDpCDCjliUliln", "https://dev.virtualearth.net/REST/v1/Imagery/Map/AerialWithLabels/?mapArea=16.014179229725443,108.1643676757448,16.042131423939413,108.19940185543001&mmd=1&mapSize=500,500&key=AvZ5t7w-HChgI2LOFoy_UF4cf77ypi2ctGYxCgWOLGFwMGIGrsiDpCDCjliUliln");

	}

	action load_satellite_image (string fp, string r1, string r2) {
		int size_x <- 500;
		int size_y <- 500;
		string rest_link <- r1;
		write rest_link;
		image_file static_map_request <- image_file(rest_link);
		image_file copy <- image_file(fp + ".png", static_map_request.contents);
//		save static_map_request.contents to:fp + ".png" type:image ;
		save copy;
		
		
		string rest_link2 <- r2;
		write rest_link2;
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

experiment generateGISdata type: gui {
}
