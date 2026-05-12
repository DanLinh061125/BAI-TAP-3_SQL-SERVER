
USE master;
GO
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'QuanLyCamCo')
    DROP DATABASE QuanLyCamCo;
GO
CREATE DATABASE QuanLyCamCo;
GO
USE QuanLyCamCo;
GO

-- =============================================================================
-- 1. THIẾT KẾ BẢNG (NHIỆM VỤ 1 - CHUẨN 3NF)
-- =============================================================================

-- Bảng Khách Hàng
CREATE TABLE KhachHang (
    MaKH INT PRIMARY KEY IDENTITY(1,1),
    TenKH NVARCHAR(100) NOT NULL,
    SoDT VARCHAR(15),
    DiaChi NVARCHAR(250)
);

-- Bảng Hợp Đồng
CREATE TABLE HopDong (
    MaHD INT PRIMARY KEY IDENTITY(1,1),
    MaKH INT FOREIGN KEY REFERENCES KhachHang(MaKH),
    NgayKy DATETIME DEFAULT GETDATE(),
    SoTienVayGoc DECIMAL(18,2) NOT NULL,
    Deadline1 DATETIME NOT NULL, -- Mốc kết thúc lãi đơn, bắt đầu lãi kép
    Deadline2 DATETIME NOT NULL, -- Mốc bắt đầu có thể thanh lý tài sản
    TrangThaiHD NVARCHAR(50) DEFAULT N'Đang vay' 
    -- Trạng thái: Đang vay, Quá hạn (nợ xấu), Đã thanh toán, Đã thanh lý tài sản, Đang trả góp
);

-- Bảng Tài Sản Thế Chấp
CREATE TABLE TaiSan (
    MaTS INT PRIMARY KEY IDENTITY(1,1),
    MaHD INT FOREIGN KEY REFERENCES HopDong(MaHD),
    TenTS NVARCHAR(100) NOT NULL,
    GiaTriDinhGia DECIMAL(18,2) NOT NULL,
    TrangThaiTS NVARCHAR(50) DEFAULT N'Đang cầm cố',
    -- Trạng thái: Đang cầm cố, Đã trả khách, Sẵn sàng thanh lý, Đã bán thanh lý
    IsSold BIT DEFAULT 0 -- Cờ đánh dấu đã bán khi thanh lý
);

-- Bảng Lịch Sử Giao Dịch (Audit Log)
CREATE TABLE LogGiaoDich (
    MaLog INT PRIMARY KEY IDENTITY(1,1),
    MaHD INT FOREIGN KEY REFERENCES HopDong(MaHD),
    NgayTra DATETIME DEFAULT GETDATE(),
    SoTienTra DECIMAL(18,2) NOT NULL,
    NguoiThu NVARCHAR(100)
);
GO

-- =============================================================================
-- 2. ĐỊNH NGHĨA KIỂU DỮ LIỆU BẢNG (CHO EVENT 1)
-- =============================================================================

-- Tạo Type để truyền danh sách nhiều tài sản vào Procedure
CREATE TYPE TaiSanType AS TABLE (
    TenTS NVARCHAR(100),
    GiaTriDinhGia DECIMAL(18,2)
);
GO

-- =============================================================================
-- 3. CÀI ĐẶT CÁC HÀM TÍNH TOÁN (EVENT 2)
-- =============================================================================

-- 3.1 Hàm tính TỔNG NỢ LÝ THUYẾT (Gốc + Lãi phát sinh)
CREATE FUNCTION fn_CalcMoneyTransaction(@TransactionID INT, @TargetDate DATETIME)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Goc DECIMAL(18,2), @NgayVay DATETIME, @DL1 DATETIME;
    DECLARE @LaiSuatDaily DECIMAL(18,4) = 0.005; -- 5.000 / 1.000.000 = 0.5%
    DECLARE @TongNo DECIMAL(18,2) = 0;

    SELECT @Goc = SoTienVayGoc, @NgayVay = NgayKy, @DL1 = Deadline1 
    FROM HopDong WHERE MaHD = @TransactionID;

    -- Nếu ngày tính trước ngày vay, chỉ trả về gốc
    IF @TargetDate <= @NgayVay RETURN @Goc;

    -- Tính số ngày lãi đơn (Từ lúc vay đến Deadline1 hoặc TargetDate)
    DECLARE @NgayLaiDon INT = DATEDIFF(DAY, @NgayVay, CASE WHEN @TargetDate <= @DL1 THEN @TargetDate ELSE @DL1 END);
    DECLARE @NoTaiDL1 DECIMAL(18,2) = @Goc + (@Goc * @LaiSuatDaily * @NgayLaiDon);

    -- Tính lãi kép nếu vượt quá Deadline 1
    IF @TargetDate > @DL1
    BEGIN
        DECLARE @NgayLaiKep INT = DATEDIFF(DAY, @DL1, @TargetDate);
        -- Công thức lãi kép: A = P * (1 + r)^n
        SET @TongNo = @NoTaiDL1 * CAST(POWER(1.0 + CAST(@LaiSuatDaily AS FLOAT), @NgayLaiKep) AS DECIMAL(18,2));
    END
    ELSE
    BEGIN
        SET @TongNo = @NoTaiDL1;
    END

    RETURN @TongNo;
END;
GO

-- 3.2 Hàm tính DƯ NỢ HIỆN TẠI (Tổng nợ - Số tiền đã trả trong Log)
CREATE FUNCTION fn_CalcMoneyContract(@ContractID INT, @TargetDate DATETIME)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @TongNoLyThuyet DECIMAL(18,2) = dbo.fn_CalcMoneyTransaction(@ContractID, @TargetDate);
    DECLARE @TongDaTra DECIMAL(18,2);

    SELECT @TongDaTra = ISNULL(SUM(SoTienTra), 0) 
    FROM LogGiaoDich 
    WHERE MaHD = @ContractID AND NgayTra <= @TargetDate;

    DECLARE @DuNo DECIMAL(18,2) = @TongNoLyThuyet - @TongDaTra;
    RETURN CASE WHEN @DuNo < 0 THEN 0 ELSE @DuNo END;
END;
GO

-- =============================================================================
-- 4. CÁC THỦ TỤC NGHIỆP VỤ (EVENT 1, 3)
-- =============================================================================

-- Event 1: Tiếp nhận hợp đồng mới
CREATE PROCEDURE sp_TiepNhanHopDong
    @MaKH INT,
    @SoTienVayGoc DECIMAL(18,2),
    @Deadline1 DATETIME,
    @Deadline2 DATETIME,
    @DanhSachTS TaiSanType READONLY
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        INSERT INTO HopDong (MaKH, SoTienVayGoc, Deadline1, Deadline2)
        VALUES (@MaKH, @SoTienVayGoc, @Deadline1, @Deadline2);
        
        DECLARE @NewHD INT = SCOPE_IDENTITY();

        INSERT INTO TaiSan (MaHD, TenTS, GiaTriDinhGia)
        SELECT @NewHD, TenTS, GiaTriDinhGia FROM @DanhSachTS;

        COMMIT TRANSACTION;
        PRINT N'Đã tạo hợp đồng mới ID: ' + CAST(@NewHD AS VARCHAR(10));
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- Event 3: Xử lý trả nợ và hoàn trả tài sản
CREATE PROCEDURE sp_XuLyTraNo
    @MaHD INT,
    @SoTienTra DECIMAL(18,2),
    @NguoiThu NVARCHAR(100)
AS
BEGIN
    DECLARE @TrangThaiHD NVARCHAR(50), @DuNoHienTai DECIMAL(18,2);
    SELECT @TrangThaiHD = TrangThaiHD FROM HopDong WHERE MaHD = @MaHD;
    SET @DuNoHienTai = dbo.fn_CalcMoneyContract(@MaHD, GETDATE());

    -- Kiểm tra nếu đã thanh lý thì không thu tiền
    IF @TrangThaiHD = N'Đã thanh lý tài sản'
    BEGIN
        PRINT N'LỖI: Tài sản đã bị thanh lý. Không thể thu tiền.';
        RETURN;
    END

    -- Ghi nhận giao dịch
    INSERT INTO LogGiaoDich (MaHD, SoTienTra, NguoiThu)
    VALUES (@MaHD, @SoTienTra, @NguoiThu);

    -- Cập nhật dư nợ và trạng thái
    DECLARE @DuNoMoi DECIMAL(18,2) = @DuNoHienTai - @SoTienTra;

    IF @DuNoMoi <= 0
    BEGIN
        UPDATE HopDong SET TrangThaiHD = N'Đã thanh toán' WHERE MaHD = @MaHD;
        UPDATE TaiSan SET TrangThaiTS = N'Đã trả khách' WHERE MaHD = @MaHD;
        PRINT N'Hợp đồng đã thanh toán đủ. Đã trả lại toàn bộ tài sản.';
    END
    ELSE
    BEGIN
        UPDATE HopDong SET TrangThaiHD = N'Đang trả góp' WHERE MaHD = @MaHD;
        PRINT N'Đã ghi nhận thanh toán. Dư nợ còn lại: ' + CAST(@DuNoMoi AS VARCHAR(20));
        
        -- Gợi ý trả lại tài sản (Giá trị tài sản còn lại >= Dư nợ còn lại)
        PRINT N'--- GỢI Ý TÀI SẢN CÓ THỂ TRẢ LẠI CHO KHÁCH ---';
        SELECT MaTS, TenTS, GiaTriDinhGia 
        FROM TaiSan 
        WHERE MaHD = @MaHD AND TrangThaiTS = N'Đang cầm cố'
        AND ( (SELECT SUM(GiaTriDinhGia) FROM TaiSan t2 WHERE t2.MaHD = @MaHD AND t2.TrangThaiTS = N'Đang cầm cố') 
              - GiaTriDinhGia ) >= @DuNoMoi;
    END
END;
GO

-- Sự kiện bổ sung: Gia hạn hợp đồng (Trả hết lãi để dời deadline)
CREATE PROCEDURE sp_GiaHanHopDong
    @MaHD INT,
    @SoNgayGiaHan INT,
    @NguoiThu NVARCHAR(100)
AS
BEGIN
    DECLARE @Goc DECIMAL(18,2), @DuNoToanBo DECIMAL(18,2);
    SELECT @Goc = SoTienVayGoc FROM HopDong WHERE MaHD = @MaHD;
    SET @DuNoToanBo = dbo.fn_CalcMoneyContract(@MaHD, GETDATE());

    DECLARE @TienLaiPhaiTra DECIMAL(18,2) = @DuNoToanBo - @Goc;

    IF @TienLaiPhaiTra > 0
    BEGIN
        PRINT N'Khách phải trả ' + CAST(@TienLaiPhaiTra AS VARCHAR(20)) + N' tiền lãi để gia hạn.';
        -- Giả định khách trả đủ lãi
        INSERT INTO LogGiaoDich (MaHD, SoTienTra, NguoiThu) VALUES (@MaHD, @TienLaiPhaiTra, @NguoiThu);
        
        UPDATE HopDong 
        SET Deadline1 = DATEADD(DAY, @SoNgayGiaHan, GETDATE()),
            Deadline2 = DATEADD(DAY, @SoNgayGiaHan + 30, GETDATE()),
            NgayKy = GETDATE(), -- Reset ngày vay về hiện tại để tính lãi kỳ mới từ Gốc
            TrangThaiHD = N'Đang vay'
        WHERE MaHD = @MaHD;
        
        PRINT N'Gia hạn thành công.';
    END
END;
GO

-- =============================================================================
-- 5. TRUY VẤN NỢ XẤU (EVENT 4)
-- =============================================================================

CREATE PROCEDURE sp_XuatDanhSachNoXau
AS
BEGIN
    SELECT 
        KH.TenKH, 
        KH.SoDT, 
        HD.SoTienVayGoc,
        DATEDIFF(DAY, HD.Deadline1, GETDATE()) AS SoNgayQuaHan,
        dbo.fn_CalcMoneyContract(HD.MaHD, GETDATE()) AS TongTienHienTai,
        dbo.fn_CalcMoneyContract(HD.MaHD, DATEADD(MONTH, 1, GETDATE())) AS DuKienSau1Thang
    FROM HopDong HD
    JOIN KhachHang KH ON HD.MaKH = KH.MaKH
    WHERE GETDATE() > HD.Deadline1 
      AND HD.TrangThaiHD NOT IN (N'Đã thanh toán', N'Đã thanh lý tài sản');
END;
GO

-- =============================================================================
-- 6. HỆ THỐNG TRIGGER (EVENT 5)
-- =============================================================================

-- Tự động cập nhật trạng thái hợp đồng sang Nợ Xấu
CREATE TRIGGER trg_CheckBadDebt
ON HopDong
AFTER UPDATE, INSERT
AS
BEGIN
    UPDATE HopDong
    SET TrangThaiHD = N'Quá hạn (nợ xấu)'
    FROM HopDong
    INNER JOIN inserted i ON HopDong.MaHD = i.MaHD
    WHERE GETDATE() > HopDong.Deadline1 
      AND HopDong.TrangThaiHD = N'Đang vay';
END;
GO

-- Tự động cập nhật tài sản Sẵn sàng thanh lý
CREATE TRIGGER trg_ReadyToLiquidation
ON HopDong
AFTER UPDATE
AS
BEGIN
    IF UPDATE(TrangThaiHD)
    BEGIN
        UPDATE TaiSan
        SET TrangThaiTS = N'Sẵn sàng thanh lý'
        FROM TaiSan
        JOIN inserted i ON TaiSan.MaHD = i.MaHD
        WHERE i.TrangThaiHD = N'Quá hạn (nợ xấu)' 
          AND GETDATE() > i.Deadline2;
    END
END;
GO

-- Tự động chuyển trạng thái tài sản thành Đã bán khi Hợp đồng "Đã thanh lý"
CREATE TRIGGER trg_MarkAsSold
ON HopDong
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE TrangThaiHD = N'Đã thanh lý tài sản')
    BEGIN
        UPDATE TaiSan
        SET TrangThaiTS = N'Đã bán thanh lý', IsSold = 1
        FROM TaiSan
        JOIN inserted i ON TaiSan.MaHD = i.MaHD
        WHERE i.TrangThaiHD = N'Đã thanh lý tài sản';
    END
END;
GO

-- =============================================================================
-- 7. KỊCH BẢN CHẠY THỬ (TEST CASE)
-- =============================================================================

-- 7.1 Tạo khách hàng
INSERT INTO KhachHang (TenKH, SoDT, DiaChi) VALUES (N'Trần Thị Thùy', '0987654321', N'K59KMT');

-- 7.2 Đăng ký hợp đồng (Lùi ngày để test lãi kép)
DECLARE @TS TaiSanType;
INSERT INTO @TS VALUES (N'iPhone 15 Pro', 25000000), (N'Macbook M3', 40000000);

-- Giả định vay từ 2 tháng trước (60 ngày)
-- Deadline 1 là sau 30 ngày -> Đã quá hạn 30 ngày lãi kép
EXEC sp_TiepNhanHopDong 
    @MaKH = 1, 
    @SoTienVayGoc = 20000000, 
    @Deadline1 = '2024-04-01', 
    @Deadline2 = '2024-05-01', 
    @DanhSachTS = @TS;

-- 7.3 Kiểm tra nợ và nợ xấu
EXEC sp_XuatDanhSachNoXau;

-- 7.4 Trả nợ một phần
EXEC sp_XuLyTraNo @MaHD = 1, @SoTienTra = 5000000, @NguoiThu = N'Quản lý Cốp';

-- 7.5 Xem lịch sử log
SELECT * FROM LogGiaoDich;
SELECT * FROM HopDong;
SELECT * FROM TaiSan;