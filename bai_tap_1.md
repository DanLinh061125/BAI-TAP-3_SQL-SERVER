# **Bài tập môn Hệ quản trị cơ sở dữ liệu-TEE560, Lớp: 59KMT**

* **Họ và tên:** Nguyễn Phạm Đan Linh
* **MSSV:** K235480106095
* **Lớp:** K59.KMT.K01

---

# BÀI TẬP

### 1. Download và cài đặt SQL Server 2025, phiên bản Developer

<img width="1917" height="1079" alt="Screenshot 2026-04-12 094116" src="https://github.com/user-attachments/assets/190f54fa-eaae-4d57-954e-5a6a8b6cf47a" />

<img width="1919" height="1075" alt="image" src="https://github.com/user-attachments/assets/277f3e0e-142e-48b2-830c-b5555ba4c272" />




### 2. Cấu hình cho SQL Server làm việc ở cổng động (Dynamic Port), TCP(MSSV: K235480106095):

<img width="1274" height="710" alt="image" src="https://github.com/user-attachments/assets/130d6622-7c97-4f26-a66c-770743b4d2e8" />

<img width="1276" height="711" alt="image" src="https://github.com/user-attachments/assets/2da9bd64-30d8-48e8-a87a-09f1f95af43a" />



### 3. Kiểm tra xem service SQL Server có đang running và mở đúng cổng đã chọn hay không?

Sử dụng lệnh trên cmd: netstat -ano | findstr LISTENING để liệt kê các cổng mà máy tính đang mở,

Nếu thấy dòng: TCP 0.0.0.0:xxxxx với xxxxx là cổng đã chọn ở bước 2 là OK.

<img width="1274" height="712" alt="image" src="https://github.com/user-attachments/assets/6193781d-f3d2-4379-907d-acda6089b294" />

### 4. Cài đặt SQL Server Management Studio

Link tải SSMS: https://learn.microsoft.com/en-us/ssms/install/install

<img width="1274" height="711" alt="image" src="https://github.com/user-attachments/assets/bcd94b56-abc5-4742-8be5-0f9b4fb7f78e" />

### 5. Chạy phần mềm ssms để Đăng nhập vào SQL Server bằng 2 cách: Windows Authentication và SQL Server Authentication.

Servername: localhost,xxxxx (với xxxxx là cổng đã chọn ở bước 2)

<img width="1274" height="714" alt="image" src="https://github.com/user-attachments/assets/d9862b04-26b8-45c7-92a6-a131ddeae381" />

<img width="1278" height="712" alt="image" src="https://github.com/user-attachments/assets/59c986ea-04ff-437f-805d-9567a23543a5" />


<img width="1278" height="713" alt="image" src="https://github.com/user-attachments/assets/f0bdc28b-9e5d-46e7-98df-0353680ee526" />



### 6. Sử dụng giao diện đồ hoạ của ssms: Tạo cơ sở dữ liệu mới (create database) với tên tuỳ ý, chọn Path (nơi lưu trữ db) cho file lưu dữ liệu và file lưu log ở ổ đĩa khác với ổ C. mở path đã chọn xem 2 file đã tạo ra.

<img width="1919" height="1079" alt="Screenshot 2026-04-12 085100" src="https://github.com/user-attachments/assets/4b1bdc8c-f880-4a0e-a593-a6486f70a90a" />

<img width="1919" height="1079" alt="Screenshot 2026-04-12 091144" src="https://github.com/user-attachments/assets/1cf3f035-c7eb-42f4-a76b-bdc69299ccba" />


### 7. Sử dụng giao diện đồ hoạ của ssms: Tạo bảng dữ liệu (create and design table) với tên bảng tuỳ ý, có các trường dữ liệu phù hợp với dữ liệu của file data mẫu (CSV), với Khoá chính (Primary Key) là trường masv

<img width="1919" height="1079" alt="Screenshot 2026-04-12 090110" src="https://github.com/user-attachments/assets/a6668a90-d70a-45f5-b1d0-38b9381be5df" />


### 8. Sử dụng giao diện đồ hoạ của ssms: Tìm cách import dữ liệu từ file mẫu vào trong bảng vừa tạo.

<img width="1919" height="1079" alt="Screenshot 2026-04-12 090241" src="https://github.com/user-attachments/assets/33813110-68cc-4db4-b009-d78d990249b8" />


<img width="1919" height="1079" alt="Screenshot 2026-04-12 090519" src="https://github.com/user-attachments/assets/53c5696a-81e4-48bb-9c32-d23614042b72" />


### 9. Mở cửa sổ mới để gõ lệnh trong ssms: GÕ lệnh để kiểm tra xem số dòng của bảng dữ liệu sau khi import, kết quả ok sẽ khoảng 12020 dòng.

SELECT COUNT(*) AS SOLUONG FROM SINHVIEN2T;

<img width="1919" height="1079" alt="Screenshot 2026-04-12 090639" src="https://github.com/user-attachments/assets/1634653c-861e-44d9-ba9d-310835fa0c1b" />



### 10. Trong cửa sổ mới để gõ lệnh: Gõ lệnh để thêm (insert) 1 row vào bảng, với dữ liệu là thông tin cá nhân của sv đang làm bài (mỗi sv sẽ luôn khác nhau ở bước này).

<img width="1919" height="1079" alt="Screenshot 2026-04-12 090649" src="https://github.com/user-attachments/assets/e9b2ad5b-b72e-49c4-ad51-50635adf4f0f" />

<img width="1272" height="673" alt="image" src="https://github.com/user-attachments/assets/27a2df2e-99f1-478b-a60d-581e3dd0b00c" />



### 11. Trong cửa sổ mới để gõ lệnh: Gõ lệnh để cập nhật(update) trường noisinh thành 'Sao Hoả' cho những dòng có noisinh và diachi đều là NULL.

<img width="1919" height="1078" alt="Screenshot 2026-04-12 090732" src="https://github.com/user-attachments/assets/9ab61b23-e242-443a-8c54-f3c8f8c1f39d" />


### 12. Sử dụng giao diện đồ hoạ của ssms: Tạo bảng SaoHoa gồm những sinh viên có nơi sinh ở 'Sao Hoả', keyword gợi ý: sử dụng 1 câu lệnh: SELECT + INTO

<img width="1919" height="1078" alt="Screenshot 2026-04-12 090732" src="https://github.com/user-attachments/assets/a2a2d1d1-e533-444b-922b-5fc537817ccc" />


### 13.Trong cửa sổ mới để gõ lệnh: Gõ lệnh xoá (delete) trong bảng SaoHoa những sinh viên cùng họ với em(Họ: Nguyễn)

<img width="1919" height="1079" alt="Screenshot 2026-04-12 090739" src="https://github.com/user-attachments/assets/7413cc77-93a1-4a0b-a2f9-117e774b3ba2" />

### 14. Sử dụng giao diện đồ hoạ của ssms: Xuất toàn bộ kết quả của các bước 6,7,8,9,10,11,12,13 ra file dulieu.sql , keyword gợi ý: sử dụng tính năng GEN SCRIPT struct+data cho database

<img width="1919" height="1079" alt="Screenshot 2026-04-12 091006" src="https://github.com/user-attachments/assets/724e208b-f0b4-4448-a19e-1390b9a123bc" />

<img width="1919" height="1079" alt="Screenshot 2026-04-12 091019" src="https://github.com/user-attachments/assets/5a8d6490-50f0-4301-8219-9857accdd068" />




### 15. Sử dụng giao diện đồ hoạ của ssms: Xoá csdl đã tạo, sau khi xoá thành công, kiểm tra tại path (path chọn ở bước 6) xem còn tồn tại 2 file của bước 6 không?

<img width="1919" height="1079" alt="Screenshot 2026-04-12 091144" src="https://github.com/user-attachments/assets/49a63ec6-5d6f-46a5-a40e-3188764c1864" />

<img width="1919" height="1079" alt="Screenshot 2026-04-12 091155" src="https://github.com/user-attachments/assets/e142e304-e457-4e89-b54a-82bf5bb79f8b" />


### 16. Tạo cửa sổ mới để gõ lệnh: mở file dulieu.sql của bước 14, chạy toàn bộ các lệnh này. REFRESH lại cây liệt kê các database => kiểm chứng kết quả được tạo ra tương đương với các bước 6,7,8,9,10,11,12,13.

<img width="1919" height="1079" alt="Screenshot 2026-04-12 092517" src="https://github.com/user-attachments/assets/e8923f6f-a506-4087-99b9-6e7b6cb44990" />


### 17. upload file dulieu.sql lên github repository của em (repository mà em đang edit file README.md)

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/6de6f1dd-c2e9-4c50-990c-3766bb60ba19" />
