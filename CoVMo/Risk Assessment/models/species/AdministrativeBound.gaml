/***
* Name: AdministrativeBound
* Author: hqngh
* Description: 
* Tags: Tag1, Tag2, TagN
***/
@ no_experiment model AdministrativeBound

import "EpidemiologicHost.gaml"
import "DetectedCase.gaml"
import "../Parameters.gaml"
species AdministrativeBound parent: EpidemiologicHost {
	string NAME_1;
	string NAME_2;
	string NAME_3;
	string GID_1;
	string GID_2;
	string GID_3;
	string VARNAME_1;
	string VARNAME_2;
	string VARNAME_3;
	list<AdministrativeBound> neighbors <- [];
	list<DetectedCase> detected_cases_F0 <- [];
	int pop;
	int F1 <- 0;
	int extern;
	int foreigner;
	int moving;
	float high_contact;
	int low_contact;
	int social_distancing;
	int traffic_in;
	int emphasize;
	float risk_point; //-> {accessment()};
	float risk_social;
	float risk_contact;
	float risk_policy;
	string current_gid;
	string current_name;
	string current_varname;
	string parent_varname;
	geometry circle_bound;
	float _Chi_so_muc_do_nghiem_trong <- 0.0;
	float _Chi_so_nguy_co_xam_nhap <- 0.0;
	float _Luu_tru <- 0.0;
	float _Bien_gioi <- 0.0;
	float _Su_kien_dong_nguoi <- 0.0;
	float _Di_cu_lien_tinh <- 0.0;
	float _Chi_so_nguy_co_ca_nhan <- 0.0;
	float _Di_chuyen_nhieu <- 0.0;
	float _Tiep_xuc_nhieu <- 0.0;
	float _Chi_so_nguy_co_moi_truong_xa_hoi <- 0.0;
	float _Mat_do_dan_so <- 0.0;
	float _TP_truc_thuoc_TW <- 0.0;
	float _Do_thi_khac <- 0.0;
	float _Nong_thon <- 0.0;
	float _Hoat_dong_kinh_te <- 0.0;
	float _Ky_tuc_xa <- 0.0;
	float _Chi_so_nguy_co_suc_khoe_va_benh_ly_nen <- 0.0;
	float _Benh_nen_man_tinh <- 0.0;
	float _Dan_so_gia <- 0.0;
	float _Chi_so_nang_luc_ung_pho_Covid <- 0.0;
	float _So_nhan_vien_y_te_va_bac_sy_dan_so <- 0.0;
	float _So_giuong_benh <- 0.0;
	float _So_may_tho <- 0.0;
	float _So_co_so_y_te <- 0.0;
	float _So_ICU <- 0.0;
	float _Benh_vien_TW <- 0.0;
	float _Kham_tu_xa <- 0.0;
	float _So_may_PCR <- 0.0;
	float _Ty_le_BN_nguoi_dan_nghi_ngo_duoc_xet_nghiem_PCR <- 0.0;
	float _Chi_so_giam_sat_phat_hien_truy_vet <- 0.0;
	float _Chi_so_nguy_co_tu_duong_bien_gioi <- 0.0;
	float _Lien_quan_den_Trung_Quoc <- 0.0;
	float _lien_quan_den_Lao <- 0.0;
	float _lien_quan_den_Campuchia <- 0.0;
	float _Chi_so_dap_ung_chinh_quyen <- 0.0;
	float _Chi_so_dap_ung_chinh_quyen_Tot <- 0.0;
	float _Chi_so_dap_ung_chinh_quyen_Trung_binh <- 0.0;
	float _Chi_so_dap_ung_chinh_quyen_Yeu <- 0.0;
	float _Chi_so_dong_mo_truong_hop <- 0.0;
	float _Chi_so_dong_mo_truong_hop_dong <- 0.0;
	float _Chi_so_dong_mo_truong_hop_mo <- 0.0;
	float _Chi_so_ho_tro <- 0.0;
	float _Ho_tro_nguoi_gia <- 0.0;
	float _Ho_tro_nguoi_co_trieu_chung <- 0.0;
	rgb my_risk_color;
	float size_of_circle_1 -> {(1 #km + ((length(detected_cases_F0) / nb_increase_size_1) < 30 ? (length(detected_cases_F0) / nb_increase_size_1) #km : 30 #km))};
	float size_of_circle_2 -> {(1 #km + ((length(detected_cases_F0) / nb_increase_size_1) < 30 ? (length(detected_cases_F0) / nb_increase_size_1) #km : 30
	#km)) * ((world.shape.perimeter) / 8000000)};
	float size_of_circle_3 -> {(1 #km + ((length(detected_cases_F0) / nb_increase_size_1) < 30 ? (length(detected_cases_F0) / nb_increase_size_1) #km : 30
	#km)) * ((world.shape.perimeter) / 20000000)};
	//	map<int,float> c_size<-[5::size_of_circle_1,8::size_of_circle_2,11::size_of_circle_3];
	list<float> lst_risk_point <- [0.0, 0.0, 0.0, 0.0, 0.0];
	float accessment {
		return accessment_19_04();
	}

	float accessment_19_04 {
		float result <- 0.0;
		result <- result + weight_Chi_so_muc_do_nghiem_trong * (get_risk_F0());
		result <- result + weight_Chi_so_nguy_co_xam_nhap * _Chi_so_nguy_co_xam_nhap;
		result <- result + weight_Luu_tru * _Luu_tru;
		result <- result + weight_Bien_gioi * _Bien_gioi;
		result <- result + weight_Su_kien_dong_nguoi * _Su_kien_dong_nguoi;
		result <- result + weight_Di_cu_lien_tinh * _Di_cu_lien_tinh;
		result <- result + weight_Chi_so_nguy_co_ca_nhan * _Chi_so_nguy_co_ca_nhan;
		result <- result + weight_Di_chuyen_nhieu * _Di_chuyen_nhieu;
		result <- result + weight_Tiep_xuc_nhieu * _Tiep_xuc_nhieu;
		result <- result + weight_Chi_so_nguy_co_moi_truong_xa_hoi * _Chi_so_nguy_co_moi_truong_xa_hoi;
		result <- result + weight_Mat_do_dan_so * _Mat_do_dan_so;
		result <- result + weight_TP_truc_thuoc_TW * _TP_truc_thuoc_TW;
		result <- result + weight_Do_thi_khac * _Do_thi_khac;
		result <- result + weight_Nong_thon * _Nong_thon;
		result <- result + weight_Hoat_dong_kinh_te * _Hoat_dong_kinh_te;
		result <- result + weight_Ky_tuc_xa * _Ky_tuc_xa;
		result <- result + weight_Chi_so_nguy_co_suc_khoe_va_benh_ly_nen * _Chi_so_nguy_co_suc_khoe_va_benh_ly_nen;
		result <- result + weight_Benh_nen_man_tinh * _Benh_nen_man_tinh;
		result <- result + weight_Dan_so_gia * _Dan_so_gia;
		result <- result + weight_Chi_so_nang_luc_ung_pho_Covid * _Chi_so_nang_luc_ung_pho_Covid;
		result <- result + weight_So_nhan_vien_y_te_va_bac_sy_dan_so * _So_nhan_vien_y_te_va_bac_sy_dan_so;
		result <- result + weight_So_giuong_benh * _So_giuong_benh;
		result <- result + weight_So_may_tho * _So_may_tho;
		result <- result + weight_So_co_so_y_te * _So_co_so_y_te;
		result <- result + weight_So_ICU * _So_ICU;
		result <- result + weight_Benh_vien_TW * _Benh_vien_TW;
		result <- result + weight_Kham_tu_xa * _Kham_tu_xa;
		result <- result + weight_So_may_PCR * _So_may_PCR;
		result <- result + weight_Ty_le_BN_nguoi_dan_nghi_ngo_duoc_xet_nghiem_PCR * _Ty_le_BN_nguoi_dan_nghi_ngo_duoc_xet_nghiem_PCR;
		result <- result + weight_Chi_so_giam_sat_phat_hien_truy_vet * _Chi_so_giam_sat_phat_hien_truy_vet;
		result <- result + weight_Chi_so_nguy_co_tu_duong_bien_gioi * _Chi_so_nguy_co_tu_duong_bien_gioi;
		result <- result + weight_Lien_quan_den_Trung_Quoc * _Lien_quan_den_Trung_Quoc;
		result <- result + weight_lien_quan_den_Lao * _lien_quan_den_Lao;
		result <- result + weight_lien_quan_den_Campuchia * _lien_quan_den_Campuchia;
		result <- result + weight_Chi_so_dap_ung_chinh_quyen * _Chi_so_dap_ung_chinh_quyen;
		result <- result + weight_Chi_so_dap_ung_chinh_quyen_Tot * _Chi_so_dap_ung_chinh_quyen_Tot;
		result <- result + weight_Chi_so_dap_ung_chinh_quyen_Trung_binh * _Chi_so_dap_ung_chinh_quyen_Trung_binh;
		result <- result + weight_Chi_so_dap_ung_chinh_quyen_Yeu * _Chi_so_dap_ung_chinh_quyen_Yeu;
		result <- result + weight_Chi_so_dong_mo_truong_hop * _Chi_so_dong_mo_truong_hop;
		result <- result + weight_Chi_so_dong_mo_truong_hop_dong * _Chi_so_dong_mo_truong_hop_dong;
		result <- result + weight_Chi_so_dong_mo_truong_hop_mo * _Chi_so_dong_mo_truong_hop_mo;
		result <- result + weight_Chi_so_ho_tro * _Chi_so_ho_tro;
		result <- result + weight_Ho_tro_nguoi_gia * _Ho_tro_nguoi_gia;
		result <- result + weight_Ho_tro_nguoi_co_trieu_chung * _Ho_tro_nguoi_co_trieu_chung;
		return result;
	}

	float accessment18_04 {
		return
		weight_Chi_so_muc_do_nghiem_trong * get_risk_F0() + weight_risk_personality * get_risk_personality() + weight_risk_society * get_risk_society() + weight_Chi_so_nguy_co_xam_nhap * get_risk_intruder() + weight_risk_policy * get_risk_policy();
	}

	float get_risk_F0 {
		return ((length(detected_cases_F0) + F1));
		//		return lst_risk_point[0];
	}

	float get_risk_personality {
		return lst_risk_point[1];
	}

	float get_risk_society {
		return lst_risk_point[2];
	}

	float get_risk_intruder {
		return lst_risk_point[3];
	}

	float get_risk_policy {
		return lst_risk_point[4];
	}

	float accessment_16_Apr {
		return weight_risk_social * get_risk_social() + weight_risk_contact * get_risk_contact() + weight_risk_policy * get_risk_policy();
	}

	float get_risk_social {
		return p_F0F1 * ((length(detected_cases_F0) + F1)) + p_extern * (extern) + p_foreigner * (foreigner) + p_moving * (moving);
	}

	float get_risk_contact {
		return p_high_contact * high_contact + p_low_contact * low_contact;
	}

	float get_risk_policy {
		return p_social_distancing * social_distancing + p_traffic_in * traffic_in + p_emphasize * emphasize;
	}

	aspect risky {
	//		if(accessment()>0){			
		draw shape color: my_risk_color border: #black;
		//		}
		//		if (#zoom > 1.1) {
		//			draw NAME_3 at: location color: #black;
		//		}

	}

	aspect default {
	//		draw shape color: I>0?#red:#white border: #black;
		draw shape color: #white empty: true border: #darkgray;
		if (length(detected_cases_F0) > 0) {
			if (length(GIS_id) = 5) {
				draw circle(size_of_circle_1) color: #red;
			}

			if (length(GIS_id) = 8) {
				draw circle(size_of_circle_2) color: #red;
			}

			if (length(GIS_id) = 11) {
				draw circle(size_of_circle_3) color: #red;
			}
			//			draw circle( (d <10? (d*2)#km:20#km)*((world.shape.perimeter)/2000000)   ) color: #yellow;
			//			draw arc((d <10? (d*2)#km:20#km)*((world.shape.perimeter)/2000000),0,180,true) color: #red;
			//			draw arc((d <10? (d*2)#km:20#km)*((world.shape.perimeter)/2000000),180,180,true)   color: #yellow;
		}

	}

	aspect simple {
	//		draw shape color: I>0?#red:#white border: #black;
		draw shape color: my_risk_color border: #white;
		//		if (#zoom > 3) {
		//			draw current_name at: location color: #white;
		//		}

	}

	aspect mixed {
	// 		draw shape color: #white empty: true border: #darkgray;
		draw shape color: my_risk_color border: #black;
		if (length(detected_cases_F0) > 0) {
			if (length(GIS_id) = 5) {
				draw circle(size_of_circle_1) color: #red border: #yellow;
			}

			if (length(GIS_id) = 8) {
				draw circle(size_of_circle_2) color: #red border: #yellow;
			}

			if (length(GIS_id) = 11) {
				draw circle(size_of_circle_3) color: #red border: #yellow;
			}

		}

	}

	aspect mixed_wander {
	// 		draw shape color: #white empty: true border: #darkgray;
		draw shape color: my_risk_color border: #black;

		//		if (length(detected_cases_F0) > 0) {
		//			if (length(GIS_id) = 5) {
		//				draw circle(size_of_circle_1) color: #red border: #yellow;
		//			}
		//
		//			if (length(GIS_id) = 8) {
		//				draw circle(size_of_circle_2) color: #red border: #yellow;
		//			}
		//
		//			if (length(GIS_id) = 11) {
		//				draw circle(size_of_circle_3) color: #red border: #yellow;
		//			}
		//
		//		}

	}

}

species AdministrativeBound_1 parent: AdministrativeBound {
	list<AdministrativeBound_1> possible_transport <- [];
	int flow_capacity <- 1;

	reflex transportation when: !empty(possible_transport) and show_traffic {
		loop p over: possible_transport {
			create People {
				condense <- myself.flow_capacity;
				location <- myself.location;
				my_target <- p.location;
				do init;
			}

		}

	}

	aspect simple {
		if (#zoom <= zoom1) {
			draw shape color: my_risk_color border: #gray;
			//			draw shape color: #white empty: true border: #gray;
			//			draw current_name at: location color: #white;
		}
		//			draw circle(2#km) color:  #red  border: #black;

	}

}

species AdministrativeBound_2 parent: AdministrativeBound {

	aspect simple {
	//		draw shape color: I>0?#red:#white border: #black;
		if (#zoom > zoom1 and #zoom <= zoom2) {
			draw shape color: my_risk_color border: #gray;
			//			draw shape color: #white empty: true border: #gray;
			//			draw current_name at: location color: #white;
		}

	}

}

species AdministrativeBound_3 parent: AdministrativeBound {

	aspect simple {
	//		draw shape color: I>0?#red:#white border: #black;
		if (#zoom > zoom2) {
			draw shape color: my_risk_color border: #gray;
			//			draw shape color: #white empty: true border: #gray;
			//			draw current_name at: location color: #white;
		}

	}

}