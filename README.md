### BÀI TẬP VỀ NHÀ 03 - THIẾT KẾ VÀ CÀI ĐẶT CSDL QUẢN LÝ CẦM ĐỒ

### Môn học : Hệ quản trị CSDL

### Lớp : K59.KMT.K01

### Giảng viên : Đỗ Duy Cốp

### Họ và tên : Nguyễn Phạm Đan Linh

### MSSV : K235480106095

 MỤC LỤC

1. Mô tả bài toán

2. Thiết kế Cơ sở dữ liệu (ERD)

3. Cài đặt SQL & Các Event Nghiệp vụ

4. Các sự kiện bổ sung (Audit Log)

5. Cấu trúc Repository

PHẦN 1. MÔ TẢ BÀI TOÁN

Hệ thống quản lý các hợp đồng vay tiền thế chấp tài sản với điểm đặc thù là cơ chế tính lãi linh hoạt, quản lý danh mục tài sản thế chấp và xử lý thanh lý đồ khi quá hạn.

Quy tắc nghiệp vụ cốt lõi:

Khách hàng & Tài sản: Một khách hàng có thể đăng ký nhiều hợp đồng cầm cố. Một hợp đồng có thể bao gồm nhiều tài sản thế chấp khác nhau.

Cơ chế Lãi suất:

Lãi đơn (Trước Deadline 1): 5.000đ / 1.000.000đ gốc / ngày (tương đương 0.5%/ngày).

Lãi kép (Sau Deadline 1): Lãi được tính dựa trên cơ sở là (Gốc + Lãi đơn đã tích lũy).

Quy tắc Trả hàng: Khách có thể trả nợ từng phần. Chỉ được lấy lại một phần tài sản khi tổng giá trị các tài sản còn lại vẫn lớn hơn hoặc bằng dư nợ hiện tại.

2. THIẾT KẾ CƠ SỞ DỮ LIỆU (ERD)

Quá trình phân tích đã chuyển đổi từ sơ đồ quan hệ thành các thực thể vật lý trong SQL Server, đạt chuẩn hóa 3NF.

2.1. Sơ đồ thực thể liên kết (ERD)
<img width="975" height="548" alt="image" src="https://github.com/user-attachments/assets/b88cc28d-881d-42b0-bbd9-edb88be441a5" />

 Sơ đồ ERD thể hiện rõ các thực thể KhachHang, HopDong, TaiSanCamCo, bảng Log và các khóa chính/khóa ngoại liên kết.


3. CÀI ĐẶT SQL & CÁC EVENT NGHIỆP VỤ

Event 1: Đăng ký hợp đồng mới (Vay tiền)

Tạo database QuanLyCamCo và tất cả bảng dữ liệu

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/2ddaf6af-432c-43c2-80d3-9b241cd6f9ac" />

Viết Store Procedure tiếp nhận hợp đồng: Lưu thông tin khách hàng, danh sách tài sản (kèm giá trị định giá), số tiền vay gốc và thiết lập 2

mốc Deadline1, Deadline2.

<img width="975" height="548" alt="image" src="https://github.com/user-attachments/assets/edbb8899-1405-420d-8eb2-2f8e50fa78b7" />

Thiết kế bảng HopDong – SQL Server

<img width="975" height="548" alt="image" src="https://github.com/user-attachments/assets/5d27425a-0843-43c9-9d39-d7a27ab7b2d6" />

Tạo bảng TaiSan và LichSuThanhToan trong hệ thống quản lý cầm đồ (SQL Server)

<img width="975" height="548" alt="image" src="https://github.com/user-attachments/assets/65213a60-61b4-4bec-a5b5-b3bde921caec" />

Tạo bảng LichSuThanhToan lưu lịch sử trả nợ trong hệ thống quản lý cầm đồ

<img width="975" height="548" alt="image" src="https://github.com/user-attachments/assets/abe67450-aad5-4c0a-ab44-0fbed00d8dd6" />

Event 2: Tính toán công nợ thời gian thực

Viết một Function fn_CalcMoneyTransaction(TransactionID, TargetDate) để tính số tiền phải trả của TransactionID này cho đến ngày TargetDate
Viết một Function fn_CalcMoneyContract(ContractID, TargetDate) để tính tổng số tiền khách(ContractID) phải trả (Gốc + Lãi đơn + Lãi kép) tính đến ngày TargetDate.
Gợi ý: SV cần sử dụng hàm tính lũy thừa hoặc vòng lặp để xử lý lãi kép.

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/707046dd-21b3-4be2-8c59-3d10b0d660f0" />
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/d6885e1f-157d-4649-9f00-03ed094df15e" />
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/d7442bcd-8369-426b-bfd5-fb2af5be6a04" />
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/426b1257-d15a-4768-bf8d-c33f88644203" />

Event 3: Xử lý trả nợ và hoàn trả tài sản
Viết Viết Store Procedure xử lý khi khách mang tiền đến:
Nếu tài sản đã bị thanh lý (sau Deadline 2 và có cờ IsSold): Thông báo không thu tiền, không trả đồ.
Nếu tài sản chưa bị thanh lý: Tính tổng nợ, trừ số tiền khách trả vào hệ thống. Nếu trả hết tiền, trả hết đồ và cập nhật trạng thái hợp đồng thành “Đã thanh toán đủ”; Nếu chưa trả hết tiền gốc+lãi: cập nhật trạng thái hợp đồng thành “Đang trả góp”, ghi nhận vào LOG số tiền đã trả, và số tiền còn nợ.
Đưa ra danh sách gợi ý trả lại cho khách hàng này dựa trên điều kiện:
Giá trị tài sản còn lại >= Dư nợ còn lại.

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/6e42fc01-40e5-47e1-8acf-7b3175f8fd86" />
<img width="1908" height="1062" alt="image" src="https://github.com/user-attachments/assets/4f46fada-5339-4ff7-8fdb-3a49ea974ee8" />
<img width="1915" height="1075" alt="image" src="https://github.com/user-attachments/assets/f16b733e-7ebc-4e63-ab28-529a2cf297f8" />
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/c8d7ef6c-c86c-4d51-89c2-0b1c2628a516" />
<img width="1918" height="1079" alt="image" src="https://github.com/user-attachments/assets/926ee032-1677-4b9f-87b2-b724ea8ecf6a" />

Event 4: Truy vấn danh sách nợ xấu (Nợ khó đòi)
Xuất danh sách các khách hàng đã quá Deadline 1 mà chưa thanh toán.
Yêu cầu các cột: Tên KH, Số điện thoại, Số tiền vay gốc, Số ngày quá hạn, Tổng tiền phải trả hiện tại (đến ngày hiện tại), Tổng số tiền phải trả sau 1 tháng nữa.
Gợi ý: Nên viết function hỗ trợ.


<img width="1919" height="1075" alt="image" src="https://github.com/user-attachments/assets/5aa37e18-e814-49f9-90c0-f25080615c95" />

Event 5: Quản lý thanh lý tài sản
Viết một Trigger tự động chuyển trạng thái hợp đồng sang "Quá hạn (nợ xấu)" sau khi hợp đồng đang ở trạng thái "Đang vay" mà ngày vượt quá Deadline 1.
Viết một Trigger tự động chuyển trạng thái tài sản sang "Sẵn sàng thanh lý" sau khi hợp đồng đang ở trạng thái "Quá hạn (nợ xấu)" mà ngày vượt quá Deadline 2.
Viết một Trigger tự động chuyển trạng thái tài sản thành “Đã bán thanh lý” sau khi trạng thái của hợp đồng chuyển sang "Đã thanh lý".
Chú ý: Mỗi tài sản cũng được theo dõi trạng thái: đang cầm cố, đã trả khách, đã bán thanh lý

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/54319ca1-7bf9-4f38-be53-d10f94395237" />

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/d7417710-9d70-4d11-a8bc-982a6f2a84ef" />

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/c786316b-47d6-49d6-872a-5e9a3041378f" />
