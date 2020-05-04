/***
* Name: tempt
* Author: dongh
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model tempt

/* Insert your model definition here */
global{
	init{
		create called number: 2;
		create caller number: 1;
	}
}
species called{
	action c{
		return 4.0;
	}
}
species caller{
	reflex fun when: cycle = 10{
		float t;
		loop i over: called{
			write float(i.c);
			t <- t + float(i.c);
		}
		write t;
	}
}
experiment temp type: gui{
	output{
		display 'main'{
			
		}
	}
}
