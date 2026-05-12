THIẾT KẾ VÀ CÀI ĐẶT CSDL QUẢN LÝ CẦM ĐỒ
________________________________________
PHẦN 1. PHÂN TÍCH TỔNG THỂ BÀI TOÁN

1.1. Logic nghiệp vụ tổng quát

Bài toán yêu cầu xây dựng cơ sở dữ liệu cho hệ thống cầm đồ.

Hệ thống phải xử lý đồng thời nhiều nghiệp vụ:

•	lưu khách hàng

•	lưu hợp đồng vay

•	lưu tài sản cầm cố


•	tính lãi theo thời gian
 
•	nhận thanh toán từng phần

•	xét điều kiện trả lại tài sản

•	quản lý nợ xấu

•	quản lý thanh lý tài sản

•	lưu lịch sử giao dịch

Điểm khó nhất của đề là tiền nợ không cố định, mà thay đổi theo thời gian do có:

•	lãi đơn trước hạn 1

•	lãi kép sau hạn 1

Ngoài ra, khách có thể:

•	trả một phần tiền

•	lấy lại một phần tài sản

•	gia hạn hợp đồng

Vì vậy dữ liệu phải được thiết kế theo hướng:

•	tách thực thể rõ ràng

•	không ghi đè lịch sử

•	tính toán từ dữ liệu gốc và dữ liệu log
________________________________________
/* =========================================================
   ẢNH CẦN CHÈN
   - Ảnh đề bài
   - Ảnh sơ đồ tư duy tổng quát hệ thống
   ========================================================= */
________________________________________
PHẦN 2. PHÂN TÍCH CÁC BẢNG ĐỂ THIẾT KẾ ERD

2.1. Bảng KhachHang

Phân tích logic

Một khách hàng có thể đến cầm đồ nhiều lần.

Nếu lưu thông tin khách hàng trực tiếp trong bảng hợp đồng thì sẽ bị lặp dữ liệu.

Vì vậy cần tách bảng KhachHang riêng để:

•	tránh trùng lặp

•	dễ theo dõi lịch sử của một khách

•	thuận lợi khi thống kê

Thuộc tính chính

•	mã khách hàng

•	họ tên

•	số điện thoại

•	giấy tờ tùy thân

•	địa chỉ
________________________________________
2.2. Bảng HopDong
Phân tích logic
Đây là bảng trung tâm của hệ thống.
Mỗi hợp đồng đại diện cho một lần khách vay tiền bằng cách thế chấp tài sản.
Bảng này phải lưu:
•	khách nào vay
•	vay bao nhiêu
•	ngày vay
•	hạn 1
•	hạn 2
•	trạng thái hiện tại
Vai trò trong ERD
•	liên kết với khách hàng
•	liên kết với tài sản
•	liên kết với lịch sử thanh toán
•	liên kết với lịch sử gia hạn
•	liên kết với lịch sử trả tài sản
________________________________________
2.3. Bảng TaiSanCamCo
Phân tích logic
Một hợp đồng có thể gồm nhiều tài sản.
Mỗi tài sản cần có giá trị định giá riêng vì hệ thống phải kiểm tra:
nếu trả lại tài sản thì phần tài sản còn giữ lại có còn đủ bảo đảm dư nợ hay không.
Do đó bảng tài sản là bắt buộc.
Thuộc tính chính
•	mã tài sản
•	mã hợp đồng
•	tên tài sản
•	loại tài sản
•	mô tả
•	giá trị định giá
•	trạng thái tài sản
________________________________________
2.4. Bảng TrangThaiHopDong
Phân tích logic
Trạng thái hợp đồng lặp đi lặp lại nhiều lần:
•	đang vay
•	đang trả góp
•	quá hạn
•	đã thanh toán
•	đã thanh lý
Nếu lưu text trực tiếp trong bảng hợp đồng:
•	dễ sai chính tả
•	khó lọc
•	khó mở rộng
Nên cần một bảng danh mục riêng.
________________________________________
2.5. Bảng TrangThaiTaiSan
Phân tích logic
Tài sản cũng có vòng đời riêng:
•	đang cầm cố
•	đã trả khách
•	sẵn sàng thanh lý
•	đã bán thanh lý
Do đó trạng thái tài sản cũng nên được chuẩn hóa thành bảng riêng.
________________________________________
2.6. Bảng NhatKyThanhToan
Phân tích logic
Đề yêu cầu phải lưu lịch sử mỗi lần khách trả tiền.
Không được chỉ cập nhật một cột “đã trả bao nhiêu” vì như vậy sẽ mất dấu vết dòng tiền.
Bảng này dùng để:
•	lưu ngày trả
•	lưu số tiền trả
•	lưu người thu tiền
•	phục vụ tính dư nợ còn lại
________________________________________
2.7. Bảng NhatKyTraTaiSan
Phân tích logic
Khi khách đủ điều kiện lấy lại tài sản, hệ thống cần biết:
•	tài sản nào đã trả
•	trả khi nào
•	ai xử lý
Bảng này đảm bảo truy vết được lịch sử trả tài sản.
________________________________________
2.8. Bảng NhatKyGiaHanHopDong
Phân tích logic
Khi khách trả lãi để gia hạn, cần lưu:
•	hạn cũ
•	hạn mới
•	số tiền lãi đã thanh toán
•	người xử lý
Nếu chỉ update trực tiếp Han1, Han2 thì sẽ mất lịch sử thay đổi.
________________________________________
2.9. Quan hệ ERD
Phân tích quan hệ
•	Một KhachHang có nhiều HopDong
•	Một HopDong có nhiều TaiSanCamCo
•	Một HopDong có nhiều NhatKyThanhToan
•	Một HopDong có nhiều NhatKyGiaHanHopDong
•	Một HopDong có nhiều NhatKyTraTaiSan
•	Một TaiSanCamCo có thể xuất hiện trong NhatKyTraTaiSan
•	Một HopDong thuộc một TrangThaiHopDong
•	Một TaiSanCamCo thuộc một TrangThaiTaiSan
________________________________________
/* =========================================================
   ẢNH CẦN CHÈN
   - Ảnh ERD hoàn chỉnh
   - Ảnh quan hệ 1-n giữa các bảng
   ========================================================= */
________________________________________
PHẦN 3. TẠO CƠ SỞ DỮ LIỆU
3.1. Phân tích logic
Trước khi tạo bảng, cần tạo cơ sở dữ liệu riêng để dễ quản lý, dễ chạy test, và tránh lẫn với dữ liệu hệ thống khác.
________________________________________
/* ===================== TẠO DATABASE ===================== */

-- Nếu database đã tồn tại thì xóa đi để chạy lại từ đầu
IF DB_ID('QuanLyCamDo') IS NOT NULL
BEGIN
    -- Đưa database về chế độ 1 người dùng để có thể xóa
    ALTER DATABASE QuanLyCamDo SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    -- Xóa database cũ
    DROP DATABASE QuanLyCamDo;
END
GO

-- Tạo mới cơ sở dữ liệu
CREATE DATABASE QuanLyCamDo;
GO

-- Chọn database để làm việc
USE QuanLyCamDo;
GO
/* =========================================================
   ẢNH CẦN CHÈN
   - Ảnh database QuanLyCamDo xuất hiện trong SSMS
     
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/1f3de00d-2365-4549-81b1-f9b38fecd7fa" />

   ========================================================= */
________________________________________
PHẦN 4. TẠO CÁC BẢNG DANH MỤC
4.1. Bảng TrangThaiHopDong
Phân tích logic
Bảng này dùng để chuẩn hóa trạng thái hợp đồng.
Nhờ đó, bảng hợp đồng chỉ cần lưu mã trạng thái thay vì lưu chuỗi dài.
________________________________________
/* ============ BẢNG TRẠNG THÁI HỢP ĐỒNG ============ */

CREATE TABLE TrangThaiHopDong
(
    MaTrangThai INT IDENTITY(1,1) PRIMARY KEY,       -- Mã trạng thái tự tăng
    KyHieuTrangThai VARCHAR(30) NOT NULL UNIQUE,     -- Mã ngắn để truy vấn
    TenTrangThai NVARCHAR(100) NOT NULL              -- Tên trạng thái hiển thị
);
GO

-- Thêm sẵn các trạng thái nghiệp vụ cần dùng
INSERT INTO TrangThaiHopDong (KyHieuTrangThai, TenTrangThai)
VALUES
('DANG_VAY', N'Đang vay'),
('DANG_TRA_GOP', N'Đang trả góp'),
('QUA_HAN', N'Quá hạn'),
('DA_THANH_TOAN', N'Đã thanh toán'),
('DA_THANH_LY', N'Đã thanh lý');
GO
/* =========================================================
   ẢNH CẦN CHÈN
   - Ảnh SELECT * FROM TrangThaiHopDong
   ========================================================= */
________________________________________
4.2. Bảng TrangThaiTaiSan
Phân tích logic
Mỗi tài sản phải được theo dõi riêng trạng thái của nó.
Bảng này giúp việc cập nhật trạng thái tài sản dễ hơn và nhất quán hơn.
________________________________________
/* ============ BẢNG TRẠNG THÁI TÀI SẢN ============ */

CREATE TABLE TrangThaiTaiSan
(
    MaTrangThaiTaiSan INT IDENTITY(1,1) PRIMARY KEY,  -- Mã trạng thái tài sản
    KyHieuTrangThai VARCHAR(30) NOT NULL UNIQUE,      -- Ký hiệu ngắn
    TenTrangThai NVARCHAR(100) NOT NULL               -- Tên trạng thái
);
GO

-- Nạp dữ liệu trạng thái tài sản
INSERT INTO TrangThaiTaiSan (KyHieuTrangThai, TenTrangThai)
VALUES
('DANG_CAM_CO', N'Đang cầm cố'),
('DA_TRA_KHACH', N'Đã trả khách'),
('SAN_SANG_THANH_LY', N'Sẵn sàng thanh lý'),
('DA_BAN_THANH_LY', N'Đã bán thanh lý');
GO
/* =========================================================
   ẢNH CẦN CHÈN
   - Ảnh SELECT * FROM TrangThaiTaiSan
   ========================================================= */
________________________________________
PHẦN 5. TẠO CÁC BẢNG NGHIỆP VỤ CHÍNH
5.1. Bảng KhachHang
Phân tích logic
Bảng này lưu thông tin cá nhân của người đi cầm đồ.
Mỗi khách có thể phát sinh nhiều hợp đồng khác nhau theo thời gian.
________________________________________
/* ===================== BẢNG KHÁCH HÀNG ===================== */

CREATE TABLE KhachHang
(
    MaKhachHang INT IDENTITY(1,1) PRIMARY KEY,      -- Mã khách hàng
    HoTen NVARCHAR(100) NOT NULL,                   -- Họ tên khách
    SoDienThoai VARCHAR(15) NOT NULL,               -- Số điện thoại liên hệ
    SoGiayTo VARCHAR(30) NULL,                      -- CMND/CCCD
    DiaChi NVARCHAR(255) NULL,                      -- Địa chỉ
    NgayTao DATETIME NOT NULL DEFAULT GETDATE()     -- Ngày tạo hồ sơ
);
GO
________________________________________
5.2. Bảng HopDong
Phân tích logic
Mỗi hợp đồng là một giao dịch vay tiền.
Bảng này là trung tâm vì toàn bộ lãi, nợ, trả góp, thanh lý đều dựa trên hợp đồng.
________________________________________
/* ===================== BẢNG HỢP ĐỒNG ===================== */

CREATE TABLE HopDong
(
    MaHopDong INT IDENTITY(1,1) PRIMARY KEY,         -- Mã hợp đồng
    MaKhachHang INT NOT NULL,                        -- Khách hàng sở hữu hợp đồng
    NgayLapHopDong DATE NOT NULL,                    -- Ngày tạo hợp đồng
    SoTienGoc DECIMAL(18,2) NOT NULL,                -- Số tiền vay gốc
    Han1 DATE NOT NULL,                              -- Mốc hạn 1
    Han2 DATE NOT NULL,                              -- Mốc hạn 2
    MaTrangThai INT NOT NULL,                        -- Trạng thái hiện tại của hợp đồng
    GhiChu NVARCHAR(255) NULL,                       -- Ghi chú thêm
    CONSTRAINT FK_HopDong_KhachHang
        FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang),
    CONSTRAINT FK_HopDong_TrangThai
        FOREIGN KEY (MaTrangThai) REFERENCES TrangThaiHopDong(MaTrangThai)
);
GO
________________________________________
5.3. Bảng TaiSanCamCo
Phân tích logic
Một hợp đồng có thể gắn nhiều tài sản.
Bảng này giúp lưu riêng từng tài sản để có thể:
•	định giá
•	cập nhật trạng thái
•	trả từng món
•	thanh lý từng món
________________________________________
/* ===================== BẢNG TÀI SẢN CẦM CỐ ===================== */

CREATE TABLE TaiSanCamCo
(
    MaTaiSan INT IDENTITY(1,1) PRIMARY KEY,             -- Mã tài sản
    MaHopDong INT NOT NULL,                             -- Thuộc hợp đồng nào
    TenTaiSan NVARCHAR(100) NOT NULL,                   -- Tên tài sản
    LoaiTaiSan NVARCHAR(100) NULL,                      -- Loại tài sản
    MoTa NVARCHAR(255) NULL,                            -- Mô tả chi tiết
    GiaTriDinhGia DECIMAL(18,2) NOT NULL,               -- Giá trị định giá
    MaTrangThaiTaiSan INT NOT NULL,                     -- Trạng thái tài sản
    DaBanThanhLy BIT NOT NULL DEFAULT 0,                -- Cờ đánh dấu đã bán thanh lý
    CONSTRAINT FK_TaiSan_HopDong
        FOREIGN KEY (MaHopDong) REFERENCES HopDong(MaHopDong),
    CONSTRAINT FK_TaiSan_TrangThai
        FOREIGN KEY (MaTrangThaiTaiSan) REFERENCES TrangThaiTaiSan(MaTrangThaiTaiSan)
);
GO
________________________________________
5.4. Bảng NhatKyThanhToan
Phân tích logic
Bảng này bắt buộc vì khách có thể trả tiền nhiều lần.
Mỗi lần trả phải lưu thành một dòng riêng để bảo toàn lịch sử.
________________________________________
/* ===================== BẢNG NHẬT KÝ THANH TOÁN ===================== */

CREATE TABLE NhatKyThanhToan
(
    MaThanhToan INT IDENTITY(1,1) PRIMARY KEY,          -- Mã lần thanh toán
    MaHopDong INT NOT NULL,                             -- Hợp đồng được trả tiền
    NgayThanhToan DATETIME NOT NULL DEFAULT GETDATE(),  -- Thời điểm thanh toán
    SoTienThanhToan DECIMAL(18,2) NOT NULL,             -- Số tiền trả
    NguoiThu NVARCHAR(100) NOT NULL,                    -- Người thu tiền
    GhiChu NVARCHAR(255) NULL,                          -- Ghi chú
    CONSTRAINT FK_ThanhToan_HopDong
        FOREIGN KEY (MaHopDong) REFERENCES HopDong(MaHopDong)
);
GO
________________________________________
5.5. Bảng NhatKyTraTaiSan
Phân tích logic
Khi khách lấy lại tài sản, cần có bảng lưu vết để biết:
•	món nào đã trả
•	khi nào trả
•	ai xử lý
________________________________________
/* ===================== BẢNG NHẬT KÝ TRẢ TÀI SẢN ===================== */

CREATE TABLE NhatKyTraTaiSan
(
    MaTraTaiSan INT IDENTITY(1,1) PRIMARY KEY,      -- Mã lần trả tài sản
    MaHopDong INT NOT NULL,                         -- Hợp đồng liên quan
    MaTaiSan INT NOT NULL,                          -- Tài sản được trả
    NgayTra DATETIME NOT NULL DEFAULT GETDATE(),    -- Ngày trả
    NguoiXuLy NVARCHAR(100) NOT NULL,               -- Người xử lý
    GhiChu NVARCHAR(255) NULL,                      -- Ghi chú
    CONSTRAINT FK_TraTaiSan_HopDong
        FOREIGN KEY (MaHopDong) REFERENCES HopDong(MaHopDong),
    CONSTRAINT FK_TraTaiSan_TaiSan
        FOREIGN KEY (MaTaiSan) REFERENCES TaiSanCamCo(MaTaiSan)
);
GO
________________________________________
5.6. Bảng NhatKyGiaHanHopDong
Phân tích logic
Gia hạn là một sự kiện nghiệp vụ độc lập.
Mỗi lần gia hạn phải lưu lại hạn cũ và hạn mới.
________________________________________
/* ===================== BẢNG NHẬT KÝ GIA HẠN ===================== */

CREATE TABLE NhatKyGiaHanHopDong
(
    MaGiaHan INT IDENTITY(1,1) PRIMARY KEY,          -- Mã lần gia hạn
    MaHopDong INT NOT NULL,                          -- Hợp đồng được gia hạn
    NgayGiaHan DATETIME NOT NULL DEFAULT GETDATE(),  -- Ngày gia hạn
    Han1Cu DATE NOT NULL,                            -- Hạn 1 cũ
    Han2Cu DATE NOT NULL,                            -- Hạn 2 cũ
    Han1Moi DATE NOT NULL,                           -- Hạn 1 mới
    Han2Moi DATE NOT NULL,                           -- Hạn 2 mới
    SoTienLaiDaTra DECIMAL(18,2) NOT NULL,           -- Số lãi đã thanh toán
    NguoiXuLy NVARCHAR(100) NOT NULL,                -- Người xử lý
    GhiChu NVARCHAR(255) NULL,                       -- Ghi chú
    CONSTRAINT FK_GiaHan_HopDong
        FOREIGN KEY (MaHopDong) REFERENCES HopDong(MaHopDong)
);
GO
/* =========================================================
   ẢNH CẦN CHÈN
   - Ảnh danh sách tất cả bảng sau khi tạo xong
   ========================================================= */
________________________________________
PHẦN 6. PHÂN TÍCH LOGIC TÍNH LÃI
6.1. Logic lãi đơn
Theo đề:
•	5.000đ / 1.000.000đ / ngày
•	tức là 0.5%/ngày
•	tương đương 0.005
Nếu chưa qua hạn 1 thì:
•	tổng nợ = gốc + lãi đơn
Công thức:
•	LaiDon = Goc * 0.005 * SoNgay
________________________________________
6.2. Logic lãi kép
Nếu đã qua hạn 1 thì:
•	đầu tiên tính lãi đơn đến hạn 1
•	sau đó lấy:
o	Goc + LaiDon làm cơ sở tính lãi kép
Công thức:
•	Tong = (Goc + LaiDon) * POWER(1 + 0.005, SoNgaySauHan1)
________________________________________
6.3. Logic dư nợ còn lại
Dư nợ thực tế không phải chỉ là tổng gốc + lãi.
Phải trừ đi toàn bộ số tiền khách đã thanh toán trước đó.
Công thức:
•	DuNo = TongPhaiTra - TongTienDaThanhToan
________________________________________
PHẦN 7. HÀM TÍNH TOÁN
7.1. Hàm tính tổng đã thanh toán
Phân tích logic
Hàm này cộng tất cả khoản tiền đã trả của một hợp đồng.
Nó phục vụ cho bước tính dư nợ còn lại.
________________________________________
/* ===================== HÀM TỔNG TIỀN ĐÃ THANH TOÁN ===================== */

CREATE FUNCTION fn_TongTienDaThanhToan
(
    @MaHopDong INT                         -- Mã hợp đồng cần tính
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Tong DECIMAL(18,2);          -- Biến lưu kết quả tổng tiền đã trả

    -- Cộng tất cả các khoản thanh toán của hợp đồng
    SELECT @Tong = ISNULL(SUM(SoTienThanhToan), 0)
    FROM NhatKyThanhToan
    WHERE MaHopDong = @MaHopDong;

    -- Trả về kết quả
    RETURN @Tong;
END
GO
________________________________________
7.2. Hàm tính tổng phải trả của hợp đồng
Phân tích logic
Hàm này tính số tiền phát sinh theo thời gian:
•	trước hạn 1 → lãi đơn
•	sau hạn 1 → lãi kép
Hàm này chưa trừ tiền đã trả.
________________________________________
/* ===================== HÀM TÍNH TỔNG PHẢI TRẢ ===================== */

CREATE FUNCTION fn_TinhTongPhaiTraHopDong
(
    @MaHopDong INT,                        -- Mã hợp đồng
    @NgayCanTinh DATE                      -- Ngày muốn tính công nợ
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @SoTienGoc DECIMAL(18,2);      -- Số tiền vay ban đầu
    DECLARE @NgayLap DATE;                 -- Ngày lập hợp đồng
    DECLARE @Han1 DATE;                    -- Hạn 1
    DECLARE @LaiSuatNgay DECIMAL(10,6);    -- Lãi suất ngày
    DECLARE @SoNgayLaiDon INT;             -- Số ngày tính lãi đơn
    DECLARE @SoNgayLaiKep INT;             -- Số ngày tính lãi kép
    DECLARE @TienLaiDon DECIMAL(18,2);     -- Tiền lãi đơn
    DECLARE @CoSoLaiKep DECIMAL(18,2);     -- Gốc + lãi đơn
    DECLARE @Tong DECIMAL(18,2);           -- Kết quả cuối cùng

    -- Gán lãi suất 0.5% mỗi ngày
    SET @LaiSuatNgay = 0.005;

    -- Lấy dữ liệu hợp đồng
    SELECT
        @SoTienGoc = SoTienGoc,
        @NgayLap = NgayLapHopDong,
        @Han1 = Han1
    FROM HopDong
    WHERE MaHopDong = @MaHopDong;

    -- Nếu ngày tính trước ngày lập hợp đồng thì xem như chưa phát sinh lãi
    IF @NgayCanTinh < @NgayLap
        RETURN @SoTienGoc;

    -- Nếu chưa qua hạn 1 thì chỉ tính lãi đơn
    IF @NgayCanTinh <= @Han1
    BEGIN
        -- Tính số ngày lãi đơn
        SET @SoNgayLaiDon = DATEDIFF(DAY, @NgayLap, @NgayCanTinh);

        -- Tính tiền lãi đơn
        SET @TienLaiDon = @SoTienGoc * @LaiSuatNgay * @SoNgayLaiDon;

        -- Tổng phải trả = gốc + lãi đơn
        SET @Tong = @SoTienGoc + @TienLaiDon;
    END
    ELSE
    BEGIN
        -- Tính số ngày lãi đơn từ ngày lập đến hạn 1
        SET @SoNgayLaiDon = DATEDIFF(DAY, @NgayLap, @Han1);

        -- Tính tiền lãi đơn đến hạn 1
        SET @TienLaiDon = @SoTienGoc * @LaiSuatNgay * @SoNgayLaiDon;

        -- Tạo cơ sở tính lãi kép
        SET @CoSoLaiKep = @SoTienGoc + @TienLaiDon;

        -- Tính số ngày sau hạn 1
        SET @SoNgayLaiKep = DATEDIFF(DAY, @Han1, @NgayCanTinh);

        -- Tính tổng nợ theo công thức lãi kép
        SET @Tong = @CoSoLaiKep * POWER((1 + @LaiSuatNgay), @SoNgayLaiKep);
    END

    -- Trả về kết quả
    RETURN @Tong;
END
GO
________________________________________
7.3. Hàm tính dư nợ còn lại
Phân tích logic
Hàm này dùng để xác định tại thời điểm hiện tại khách còn nợ bao nhiêu.
Nó lấy:
•	tổng phải trả
•	trừ tổng tiền đã thanh toán
________________________________________
/* ===================== HÀM TÍNH DƯ NỢ CÒN LẠI ===================== */

CREATE FUNCTION fn_DuNoConLai
(
    @MaHopDong INT,                       -- Mã hợp đồng cần tính
    @NgayCanTinh DATE                     -- Ngày tính dư nợ
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @TongPhaiTra DECIMAL(18,2);   -- Tổng phát sinh gốc + lãi
    DECLARE @DaThanhToan DECIMAL(18,2);   -- Tổng tiền khách đã trả
    DECLARE @DuNo DECIMAL(18,2);          -- Dư nợ cuối cùng

    -- Lấy tổng phải trả đến ngày cần tính
    SET @TongPhaiTra = dbo.fn_TinhTongPhaiTraHopDong(@MaHopDong, @NgayCanTinh);

    -- Lấy tổng tiền khách đã thanh toán
    SET @DaThanhToan = dbo.fn_TongTienDaThanhToan(@MaHopDong);

    -- Tính dư nợ
    SET @DuNo = @TongPhaiTra - @DaThanhToan;

    -- Nếu âm thì đưa về 0
    IF @DuNo < 0
        SET @DuNo = 0;

    -- Trả kết quả
    RETURN @DuNo;
END
GO
/* =========================================================
   ẢNH CẦN CHÈN
   - Ảnh tạo 3 function thành công
   ========================================================= */
________________________________________
PHẦN 8. PHÂN TÍCH EVENT 1 - ĐĂNG KÝ HỢP ĐỒNG MỚI
8.1. Logic xử lý
Khi tạo hợp đồng mới, hệ thống cần:
1.	thêm khách hàng
2.	thêm hợp đồng
3.	thêm danh sách tài sản
Vì một hợp đồng có nhiều tài sản, nên cần dùng table type để truyền danh sách tài sản vào stored procedure.
________________________________________
8.2. Tạo kiểu dữ liệu bảng
/* ===================== KIỂU DỮ LIỆU DANH SÁCH TÀI SẢN ===================== */

CREATE TYPE DanhSachTaiSan AS TABLE
(
    TenTaiSan NVARCHAR(100),              -- Tên tài sản
    LoaiTaiSan NVARCHAR(100),             -- Loại tài sản
    MoTa NVARCHAR(255),                   -- Mô tả tài sản
    GiaTriDinhGia DECIMAL(18,2)           -- Giá trị định giá
);
GO
________________________________________
8.3. Stored Procedure thêm hợp đồng mới
/* ===================== THỦ TỤC THÊM HỢP ĐỒNG MỚI ===================== */

CREATE PROCEDURE sp_ThemHopDongMoi
    @HoTen NVARCHAR(100),                         -- Tên khách hàng
    @SoDienThoai VARCHAR(15),                     -- SĐT khách
    @SoGiayTo VARCHAR(30),                        -- Giấy tờ tùy thân
    @DiaChi NVARCHAR(255),                        -- Địa chỉ khách
    @NgayLapHopDong DATE,                         -- Ngày lập hợp đồng
    @SoTienGoc DECIMAL(18,2),                     -- Số tiền vay gốc
    @Han1 DATE,                                   -- Deadline 1
    @Han2 DATE,                                   -- Deadline 2
    @DanhSachTaiSan DanhSachTaiSan READONLY       -- Danh sách tài sản
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MaKhachHang INT;                     -- Lưu mã khách hàng vừa tạo
    DECLARE @MaHopDong INT;                       -- Lưu mã hợp đồng vừa tạo
    DECLARE @MaTrangThaiHopDong INT;              -- Trạng thái hợp đồng mặc định
    DECLARE @MaTrangThaiTaiSan INT;               -- Trạng thái tài sản mặc định

    -- Lấy mã trạng thái hợp đồng "Đang vay"
    SELECT @MaTrangThaiHopDong = MaTrangThai
    FROM TrangThaiHopDong
    WHERE KyHieuTrangThai = 'DANG_VAY';

    -- Lấy mã trạng thái tài sản "Đang cầm cố"
    SELECT @MaTrangThaiTaiSan = MaTrangThaiTaiSan
    FROM TrangThaiTaiSan
    WHERE KyHieuTrangThai = 'DANG_CAM_CO';

    -- Thêm khách hàng mới
    INSERT INTO KhachHang (HoTen, SoDienThoai, SoGiayTo, DiaChi)
    VALUES (@HoTen, @SoDienThoai, @SoGiayTo, @DiaChi);

    -- Lấy mã khách hàng vừa thêm
    SET @MaKhachHang = SCOPE_IDENTITY();

    -- Thêm hợp đồng mới
    INSERT INTO HopDong (MaKhachHang, NgayLapHopDong, SoTienGoc, Han1, Han2, MaTrangThai, GhiChu)
    VALUES (@MaKhachHang, @NgayLapHopDong, @SoTienGoc, @Han1, @Han2, @MaTrangThaiHopDong, N'Hợp đồng mới');

    -- Lấy mã hợp đồng vừa tạo
    SET @MaHopDong = SCOPE_IDENTITY();

    -- Thêm toàn bộ tài sản thuộc hợp đồng
    INSERT INTO TaiSanCamCo
    (
        MaHopDong,
        TenTaiSan,
        LoaiTaiSan,
        MoTa,
        GiaTriDinhGia,
        MaTrangThaiTaiSan
    )
    SELECT
        @MaHopDong,
        TenTaiSan,
        LoaiTaiSan,
        MoTa,
        GiaTriDinhGia,
        @MaTrangThaiTaiSan
    FROM @DanhSachTaiSan;
END
GO
/* =========================================================
   ẢNH CẦN CHÈN
   - Ảnh tạo procedure sp_ThemHopDongMoi
   ========================================================= */


