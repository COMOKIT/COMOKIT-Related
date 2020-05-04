/***
* Name: draw
* Author: dongh
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model Draw

/* Insert your model definition here */
global {

	csv_file scen2 <- csv_file("../scen2.csv");

	csv_file scen3 <- csv_file("../scen3.csv");

	csv_file scen4 <- csv_file("../scen4.csv");

	csv_file scen5 <- csv_file("../scen5.csv");

	csv_file scen6 <- csv_file("../scen6.csv");
	
	matrix s2 <- matrix(scen2);
	matrix s3 <- matrix(scen3);
	matrix s4 <- matrix(scen4);
	matrix s5 <- matrix(scen5);
	matrix s6 <- matrix(scen6);
	
	float sc2; float sc3; float sc4; float sc5; float sc6;
	
	reflex take_value {
		sc2 <- float(s2[cycle, 29]);
		sc3 <- float(s3[cycle, 29]);
		sc4 <- float(s4[cycle, 29]);
		sc5 <- float(s5[cycle, 24]);
		sc6 <- float(s6[cycle, 18]);
		if (cycle >= 90){
			do pause;
		}
	} 
		

}
experiment draw {
	output{
		display "chart" {
			chart "Time Series" type: series {
        		data "scenarios 2" value: sc2 color: #black;
        		data "scenarios 3" value: sc3 color: #violet;
        		data "scenarios 4" value: sc4 color: #green;
        		data "scenarios 5" value: sc5 color: #red;
        		data "scenarios 6" value: sc6 color: #blue;
       		 } 			
		}
	}
}
