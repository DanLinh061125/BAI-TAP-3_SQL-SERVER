# Bài kiểm tra số 2 - Hẹ Quản trị Cơ sở dữ liệu (SQL SERVER)
# PHẦN MỞ ĐẦU
Thông tin sinh viên:

- **Họ và tên** : Nguyễn Phạm Đan Linh

- **Mã sinh viên** : K235480106095

- **Lớp** : K59KMT.K01

- **Khoa** : Điện tử

- **Môn học** : Hệ Quản Trị Cơ Sở Dữ Liệu (SQL Server)

## Yêu Cầu Đầu Bài

**Đề tài: Quản lý khách sạn** 

**I. Giới Thiệu Về Hệ Thống Quản Lý Khách Sạn**

Xây dựng một hệ thống quản lý khách sạn (QuanLyKhachSan) từ nền tảng SQL Server, bao gồm các chức năng chủ yếu như quản lý thông tin khách hàng, quản lý dữ liệu phòng, và quản lý các lượt đặt phòng. Mỗi khách hàng đều có hồ sơ lưu trữ với các thông tin cá nhân, số điện thoại liên hệ, ngày sinh và điểm đánh giá; mỗi phòng trong khách sạn được phân loại theo loại phòng (Standard, Superior, Deluxe, Suite), có diện tích riêng biệt và giá thuê theo ngày; các lượt đặt phòng lưu giữ mối quan hệ giữa khách hàng và phòng, cùng với thời gian nhận-trả phòng và tiền cọc.

Toàn bộ bài làm được chia thành 5 phần chính theo thứ tự tăng độ phức tạp.

- Thiết Kế Cơ Sở Dữ Liệu — khởi tạo các bảng KhachHang, Phong, DatPhong với các ràng buộc toàn vẹn (Primary Key, Foreign Key, Check Constraint) và chèn dữ liệu mẫu.
  
- Xây Dựng Function — tạo các hàm tính toán như tính số ngày ở, tính doanh thu, tìm phòng trống; những hàm này giúp tái sử dụng logic và làm sạch mã.
  
- Xây Dựng Stored Procedure — tạo các thủ tục lưu trữ để xử lý các nghiệp vụ phức tạp như đặt phòng mới, tính hóa đơn, báo cáo doanh thu theo tháng.
  
- Trigger Xử Lý Nghiệp Vụ — định nghĩa các trigger tự động kích hoạt khi dữ liệu thay đổi (chẳng hạn, tự động cập nhật trạng thái phòng khi có đặt phòng mới, hoặc ghi log thay đổi).
  
- Dùng Cursor và Xử Lý Dữ Liệu — sử dụng cursor để duyệt từng bản ghi và thực hiện các xử lý tuần tự, đồng thời so sánh hiệu năng giữa phương pháp cursor và phương pháp set-based, từ đó rút ra kết luận về tối ưu hóa.
  
Trong quá trình thực hiện, sẽ thiết kế cơ sở dữ liệu với tên chuẩn: QuanLyKhachSan_K235480106022. Mỗi phần lệnh SQL viết ra sẽ đi kèm một ảnh screenshot chứa mã lệnh và kết quả thực thi, với các chú thích chi tiết: ảnh dùng để minh họa bước nào, câu lệnh giải quyết vấn đề gì, kết quả thể hiện thông tin gì. Thông qua bài tập này sẽ nắm vững các khái niệm cơ bản và nâng cao của SQL Server, từ DDL (Data Definition Language) đến DML (Data Manipulation Language), từ những truy vấn đơn giản đến những xử lý phức tạp bằng Function, Procedure, Trigger, và Cursor, từ đó tích lũy kỹ năng thiết kế và quản trị cơ sở dữ liệu chuyên nghiệp.

## NỘI DUNG YÊU CẦU (GỒM 5 PHẦN):

### Phần 1: Thiết kế và Khởi tạo Cấu trúc Dữ liệu (Kiến thức 6, 7) 
+ Tạo cơ sở dữ liệu

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/ee12e08d-ec38-4da8-84ce-f3497d0038e1" />

                                            Tạo cơ sở dữ liệu QUANLYKHACHSAN_K235480106095 
                                      
+ Bảng [KHACHHANG]:
  
Phân tích:

    CREATE TABLE [KhachHang] (
    [MaKhachHang] INT IDENTITY(1,1) PRIMARY KEY,
    [TenKhachHang] NVARCHAR(100) NOT NULL,
    [SoDienThoai] VARCHAR(15),
    [NgaySinh] DATE,
    [DiemDanhGia] INT CHECK (DiemDanhGia BETWEEN 0 AND 10)
    )
  
MaKhachHang: Primary Key (PK) → định danh duy nhất, tự tăng

TenKhachHang: NOT NULL → bắt buộc nhập

DiemDanhGia: CHECK (CK) → chỉ cho phép giá trị từ 0–10

Ý nghĩa:

Đảm bảo dữ liệu khách hàng không bị trùng và hợp lệ.

<img width="1918" height="1079" alt="image" src="https://github.com/user-attachments/assets/968faf0f-e05a-4bcd-98d4-b51e11bd6e09" />

                                                        Tạo bảng KhachHang
+ Bảng [PHONG]:

Mục đích:

Quản lý thông tin phòng trong khách sạn.

Câu lệnh SQL:

    CREATE TABLE [Phong] (
    [MaPhong] INT IDENTITY(1,1) PRIMARY KEY,
    [LoaiPhong] NVARCHAR(50),
    [DienTich] FLOAT,
    [GiaPhong] DECIMAL(10,2),
    [TrangThai] BIT
    )

Phân tích:

MaPhong: Primary Key (PK)

GiaPhong: dùng DECIMAL → đảm bảo tính chính xác tiền

TrangThai: kiểu BIT

0: phòng trống

1: phòng đã thuê

Ý nghĩa:

Giúp quản lý tình trạng phòng và giá thuê rõ ràng.

Kết quả:

Bảng được tạo thành công, có thể lưu dữ liệu phòng.

  <img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/b3d1271d-9467-487b-8d86-78c0416b1748" />
               
                                                        Tạo bảng Phong
+ Bảng [DatPhong]
Mục đích:
Quản lý các lượt đặt phòng của khách hàng.

Câu lệnh SQL:

    CREATE TABLE [DatPhong] (
    [MaDatPhong] INT IDENTITY(1,1) PRIMARY KEY,
    [MaKhachHang] INT,
    [MaPhong] INT,
    [NgayNhan] DATETIME,
    [NgayTra] DATETIME,
    [TienCoc] DECIMAL(10,2),
    FOREIGN KEY ([MaKhachHang]) REFERENCES [KhachHang]([MaKhachHang]),
    FOREIGN KEY ([MaPhong]) REFERENCES [Phong]([MaPhong])
    )

Phân tích:

MaDatPhong: Primary Key (PK)
MaKhachHang: Foreign Key (FK) → liên kết bảng KhachHang
MaPhong: Foreign Key (FK) → liên kết bảng Phong

Ý nghĩa:

Đảm bảo chỉ có thể đặt phòng khi khách hàng và phòng tồn tại
Tăng tính toàn vẹn dữ liệu (không có dữ liệu “mồ côi”)

Kết quả:

Bảng được tạo thành công và liên kết đúng với các bảng khác.

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/97fde3c6-5b78-4182-b539-b2f559c46c06" />      
           
                                                        Tạo bảng DatPhong

+ Chèn dữ liệu
            
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/db5cd0ba-ee9b-4747-9177-b3d663fb4f5f" />
                                          
                                          Dữ liệu mẫu chèn vào bảng DatPhong - 5 rows affected.
  
### Phần 2: Xây dựng Function (Kiến thức 8, 9) 

- Hãy cho biết trong SQL Server có những loại function build_in (hàm có sẵn) nào, nêu 1 vài system function build_in mà em tìm hiểu được (ko cần nhiều, cần đặc sắc theo góc nhìn của em), cho SQL khai thác các hàm đó.
    
CÁC LOẠI BUILT-IN FUNCTION TRONG SQL SERVER

## Trong SQL Server, các hàm có sẵn (Built-in Functions) được chia thành các nhóm chính sau:

 1. Hàm xử lý chuỗi (String Functions)
Ví dụ: LEN(), UPPER(), LOWER(), CONCAT()

 3. Hàm ngày giờ (Date & Time Functions)
Ví dụ: GETDATE(), DATEDIFF(), DATEADD()

 5. Hàm toán học (Mathematical Functions)
Ví dụ: ABS(), ROUND(), CEILING()

 7. Hàm hệ thống (System Functions)
Ví dụ: NEWID(), ISNULL(), CAST()

 9. Hàm tổng hợp (Aggregate Functions)
Ví dụ: COUNT(), SUM(), AVG(), MAX(), MIN()

## MỘT SỐ BUILT-IN FUNCTION TIÊU BIỂU (THEO GÓC NHÌN CÁ NHÂN)

+ NEWID(): Tạo mã định danh duy nhất (GUID) và thường dùng để xáo trộn (random) dữ liệu

-- Lấy ngẫu nhiên 1 khách hàng để gợi ý dịch vụ

      SELECT TOP 1 MaKhachHang, TenKhachHang
      FROM [KhachHang]
      ORDER BY NEWID();

Giải thích:

NEWID(): tạo ra một giá trị GUID ngẫu nhiên. Khi dùng trong ORDER BY, mỗi dòng sẽ được gán một giá trị ngẫu nhiên → giúp xáo trộn dữ liệu và lấy ra bản ghi bất kỳ.

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/00613313-1bac-4565-8ebb-a13be53ea059" />
                
                Lấy ngẫu nhiên một khách hàng trong hệ thống để phục vụ cho việc gợi ý hoặc kiểm thử dữ liệu.
                
 + DATEDIFF(): Tính khoảng cách giữa 2 mốc thời gian (rất quan trọng trong bài toán khách sạn)
   
-- Tính số ngày khách đã ở
    SELECT 
    MaDatPhong,
    NgayNhan,
    NgayTra,
    DATEDIFF(DAY, NgayNhan, NgayTra) AS SoNgayO
    FROM [DatPhong]
    WHERE NgayTra IS NOT NULL;
    
Giải thích:

DATEDIFF() dùng để tính khoảng thời gian giữa 2 ngày. Trong hệ thống khách sạn, hàm này được dùng để tính số ngày khách lưu trú → làm cơ sở để tính tiền phòng.

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/3950161b-e118-4b80-b91a-4cc5bd8754bc" />

                                    Tính số ngày khách đã ở dựa trên ngày nhận và ngày trả phòng.     
                                    
+ COALESCE(): Lấy giá trị đầu tiên khác NULL trong danh sách
  
-- Nếu khách chưa trả phòng thì lấy ngày hiện tại
    SELECT 
    MaDatPhong,
    NgayNhan,
    NgayTra,
    COALESCE(NgayTra, GETDATE()) AS NgayTraThucTe
    FROM [DatPhong];

Giải thích:

COALESCE() trả về giá trị đầu tiên khác NULL trong danh sách. Trong bài toán khách sạn, nếu khách chưa trả phòng (NgayTra = NULL) thì sẽ thay bằng

ngày hiện tại (GETDATE()) để tiếp tục tính toán.

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/dc86c226-78b4-44b7-a1af-911e4696864a" />
     
              Xử lý dữ liệu NULL của cột NgayTra bằng cách thay thế bằng thời gian hiện tại để đảm bảo tính toán không bị gián đoạn.
      
 ## + Hàm do người dùng tự viết trong SQL thường mang mục đích gì? Nó có những loại nào? Mỗi loại thường được dùng khi nào? Tại sao có nhiều system function rồi mà vẫn cần tự viết fn riêng?
 
 ## Hàm do người dùng tự định nghĩa (User-Defined Functions – UDF)
 
a) Khái niệm và mục đích

+ Trong SQL Server, ngoài các hàm có sẵn, người dùng có thể tự xây dựng các hàm riêng nhằm phục vụ cho những yêu cầu xử lý dữ liệu đặc thù của hệ thống.

Về bản chất, UDF là một khối lệnh SQL có tên, nhận tham số đầu vào và trả về kết quả (dạng giá trị hoặc bảng).

Việc sử dụng UDF mang lại nhiều lợi ích:

Giúp chuẩn hóa logic xử lý (tránh viết lặp nhiều lần)

Làm cho câu lệnh SQL dễ đọc, rõ ràng hơn

Tăng khả năng tái sử dụng trong toàn bộ hệ thống

Hỗ trợ bảo trì và nâng cấp thuận tiện

+ Trong bài toán quản lý khách sạn, các nghiệp vụ như:

Tính tiền phòng

Truy xuất lịch sử đặt phòng

Thống kê hoạt động

đều rất phù hợp để triển khai dưới dạng UDF

b) Các loại hàm và cách sử dụng

Trong SQL Server, UDF được chia thành 3 nhóm chính:

 1. Scalar Function

Đây là loại hàm đơn giản nhất, trả về một giá trị duy nhất (kiểu số, chuỗi, ngày...).

+ Đặc điểm:

Có thể dùng trong SELECT như một cột

Thực hiện tính toán trên từng bản ghi

+ Khi sử dụng:

Khi cần xử lý logic tính toán độc lập

Ví dụ: tính tổng tiền của một lần đặt phòng

2. Inline Table-Valued Function (ITVF)

Đây là hàm trả về một tập kết quả dạng bảng, được xây dựng từ một câu lệnh SELECT duy nhất.

Đặc điểm:

Không sử dụng biến trung gian

Hiệu năng cao (gần giống VIEW nhưng linh hoạt hơn)

Khi sử dụng:

Khi cần truy vấn dữ liệu có điều kiện động

Ví dụ: danh sách lịch sử đặt phòng theo từng khách

3. Multi-statement Table-Valued Function (MSTVF)

Đây là loại hàm nâng cao, cũng trả về bảng nhưng cho phép xử lý nhiều bước logic bên trong.

Đặc điểm:

Sử dụng biến bảng (@Table)

Có thể dùng IF, UPDATE, vòng lặp

Khi sử dụng:

Khi bài toán cần xử lý nhiều bước hoặc điều kiện phức tạp

Ví dụ: báo cáo thống kê, phân loại dữ liệu

c) Vì sao vẫn cần UDF khi đã có Built-in Function?

Các hàm có sẵn (Built-in) như:

    DATEDIFF()
    GETDATE()
    ISNULL()

chỉ giải quyết các thao tác cơ bản, mang tính tổng quát.

Tuy nhiên, trong thực tế:

Mỗi hệ thống có quy tắc nghiệp vụ riêng

Các yêu cầu thường là kết hợp nhiều bước xử lý

Không thể biểu diễn bằng một hàm đơn lẻ

Ví dụ:

Built-in chỉ giúp tính số ngày

Nhưng:

Tổng tiền = số ngày × giá phòng
→ đây là logic nghiệp vụ → phải tự xây dựng hàm

Do đó, UDF được sử dụng để:

Đóng gói logic phức tạp thành một đơn vị độc lập
Tái sử dụng trong nhiều truy vấn
Đảm bảo tính nhất quán của hệ thống

  ## + Viết 01 Scalar Function (Hàm trả về một giá trị): Đưa ra 1 logic cho cơ sở dữ liệu của em, mà cần dùng đến function này. (SV TỰ NGHĨ RA YÊU CẦU CỦA HÀM VÀ VIẾT HÀM GIẢI QUYẾT NÓ). Sau khi đã có hàm, viết câu lệnh sql khai thác hàm đó.

- Scalar Function – Tính tiền phòng sau khi trừ tiền cọc
  
Ý tưởng (logic tự nghĩ )

Trong hệ thống khách sạn, ngoài việc tính tổng tiền phòng, cần xác định số tiền khách còn phải thanh toán sau khi đã trừ tiền đặt cọc.

Công thức:

Số tiền phải trả = (Số ngày ở × Giá phòng) – Tiền cọc

Luồng xử lý

Bước 1: Nhận vào MaDatPhong
Bước 2: Lấy dữ liệu:
Ngày nhận
Ngày trả (nếu NULL → lấy GETDATE)
Giá phòng
Tiền cọc
Bước 3: Tính số ngày ở (tối thiểu 1 ngày)
Bước 4: Tính tổng tiền
Bước 5: Trừ tiền cọc
Bước 6: Trả về kết quả

Code:

    CREATE FUNCTION fn_TienConLaiPhaiTra (@MaDatPhong INT)
    RETURNS MONEY
    AS
    BEGIN
    DECLARE @NgayNhan DATETIME
    DECLARE @NgayTra DATETIME
    DECLARE @GiaPhong MONEY
    DECLARE @TienCoc MONEY
    DECLARE @SoNgay INT
    DECLARE @TongTien MONEY
    DECLARE @ConLai MONEY

    -- Lấy dữ liệu
        SELECT 
        @NgayNhan = d.NgayNhan,
        @NgayTra = ISNULL(d.NgayTra, GETDATE()),
        @GiaPhong = p.GiaPhong,
        @TienCoc = d.TienCoc
        FROM DatPhong d
        JOIN Phong p ON d.MaPhong = p.MaPhong
        WHERE d.MaDatPhong = @MaDatPhong
    -- Tính số ngày (ít nhất 1 ngày)
        SET @SoNgay = DATEDIFF(DAY, @NgayNhan, @NgayTra)
        IF @SoNgay = 0 SET @SoNgay = 1
    -- Tính tổng tiền
        SET @TongTien = @SoNgay * @GiaPhong
    -- Trừ tiền cọc
        SET @ConLai = @TongTien - ISNULL(@TienCoc, 0)
        RETURN @ConLai
        END
        GO
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/c86103b3-970d-450d-8d8c-4ee83917bc0b" />
                                                       
                                                        Tạo hàm 
+ Khai thác hàm
  
-- Xem số tiền còn phải trả của từng đặt phòng

    SELECT 
    MaDatPhong,
    MaKhachHang,
    MaPhong,
    NgayNhan,
    NgayTra,
    TienCoc,
    dbo.fn_TienConLaiPhaiTra(MaDatPhong) AS TienConLai
    FROM DatPhong
    
<img width="1910" height="1079" alt="image" src="https://github.com/user-attachments/assets/9e2581cf-0da4-4e8b-94c7-fe7f82b2191f" />

        Hàm fn_TienConLaiPhaiTra được xây dựng để tính số tiền khách còn phải thanh toán sau khi đã trừ tiền đặt cọc. Hàm sử dụng DATEDIFF để tính số ngày ở và ISNULL để xử lý trường hợp khách chưa trả phòng hoặc chưa có tiền cọc.

  ## + Viết 01 Inline Table-Valued Function: Trả về danh sách các bản ghi theo một điều kiện lọc cụ thể (SV TỰ NGHĨ RA YÊU CẦU CỦA HÀM VÀ VIẾT HÀM GIẢI QUYẾT NÓ). Sau khi đã có hàm, viết câu lệnh sql khai thác hàm đó.

+ Inline Table-Valued Function – Danh sách khách hàng có đánh giá cao
  
Ý tưởng

Trong hệ thống khách sạn, cần xác định những khách hàng có mức đánh giá tốt để:

ưu tiên chăm sóc
áp dụng khuyến mãi

Vì vậy xây dựng hàm:

Trả về danh sách khách hàng có điểm đánh giá ≥ giá trị truyền vào

+ Luồng xử lý
Bước 1: Hàm nhận vào tham số @DiemToiThieu
Bước 2: Truy vấn bảng KhachHang
Bước 3: Lọc những khách có điểm ≥ điều kiện
Bước 4: Trả về danh sách kết quả
Code:

    CREATE FUNCTION fn_KhachHangDanhGiaCao (@DiemToiThieu INT)
    RETURNS TABLE
    AS
    RETURN
    (
    SELECT 
        MaKhachHang,
        TenKhachHang,
        SoDienThoai,
        DiemDanhGia
    FROM KhachHang
    WHERE DiemDanhGia >= @DiemToiThieu
    );
    GO
  
Khai thác hàm

      -- Lấy danh sách khách có đánh giá từ 4 trở lên
          SELECT * 
          FROM dbo.fn_KhachHangDanhGiaCao(4)
          ORDER BY DiemDanhGia DESC;
          
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/6d516c93-72ea-462a-b1d5-5196fbc8748f" />
                                
                                Tạo function fn_KhachHangDanhGiaCao thành công trong SQL Server
                                
Khai thác hàm

          -- Lấy danh sách khách có đánh giá từ 4 trở lên
            SELECT * 
            FROM dbo.fn_KhachHangDanhGiaCao(4)
            ORDER BY DiemDanhGia DESC;
            
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/62ccee8e-b3a3-477f-b6cd-4af55b63d1e1" />

      Hàm fn_KhachHangDanhGiaCao được sử dụng để lọc danh sách khách hàng dựa trên điểm đánh giá. Hàm nhận vào một ngưỡng điểm tối thiểu và trả về các khách hàng có điểm đánh giá lớn hơn hoặc bằng giá trị đó.

  ## + Viết 01 Multi-statement Table-Valued Function: Thực hiện xử lý logic phức tạp bên trong (có sử dụng biến bảng) trước khi trả về kết quả. (SV TỰ NGHĨ RA YÊU CẦU CỦA HÀM VÀ VIẾT HÀM GIẢI QUYẾT NÓ). Sau khi đã có hàm, viết câu lệnh sql khai thác hàm đó.

+ Multi-statement Table-Valued Function – Báo cáo doanh thu theo từng phòng
+ 
Ý tưởng

Ban quản lý khách sạn cần một báo cáo:

Mỗi phòng trong một tháng cụ thể tạo ra bao nhiêu doanh thu

Ngoài ra, cần phân loại hiệu quả kinh doanh của phòng:

Doanh thu ≥ 10 triệu → Hiệu quả cao
5 – <10 triệu → Trung bình
< 5 triệu → Hiệu quả thấp

Luồng xử lý
Bước 1: Nhận vào @Thang, @Nam
Bước 2: Tạo biến bảng để lưu kết quả
Bước 3: Lấy dữ liệu từ bảng Phong + DatPhong
Bước 4: Tính:
Số ngày ở
Doanh thu từng lượt
Bước 5: Cộng dồn doanh thu theo phòng
Bước 6: Dùng UPDATE để phân loại hiệu quả
Bước 7: Trả về bảng kết quả

Code
    CREATE FUNCTION fn_DoanhThuPhongTheoThang (
    @Thang INT,
    @Nam INT
    )
    RETURNS @BangKetQua TABLE (
    MaPhong VARCHAR(10),
    LoaiPhong NVARCHAR(50),
    TongDoanhThu MONEY,
    DanhGia NVARCHAR(50)
    )
    AS
    BEGIN
    -- Bước 1: Đưa dữ liệu doanh thu cơ bản vào bảng tạm
    INSERT INTO @BangKetQua (MaPhong, LoaiPhong, TongDoanhThu, DanhGia)
    SELECT 
        p.MaPhong,
        p.LoaiPhong,
        SUM(
            CASE 
                WHEN d.NgayTra IS NULL 
                    THEN DATEDIFF(DAY, d.NgayNhan, GETDATE()) * p.GiaPhong
                ELSE 
                    CASE 
                        WHEN DATEDIFF(DAY, d.NgayNhan, d.NgayTra) = 0 
                            THEN 1 * p.GiaPhong
                        ELSE DATEDIFF(DAY, d.NgayNhan, d.NgayTra) * p.GiaPhong
                    END
            END
        ) AS TongDoanhThu,
        N'Chưa phân loại'
    FROM Phong p
    LEFT JOIN DatPhong d 
        ON p.MaPhong = d.MaPhong
        AND MONTH(d.NgayNhan) = @Thang
        AND YEAR(d.NgayNhan) = @Nam
    GROUP BY p.MaPhong, p.LoaiPhong;

    -- Bước 2: Phân loại hiệu quả
    UPDATE @BangKetQua
    SET DanhGia = 
        CASE 
            WHEN TongDoanhThu >= 10000000 THEN N'Hiệu quả cao'
            WHEN TongDoanhThu >= 5000000 THEN N'Trung bình'
            ELSE N'Hiệu quả thấp'
        END;

    RETURN;
END;
GO

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/b1d289eb-6f8b-4a0c-9656-c5a80903a516" />
                   
                                    Tạo function báo cáo doanh thu và phân loại hiệu quả phòng
Khai thác hàm

-- Xem doanh thu phòng tháng 10 năm 2023
        SELECT * 
        FROM dbo.fn_DoanhThuPhongTheoThang(10, 2023)
        ORDER BY TongDoanhThu DESC;
        
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/63e237ba-bb43-4542-935a-a75e3b90af41" />
                
                              Kết quả truy vấn hàm fn_DoanhThuPhongTheoThang theo tháng và năm
                
### Phần 3: Xây dựng Store Procedure (Kiến thức 10) 

  ## + Trong SQL Server có những SP có sẵn nào? nêu 1 vài system sp mà em tìm hiểu được, giải thích cách dùng chúng.
Tổng quan về System Stored Procedures trong SQL Server

Trong SQL Server, System Stored Procedures (Các thủ tục lưu trữ hệ thống) là những tập lệnh SQL được biên dịch sẵn do chính Microsoft tạo ra. Chúng thường bắt đầu bằng tiền tố sp_ (viết tắt của system procedure).

Mục đích chính:

Quản trị hệ thống (System Administration).

Quản lý bảo mật (Security Management).

Lấy thông tin metadata về các đối tượng trong database (bảng, cột, kiểu dữ liệu...).

Bảo trì cơ sở dữ liệu.

Lưu ý quan trọng: Mặc dù các System SP được lưu trữ vật lý trong database ẩn tên là Resource, chúng xuất hiện một cách logic trong schema sys của mọi cơ sở dữ liệu. Bạn có thể thực thi chúng từ bất kỳ database nào.

Một số System SP tiêu biểu
1. sp_help – Xem cấu trúc bảng

Mục đích

Dùng để hiển thị toàn bộ thông tin của một bảng:

danh sách cột
kiểu dữ liệu
khóa chính (PK)
ràng buộc

Cách dùng

1. sp_help: Xem thông tin đối tượng
   
Mục đích: Giúp bạn xem toàn bộ cấu trúc của một đối tượng trong database (như Table, View, Stored Procedure, v.v.) mà không cần phải dùng giao diện click chuột rườm rà.

Cách dùng:

EXEC sp_help; (Không tham số): Liệt kê danh sách tất cả các đối tượng trong cơ sở dữ liệu hiện tại.

EXEC sp_help 'Tên_Bảng';: Trả về chi tiết các cột, kiểu dữ liệu, khóa chính (Primary Key), khóa ngoại (Foreign Key), và các Index có trên bảng đó
-- --------------------------------------------------------------------
PRINT '--- 1. sp_help: Xem thong tin doi tuong ---';

-- Tạo bảng tạm thời để thử nghiệm

      IF OBJECT_ID('TestHelpTable', 'U') IS NOT NULL DROP TABLE TestHelpTable;
      GO
      CREATE TABLE TestHelpTable (
      Id INT IDENTITY(1,1) PRIMARY KEY, 
     Name NVARCHAR(50)
      );
      GO

-- Chạy sp_help để phân tích cấu trúc bảng vừa tạo

      EXEC sp_help 'TestHelpTable';
      GO

-- Dọn dẹp

      DROP TABLE TestHelpTable;
      GO
      
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/df373f8a-0308-4921-8a34-21305c540461" />
                        
                                                  Hình ảnh ví dụ sp_help
2. sp_who2: Xem các session đang hoạt động
   
Mục đích: Dùng để theo dõi xem "Ai đang làm gì" trên server SQL. Nó hiển thị các luồng xử lý (process), người dùng nào đang kết nối, và máy tính nào đang gọi vào DB. Đặc biệt hữu ích để tìm ra lệnh nào đang bị "treo" hoặc gây tắc nghẽn (Block).

Cách dùng:

EXEC sp_who2;: Hiển thị toàn bộ các kết nối (kể cả kết nối đang ngủ - sleeping).

EXEC sp_who2 'active';: Chỉ hiển thị các kết nối đang thực thi truy vấn. Nếu bạn thấy cột BlkBy (Blocked By) có chứa số, tức là tiến trình đó đang bị khóa bởi một tiến trình khác có mã số (SPID) tương ứng.
-- --------------------------------------------------------------------
PRINT '--- 2. sp_who2: Xem cac session dang hoat dong ---';

-- Xem tất cả session, tài nguyên sử dụng, trạng thái block
EXEC sp_who2;

-- Lọc chỉ xem các session đang "active"
      EXEC sp_who2 'active';
      GO
      
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/f6a9236a-8c88-4d23-ab76-541a0fbe39ef" />

                                Hình ảnh ví dụ sp_who2

3. sp_spaceused: Kiểm tra dung lượng
   
Mục đích: Kiểm tra xem dữ liệu đang chiếm bao nhiêu dung lượng trên ổ cứng để có kế hoạch dọn dẹp hoặc nâng cấp.

Cách dùng:

EXEC sp_spaceused;: Cho bạn biết tổng dung lượng của toàn bộ Database hiện tại là bao nhiêu, và còn trống bao nhiêu MB.

EXEC sp_spaceused 'Tên_Bảng';: Cho bạn biết bảng đó có tổng cộng bao nhiêu dòng (rows), dung lượng phần data thực tế là bao nhiêu và dung lượng của các Index trên bảng đó chiếm bao nhiêu.
-- --------------------------------------------------------------------
PRINT '--- 3. sp_spaceused: Kiem tra dung luong ---';

-- Xem dung lượng của toàn bộ Database hiện tại
      EXEC sp_spaceused;
      GO

-- Tạo bảng tạm và chèn dữ liệu để kiểm tra dung lượng bảng
      IF OBJECT_ID('TestSpaceTable', 'U') IS NOT NULL DROP TABLE TestSpaceTable;
      GO
      CREATE TABLE TestSpaceTable (Id INT, Data NVARCHAR(MAX));
      INSERT INTO TestSpaceTable (Id, Data) VALUES (1, 'Some test data');
      GO

-- Xem kích thước và số dòng của bảng TestSpaceTable
      EXEC sp_spaceused 'TestSpaceTable';
      GO
      
-- Dọn dẹp
      DROP TABLE TestSpaceTable;
      GO
      
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/645cb124-cbca-41b7-b38d-7c2baa12376b" />

                                        Hình ảnh ví dụ sp_spaceused
                                        
4. sp_helptext: Xem mã nguồn (source code)
   
Mục đích: Khi bạn muốn đọc code bên trong của một đối tượng có chứa logic (như View, Stored Procedure, Trigger, Function) do người khác viết để hiểu cách nó hoạt động.

Cách dùng:

EXEC sp_helptext 'Tên_Procedure_Hoac_View';: Lệnh này sẽ in ra toàn bộ đoạn code T-SQL nguyên gốc đã được dùng để tạo ra đối tượng đó. (Lưu ý: Không dùng được với Table, và không xem được nếu lúc tạo người viết đã dùng tùy chọn WITH ENCRYPTION để mã hóa bảo mật).
-- --------------------------------------------------------------------
PRINT '--- 4. sp_helptext: Xem ma nguon (source code) ---';

-- Tạo một Stored Procedure mẫu
        IF OBJECT_ID('usp_DummySP', 'P') IS NOT NULL DROP PROCEDURE usp_DummySP;
        GO
        CREATE PROCEDURE usp_DummySP
        AS
        BEGIN
    -- Đây là nội dung của SP mẫu
        SELECT GETDATE() AS CurrentDateTime;
        END;
        GO

-- Chạy sp_helptext để xem lại mã nguồn của SP vừa tạo
        EXEC sp_helptext 'usp_DummySP';
        GO

-- Dọn dẹp
        DROP PROCEDURE usp_DummySP;
         GO
         
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/99178d91-9d49-41e8-aa31-84f2b49567e2" />

                                Hình ảnh ví dụ sp_helptext
                                
  ## + Viết 01 Store Procedure đơn giản để thực hiện lệnh INSERT hoặc UPDATE dữ liệu, có kiểm tra điều kiện logic (SV TỰ NGHĨ RA YÊU CẦU CỦA SP VÀ VIẾT SP GIẢI QUYẾT NÓ)
  
Tên thủ tục: usp_DatPhong

Nghiệp vụ áp dụng: Quản lý thao tác Đặt phòng / Thuê phòng.

Ý tưởng logic:

Thủ tục nhận vào các thông tin đặt phòng cơ bản: Mã khách hàng, Mã phòng, Ngày nhận và Ngày trả.

Kiểm tra tính hợp lệ (Validation): Trước khi thao tác với dữ liệu, SP thực hiện 2 kiểm tra:

Logic thời gian: Ngày trả phòng bắt buộc phải lớn hơn (sau) ngày nhận phòng.

Logic trạng thái: Tra cứu bảng Phong để đảm bảo căn phòng khách chọn đang ở trạng thái "Trống" (chưa bị người khác thuê).

Thực thi lệnh: Nếu thỏa mãn các điều kiện trên, hệ thống sử dụng khối Transaction (BEGIN TRAN... COMMIT TRAN) để đảm bảo tính toàn vẹn dữ liệu khi thực hiện đồng thời 2 việc:

INSERT: Thêm một bản ghi mới vào bảng DatPhong để lưu lại lịch sử thuê.

UPDATE: Cập nhật cột TrangThai của bảng Phong thành "Đã thuê" để khóa phòng, không cho người khác đặt trùng.'

 BÀI TẬP: QUẢN LÝ KHÁCH SẠN
-- ====================================================================

-- 1. TẠO CÁC BẢNG DỮ LIỆU
          IF OBJECT_ID('DatPhong', 'U') IS NOT NULL DROP TABLE DatPhong;
          IF OBJECT_ID('Phong', 'U') IS NOT NULL DROP TABLE Phong;
          IF OBJECT_ID('KhachHang', 'U') IS NOT NULL DROP TABLE KhachHang;
          GO

-- Bảng thông tin Khách hàng
          CREATE TABLE KhachHang (
          MaKH VARCHAR(10) PRIMARY KEY,
          TenKH NVARCHAR(100) NOT NULL,
          SoDienThoai VARCHAR(15)
          );

-- Bảng thông tin Phòng
          CREATE TABLE Phong (
          MaPhong VARCHAR(10) PRIMARY KEY,
          LoaiPhong NVARCHAR(50),
          GiaPhong DECIMAL(18,2),
          TrangThai NVARCHAR(20) DEFAULT N'Trống' -- Các trạng thái: 'Trống' hoặc 'Đã thuê'
          );

-- Bảng thông tin Đặt phòng
    CREATE TABLE DatPhong (
    MaDatPhong INT IDENTITY(1,1) PRIMARY KEY,
    MaKH VARCHAR(10),
    MaPhong VARCHAR(10),
    NgayNhan DATE,
    NgayTra DATE,
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),
    FOREIGN KEY (MaPhong) REFERENCES Phong(MaPhong)
    );
    GO

-- Thêm dữ liệu mẫu ban đầu

    INSERT INTO KhachHang VALUES 
    ('KH01', N'Nguyễn Văn A', '0901234567'), 
    ('KH02', N'Trần Thị B', '0912345678');

    INSERT INTO Phong VALUES 
    ('P101', N'Tiêu chuẩn', 500000, N'Trống'), 
    ('P102', N'VIP', 1200000, N'Trống'),
    ('P103', N'Gia đình', 800000, N'Trống');
     GO
     
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/5abb0f3e-deb3-401a-ae66-90480e956a3b" />
          
                    Mã nguồn và kết quả thực thi tạo cấu trúc bảng, thêm dữ liệu mẫu cho hệ thống Quản lý khách sạn.

-- YÊU CẦU 2: SP THỰC HIỆN INSERT HOẶC UPDATE CÓ KIỂM TRA LOGIC
-- Nghiệp vụ: Đặt phòng.
-- Logic: Kiểm tra phòng trống & Ngày trả phải lớn hơn ngày nhận.
-- Action: INSERT thông tin thuê và UPDATE trạng thái phòng.
-- ====================================================================
      IF OBJECT_ID('usp_DatPhong', 'P') IS NOT NULL DROP PROCEDURE usp_DatPhong;
      GO
      CREATE PROCEDURE usp_DatPhong
    @MaKH VARCHAR(10),
    @MaPhong VARCHAR(10),
    @NgayNhan DATE,
    @NgayTra DATE
      AS
      BEGIN
    -- Kiểm tra logic 1: Ngày trả phải sau ngày nhận
    IF @NgayTra <= @NgayNhan
    BEGIN
        PRINT N'⛔ LỖI: Ngày trả phòng phải lớn hơn ngày nhận phòng!';
        RETURN;
    END

    -- Kiểm tra logic 2: Tình trạng phòng có đang trống không
    DECLARE @TrangThai NVARCHAR(20);
    SELECT @TrangThai = TrangThai FROM Phong WHERE MaPhong = @MaPhong;

    IF @TrangThai = N'Đã thuê'
    BEGIN
        PRINT N'⛔ LỖI: Phòng ' + @MaPhong + N' hiện đã có người thuê!';
        RETURN;
    END

    -- Nếu hợp lệ: Tiến hành Đặt phòng (INSERT) và Cập nhật trạng thái (UPDATE)
    BEGIN TRAN;
    BEGIN TRY
        -- Ghi nhận lịch sử đặt phòng
        INSERT INTO DatPhong (MaKH, MaPhong, NgayNhan, NgayTra)
        VALUES (@MaKH, @MaPhong, @NgayNhan, @NgayTra);

        -- Khóa phòng lại (chuyển trạng thái)
        UPDATE Phong
        SET TrangThai = N'Đã thuê'
        WHERE MaPhong = @MaPhong;

        COMMIT TRAN;
        PRINT N' THÀNH CÔNG: Khách hàng ' + @MaKH + N' đã đặt phòng ' + @MaPhong + N' thành công!';
        END TRY
        BEGIN CATCH
        ROLLBACK TRAN;
        PRINT N' LỖI HỆ THỐNG: Không thể hoàn tất thao tác đặt phòng.';
        END CATCH
        END;
        GO
        
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/12c4a550-eb1c-4c94-a0ab-9ce8811da61d" />
                  
                            Đoạn lệnh tạo thủ tục xử lý lệnh INSERT/UPDATE có kèm theo bẫy lỗi logic.
        
  ## + Viết 01 Store Procedure có sử dụng tham số OUTPUT để trả về một giá trị tính toán (SV TỰ NGHĨ RA YÊU CẦU CỦA SP VÀ VIẾT SP GIẢI QUYẾT NÓ, SP NÀY CÓ DÙNG THAM SỐ LOẠI OUTPUT)
  
====================================================================

-- YÊU CẦU 3: SP SỬ DỤNG THAM SỐ OUTPUT ĐỂ TRẢ VỀ GIÁ TRỊ TÍNH TOÁN

-- Nghiệp vụ: Tính tổng tiền thanh toán cho một lượt đặt phòng.

-- ====================================================================


          IF OBJECT_ID('usp_TinhTienThanhToan', 'P') IS NOT NULL DROP PROCEDURE usp_TinhTienThanhToan;
          GO
          CREATE PROCEDURE usp_TinhTienThanhToan
          @MaDatPhong INT,
          @TongTien DECIMAL(18,2) OUTPUT -- <=== Khai báo tham số đầu ra (OUTPUT)
          AS
          BEGIN
    -- Công thức: Tổng tiền = (Số ngày thuê) * (Giá phòng)
    -- Dùng hàm DATEDIFF để đếm số ngày giữa ngày nhận và ngày trả
          SELECT @TongTien = DATEDIFF(DAY, dp.NgayNhan, dp.NgayTra) * p.GiaPhong
          FROM DatPhong dp
          JOIN Phong p ON dp.MaPhong = p.MaPhong
           WHERE dp.MaDatPhong = @MaDatPhong;
    -- Nếu khách trả trong ngày (DATEDIFF = 0), tính tròn 1 ngày
          IF @TongTien = 0
          BEGIN
         SELECT @TongTien = p.GiaPhong
         FROM DatPhong dp JOIN Phong p ON dp.MaPhong = p.MaPhong
         WHERE dp.MaDatPhong = @MaDatPhong;
        END
         IF @TongTien IS NULL SET @TongTien = 0;
        END;
        GO

<img width="1914" height="1079" alt="image" src="https://github.com/user-attachments/assets/87981b94-0392-4e62-af18-936c02b49a0b" />
                 
                              Khởi tạo thủ tục tính tổng tiền phòng có sử dụng tham số đầu ra (OUTPUT).

  ## + Viết 01 Store Procedure trả về một tập kết quả (Result set) từ lệnh SELECT sau khi đã join nhiều bảng. (SV TỰ NGHĨ RA YÊU CẦU CỦA SP VÀ VIẾT SP GIẢI QUYẾT NÓ)
 ====================================================================
-- YÊU CẦU 4: SP TRẢ VỀ RESULT SET SAU KHI JOIN NHIỀU BẢNG
-- Nghiệp vụ: Tra cứu lịch sử thuê phòng chi tiết của khách hàng.
-- ====================================================================
            IF OBJECT_ID('usp_ChiTietLichSuDatPhong', 'P') IS NOT NULL DROP PROCEDURE usp_ChiTietLichSuDatPhong;
            GO
            CREATE PROCEDURE usp_ChiTietLichSuDatPhong
            @MaKH VARCHAR(10)
            AS
            BEGIN
    -- Lệnh SELECT kết hợp JOIN 3 bảng: DatPhong, KhachHang, Phong
            SELECT 
        dp.MaDatPhong AS [Mã Đơn],
        kh.TenKH AS [Tên Khách Hàng],
        kh.SoDienThoai AS [SĐT],
        p.MaPhong AS [Phòng],
        p.LoaiPhong AS [Loại Phòng],
        dp.NgayNhan AS [Ngày Nhận],
        dp.NgayTra AS [Ngày Trả],
        p.GiaPhong AS [Đơn Giá/Ngày]
        FROM DatPhong dp
        JOIN KhachHang kh ON dp.MaKH = kh.MaKH
        JOIN Phong p ON dp.MaPhong = p.MaPhong
        WHERE kh.MaKH = @MaKH
        ORDER BY dp.NgayNhan DESC;
        END;
        GO
        
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/f3a2d646-ede6-4ca9-acd6-6aa3fb2994b3" />

                  Khởi tạo thủ tục tra cứu lịch sử đặt phòng bằng cách sử dụng lệnh SELECT kết hợp JOIN 3 bảng dữ liệu.
            
-- ====================================================================
-- CHẠY THỬ NGHIỆM TỔNG HỢP (TEST CASES)
-- ====================================================================

          PRINT '--- 1. TEST YÊU CẦU 2 (INSERT/UPDATE LOGIC) ---';
-- Trường hợp Lỗi Logic: Ngày trả nhỏ hơn ngày nhận
        EXEC usp_DatPhong @MaKH = 'KH01', @MaPhong = 'P101', @NgayNhan = '2023-10-05', @NgayTra = '2023-10-01';

-- Trường hợp Hợp lệ: Đặt phòng P101 trong 4 ngày
        EXEC usp_DatPhong @MaKH = 'KH01', @MaPhong = 'P101', @NgayNhan = '2023-10-01', @NgayTra = '2023-10-05';

-- Trường hợp Lỗi Logic: P101 hiện đã bị KH01 thuê (Trạng thái = Đã thuê), KH02 không thể thuê tiếp
        EXEC usp_DatPhong @MaKH = 'KH02', @MaPhong = 'P101', @NgayNhan = '2023-10-02', @NgayTra = '2023-10-06';

        PRINT '';
        PRINT '--- 2. TEST YÊU CẦU 3 (THAM SỐ OUTPUT) ---';
        DECLARE @TienThanhToan DECIMAL(18,2); -- Tạo biến để hứng giá trị
-- Tính tiền cho Mã đặt phòng số 1 (Của KH01 vừa thuê 4 ngày, phòng P101 giá 500k/ngày)
        EXEC usp_TinhTienThanhToan @MaDatPhong = 1, @TongTien = @TienThanhToan OUTPUT; 
        PRINT N'>> Tổng tiền phòng tính toán được là: ' + FORMAT(@TienThanhToan, 'N0') + N' VNĐ';
        PRINT '';
        PRINT '--- 3. TEST YÊU CẦU 4 (JOIN RESULT SET) ---';
-- Trích xuất lịch sử chi tiết (Result set bảng) cho khách hàng KH01
        EXEC usp_ChiTietLichSuDatPhong @MaKH = 'KH01';
        GO
        
  <img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/76c4264e-de7e-438f-b431-01ddc5dffd35" />
        
                    Giao diện thực thi Test Cases và hiển thị bảng kết quả (Result set) tra cứu lịch sử đặt phòng chi tiết.
 
### Phần 4: Trigger và Xử lý logic nghiệp vụ (Kiến thức 11)

Bài Toán: "Hệ Thống Tự Động Cập Nhật Thống Kê Phòng Khách Sạn Sử Dụng Trigger"

Mô tả bài toánKhách sạn cần quản lý việc đặt phòng hàng ngày. Mỗi khi nhân viên thao tác trên bảng đặt phòng, hệ thống phải tự động cập nhật bảng thống kê mà không cần nhân viên làm thủ công.

- PHẦN 1: Trigger Một Chiều

"Tự Động Cập Nhật Thống Kê Khi Có Biến Động Đặt Phòng"

Bước 1 — Khởi Tạo Cơ Sở Dữ Liệu Khách Sạn

          sqlCREATE DATABASE QuanLyKhachSan;
          GO
          USE QuanLyKhachSan;
          GO

<img width="1918" height="1079" alt="image" src="https://github.com/user-attachments/assets/5df16a3b-c80a-40ba-bbe7-40df86fbaf87" />
                             
                                Bước 1 — Khởi Tạo Cơ Sở Dữ Liệu Khách Sạn Thành Công
                                
Bước 2 — Xây Dựng Bảng Đặt Phòng (Bảng A) và Bảng Thống Kê Phòng (Bảng B)

      USE QuanLyKhachSan;
      GO

-- Bảng A: Lưu thông tin đặt phòng hàng ngày
      CREATE TABLE DATPHONG (
      MaDatPhong    INT PRIMARY KEY IDENTITY(1,1),
      MaPhong       INT NOT NULL,
      MaKhachHang   INT NOT NULL,
      NgayNhanPhong DATE NOT NULL,
      NgayTraPhong  DATE NOT NULL,
      TrangThai     NVARCHAR(50) DEFAULT N'Chờ xác nhận',
      TongTien      DECIMAL(18,2) DEFAULT 0
      );

-- Bảng B: Lưu thống kê tổng hợp theo từng phòng
      CREATE TABLE THONGKE_PHONG (
      MaPhong        INT PRIMARY KEY,
      TongLuotDat    INT DEFAULT 0,
      TongDoanhThu   DECIMAL(18,2) DEFAULT 0,
      TrangThaiPhong NVARCHAR(50) DEFAULT N'Trống',
      LanCapNhatCuoi DATETIME DEFAULT GETDATE()
      );
      
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/ba097582-efa3-42b6-9c5b-f4b0a877336b" />
                  
                    Bước 2 — Xây Dựng Bảng Đặt Phòng (Bảng A) và Bảng Thống Kê Phòng (Bảng B) Thành Công

Bước 3 — Nhập Danh Sách Phòng Ban Đầu Vào Bảng Thống Kê

        USE QuanLyKhachSan;
        GO
        INSERT INTO THONGKE_PHONG (MaPhong) VALUES (101);
        INSERT INTO THONGKE_PHONG (MaPhong) VALUES (102);
        INSERT INTO THONGKE_PHONG (MaPhong) VALUES (103);

-- Kiểm tra
        SELECT * FROM THONGKE_PHONG;

<img width="1918" height="1079" alt="image" src="https://github.com/user-attachments/assets/4bfebfcd-7833-4fac-9f1d-6b069f78ad78" />
                     
                                  Bước 3 — Nhập Danh Sách Phòng Ban Đầu Vào Bảng Thống Kê Thành Công

+ Bước 4 — Tạo Trigger Tự Động Cập Nhật Thống Kê Khi Bảng Đặt Phòng Thay Đổi
  
          USE QuanLyKhachSan;
          GO
          CREATE TRIGGER trg_CapNhatThongKePhong
          ON DATPHONG
          AFTER INSERT, UPDATE, DELETE
          AS
          BEGIN
          SET NOCOUNT ON;
          DECLARE @DanhSachPhong TABLE (MaPhong INT);
          INSERT INTO @DanhSachPhong
          SELECT MaPhong FROM inserted
          UNION
          SELECT MaPhong FROM deleted;
          UPDATE tk
          SET
          tk.TongLuotDat = (
            SELECT COUNT(*)
            FROM DATPHONG dp
            WHERE dp.MaPhong = tk.MaPhong
        ),
        tk.TongDoanhThu = (
            SELECT ISNULL(SUM(dp.TongTien), 0)
            FROM DATPHONG dp
            WHERE dp.MaPhong = tk.MaPhong
              AND dp.TrangThai = N'Đã thanh toán'
        ),
        tk.TrangThaiPhong = CASE
            WHEN EXISTS (
                SELECT 1 FROM DATPHONG dp
                WHERE dp.MaPhong = tk.MaPhong
                  AND dp.TrangThai = N'Đang ở'
            ) THEN N'Đang có khách'
            WHEN EXISTS (
                SELECT 1 FROM DATPHONG dp
                WHERE dp.MaPhong = tk.MaPhong
                  AND dp.TrangThai = N'Chờ xác nhận'
                  AND dp.NgayNhanPhong = CAST(GETDATE() AS DATE)
            ) THEN N'Chờ nhận phòng'
            ELSE N'Trống'
            END,
            tk.LanCapNhatCuoi = GETDATE()
            FROM THONGKE_PHONG tk
            WHERE tk.MaPhong IN (SELECT MaPhong FROM @DanhSachPhong);
             PRINT N'[Trigger] Bảng thống kê đã được cập nhật tự động!';
            END;
            GO

<img width="1919" height="1079" alt="Screenshot 2026-05-03 143042" src="https://github.com/user-attachments/assets/5928227d-7084-4982-b372-7699944a49e7" />

                              Bước 4 — Tạo Trigger Tự Động Cập Nhật Thống Kê Khi Bảng Đặt Phòng Thay Đổi Thành Công
                
+ Bước 5 — Kiểm Tra Trigger Hoạt Động Đúng Hay Không
  
          USE QuanLyKhachSan;
          GO

-- Xem bảng B trước khi thêm đặt phòng
          PRINT N'=== BẢNG THỐNG KÊ TRƯỚC KHI ĐẶT PHÒNG ===';
          SELECT * FROM THONGKE_PHONG;

-- Nhân viên thêm đặt phòng mới (khách đang ở)
          INSERT INTO DATPHONG (MaPhong, MaKhachHang, NgayNhanPhong, NgayTraPhong, TrangThai, TongTien)
          VALUES (101, 1, '2025-06-01', '2025-06-03', N'Đang ở', 1500000);
          PRINT N'=== BẢNG THỐNG KÊ SAU KHI THÊM KHÁCH ĐANG Ở ===';
          SELECT * FROM THONGKE_PHONG WHERE MaPhong = 101;
          
-- Kết quả mong đợi: TongLuotDat = 1, TrangThaiPhong = 'Đang có khách'

-- Thêm đặt phòng đã thanh toán

          INSERT INTO DATPHONG (MaPhong, MaKhachHang, NgayNhanPhong, NgayTraPhong, TrangThai, TongTien)
          VALUES (101, 2, '2025-06-10', '2025-06-12', N'Đã thanh toán', 2000000);
          PRINT N'=== BẢNG THỐNG KÊ SAU KHI THÊM KHÁCH ĐÃ THANH TOÁN ===';
          SELECT * FROM THONGKE_PHONG WHERE MaPhong = 101;
-- Kết quả mong đợi: TongLuotDat = 2, TongDoanhThu = 2000000

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/1693c3e2-60c6-4574-b43c-503d7fe8c6b0" />
          
                  Bước 5 — Kiểm Tra Trigger Một Chiều Hoạt Động Đúng: Bảng Thống Kê Tự Động Cập Nhật Khi Có Đặt Phòng Mới
          
PHẦN 2: Trigger Vòng

Quan Sát Hiện Tượng Trigger Kích Hoạt Lẫn Nhau Giữa Hai Bảng

Bước 6 — Dọn Dẹp Trigger Cũ 
        GO
        DROP TRIGGER IF EXISTS trg_CapNhatThongKePhong;
        GO
        PRINT N'Đã xóa trigger cũ, sẵn sàng tạo trigger vòng!';
        
<img width="1919" height="1076" alt="image" src="https://github.com/user-attachments/assets/0fcd6904-60b8-4c8b-8417-16c58e611430" />
                  
                                Bước 6 — Dọn Dẹp Trigger Cũ Trước Khi Thử Nghiệm Trigger Vòng Thành Công
                  
Bước 7 — Tạo Trigger Trên Bảng A: Khi Có Đặt Phòng Mới Thì Cập Nhật Bảng Thống Kê

          USE QuanLyKhachSan;
          GO
          CREATE TRIGGER trg_A_Insert_CapNhat_B
          ON DATPHONG
          AFTER INSERT
          AS
          BEGIN
          SET NOCOUNT ON;
          PRINT N'[Trigger A] Phat hien dat phong moi → Dang cap nhat bang thong ke (B)...';
          UPDATE THONGKE_PHONG
          SET
          TongLuotDat    = TongLuotDat + 1,
          LanCapNhatCuoi = GETDATE()
          WHERE MaPhong IN (SELECT MaPhong FROM inserted);
          PRINT N'[Trigger A] Hoan tat cap nhat bang thong ke!';
          END;
          GO
          
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/84634b00-8ac5-4e2c-9acb-8efcda294f1e" />
        
                        Bước 7 — Tạo Trigger Trên Bảng A: Khi Có Đặt Phòng Mới Thì Tự Động Cập Nhật Bảng Thống Kê Thành Công
          
Bước 8 — Tạo Trigger Trên Bảng B: Khi Thống Kê Thay Đổi Thì Xác Nhận Lại Trạng Thái Đặt Phòng

        USE QuanLyKhachSan;
        GO
        CREATE TRIGGER trg_B_Update_CapNhat_A
        ON THONGKE_PHONG
        AFTER UPDATE
        AS
        BEGIN
        SET NOCOUNT ON;
        PRINT N'[Trigger B] Phat hien thong ke thay doi → Dang xac nhan lai trang thai dat phong (A)...';
        
    -- Điều kiện dừng quan trọng: chỉ cập nhật đặt phòng còn "Chờ xác nhận"
        UPDATE DATPHONG
        SET TrangThai = N'Đã xác nhận hệ thống'
        WHERE MaPhong IN (SELECT MaPhong FROM inserted)
        AND TrangThai = N'Chờ xác nhận';
        PRINT N'[Trigger B] Hoan tat xac nhan trang thai dat phong!';
        END;
        GO
        
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/12ba356c-d2a4-4a18-9d4c-1945dd2b8030" />
        
                    Bước 8 — Tạo Trigger Trên Bảng B: Khi Thống Kê Thay Đổi Thì Tự Động Xác Nhận Lại Trạng Thái Đặt Phòng Thành Công
        
Bước 9 — Kích Hoạt Trigger Vòng và Quan Sát Thứ Tự Thực Thi

        USE QuanLyKhachSan;
        GO
        
-- Xem dữ liệu TRƯỚC khi INSERT

        PRINT N'=== TRUOC KHI INSERT ===';
        SELECT MaDatPhong, MaPhong, TrangThai 
        FROM DATPHONG 
        WHERE MaPhong = 102;
        SELECT MaPhong, TongLuotDat, LanCapNhatCuoi 
        FROM THONGKE_PHONG 
        WHERE MaPhong = 102;
        
-- Hành động này kích hoạt chuỗi trigger vòng

        INSERT INTO DATPHONG (MaPhong, MaKhachHang, NgayNhanPhong, NgayTraPhong, TrangThai, TongTien)
        VALUES (102, 3, '2025-06-15', '2025-06-17', N'Chờ xác nhận', 1800000);
        
-- Xem dữ liệu SAU khi INSERT

        PRINT N'=== SAU KHI INSERT ===';
        SELECT MaDatPhong, MaPhong, TrangThai 
        FROM DATPHONG 
        WHERE MaPhong = 102;
        SELECT MaPhong, TongLuotDat, LanCapNhatCuoi 
        FROM THONGKE_PHONG 
        WHERE MaPhong = 102;
        
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/77a9448b-eb64-4763-ab45-fbd44b848d1e" />
          
                 Bước 9 — Kích Hoạt Trigger Vòng và Quan Sát Kết Quả: Cả Hai Bảng Tự Động Cập Nhật Lẫn Nhau Thành Công
                 
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/9b43abca-ed16-4921-9ecc-1824e4eebde2" />
                               
                                        Kết quả xem ở Messenger
                                  
Bước 10 — Kiểm Tra Kết Quả Sau Trigger Vòng

          USE QuanLyKhachSan;
          GO
-- Kiểm tra bảng A: TrangThai đã đổi chưa?

      PRINT N'=== KIEM TRA BANG A (DATPHONG) ===';
      SELECT 
      MaDatPhong,
      MaPhong,
      TrangThai,          -- Mong đợi: "Đã xác nhận hệ thống"
      TongTien
      FROM DATPHONG
      WHERE MaPhong = 102;
      
-- Kiểm tra bảng B: TongLuotDat đã tăng chưa?
      PRINT N'=== KIEM TRA BANG B (THONGKE_PHONG) ===';
      SELECT 
      MaPhong,
      TongLuotDat,        -- Mong đợi: tăng lên 1
      LanCapNhatCuoi      -- Mong đợi: thời điểm vừa chạy
      FROM THONGKE_PHONG
      WHERE MaPhong = 102;
      
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/74579056-77c6-4156-99c0-1826e615031f" />
                
                            Bước 10 — Kiểm Tra Kết Quả Sau Trigger Vòng: Cả Hai Bảng Đã Được Cập Nhật Đúng

Bước 11 — Kiểm Tra Giới Hạn An Toàn Của Hệ Thống

      USE QuanLyKhachSan
      GO
      SELECT
      name                    AS TenDatabase,
      is_recursive_triggers_on AS TriggerDequyDangBat
        FROM sys.databases
      WHERE name = 'QuanLyKhachSan';
-- 0 = TẮT = An toàn
-- 1 = BẬT = Nguy hiểm 

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/3b1d029a-5f3b-4166-a49f-68cea89a20aa" />
                 
                      Bước 11 — Kiểm Tra Giới Hạn An Toàn Của Hệ Thống: Cấu Hình Recursive Trigger
                      
- Nhận Xét Cuối Cùng Về Tình Trạng Trigger Vòng
  
+ Điều gì xảy ra nếu KHÔNG có điều kiện dừng?
+ 
-- Ví dụ trigger B nguy hiểm (KHÔNG có điều kiện dừng)
  
      UPDATE DATPHONG
      SET TongTien = TongTien + 1        -- Cập nhật vô điều kiện
      WHERE MaPhong IN (SELECT MaPhong FROM inserted);
  
-- Hậu quả:

            -- INSERT A → Trigger A → UPDATE B → Trigger B → UPDATE A
--          → Trigger A → UPDATE B → Trigger B → UPDATE A
--          → ... lặp mãi đến cấp 32
--          → SQL Server báo lỗi và ROLLBACK 

Kết luận:

Trigger vòng giữa 2 bảng hoạt động an toàn trong bài toán này vì Trigger B chỉ cập nhật những đặt phòng còn trạng thái "Chờ xác nhận". Sau khi cập nhật xong, điều kiện không còn thỏa mãn nên chuỗi trigger tự dừng lại. Trong thực tế, lập trình viên cần luôn thiết kế điều kiện dừng rõ ràng khi dùng trigger vòng, nếu không hệ thống sẽ bị lỗi nghiêm trọng và mất toàn bộ dữ liệu của transaction đó.

### Phần 5: Cursor và Duyệt dữ liệu 

Setup dữ liệu mẫu
      sql-- Tạo bảng
      CREATE TABLE Phong (
      MaPhong     INT PRIMARY KEY,
      LoaiPhong   NVARCHAR(50),
      GiaPhong    FLOAT,
      TrangThai   NVARCHAR(20)  -- 'Trống', 'Đã đặt', 'Đang dùng'
      );
      CREATE TABLE KhachHang (
      MaKH        INT PRIMARY KEY,
      HoTen       NVARCHAR(100),
      CCCD        NVARCHAR(20),
      SoDienThoai NVARCHAR(15)
      );
    CREATE TABLE DatPhong (
    MaDatPhong  INT PRIMARY KEY IDENTITY(1,1),
    MaKH        INT FOREIGN KEY REFERENCES KhachHang(MaKH),
    MaPhong     INT FOREIGN KEY REFERENCES Phong(MaPhong),
    NgayNhanPhong DATE,
    NgayTraPhong  DATE,
    TongTien    FLOAT,
    TrangThai   NVARCHAR(20)  -- 'Đang ở', 'Đã trả', 'Đã hủy'
    );

-- Dữ liệu mẫu
    INSERT INTO Phong VALUES
    (101, N'Phòng đơn',   500000,  N'Đang dùng'),
    (102, N'Phòng đôi',   800000,  N'Đang dùng'),
    (103, N'Phòng VIP',   1500000, N'Đang dùng'),
    (104, N'Phòng đơn',   500000,  N'Trống'),
    (105, N'Phòng đôi',   800000,  N'Đang dùng'),
    (106, N'Phòng VIP',   1500000, N'Trống');
      INSERT INTO KhachHang VALUES
      (1, N'Nguyễn Văn An',   '001234567890', '0901111111'),
      (2, N'Trần Thị Bình',   '001234567891', '0902222222'),
      (3, N'Lê Văn Cường',    '001234567892', '0903333333'),
      (4, N'Phạm Thị Dung',   '001234567893', '0904444444'),
      (5, N'Hoàng Văn Em',    '001234567894', '0905555555');

    INSERT INTO DatPhong (MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, TongTien, TrangThai) VALUES
    (1, 101, '2025-04-25', '2025-04-28', 1500000, N'Đang ở'),
    (2, 102, '2025-04-26', '2025-04-30', 3200000, N'Đang ở'),
    (3, 103, '2025-04-27', '2025-05-01', 6000000, N'Đang ở'),
    (4, 105, '2025-04-28', '2025-05-02', 3200000, N'Đang ở'),
    (5, 101, '2025-03-01', '2025-03-03', 1000000, N'Đã trả'),
    (1, 102, '2025-03-10', '2025-03-12', 1600000, N'Đã trả');

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/7b78de32-ef12-4276-b88d-5ba695438b78" />
                      
                                                  Setup dữ liệu mẫu
                        
## + Viết một đoạn script sử dụng CURSOR để duyệt qua danh sách của 1 câu lệnh SQL dạng SELECT, duyệt qua từng bản ghi, xử lý riêng từng bản ghi (THEO LOGIC SV TỰ ĐẶT RA: SAO CHO HỢP LÝ VÀ THUYẾT PHỤC)

Yêu cầu 1 — CURSOR duyệt từng đơn đặt phòng & tính tiền

Bài toán: Duyệt các đơn đặt phòng đang "Đang ở", tính số ngày ở × GiaNgay, rồi cập nhật TongTien vào HoaDon và in thông báo từng khách.

    DECLARE
    @MaDat      INT,
    @MaPhong    INT,
    @HoTen      NVARCHAR(100),
    @NgayNhan   DATE,
    @NgayTra    DATE,
    @GiaNgay    FLOAT,
    @SoNgay     INT,
    @TongTien   FLOAT,
    @MaHD       INT;

    DECLARE cur_DatPhong CURSOR FOR
    SELECT
        dp.MaDat,
        dp.MaPhong,
        kh.HoTen,
        dp.NgayNhanPhong,
        dp.NgayTraPhong
    FROM DatPhong dp
    JOIN KhachHang kh ON dp.MaKH = kh.MaKH
    WHERE dp.TrangThai = N'Đang ở';

    OPEN cur_DatPhong;

    FETCH NEXT FROM cur_DatPhong
    INTO @MaDat, @MaPhong, @HoTen, @NgayNhan, @NgayTra;

    WHILE @@FETCH_STATUS = 0
    BEGIN
    -- Lấy GiaNgay từ LoaiPhong qua Phong
    SELECT @GiaNgay = lp.GiaNgay
    FROM Phong p
    JOIN LoaiPhong lp ON p.MaLoai = lp.MaLoai
    WHERE p.MaPhong = @MaPhong;

    -- Tính số ngày ở
    SET @SoNgay = DATEDIFF(DAY, @NgayNhan, @NgayTra);

    -- Tính tổng tiền
    SET @TongTien = @GiaNgay * @SoNgay;

    -- Lấy MaHD tương ứng
    SELECT @MaHD = MaHD FROM HoaDon WHERE MaDat = @MaDat;

    -- Cập nhật TongTien vào HoaDon
    UPDATE HoaDon
    SET TongTien = @TongTien
    WHERE MaHD = @MaHD;

    -- In thông báo
    PRINT N'✔ Khách: ' + @HoTen +
          N' | Phòng: ' + CAST(@MaPhong AS NVARCHAR) +
          N' | Số ngày: ' + CAST(@SoNgay AS NVARCHAR) +
          N' | Giá/ngày: ' + CAST(@GiaNgay AS NVARCHAR) +
          N' | Tổng tiền: ' + CAST(@TongTien AS NVARCHAR) + N' VNĐ';

    FETCH NEXT FROM cur_DatPhong
    INTO @MaDat, @MaPhong, @HoTen, @NgayNhan, @NgayTra;
    END;
  
    CLOSE cur_DatPhong;
    DEALLOCATE cur_DatPhong;

    PRINT N'=> Đã cập nhật xong TongTien cho tất cả đơn đang ở.';
    
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/172352e4-6b41-43d0-838f-4b2b8e9ced75" />

                                            Kết quả chạy CURSOR - Yêu cầu 1

## + Tìm cách không sử dụng CURSOR để giải quyết bài toán mà em đã dùng CURSOR mới giải quyết được ở trên. thử so sánh tốc độ giữa có dùng cursor và không dùng cursor (nếu cùng kết quả) thì thời gian xử lý cái nào nhanh hơn, cần ảnh chụp màn hình minh chứng.

+ Lần 1 — Chạy CURSOR (chụp màn hình kết quả + thời gian)
  
     DECLARE @BatDau DATETIME = GETDATE();

    DECLARE
    @MaDat      INT,
    @MaPhong    INT,
    @HoTen      NVARCHAR(100),
    @NgayNhan   DATE,
    @NgayTra    DATE,
    @GiaNgay    FLOAT,
    @SoNgay     INT,
    @TongTien   FLOAT,
    @MaHD       INT;

    DECLARE cur_DatPhong CURSOR FOR
    SELECT
        dp.MaDat,
        dp.MaPhong,
        kh.HoTen,
        dp.NgayNhanPhong,
        dp.NgayTraPhong
    FROM DatPhong dp
    JOIN KhachHang kh ON dp.MaKH = kh.MaKH
    WHERE dp.TrangThai = N'Đang ở';

    OPEN cur_DatPhong;
  FETCH NEXT FROM cur_DatPhong
  INTO @MaDat, @MaPhong, @HoTen, @NgayNhan, @NgayTra;

  WHILE @@FETCH_STATUS = 0
  BEGIN
    SELECT @GiaNgay = lp.GiaNgay
    FROM Phong p
    JOIN LoaiPhong lp ON p.MaLoai = lp.MaLoai
    WHERE p.MaPhong = @MaPhong;

    SET @SoNgay   = DATEDIFF(DAY, @NgayNhan, @NgayTra);
    SET @TongTien = @GiaNgay * @SoNgay;

    SELECT @MaHD = MaHD FROM HoaDon WHERE MaDat = @MaDat;

    UPDATE HoaDon SET TongTien = @TongTien WHERE MaHD = @MaHD;

    PRINT N'✔ Khách: ' + @HoTen +
          N' | Số ngày: ' + CAST(@SoNgay AS NVARCHAR) +
          N' | Tổng tiền: ' + FORMAT(@TongTien, 'N0') + N' VNĐ';

    FETCH NEXT FROM cur_DatPhong
    INTO @MaDat, @MaPhong, @HoTen, @NgayNhan, @NgayTra;
  END;

  CLOSE cur_DatPhong;
  DEALLOCATE cur_DatPhong;
  
  PRINT N'';
  PRINT N'[CURSOR] Thời gian xử lý: '
    + CAST(DATEDIFF(MILLISECOND, @BatDau, GETDATE()) AS NVARCHAR) + N' ms';

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/89011f34-c32a-4b61-b8de-228055342abf" />
 
                                                   Hinh7_KetQua_YeuCau2_Cursor.png
 
+ Lần 2 — Chạy SQL thuần
   
        DECLARE @BatDau DATETIME = GETDATE();

-- Cùng kết quả: cập nhật TongTien cho đơn "Đang ở"

        UPDATE hd
        SET hd.TongTien = lp.GiaNgay * DATEDIFF(DAY, dp.NgayNhanPhong, dp.NgayTraPhong)
        FROM HoaDon hd
        JOIN DatPhong dp  ON hd.MaDat   = dp.MaDat
        JOIN Phong p      ON dp.MaPhong = p.MaPhong
        JOIN LoaiPhong lp ON p.MaLoai   = lp.MaLoai
        WHERE dp.TrangThai = N'Đang ở';

-- Hiển thị kết quả giống CURSOR

    SELECT
    kh.HoTen,
    DATEDIFF(DAY, dp.NgayNhanPhong, dp.NgayTraPhong) AS SoNgay,
    lp.GiaNgay,
    hd.TongTien
    FROM HoaDon hd
    JOIN DatPhong dp  ON hd.MaDat   = dp.MaDat
    JOIN KhachHang kh ON dp.MaKH    = kh.MaKH
    JOIN Phong p      ON dp.MaPhong = p.MaPhong
    JOIN LoaiPhong lp ON p.MaLoai   = lp.MaLoai
    WHERE dp.TrangThai = N'Đang ở';

    PRINT N'[SQL THUẦN] Thời gian xử lý: '
+ CAST(DATEDIFF(MILLISECOND, @BatDau, GETDATE()) AS NVARCHAR) + N' ms';

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/06f6d46e-5f90-4970-9dd7-ded4165ff31c" />

                                                       Hinh8_KetQua_YeuCau2_SQLThuần.png
                                                       
+ So sánh CURSOR và SQL Thuần
  
1. Cùng kết quả TongTien:

CURSOR: ✅ Cập nhật đúng TongTien cho từng đơn
SQL Thuần: ✅ Cập nhật đúng TongTien cho từng đơn

2. Thời gian xử lý:

CURSOR: Chậm hơn vì xử lý tuần tự từng dòng một
SQL Thuần: Nhanh hơn vì xử lý toàn bộ tập dữ liệu trong 1 lần

3. Số dòng code:

CURSOR: Khoảng 35 dòng (cần DECLARE, OPEN, FETCH, CLOSE, DEALLOCATE)
SQL Thuần: Khoảng 10 dòng (chỉ cần 1 câu UPDATE + JOIN)

4. Hiển thị kết quả:

CURSOR: In thông báo riêng từng khách hàng bằng lệnh PRINT
SQL Thuần: Hiển thị toàn bộ kết quả dạng bảng cùng lúc

5. Kết luận:

CURSOR phù hợp khi cần xử lý logic khác nhau cho từng dòng
SQL Thuần phù hợp khi cần tốc độ nhanh và cùng logic cho tất cả dòng
Ưu tiên dùng SQL Thuần trước, chỉ dùng CURSOR khi thật sự cần thiết

## + Nếu vẫn tìm được cách dùng SQL để giải quyết vấn đề mà ko cần CURSOR: thử nghĩ bài toán khác, mà chỉ CURSOR mới giải quyết được, còn SQL rất khó giải quyết đc (theo logic suy nghĩ của em)

+ Yêu cầu 3 — Bài toán chỉ CURSOR giải được

Bài toán: Duyệt từng khách hàng, kiểm tra số lần đặt phòng:

Nếu đặt ≥ 3 lần → cộng thêm 50 điểm vào DiemTichLuy
Nếu đặt 1–2 lần → cộng thêm 20 điểm
Nếu chưa đặt lần nào → in cảnh báo, không cộng điểm

SQL thuần rất khó xử lý vì cần rẽ nhánh IF/ELSE với mức điểm khác nhau theo từng khách + in thông báo riêng cho từng trường hợp.

    sqlDECLARE
    @MaKH       INT,
    @HoTen      NVARCHAR(100),
    @DiemHienTai FLOAT,
    @SoLanDat   INT,
    @DiemCong   INT;

    DECLARE cur_KhachHang CURSOR FOR
    SELECT MaKH, HoTen, DiemTichLuy
    FROM KhachHang;

    OPEN cur_KhachHang;

    FETCH NEXT FROM cur_KhachHang
    INTO @MaKH, @HoTen, @DiemHienTai;

    WHILE @@FETCH_STATUS = 0
    BEGIN
    -- Đếm số lần đặt phòng
    SELECT @SoLanDat = COUNT(*)
    FROM DatPhong
    WHERE MaKH = @MaKH;

    IF @SoLanDat >= 3
    BEGIN
        SET @DiemCong = 50;
        UPDATE KhachHang
        SET DiemTichLuy = DiemTichLuy + @DiemCong
        WHERE MaKH = @MaKH;

        PRINT N'⭐ Khách VIP: ' + @HoTen +
              N' | Số lần đặt: ' + CAST(@SoLanDat AS NVARCHAR) +
              N' | Điểm hiện tại: ' + CAST(@DiemHienTai AS NVARCHAR) +
              N' → Cộng ' + CAST(@DiemCong AS NVARCHAR) + N' điểm';
    END
    ELSE IF @SoLanDat >= 1
    BEGIN
        SET @DiemCong = 20;
        UPDATE KhachHang
        SET DiemTichLuy = DiemTichLuy + @DiemCong
        WHERE MaKH = @MaKH;

        PRINT N'✔ Khách: ' + @HoTen +
              N' | Số lần đặt: ' + CAST(@SoLanDat AS NVARCHAR) +
              N' | Điểm hiện tại: ' + CAST(@DiemHienTai AS NVARCHAR) +
              N' → Cộng ' + CAST(@DiemCong AS NVARCHAR) + N' điểm';
    END
    ELSE
    BEGIN
        PRINT N'⚠ Khách: ' + @HoTen +
              N' chưa có lần đặt phòng nào → Không cộng điểm.';
    END;

    FETCH NEXT FROM cur_KhachHang
    INTO @MaKH, @HoTen, @DiemHienTai;
    END;

    CLOSE cur_KhachHang;
    DEALLOCATE cur_KhachHang;

    PRINT N'=> Hoàn tất cập nhật điểm tích lũy cho tất cả khách hàng.';

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/953f0974-22e0-4271-ae62-d0289b646ed1" />

                                                                  Kết quả xử lý


