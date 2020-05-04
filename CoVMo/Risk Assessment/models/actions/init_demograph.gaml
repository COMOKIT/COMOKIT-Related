/***
* Name: Provinces
* Author: hqngh
* Description: 
* Tags: Tag1, Tag2, TagN
***/
@ no_experiment model init_demograph

import "../Constants.gaml"
import "../Parameters.gaml"
import "../species/AdministrativeBound.gaml"

global {

	action init_demograph {
		string fpath1 <- "../../data/VNM_1_formula.csv";
		file demo_csv_file1 <- csv_file(fpath1, true);
		matrix data <- (demo_csv_file1.contents);
		loop i from: 0 to: data.rows - 1 {
		//				write "" + data[0, i] + " " + data[1, i];
			ask map_adm_1["" + data[0, i]] {
				_Chi_so_muc_do_nghiem_trong <- float(data[1, i]);
				_Chi_so_nguy_co_xam_nhap <- float(data[2, i]);
				_Luu_tru <- float(data[3, i]);
				_Bien_gioi <- float(data[4, i]);
				_Su_kien_dong_nguoi <- float(data[5, i]);
				_Di_cu_lien_tinh <- float(data[6, i]);
				_Chi_so_nguy_co_ca_nhan <- float(data[7, i]);
				_Di_chuyen_nhieu <- float(data[8, i]);
				_Tiep_xuc_nhieu <- float(data[9, i]);
				_Chi_so_nguy_co_moi_truong_xa_hoi <- float(data[10, i]);
				_Mat_do_dan_so <- float(data[11, i]);
				_TP_truc_thuoc_TW <- float(data[12, i]);
				_Do_thi_khac <- float(data[13, i]);
				_Nong_thon <- float(data[14, i]);
				_Hoat_dong_kinh_te <- float(data[15, i]);
				_Ky_tuc_xa <- float(data[16, i]);
				_Chi_so_nguy_co_suc_khoe_va_benh_ly_nen <- float(data[17, i]);
				_Benh_nen_man_tinh <- float(data[18, i]);
				_Dan_so_gia <- float(data[19, i]);
				_Chi_so_nang_luc_ung_pho_Covid <- float(data[20, i]);
				_So_nhan_vien_y_te_va_bac_sy_dan_so <- float(data[21, i]);
				_So_giuong_benh <- float(data[22, i]);
				_So_may_tho <- float(data[23, i]);
				_So_co_so_y_te <- float(data[24, i]);
				_So_ICU <- float(data[25, i]);
				_Benh_vien_TW <- float(data[26, i]);
				_Kham_tu_xa <- float(data[27, i]);
				_So_may_PCR <- float(data[28, i]);
				_Ty_le_BN_nguoi_dan_nghi_ngo_duoc_xet_nghiem_PCR <- float(data[29, i]);
				//_Chi_s? ?�p ?ng<-float(data[30, i]);
				_Chi_so_giam_sat_phat_hien_truy_vet <- float(data[31, i]);
				_Chi_so_nguy_co_tu_duong_bien_gioi <- float(data[32, i]);
				_Lien_quan_den_Trung_Quoc <- float(data[33, i]);
				_lien_quan_den_Lao <- float(data[34, i]);
				_lien_quan_den_Campuchia <- float(data[35, i]);
				_Chi_so_dap_ung_chinh_quyen <- float(data[36, i]);
				_Chi_so_dap_ung_chinh_quyen_Tot <- float(data[37, i]);
				_Chi_so_dap_ung_chinh_quyen_Trung_binh <- float(data[38, i]);
				_Chi_so_dap_ung_chinh_quyen_Yeu <- float(data[39, i]);
				_Chi_so_dong_mo_truong_hop <- float(data[40, i]);
				_Chi_so_dong_mo_truong_hop_dong <- float(data[41, i]);
				_Chi_so_dong_mo_truong_hop_mo <- float(data[42, i]);
				_Chi_so_ho_tro <- float(data[43, i]);
				_Ho_tro_nguoi_gia <- float(data[44, i]);
				_Ho_tro_nguoi_co_trieu_chung <- float(data[45, i]);
			}

		}

		fpath1 <- "../../data/demographie/VNM_1.csv";
		//		if (!file_exists(fpath1)) {
		ask AdministrativeBound_1 + AdministrativeBound_2 + AdministrativeBound_3 {
			extern <- rnd(100);
			foreigner <- rnd(100);
			moving <- rnd(100);
			high_contact <- rnd(100.0);
			low_contact <- rnd(100);
			social_distancing <- rnd(100);
			traffic_in <- rnd(100);
			emphasize <- rnd(100);
		}
		//			return;
		//		}
		demo_csv_file1 <- csv_file(fpath1, true);
		data <- (demo_csv_file1.contents);
		loop i from: 0 to: data.rows - 1 {
		//				write "" + data[0, i] + " " + data[1, i];
			ask map_adm_1["" + data[1, i]] {
			//				write int(self);
				extern <- int(data[2, i]);
				foreigner <- int(data[3, i]);
				moving <- int(data[4, i]);
				high_contact <- float(data[5, i]);
				low_contact <- int(data[6, i]);
				social_distancing <- int(data[7, i]);
				traffic_in <- int(data[8, i]);
				emphasize <- int(data[9, i]);
			}

		}

		string fpath2 <- "../../data/demographie/VNM.27_1.csv";
		file demo_csv_file2 <- csv_file(fpath2, true);
		data <- (demo_csv_file2.contents);
		loop i from: 0 to: data.rows - 1 {
		//						write "" + data[0, i] + " " + data[1, i];
			ask map_adm_2["" + data[0, i] + " " + data[1, i]] {
				extern <- int(data[2, i]);
				foreigner <- int(data[3, i]);
				moving <- int(data[4, i]);
				high_contact <- float(data[5, i]);
				low_contact <- int(data[6, i]);
				social_distancing <- int(data[7, i]);
				traffic_in <- int(data[8, i]);
				emphasize <- int(data[9, i]);
			}

		}

		fpath2 <- "../../data/demographie/VNM.25_1.csv";
		demo_csv_file2 <- csv_file(fpath2, true);
		data <- (demo_csv_file2.contents);
		loop i from: 0 to: data.rows - 1 {
		//				write "" + data[0, i] + " " + data[1, i];
			ask map_adm_2["" + data[0, i] + " " + data[1, i]] {
				extern <- int(data[2, i]);
				foreigner <- int(data[3, i]);
				moving <- int(data[4, i]);
				high_contact <- float(data[5, i]);
				low_contact <- int(data[6, i]);
				social_distancing <- int(data[7, i]);
				traffic_in <- int(data[8, i]);
				emphasize <- int(data[9, i]);
			}

		}

		string fpath3 <- "../../data/demographie/VNM.27.16_1.csv";
		file demo_csv_file3 <- csv_file(fpath3, true);
		data <- (demo_csv_file3.contents);
		loop i from: 0 to: data.rows - 1 {
			ask map_adm_3["" + data[0, i] + " " + data[1, i]] {
				extern <- int(data[2, i]);
				foreigner <- int(data[3, i]);
				moving <- int(data[4, i]);
				high_contact <- float(data[5, i]);
				low_contact <- int(data[6, i]);
				social_distancing <- int(data[7, i]);
				traffic_in <- int(data[8, i]);
				emphasize <- int(data[9, i]);
			}

		}

	}

}