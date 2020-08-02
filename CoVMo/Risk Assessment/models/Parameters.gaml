/***
* Name: Corona
* Author: hqngh
* Description: 
* Tags: Tag1, Tag2, TagN
***/
@ no_experiment model Parameters

import "Constants.gaml"
import "species/AdministrativeBound.gaml"

global {
// xac dinh moi buoc bang 15 phut
	float step <- 15 #minute;
	float c_zoom <- 1.0;
	//thoi gian khoi dau mo hinh
	date starting_date <- date([2020, 8, 2, 7, 0]);

	// thoi gian virus ton tai va gay nguy hiem o khu vuc benh nhan di qua (tinh theo gio)
	int v_time_life <- 24;
	bool do_init <- true;
	float _size <- world.shape.perimeter / 10000;
	//	shape_file provinces_shp_file <- shape_file("../includes/gadm36_VNM_shp/gadm36_VNM_1.shp");
	//	shape_file provinces_shp_file <- shape_file("../includes/gadm36_VNM_shp/gadm36_VNM_2.shp");
	shape_file provinces_shp_file; // <- shape_file("../includes/gadm36_VNM_shp/gadm36_VNM_3.shp");
//	shape_file provinces_shp_file1 <- shape_file("../includes/gadm36_VNM_shp/gadm36_VNM_1.shp");
	shape_file provinces_shp_file1 <- shape_file("../includes/gadm36_VNM_shp/generated/gadm36_VNM_1.shp");
	shape_file provinces_shp_file2 <- shape_file("../includes/gadm36_VNM_shp/gadm36_VNM_2.shp");
	shape_file provinces_shp_file3 <- shape_file("../includes/gadm36_VNM_shp/gadm36_VNM_3.shp");
	//	shape_file provinces_shp_file3 <- shape_file("../includes/gadm36_VNM_shp/generated/VNM.27.16_1.shp");
	list<int> statistic_cases_added <- [];
//	geometry shape <- envelope(image_file("../images/satellite_" + GIS_id + ".png"));
		geometry shape <- envelope(provinces_shp_file1);
	bool show_traffic <- true;
	bool show_ranking <- true;
	int nb_ranking_list <- 10;
	file a_file <- folder("../results/");
	bool a_boolean_to_disable_parameters <- true;
//	float weight_risk_F0 <- 5.0;
	float weight_risk_personality <- 2.0;
	float weight_risk_society <- 3.0;
//	float weight_risk_intruder <- 4.0;
	float weight_risk_policy <- 3.0;
	float weight_risk_pathology <- 3.0;
	
	
	
	
	
	float weight_Chi_so_muc_do_nghiem_trong <- 5.0 ;
	float weight_Chi_so_nguy_co_xam_nhap <- 4.0 ;
	float weight_Luu_tru <- 10.0 ;
	float weight_Bien_gioi <- 20.0 ;
	float weight_Su_kien_dong_nguoi <- 20.0 ;
	float weight_Di_cu_lien_tinh <- 50.0 ;
	float weight_Chi_so_nguy_co_ca_nhan <- 1.0 ;
	float weight_Di_chuyen_nhieu <- 30.0 ;
	float weight_Tiep_xuc_nhieu <- 70.0 ;
	float weight_Chi_so_nguy_co_moi_truong_xa_hoi <- 5.0 ;
	float weight_Mat_do_dan_so <- 20.0 ;
	float weight_TP_truc_thuoc_TW <- 50.0 ;
	float weight_Do_thi_khac <- 20.0 ;
	float weight_Nong_thon <- 10.0 ;
	float weight_Hoat_dong_kinh_te <- 20.0 ;
	float weight_Ky_tuc_xa <- 10.0 ;
	float weight_Chi_so_nguy_co_suc_khoe_va_benh_ly_nen <- 3.0 ;	
	float weight_Benh_nen_man_tinh <- 70.0 ;
	float weight_Dan_so_gia <- 30.0 ;
	float weight_Chi_so_nang_luc_ung_pho_Covid <- 3.0 ;
	float weight_So_nhan_vien_y_te_va_bac_sy_dan_so <- 10.0 ;
	float weight_So_giuong_benh <- 10.0 ;
	float weight_So_may_tho <- 30.0 ;
	float weight_So_co_so_y_te <- 10.0 ;
	float weight_So_ICU <- 20.0 ;
	float weight_Benh_vien_TW <- 30.0 ;
	float weight_Kham_tu_xa <- 10.0 ;
	float weight_So_may_PCR <- 10.0 ;
	float weight_Ty_le_BN_nguoi_dan_nghi_ngo_duoc_xet_nghiem_PCR <- 30.0 ;
	float weight_Chi_so_giam_sat_phat_hien_truy_vet <- 5.0 ;
	float weight_Chi_so_nguy_co_tu_duong_bien_gioi <- 5.0 ;
	float weight_Lien_quan_den_Trung_Quoc <- 5.0 ;
	float weight_lien_quan_den_Lao <- 5.0 ;
	float weight_lien_quan_den_Campuchia <- 5.0 ;
	float weight_Chi_so_dap_ung_chinh_quyen <- 5.0 ;
	float weight_Chi_so_dap_ung_chinh_quyen_Tot <- 5.0 ;
	float weight_Chi_so_dap_ung_chinh_quyen_Trung_binh <- 5.0 ;
	float weight_Chi_so_dap_ung_chinh_quyen_Yeu <- 5.0 ;
	float weight_Chi_so_dong_mo_truong_hop <- 5.0 ;
	float weight_Chi_so_dong_mo_truong_hop_dong <- 5.0 ;
	float weight_Chi_so_dong_mo_truong_hop_mo <- 5.0 ;
	float weight_Chi_so_ho_tro <- 5.0 ;
	float weight_Ho_tro_nguoi_gia <- 5.0 ;
	float weight_Ho_tro_nguoi_co_trieu_chung <- 5.0 ;

	
	
	
	
	
	float weight_risky_activity <- 0.5;
	float weight_risky_zone <- 0.5;
	float weight_risky_transport <- 0.5;
	float weight_risky_policy <- 0.5;
	float weight_risk_social <- 0.35;
	float weight_risk_contact <- 0.3;
	//	float weight_risk_policy<-0.35;
	float p_F0F1 <- 0.35;
	float p_extern <- 0.2;
	float p_foreigner <- 0.3;
	float p_moving <- 0.2;
	float p_high_contact <- 0.6;
	float p_low_contact <- 0.4;
	float p_social_distancing <- 0.45;
	float p_traffic_in <- 0.35;
	float p_emphasize <- 0.2;
	string GIS_id0 <- "VNM_1";
	string GIS_id1 <- "VNM.27_1";
	string GIS_id2 <- "VNM.27.16_1";
	string GIS_id3 <- "VNM.25_1";
	list<string> lst_GIS_id <- [GIS_id0, GIS_id1, GIS_id2, GIS_id3];
	string GIS_id <- lst_GIS_id[0];
	map<string, string> map_GIS_name <- [GIS_id0::"Việt Nam", GIS_id1::"Hà Nội", GIS_id2::"Long Biên", GIS_id3::"Hồ Chí Minh"];

	//	float max_risk_point ->{AdministrativeBound_1 max_of each.risk_point};
	map<string, list<AdministrativeBound_1>> map_adm_1; // <- AdministrativeBound_1 group_by (each.VARNAME_1);
	map<string, list<AdministrativeBound_2>> map_adm_2; // <- AdministrativeBound_1 group_by (each.VARNAME_2);
	map<string, list<AdministrativeBound_3>> map_adm_3; // <- AdministrativeBound_1 group_by (each.VARNAME_2+" "+each.VARNAME_3);
	map<string, list<string>> quarantine_zone;
	geometry info_target1;
	geometry info_target2;
	geometry info_target3;
	string info_text <- "";
	geometry zone1 <- circle(0.1 #m);
	geometry zone2 <- circle(0.1 #m);
	geometry zone3 <- circle(0.001 #m);
	AdministrativeBound under_mouse_agent;
	int nb_increase_size_1 <- 10;
	int nb_increase_size_2 <- 20;
	int nb_increase_size_3 <- 1;
	map<int, int> map_nb_increase <- [5::nb_increase_size_1, 8::nb_increase_size_1, 11::nb_increase_size_1];
	float max_risk_point <- 200.0;
	//	float radius_circle_1<- (20 #km);
	//	float radius_circle_2 -> (1#km) ;
	//	float radius_circle_3 -> (0.01#m);
	int row_idx <- 0;
	int zoom1 <- 10;
	int zoom2 <- 30;
}