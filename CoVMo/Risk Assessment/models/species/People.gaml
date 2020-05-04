/***
* Name: DetectedCase
* Author: hqngh
* Description: 
* Tags: Tag1, Tag2, TagN
***/
@ no_experiment model People

import "AdministrativeBound.gaml"
species People skills: [moving] {
	float size <- 1 #km;
	bool confined <- false;
	bool recovered <- false;
	bool infected <- false;
	path ownpath;
	point my_target;
	//	float spd <- (1+rnd(5))#m;
	float spd <- (10) #m;
	rgb mycolor <- hsb(240 / 360, 0.5 + (rnd(5) / 10), 1);
	int condense<-1;
	action init {
		do goto target: my_target speed: spd;
		geometry c <- (rectangle(((size) * (5 + rnd(4)))/(c_zoom / 5),((size+((condense/20)#km)) * (1 + rnd(1)))/(c_zoom / 5)) at_location location )rotated_by heading;
		list cc <- [];
		loop times: condense {
			cc <+ triangle(size/(c_zoom / 5)) at_location any_location_in(c);
		}

		shape <- union(cc);
	}

	reflex moving_province when: !infected and show_traffic{
		do goto target: my_target speed: spd;
		if ((location distance_to my_target) < 4 #km) {
			do die;
		}

	}

	aspect default {
		if (show_traffic) {
			draw shape empty: true color: mycolor ;
		}

	}

}