USE AdventureWorks2014
GO
--Lấy ra dữ liệu của bảng Contact có ContactTypeID >= 3 và ContactTypeID <= 10
SELECT * FROM Person.ContactType
WHERE ContactTypeID >= 3 AND ContactTypeID <= 10
--Lấy ra dữ liệu của bảng Contact có ContactID trong khoảng [3, 10]
SELECT * FROM Person.ContactType
WHERE ContactTypeID BETWEEN 3 AND 10
--Lấy ra những Contact có Name kết thúc bởi ký tự e
SELECT * FROM Person.ContactType
WHERE Name LIKE '%e'
--Lấy ra những Contact có LastName bắt đầu bởi ký tự R hoặc A kết thúc bởi ký tự e
SELECT * FROM Person.ContactType
WHERE Name LIKE '[RA]%e'
--Lấy ra những Contact có LastName có 4 ký tự bắt đầu bởi ký tự R hoặc A kết thúc bởi ký tự e
SELECT * FROM Person.ContactType
WHERE Name LIKE '[RA]__e'
--Sử dụng INNER JOIN
SELECT Person.StateProvince.*
FROM Person.StateProvince INNER JOIN Person.Address ON
Person.StateProvince.StateProvinceID = Person.Address.StateProvinceID
SELECT * FROM Person.Address
SELECT City, COUNT(*) [Title Number]
FROM Person.Address
WHERE City LIKE 'Bo%'
GROUP BY ALL City
--GROUP BY với HAVING: mệnh đề HAVING sẽ lọc kết quả trong lúc được gộp nhóm
SELECT City, COUNT(*) [Title Number]
FROM Person.Address
GROUP BY ALL City
HAVING City LIKE 'Bo%'

--Phan III
IF EXISTS (SELECT * FROM sys.databases WHERE Name='QLNhanVien')
DROP DATABASE QLNhanVien
GO
CREATE DATABASE QLNhanVien
GO
USE QLNhanVien
GO

CREATE TABLE PhongBan
(
	MaPB varchar(7) PRIMARY KEY,
	TenPB nvarchar(50)
)
--DROP TABLE NhanVien
--ALTER TABLE LuongDA
--DROP CONSTRAINT fk_MaNV
CREATE TABLE NhanVien
(
	MaNV varchar(7) PRIMARY KEY,
	TenNV nvarchar(50),
	NgaySinh Datetime,
	SoCMND char(9) CHECK (SoCMND between 100000000 and 999999999),
	GioiTinh char(1) CHECK (GioiTinh IN ('M','F')) DEFAULT 'M',
	DiaChi nvarchar(100),
	NgayVaoLam Datetime,
	MaPB varchar(7),
	CONSTRAINT fk FOREIGN KEY (MaPB) REFERENCES PhongBan(MaPB)
) 

CREATE TABLE LuongDA
(
	MaDA varchar(8) NOT NULL,
	MaNV varchar(7) NOT NULL,
	SoTien Money CHECK (SoTien > 0),
	NgayNhan DATETIME DEFAULT GETDATE(),
	CONSTRAINT fk_MaNV FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
	CONSTRAINT PK PRIMARY KEY (MaDA,MaNV)
)

ALTER TABLE NhanVien 
ADD CONSTRAINT CHK_Gioi_Tinh CHECK (GioiTinh = 'M' OR GioiTinh = 'F') 

ALTER TABLE NhanVien
ADD CONSTRAINT df_GioiTinh
DEFAULT 'M' FOR GioiTinh

ALTER TABLE NhanVien
ADD CONSTRAINT CHK_NgayVaoLamNgaySinh CHECK (DATEDIFF(year, NgaySinh,NgayVaoLam)>=20)

ALTER TABLE NhanVien
ADD CONSTRAINT CHK_NgaySinh CHECK (DATEDIFF(year, NgaySinh,getdate())>0)

--SELECT * FROM NhanVien
--WHERE DATEDIFF(year, NgaySinh,NgayVaoLam) > 20

--SELECT DATEDIFF(year, '1993-08-25','1996-01-01')
--1,Thực hiện chèn dữ liệu vào các bảng vừa tạo (ít nhất 5 bản ghi cho mỗi bảng).
INSERT INTO PhongBan
VALUES (1,'Kinh Doanh'),(2,'Hanh Chinh'),(3,'Ke Toan'),(4,'Ky Thuat'),(5,'Thiet Ke')

INSERT INTO NhanVien(MaNV,TenNV,NgaySinh,SoCMND,GioiTinh,DiaChi,NgayVaoLam,MaPB)
VALUES 
(1,'Nguyen Van An','1993-08-25',123456789,'M','Ha Nam','2017-12-05',1),
(2,'Nguyen Xuan An','1998-08-25',123456789,'M','Thai Binh','2020-12-05',2),
(3,'Nguyen Thi Ha','1990-08-25',123456789,'F','Ha Noi','2017-12-05',3),
(4,'Tran Van Nam','1989-08-25',123456789,'M','Ha Nam','2010-12-05',4),
(5,'Nguyen Thi Tu','1985-08-25',123456789,'F','Nam Dinh','2015-12-05',5),
(6,'Bui Thi Xuan','1983-08-25',123456789,'F','Hai Duong','2010-12-05',2),
(7,'Ha Van Thanh','1993-08-25',123456789,'M','Tuyen Quang','2017-12-05',3)

INSERT INTO NhanVien(MaNV,TenNV,NgaySinh,SoCMND,GioiTinh,DiaChi,NgayVaoLam,MaPB)
VALUES 
(8,'Nguyen Van Tich','1991-08-25',123456781,'M','Ha Nam','2017-12-05',1)

INSERT INTO LuongDA
VALUES(3,8,19000,'2017-08-09'),
(4,1,10000,'2016-08-09'),
(5,4,13000,'2019-08-09'),
(6,2,10000,'2014-08-09'),
(7,2,17000,'2013-08-09'),
(8,1,10000,'2016-08-09'),
(9,6,10000,'2017-08-09')

INSERT INTO LuongDA(MaDA,MaNV,SoTien)
VALUES(3,3,1100)
--2.Viết một query để hiển thị thông tin về các bảng LUONGDA, NHANVIEN, PHONGBAN.
SELECT * FROM PhongBan
SELECT * FROM NhanVien
SELECT * FROM LuongDA
--3. Viết một query để hiển thị những nhân viên có giới tính là ‘F’.
SELECT * FROM NhanVien
WHERE NhanVien.GioiTinh = 'F'
--4. Hiển thị tất cả các dự án, mỗi dự án trên 1 dòng.
SELECT * FROM LuongDA
--5. Hiển thị tổng lương của từng nhân viên (dùng mệnh đề GROUP BY).
SELECT LuongDA.MaNV,NhanVien.TenNV,SUM(LuongDA.SoTien) AS 'Tong luong' 
FROM NhanVien INNER JOIN LuongDA ON NhanVien.MaNV = LuongDA.MaNV
GROUP BY LuongDA.MaNV,NhanVien.TenNV
--6. Hiển thị tất cả các nhân viên trên một phòng ban cho trước (VD: ‘Hành chính’).
SELECT NhanVien.TenNV,PhongBan.TenPB 
FROM NhanVien INNER JOIN PhongBan ON NhanVien.MaPB = PhongBan.MaPB
WHERE PhongBan.TenPB = 'Hanh Chinh'
--7. Hiển thị mức lương của những nhân viên phòng hành chính.
--8. Hiển thị số lượng nhân viên của từng phòng.
SELECT PhongBan.TenPB,COUNT(NhanVien.MaPB) AS 'So luong' 
FROM NhanVien INNER JOIN PhongBan ON NhanVien.MaPB = PhongBan.MaPB
GROUP BY PhongBan.TenPB
--9. Viết một query để hiển thị những nhân viên mà tham gia ít nhất vào một dự án.
SELECT LuongDA.MaNV,NhanVien.TenNV,COUNT(LuongDA.MaDA) AS 'So Du An' 
FROM NhanVien INNER JOIN LuongDA ON NhanVien.MaNV = LuongDA.MaNV
GROUP BY LuongDA.MaNV,NhanVien.TenNV
HAVING COUNT(LuongDA.MaDA) = 1
--10. Viết một query hiển thị phòng ban có số lượng nhân viên nhiều nhất.
SELECT PhongBan.TenPB,COUNT(NhanVien.MaPB) AS 'So luong' 
FROM NhanVien INNER JOIN PhongBan ON NhanVien.MaPB = PhongBan.MaPB
GROUP BY PhongBan.TenPB
HAVING COUNT(NhanVien.MaPB) >= ALL (SELECT COUNT(NhanVien.MaPB) AS 'So luong' 
FROM NhanVien INNER JOIN PhongBan ON NhanVien.MaPB = PhongBan.MaPB
GROUP BY PhongBan.TenPB)
--11. Tính tổng số lưong của các nhân viên trong phòng Hành chính.
--12. Hiển thị tống lương của các nhân viên có số CMND tận cùng bằng 9.
SELECT LuongDA.MaNV,NhanVien.TenNV,NhanVien.SoCMND,SUM(LuongDA.SoTien) AS 'Tong luong' 
FROM NhanVien INNER JOIN LuongDA ON NhanVien.MaNV = LuongDA.MaNV
WHERE NhanVien.SoCMND LIKE '%9'
GROUP BY LuongDA.MaNV,NhanVien.TenNV,NhanVien.SoCMND
--13. Tìm nhân viên có số lương cao nhất.
SELECT LuongDA.MaNV,NhanVien.TenNV,SUM(LuongDA.SoTien) AS 'Tong luong' 
FROM NhanVien INNER JOIN LuongDA ON NhanVien.MaNV = LuongDA.MaNV
GROUP BY LuongDA.MaNV,NhanVien.TenNV
HAVING SUM(LuongDA.SoTien) >= ALL(SELECT SUM(LuongDA.SoTien) AS 'Tong luong' 
FROM NhanVien INNER JOIN LuongDA ON NhanVien.MaNV = LuongDA.MaNV
GROUP BY LuongDA.MaNV,NhanVien.TenNV)
--14. Tìm nhân viên ở phòng Hành chính có giới tính bằng ‘F’ và có mức lương > 1200000.
SELECT NhanVien.TenNV,PhongBan.TenPB,NhanVien.GioiTinh 
FROM NhanVien INNER JOIN PhongBan ON NhanVien.MaPB = PhongBan.MaPB
WHERE PhongBan.TenPB = 'Hanh Chinh' AND NhanVien.GioiTinh = 'F'
--15. Tìm tổng lương trên từng phòng.
--16. Liệt kê các dự án có ít nhất 2 người tham gia.
SELECT LuongDA.MaDA,COUNT(LuongDA.MaNV) AS 'So luong nguoi tham gia' FROM LuongDA
GROUP BY LuongDA.MaDA
HAVING COUNT(LuongDA.MaNV) >= 2
--17. Liệt kê thông tin chi tiết của nhân viên có tên bắt đầu bằng ký tự ‘N’.
SELECT * FROM NhanVien
WHERE NhanVien.TenNV LIKE 'N%'
--18. Hiển thị thông tin chi tiết của nhân viên được nhận tiền dự án trong năm 2017.
SELECT * 
FROM NhanVien INNER JOIN LuongDA ON NhanVien.MaNV = LuongDA.MaNV
WHERE DATEPART(year,LuongDA.NgayNhan) = '2017'
--19. Hiển thị thông tin chi tiết của nhân viên không tham gia bất cứ dự án nào.
