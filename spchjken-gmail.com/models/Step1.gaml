/***
* Name: Step1
* Author: dongh
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model Step1

/* first model to figure out problem with input environtment */

global{
	//import file shp dau vao
	
	shape_file boundary <- shape_file("../includes/boundary.shp");

	shape_file Ho_Chi_Minh_City <- shape_file("../includes/Ho Chi Minh City_1973756_AL4.shp");
	
	shape_file BinhChanh <- shape_file("../includes/Bình Chánh District_7157268_AL6.shp");

	shape_file BinhTan <- shape_file("../includes/Binh Tan District_6909710_AL6.shp");

	shape_file BinhThanh <- shape_file("../includes/Binh Thanh District_3797166_AL6.shp");

	shape_file CanGio <- shape_file("../includes/Can Gio District_7157255_AL6.shp");

	shape_file CuChi <- shape_file("../includes/Củ Chi District_7157220_AL6.shp");

	shape_file District_1 <- shape_file("../includes/District 1_2587287_AL6.shp");

	shape_file District_2 <- shape_file("../includes/District 2_3799817_AL6.shp");

	shape_file District_3 <- shape_file("../includes/District 3_3819816_AL6.shp");

	shape_file District_4 <- shape_file("../includes/District 4_2778323_AL6.shp");

	shape_file District_5 <- shape_file("../includes/District 5_3820432_AL6.shp");

	shape_file District_6 <- shape_file("../includes/District 6_6228792_AL6.shp");

	shape_file District_7 <- shape_file("../includes/district 7.shp");

	shape_file District_8 <- shape_file("../includes/District 8_6888445_AL6.shp");

	shape_file District_9 <- shape_file("../includes/District 9_7144246_AL6.shp");
	
	shape_file District_10 <- shape_file("../includes/District 10_6228121_AL6.shp");

	shape_file District_11 <- shape_file("../includes/District 11_6846181_AL6.shp");
	
	shape_file District_12 <- shape_file("../includes/District 12_6923167_AL6.shp");

	shape_file GoVap <- shape_file("../includes/Go Vap District_6908316_AL6.shp");

	shape_file HocMon <- shape_file("../includes/Hoc Mon District_7157219_AL6.shp");

	shape_file NhaBe <- shape_file("../includes/Nhà Bè District_7157197_AL6.shp");

	shape_file PhuNhuan <- shape_file("../includes/Phu Nhuan District_3851694_AL6.shp");

	shape_file TanBinh <- shape_file("../includes/Tan Binh District_6846177_AL6.shp");

	shape_file TanPhu <- shape_file("../includes/Tan Phu District_6846128_AL6.shp");

	shape_file ThuDuc <- shape_file("../includes/Thu Duc District_6941055_AL6.shp");
	
	geometry shape <- envelope(Ho_Chi_Minh_City);
	
	// thong nhat tap hop cac file dau vao lai
	list<file> list_dis <- [BinhChanh, BinhTan, BinhThanh, CanGio, CuChi, District_1, District_2, District_3, District_4, District_5, District_6, District_7, District_8, District_9,
		District_10, District_11, District_12, GoVap, HocMon, NhaBe, PhuNhuan, TanBinh, TanPhu, ThuDuc
	];
	
	// xac dinh moi buoc bang 15 phut
	float step <- 15 #minute;
	
	//thoi gian khoi dau mo hinh
	date starting_date <- date([2020,3,1,0,0]);
	
	init{
		loop i from: 0 to: length(list_dis) - 1{
			create districts from: list_dis[i];
		}
	}
}

species districts{
	// so thu tu
	int ID;
	//dien tich
	float S;
	//dan so
	int pol;
	//danh sach benh nhan
	list<F0> pats;
	// phan hien thi
	aspect default{
		draw shape color: #black;
	}
	aspect pie{
		draw circle(length(pats)*1000) color: #red;
	}
}

species wards parent: districts{}

species closed_sets{
	// dien tich
	float S;
	// luu luong (15p - 1 cycle)
	float pol;
	// muc do nguy co
	bool risk;
}

species F0{
	
	int ID;	
	
	string name;
	
	int age;
	
	point home;
	
	point work_station;
	
	bool other_sickness;
	
	int stat;
	
	list<point, date> movement_history;
}

species F1 parent: F0{
	
	F0 source;
	
	date time_met_source;
	
	point location_met_source;
}

species F2 parent: F0{
	
	F1 source;
	
	date time_met_source;
	
	point location_met_source;
}

experiment step_1 type: gui{
	
	output{
		display "main monitor"{
			species districts;
		}
	}
}