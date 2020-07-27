/***
* Name: Corona
* Author: hqngh
* Description: 
* Tags: Tag1, Tag2, TagN
***/
@no_experiment

model Constants

global {
	string risky_activity<-"Nhóm nguy cơ";
	string ra_tourist<-"Khách du lịch"; 
 	string ra_shipper<-"Shipper"; 
 	string ra_cooking<-"Nấu ăn/bán đồ ăn"; 
 	string ra_vendor<-"Hàng tạp hoá/siêu thị";
	string ra_officer<-"Còn làm việc tại cơ quan"; 
 	string ra_worker<-"Công nhân KCN và nhà máy";
 
	
	string risky_zone<-"Khu vực nguy cơ";
	string rz_family<-"Gia đình";
 	string rz_market<-"Tiệm tạp hoá/Siêu thị";
 	string rz_playground<-"Vui chơi/giải trí/ du lịch";
 	string rz_park<-"Công viên (thể dục)";
 	string rz_office<-"Cơ quan còn làm việc";
 	string rz_factory<-"KCN/ Nhà máy";

	string risky_transport<-"Di chuyển đi/đến";
 	string rt_transport_flow<-"Số lượng đi/đến";
 	string rt_trasnportation<-"Phương tiện/đường";
 	string rt_transport_moment<-"Điểm đến/thời gian";
 	string rt_transport_interaction_rate<-"Mức độ tiếp xúc";
 
	string risky_policy<-"Chính sách áp dụng";
	string rp_policy_agreed<-"Đồng thuận với chính sách";


	
}