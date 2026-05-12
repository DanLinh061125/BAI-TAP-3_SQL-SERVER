-- ============================================================
-- BÀI KIỂM TRA SỐ 2 - QUẢN LÝ KHÁCH SẠN
-- Mã sinh viên: K235480106095
-- Database: QuanLyKhachSan_K235480106095
-- ============================================================

-- ============================================================
-- PHẦN 1: THIẾT KẾ VÀ KHỞI TẠO CẤU TRÚC DỮ LIỆU
-- ============================================================

CREATE DATABASE [QuanLyKhachSan_K235480106095];
GO

USE [QuanLyKhachSan_K235480106095];
GO

-- Bảng 1: LoaiPhong (Room Type)
-- PK: MaLoaiPhong (tự tăng)
CREATE TABLE [LoaiPhong] (
    [MaLoaiPhong]   INT             IDENTITY(1,1) PRIMARY KEY,  -- PK tự tăng
    [TenLoai]       NVARCHAR(100)   NOT NULL,                   -- VD: Phòng Đơn, Suite
    [GiaMotDem]     MONEY           NOT NULL,                   -- giá một đêm (kiểu tiền tệ)
    [SucChua]       INT             NOT NULL                    -- CK: sức chứa 1..10 người
        CONSTRAINT [CK_LoaiPhong_SucChua] CHECK ([SucChua] BETWEEN 1 AND 10),
    [MoTa]          NVARCHAR(500)   NULL
);
GO

-- Bảng 2: Phong (Room)
-- PK: MaPhong; FK: MaLoaiPhong -> LoaiPhong
CREATE TABLE [Phong] (
    [MaPhong]       NVARCHAR(10)    PRIMARY KEY,                -- PK: mã phòng VD P101
    [TenPhong]      NVARCHAR(50)    NOT NULL,
    [Tang]          INT             NOT NULL                    -- CK: tầng 1..50
        CONSTRAINT [CK_Phong_Tang] CHECK ([Tang] BETWEEN 1 AND 50),
    [TrangThai]     NVARCHAR(20)    NOT NULL DEFAULT N'Trống'   -- CK: trạng thái
        CONSTRAINT [CK_Phong_TrangThai] CHECK ([TrangThai] IN (N'Trống', N'Đang thuê', N'Bảo trì')),
    [MaLoaiPhong]   INT             NOT NULL,                   -- FK -> LoaiPhong
    CONSTRAINT [FK_Phong_LoaiPhong] FOREIGN KEY ([MaLoaiPhong]) REFERENCES [LoaiPhong]([MaLoaiPhong])
);
GO

-- Bảng 3: KhachHang (Customer)
-- PK: MaKhach (tự tăng)
CREATE TABLE [KhachHang] (
    [MaKhach]       INT             IDENTITY(1,1) PRIMARY KEY,
    [HoTen]         NVARCHAR(100)   NOT NULL,
    [SoCCCD]        NVARCHAR(20)    NOT NULL UNIQUE,            -- CCCD duy nhất
    [SoDienThoai]   NVARCHAR(15)    NULL,
    [Email]         NVARCHAR(100)   NULL,
    [QuocTich]      NVARCHAR(50)    NOT NULL DEFAULT N'Việt Nam',
    [NgaySinh]      DATE            NULL
);
GO

-- Bảng 4: DatPhong (Booking)
-- PK: MaDatPhong; FK: MaKhach -> KhachHang, MaPhong -> Phong
CREATE TABLE [DatPhong] (
    [MaDatPhong]    INT             IDENTITY(1,1) PRIMARY KEY,
    [MaKhach]       INT             NOT NULL,                   -- FK -> KhachHang
    [MaPhong]       NVARCHAR(10)    NOT NULL,                   -- FK -> Phong
    [NgayNhanPhong] DATE            NOT NULL,
    [NgayTraPhong]  DATE            NOT NULL,
    [SoNguoi]       INT             NOT NULL DEFAULT 1
        CONSTRAINT [CK_DatPhong_SoNguoi]  CHECK ([SoNguoi] >= 1),
    [TongTien]      MONEY           NULL,
    [TrangThai]     NVARCHAR(20)    NOT NULL DEFAULT N'Đặt trước'
        CONSTRAINT [CK_DatPhong_TrangThai] CHECK ([TrangThai] IN (N'Đặt trước', N'Đang ở', N'Đã trả', N'Hủy')),
    [GhiChu]        NVARCHAR(500)   NULL,
    CONSTRAINT [CK_DatPhong_Ngay]         CHECK ([NgayTraPhong] > [NgayNhanPhong]),
    CONSTRAINT [FK_DatPhong_KhachHang]    FOREIGN KEY ([MaKhach])  REFERENCES [KhachHang]([MaKhach]),
    CONSTRAINT [FK_DatPhong_Phong]        FOREIGN KEY ([MaPhong])  REFERENCES [Phong]([MaPhong])
);
GO

-- Bảng 5: DichVu (Service)
-- PK: MaDichVu (tự tăng)
CREATE TABLE [DichVu] (
    [MaDichVu]      INT             IDENTITY(1,1) PRIMARY KEY,
    [TenDichVu]     NVARCHAR(100)   NOT NULL,
    [DonGia]        MONEY           NOT NULL
        CONSTRAINT [CK_DichVu_DonGia] CHECK ([DonGia] >= 0),
    [DonVi]         NVARCHAR(30)    NOT NULL DEFAULT N'lần'
);
GO

-- Bảng 6: SuDungDichVu (ServiceUsage)
-- PK: MaSuDung; FK: MaDatPhong -> DatPhong, MaDichVu -> DichVu
CREATE TABLE [SuDungDichVu] (
    [MaSuDung]      INT             IDENTITY(1,1) PRIMARY KEY,
    [MaDatPhong]    INT             NOT NULL,
    [MaDichVu]      INT             NOT NULL,
    [SoLuong]       INT             NOT NULL DEFAULT 1
        CONSTRAINT [CK_SuDung_SoLuong] CHECK ([SoLuong] >= 1),
    [NgaySuDung]    DATE            NOT NULL DEFAULT GETDATE(),
    CONSTRAINT [FK_SuDung_DatPhong] FOREIGN KEY ([MaDatPhong]) REFERENCES [DatPhong]([MaDatPhong]),
    CONSTRAINT [FK_SuDung_DichVu]   FOREIGN KEY ([MaDichVu])   REFERENCES [DichVu]([MaDichVu])
);
GO

-- ============================================================
-- DỮ LIỆU MẪU
-- ============================================================

INSERT INTO [LoaiPhong] ([TenLoai],[GiaMotDem],[SucChua],[MoTa]) VALUES
(N'Phòng Đơn',      500000,  1, N'Phòng tiêu chuẩn 1 giường đơn'),
(N'Phòng Đôi',      800000,  2, N'Phòng tiêu chuẩn 1 giường đôi'),
(N'Phòng Gia Đình', 1200000, 4, N'Phòng rộng cho gia đình'),
(N'Suite VIP',      3000000, 2, N'Phòng cao cấp view biển');

INSERT INTO [Phong] ([MaPhong],[TenPhong],[Tang],[TrangThai],[MaLoaiPhong]) VALUES
('P101', N'Phòng 101', 1, N'Trống',     1),
('P102', N'Phòng 102', 1, N'Đang thuê', 2),
('P201', N'Phòng 201', 2, N'Trống',     2),
('P202', N'Phòng 202', 2, N'Bảo trì',   3),
('P301', N'Phòng 301', 3, N'Trống',     3),
('P401', N'Suite 401', 4, N'Đang thuê', 4),
('P402', N'Suite 402', 4, N'Trống',     4);

INSERT INTO [KhachHang] ([HoTen],[SoCCCD],[SoDienThoai],[Email],[QuocTich],[NgaySinh]) VALUES
(N'Nguyễn Văn An',  '001234567890', '0901234567', 'an@email.com',   N'Việt Nam', '1990-05-10'),
(N'Trần Thị Bình',  '002345678901', '0912345678', 'binh@email.com', N'Việt Nam', '1985-08-22'),
(N'Lê Minh Cường',  '003456789012', '0923456789', 'cuong@email.com',N'Việt Nam', '1995-12-01'),
(N'John Smith',     '004567890123', '0934567890', 'john@email.com', N'Mỹ',       '1988-03-15'),
(N'Phạm Thị Dung',  '005678901234', '0945678901', 'dung@email.com', N'Việt Nam', '2000-07-30');

INSERT INTO [DatPhong] ([MaKhach],[MaPhong],[NgayNhanPhong],[NgayTraPhong],[SoNguoi],[TrangThai],[GhiChu]) VALUES
(1, 'P101', '2025-06-01', '2025-06-04', 1, N'Đã trả',    N'Khách quen'),
(2, 'P102', '2025-06-05', '2025-06-08', 2, N'Đang ở',    NULL),
(3, 'P301', '2025-06-10', '2025-06-15', 3, N'Đặt trước', N'Yêu cầu tầng cao'),
(4, 'P401', '2025-06-05', '2025-06-07', 2, N'Đang ở',    N'Khách nước ngoài'),
(5, 'P201', '2025-06-12', '2025-06-14', 1, N'Đặt trước', NULL);

UPDATE [DatPhong] SET [TongTien] = 1500000 WHERE [MaDatPhong] = 1;

INSERT INTO [DichVu] ([TenDichVu],[DonGia],[DonVi]) VALUES
(N'Giặt ủi',  50000,  N'bộ'),
(N'Ăn sáng',  80000,  N'người'),
(N'Spa',      200000, N'lần'),
(N'Thuê xe',  300000, N'ngày'),
(N'Minibar',  150000, N'lần');

INSERT INTO [SuDungDichVu] ([MaDatPhong],[MaDichVu],[SoLuong],[NgaySuDung]) VALUES
(1, 1, 2, '2025-06-02'),
(1, 2, 2, '2025-06-02'),
(2, 2, 2, '2025-06-06'),
(4, 3, 1, '2025-06-06'),
(4, 5, 1, '2025-06-05');
GO

-- ============================================================
-- PHẦN 2: XÂY DỰNG FUNCTION
-- ============================================================

-- 2A: Ví dụ các hàm built-in SQL Server

-- Nhóm chuỗi
SELECT LEN(N'Khách sạn Mặt Trời') AS [DoDai];
SELECT UPPER('hotel') AS [ChuoiHoa];
SELECT CONCAT(N'Phòng: ', 'P101', N' | Tầng: ', 1) AS [ThongTinPhong];
SELECT TRIM(N'  Nguyễn Văn An  ') AS [TenSauCat];

-- Nhóm ngày tháng
SELECT GETDATE() AS [ThoiGianHienTai];
SELECT FORMAT(GETDATE(), 'dd/MM/yyyy HH:mm') AS [NgayGioFormatDep];
SELECT DATEDIFF(DAY, '2025-06-01', '2025-06-04') AS [SoDemLuu];
SELECT DATEADD(DAY, 3, '2025-06-01') AS [NgayTraPhongDuKien];

-- Nhóm toán học & chuyển đổi
SELECT ROUND(1500000.678, 0) AS [LamTron];
SELECT CAST(3000000 AS NVARCHAR) + N' VNĐ' AS [HienThiTien];
SELECT CONVERT(NVARCHAR, GETDATE(), 103) AS [NgayDangViet];

-- Nhóm điều kiện & hệ thống
SELECT ISNULL(NULL, N'Chưa có ghi chú') AS [GhiChu];
SELECT COALESCE(NULL, NULL, N'Khách Việt Nam') AS [QuocTich];
SELECT IIF(3000000 > 1000000, N'Phòng cao cấp', N'Phòng tiêu chuẩn') AS [PhanLoai];
SELECT @@ROWCOUNT AS [SoDongBiAnhHuong];
GO

-- ====================================================
-- SCALAR FUNCTION: Tính tổng tiền một lần đặt phòng
-- Logic: (số đêm x giá phòng) + tổng tiền dịch vụ đã sử dụng
-- ====================================================
CREATE FUNCTION [dbo].[fn_TinhTongTienDatPhong] (@MaDatPhong INT)
RETURNS MONEY
AS
BEGIN
    DECLARE @TienPhong   MONEY = 0;
    DECLARE @TienDichVu  MONEY = 0;

    SELECT @TienPhong = DATEDIFF(DAY, [dp].[NgayNhanPhong], [dp].[NgayTraPhong]) * [lp].[GiaMotDem]
    FROM [DatPhong] [dp]
    JOIN [Phong] [p]      ON [dp].[MaPhong]    = [p].[MaPhong]
    JOIN [LoaiPhong] [lp] ON [p].[MaLoaiPhong] = [lp].[MaLoaiPhong]
    WHERE [dp].[MaDatPhong] = @MaDatPhong;

    SELECT @TienDichVu = ISNULL(SUM([sdv].[SoLuong] * [dv].[DonGia]), 0)
    FROM [SuDungDichVu] [sdv]
    JOIN [DichVu] [dv] ON [sdv].[MaDichVu] = [dv].[MaDichVu]
    WHERE [sdv].[MaDatPhong] = @MaDatPhong;

    RETURN ISNULL(@TienPhong, 0) + @TienDichVu;
END;
GO

-- Khai thác Scalar Function
SELECT
    [dp].[MaDatPhong],
    [kh].[HoTen],
    [dp].[MaPhong],
    DATEDIFF(DAY,[dp].[NgayNhanPhong],[dp].[NgayTraPhong]) AS [SoDem],
    [dbo].[fn_TinhTongTienDatPhong]([dp].[MaDatPhong]) AS [TongTienDuKien]
FROM [DatPhong] [dp]
JOIN [KhachHang] [kh] ON [dp].[MaKhach] = [kh].[MaKhach]
ORDER BY [dp].[MaDatPhong];
GO

-- ====================================================
-- INLINE TABLE-VALUED FUNCTION: Danh sách phòng trống theo loại
-- Logic: Nhận MaLoaiPhong (0 = tất cả), trả về phòng đang Trống
-- ====================================================
CREATE FUNCTION [dbo].[fn_PhongTrongTheoLoai] (@MaLoaiPhong INT)
RETURNS TABLE
AS
RETURN (
    SELECT
        [p].[MaPhong],
        [p].[TenPhong],
        [p].[Tang],
        [lp].[TenLoai],
        [lp].[GiaMotDem],
        [lp].[SucChua]
    FROM [Phong] [p]
    JOIN [LoaiPhong] [lp] ON [p].[MaLoaiPhong] = [lp].[MaLoaiPhong]
    WHERE [p].[TrangThai] = N'Trống'
      AND ([p].[MaLoaiPhong] = @MaLoaiPhong OR @MaLoaiPhong = 0)
);
GO

-- Khai thác Inline TVF
SELECT * FROM [dbo].[fn_PhongTrongTheoLoai](0);   -- tất cả phòng trống
SELECT * FROM [dbo].[fn_PhongTrongTheoLoai](2);   -- chỉ phòng đôi trống
GO

-- ====================================================
-- MULTI-STATEMENT TVF: Báo cáo doanh thu theo từng tháng trong năm
-- Logic: Duyệt 12 tháng, tính tổng tiền đặt phòng 'Đã trả',
--        xếp loại: Cao / Trung bình / Thấp
-- ====================================================
CREATE FUNCTION [dbo].[fn_DoanhThuTheoNam] (@Nam INT)
RETURNS @BaoCao TABLE (
    [Thang]      INT,
    [TenThang]   NVARCHAR(20),
    [SoDatPhong] INT,
    [DoanhThu]   MONEY,
    [XepLoai]    NVARCHAR(20)
)
AS
BEGIN
    DECLARE @Thang INT = 1;
    DECLARE @SoDatPhong INT, @DoanhThu MONEY;

    WHILE @Thang <= 12
    BEGIN
        SELECT
            @SoDatPhong = COUNT(*),
            @DoanhThu   = ISNULL(SUM([dbo].[fn_TinhTongTienDatPhong]([MaDatPhong])), 0)
        FROM [DatPhong]
        WHERE YEAR([NgayTraPhong])  = @Nam
          AND MONTH([NgayTraPhong]) = @Thang
          AND [TrangThai] = N'Đã trả';

        INSERT INTO @BaoCao VALUES (
            @Thang,
            N'Tháng ' + CAST(@Thang AS NVARCHAR),
            ISNULL(@SoDatPhong, 0),
            ISNULL(@DoanhThu,   0),
            CASE
                WHEN ISNULL(@DoanhThu,0) >= 10000000 THEN N'Cao'
                WHEN ISNULL(@DoanhThu,0) >= 3000000  THEN N'Trung bình'
                ELSE N'Thấp'
            END
        );
        SET @Thang = @Thang + 1;
    END;
    RETURN;
END;
GO

-- Khai thác Multi-statement TVF
SELECT * FROM [dbo].[fn_DoanhThuTheoNam](2025) WHERE [SoDatPhong] > 0;
GO

-- ============================================================
-- PHẦN 3: STORE PROCEDURE
-- ============================================================

-- Một số System SP của SQL Server
EXEC sp_help 'DatPhong';      -- xem cấu trúc bảng DatPhong
EXEC sp_helpdb;                -- liệt kê tất cả database
EXEC sp_who;                   -- xem phiên kết nối đang hoạt động
EXEC sp_helpindex 'Phong';     -- xem index trên bảng Phong
GO

-- ====================================================
-- SP1: Check-in (nhận phòng) - INSERT có kiểm tra điều kiện
-- Logic: kiểm tra phòng trống, sức chứa, ngày hợp lệ rồi INSERT
-- ====================================================
CREATE PROCEDURE [dbo].[sp_CheckIn]
    @MaKhach        INT,
    @MaPhong        NVARCHAR(10),
    @NgayNhanPhong  DATE,
    @NgayTraPhong   DATE,
    @SoNguoi        INT,
    @GhiChu         NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @NgayTraPhong <= @NgayNhanPhong
    BEGIN PRINT N'Lỗi: Ngày trả phòng phải sau ngày nhận phòng.'; RETURN; END;

    IF NOT EXISTS (SELECT 1 FROM [KhachHang] WHERE [MaKhach] = @MaKhach)
    BEGIN PRINT N'Lỗi: Khách hàng không tồn tại.'; RETURN; END;

    IF NOT EXISTS (SELECT 1 FROM [Phong] WHERE [MaPhong]=@MaPhong AND [TrangThai]=N'Trống')
    BEGIN PRINT N'Lỗi: Phòng không tồn tại hoặc không trống.'; RETURN; END;

    DECLARE @SucChua INT;
    SELECT @SucChua = [lp].[SucChua]
    FROM [Phong] [p] JOIN [LoaiPhong] [lp] ON [p].[MaLoaiPhong]=[lp].[MaLoaiPhong]
    WHERE [p].[MaPhong] = @MaPhong;

    IF @SoNguoi > @SucChua
    BEGIN
        PRINT N'Lỗi: Số người vượt sức chứa (' + CAST(@SucChua AS NVARCHAR) + N' người).';
        RETURN;
    END;

    INSERT INTO [DatPhong]([MaKhach],[MaPhong],[NgayNhanPhong],[NgayTraPhong],[SoNguoi],[TrangThai],[GhiChu])
    VALUES (@MaKhach,@MaPhong,@NgayNhanPhong,@NgayTraPhong,@SoNguoi,N'Đang ở',@GhiChu);

    UPDATE [Phong] SET [TrangThai]=N'Đang thuê' WHERE [MaPhong]=@MaPhong;

    PRINT N'Check-in thành công! Phòng ' + @MaPhong + N' đã được đặt.';
END;
GO

-- Khai thác SP1
EXEC [dbo].[sp_CheckIn] 3, 'P101', '2025-06-15', '2025-06-18', 1, N'Khách VIP';   -- thành công
EXEC [dbo].[sp_CheckIn] 1, 'P401', '2025-06-15', '2025-06-18', 5, NULL;            -- lỗi sức chứa
EXEC [dbo].[sp_CheckIn] 2, 'P102', '2025-06-15', '2025-06-18', 1, NULL;            -- lỗi phòng đang thuê
GO

-- ====================================================
-- SP2: Check-out (trả phòng) - tham số OUTPUT trả về tổng tiền
-- Logic: tính tổng tiền qua fn_TinhTongTienDatPhong, cập nhật trạng thái
-- ====================================================
CREATE PROCEDURE [dbo].[sp_CheckOut]
    @MaDatPhong     INT,
    @TongThanhToan  MONEY OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM [DatPhong] WHERE [MaDatPhong]=@MaDatPhong AND [TrangThai]=N'Đang ở')
    BEGIN
        PRINT N'Lỗi: Không tìm thấy đặt phòng hợp lệ để trả.';
        SET @TongThanhToan = 0;
        RETURN;
    END;

    SET @TongThanhToan = [dbo].[fn_TinhTongTienDatPhong](@MaDatPhong);

    UPDATE [DatPhong]
    SET [TrangThai]=N'Đã trả', [TongTien]=@TongThanhToan
    WHERE [MaDatPhong]=@MaDatPhong;

    UPDATE [Phong] SET [TrangThai]=N'Trống'
    WHERE [MaPhong]=(SELECT [MaPhong] FROM [DatPhong] WHERE [MaDatPhong]=@MaDatPhong);

    PRINT N'Check-out thành công! Tổng tiền: ' + CAST(@TongThanhToan AS NVARCHAR) + N' VNĐ';
END;
GO

-- Khai thác SP2
DECLARE @Tien MONEY;
EXEC [dbo].[sp_CheckOut] 2, @Tien OUTPUT;
SELECT @Tien AS [TongTienPhaiTra];
GO

-- ====================================================
-- SP3: Báo cáo tình trạng đặt phòng (JOIN 4 bảng, trả result set)
-- Logic: JOIN DatPhong + KhachHang + Phong + LoaiPhong, lọc theo trạng thái
-- ====================================================
CREATE PROCEDURE [dbo].[sp_BaoCaoDatPhong]
    @TrangThai NVARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [dp].[MaDatPhong],
        [kh].[HoTen]        AS [TenKhach],
        [kh].[QuocTich],
        [p].[MaPhong],
        [p].[TenPhong],
        [p].[Tang],
        [lp].[TenLoai]      AS [LoaiPhong],
        [lp].[GiaMotDem],
        [dp].[NgayNhanPhong],
        [dp].[NgayTraPhong],
        DATEDIFF(DAY,[dp].[NgayNhanPhong],[dp].[NgayTraPhong]) AS [SoDem],
        [dp].[SoNguoi],
        [dp].[TrangThai],
        [dbo].[fn_TinhTongTienDatPhong]([dp].[MaDatPhong])    AS [TongTienDuKien],
        [dp].[GhiChu]
    FROM [DatPhong] [dp]
    JOIN [KhachHang] [kh]  ON [dp].[MaKhach]    = [kh].[MaKhach]
    JOIN [Phong] [p]        ON [dp].[MaPhong]    = [p].[MaPhong]
    JOIN [LoaiPhong] [lp]   ON [p].[MaLoaiPhong]= [lp].[MaLoaiPhong]
    WHERE @TrangThai IS NULL OR [dp].[TrangThai] = @TrangThai
    ORDER BY [dp].[NgayNhanPhong] DESC;
END;
GO

-- Khai thác SP3
EXEC [dbo].[sp_BaoCaoDatPhong];                         -- tất cả
EXEC [dbo].[sp_BaoCaoDatPhong] @TrangThai = N'Đang ở'; -- đang ở
GO

-- ============================================================
-- PHẦN 4: TRIGGER
-- ============================================================

-- Bảng ghi lịch sử thay đổi trạng thái phòng
CREATE TABLE [LichSuPhong] (
    [MaLog]         INT          IDENTITY(1,1) PRIMARY KEY,
    [MaPhong]       NVARCHAR(10),
    [TrangThaiCu]   NVARCHAR(20),
    [TrangThaiMoi]  NVARCHAR(20),
    [ThoiGian]      DATETIME     DEFAULT GETDATE(),
    [GhiChu]        NVARCHAR(200) NULL
);
GO

-- TRIGGER 1: Bảng A (Phong) thay đổi TrangThai -> ghi log vào Bảng B (LichSuPhong)
CREATE TRIGGER [trg_Phong_GhiLichSu]
ON [Phong]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE([TrangThai])
    BEGIN
        INSERT INTO [LichSuPhong]([MaPhong],[TrangThaiCu],[TrangThaiMoi],[GhiChu])
        SELECT
            [i].[MaPhong],
            [d].[TrangThai],
            [i].[TrangThai],
            N'Ghi bởi trigger lúc ' + CONVERT(NVARCHAR,GETDATE(),120)
        FROM inserted [i]
        JOIN deleted [d] ON [i].[MaPhong]=[d].[MaPhong]
        WHERE [i].[TrangThai] <> [d].[TrangThai];
    END;
END;
GO

-- Test trigger 1
UPDATE [Phong] SET [TrangThai]=N'Bảo trì' WHERE [MaPhong]='P201';
UPDATE [Phong] SET [TrangThai]=N'Trống'   WHERE [MaPhong]='P201';
SELECT * FROM [LichSuPhong];
GO

-- ============================================================
-- TRIGGER VÒNG TRÒN: A -> B -> A
-- ============================================================

CREATE TABLE [ThongKePhong] (
    [MaLoaiPhong]   INT PRIMARY KEY,
    [SoPhongTrong]  INT DEFAULT 0
);
GO

INSERT INTO [ThongKePhong]([MaLoaiPhong],[SoPhongTrong])
SELECT [MaLoaiPhong], COUNT(*)
FROM [Phong] WHERE [TrangThai]=N'Trống'
GROUP BY [MaLoaiPhong];
GO

-- TRIGGER A->B: Phong thay đổi -> cập nhật ThongKePhong
CREATE TRIGGER [trg_Phong_CapNhatThongKe]
ON [Phong]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE([TrangThai])
    BEGIN
        DECLARE @MaLoai INT;
        SELECT @MaLoai = [MaLoaiPhong] FROM inserted;

        UPDATE [ThongKePhong]
        SET [SoPhongTrong] = (
            SELECT COUNT(*) FROM [Phong]
            WHERE [MaLoaiPhong]=@MaLoai AND [TrangThai]=N'Trống'
        )
        WHERE [MaLoaiPhong]=@MaLoai;
    END;
END;
GO

-- TRIGGER B->A: ThongKePhong thay đổi -> in thông báo (KHÔNG tác động ngược lại Phong)
CREATE TRIGGER [trg_ThongKe_PhanHoi]
ON [ThongKePhong]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    PRINT N'[TRIGGER B] ThongKePhong vừa cập nhật. Không tác động ngược lại để tránh vòng lặp vô tận.';
    -- Nếu đây UPDATE lại Phong: trg_Phong_CapNhatThongKe kích hoạt -> trg_ThongKe_PhanHoi -> ...
    -- SQL Server sẽ lỗi "nesting level exceeded 32" nếu RECURSIVE_TRIGGERS = ON
END;
GO

-- Test vòng tròn
UPDATE [Phong] SET [TrangThai]=N'Đang thuê' WHERE [MaPhong]='P402';
SELECT * FROM [ThongKePhong];
GO

-- ============================================================
-- PHẦN 5: CURSOR VÀ DUYỆT DỮ LIỆU
-- ============================================================

-- BÀI TOÁN: Duyệt từng phòng đang ở, tính số ngày đã lưu trú.
-- Nếu vượt 7 ngày thì in cảnh báo "Ở lâu bất thường".

-- CÁCH 1: Dùng CURSOR
DECLARE @MaPhong    NVARCHAR(10);
DECLARE @MaDatPhong INT;
DECLARE @HoTen      NVARCHAR(100);
DECLARE @NgayNhan   DATE;
DECLARE @SoNgay     INT;

DECLARE [curPhongDangO] CURSOR FOR
    SELECT [dp].[MaDatPhong],[dp].[MaPhong],[kh].[HoTen],[dp].[NgayNhanPhong]
    FROM [DatPhong] [dp]
    JOIN [KhachHang] [kh] ON [dp].[MaKhach]=[kh].[MaKhach]
    WHERE [dp].[TrangThai]=N'Đang ở';

OPEN [curPhongDangO];
FETCH NEXT FROM [curPhongDangO] INTO @MaDatPhong,@MaPhong,@HoTen,@NgayNhan;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SoNgay = DATEDIFF(DAY, @NgayNhan, GETDATE());

    IF @SoNgay > 7
        PRINT N'[CẢNH BÁO] Phòng ' + @MaPhong + N' - ' + @HoTen
              + N' đã ở ' + CAST(@SoNgay AS NVARCHAR) + N' ngày - Bất thường!';
    ELSE
        PRINT N'[OK] Phòng ' + @MaPhong + N' - ' + @HoTen
              + N' - ' + CAST(@SoNgay AS NVARCHAR) + N' ngày - Bình thường.';

    FETCH NEXT FROM [curPhongDangO] INTO @MaDatPhong,@MaPhong,@HoTen,@NgayNhan;
END;

CLOSE [curPhongDangO];
DEALLOCATE [curPhongDangO];
GO

-- CÁCH 2: Không dùng CURSOR - giải quyết cùng bài toán bằng set-based
SELECT
    [dp].[MaDatPhong],
    [dp].[MaPhong],
    [kh].[HoTen],
    [dp].[NgayNhanPhong],
    DATEDIFF(DAY,[dp].[NgayNhanPhong],GETDATE()) AS [SoNgayDaO],
    CASE
        WHEN DATEDIFF(DAY,[dp].[NgayNhanPhong],GETDATE()) > 7
        THEN N'Bất thường'
        ELSE N'Bình thường'
    END AS [TinhTrang]
FROM [DatPhong] [dp]
JOIN [KhachHang] [kh] ON [dp].[MaKhach]=[kh].[MaKhach]
WHERE [dp].[TrangThai]=N'Đang ở';
GO

-- ====================================================
-- SO SÁNH TỐC ĐỘ
-- ====================================================
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- CURSOR
DECLARE @P2 NVARCHAR(10),@D2 INT,@H2 NVARCHAR(100),@N2 DATE;
DECLARE [curTest] CURSOR FOR
    SELECT [dp].[MaDatPhong],[dp].[MaPhong],[kh].[HoTen],[dp].[NgayNhanPhong]
    FROM [DatPhong] [dp] JOIN [KhachHang] [kh] ON [dp].[MaKhach]=[kh].[MaKhach]
    WHERE [dp].[TrangThai]=N'Đang ở';
OPEN [curTest]; FETCH NEXT FROM [curTest] INTO @D2,@P2,@H2,@N2;
WHILE @@FETCH_STATUS=0 BEGIN FETCH NEXT FROM [curTest] INTO @D2,@P2,@H2,@N2; END;
CLOSE [curTest]; DEALLOCATE [curTest];
GO

-- Set-based
SELECT [dp].[MaDatPhong],[dp].[MaPhong],[kh].[HoTen],
       DATEDIFF(DAY,[dp].[NgayNhanPhong],GETDATE()) AS [SoNgay]
FROM [DatPhong] [dp] JOIN [KhachHang] [kh] ON [dp].[MaKhach]=[kh].[MaKhach]
WHERE [dp].[TrangThai]=N'Đang ở';
GO

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

-- ====================================================
-- BÀI TOÁN CHỈ CURSOR MỚI LÀM TỐT:
-- In hóa đơn chi tiết từng đặt phòng đã trả chưa có TongTien,
-- cập nhật TongTien đồng thời. SQL set-based UPDATE được nhưng
-- KHÔNG thể in hóa đơn định dạng riêng từng dòng như này.
-- ====================================================
DECLARE
    @MD3 INT, @MP3 NVARCHAR(10), @HT3 NVARCHAR(100),
    @NN3 DATE, @NT3 DATE, @TT3 MONEY;

DECLARE [curHoaDon] CURSOR FOR
    SELECT [dp].[MaDatPhong],[kh].[HoTen],[dp].[MaPhong],[dp].[NgayNhanPhong],[dp].[NgayTraPhong]
    FROM [DatPhong] [dp]
    JOIN [KhachHang] [kh] ON [dp].[MaKhach]=[kh].[MaKhach]
    WHERE [dp].[TrangThai]=N'Đã trả' AND [dp].[TongTien] IS NULL;

OPEN [curHoaDon];
FETCH NEXT FROM [curHoaDon] INTO @MD3,@HT3,@MP3,@NN3,@NT3;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @TT3 = [dbo].[fn_TinhTongTienDatPhong](@MD3);
    UPDATE [DatPhong] SET [TongTien]=@TT3 WHERE [MaDatPhong]=@MD3;

    PRINT N'==============================';
    PRINT N'HÓA ĐƠN #' + CAST(@MD3 AS NVARCHAR);
    PRINT N'Khách hàng : ' + @HT3;
    PRINT N'Phòng      : ' + @MP3;
    PRINT N'Ngày nhận  : ' + CONVERT(NVARCHAR,@NN3,103);
    PRINT N'Ngày trả   : ' + CONVERT(NVARCHAR,@NT3,103);
    PRINT N'Số đêm     : ' + CAST(DATEDIFF(DAY,@NN3,@NT3) AS NVARCHAR);
    PRINT N'Tổng tiền  : ' + CAST(@TT3 AS NVARCHAR) + N' VNĐ';
    PRINT N'==============================';

    FETCH NEXT FROM [curHoaDon] INTO @MD3,@HT3,@MP3,@NN3,@NT3;
END;

CLOSE [curHoaDon];
DEALLOCATE [curHoaDon];
GO
