create database session10_sql;
use session10_sql;

CREATE TABLE Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    Full_Name VARCHAR(100),
    Phone VARCHAR(20),
    Age INT,
    Address VARCHAR(255)
);

-- 2. Tạo Procedure nạp 500.000 dòng (Copy y hệt mẫu đề bài)
DELIMITER //
CREATE PROCEDURE SeedPatients()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 500000 DO
        INSERT INTO Patients (Full_Name, Phone, Age, Address)
        VALUES (CONCAT('Patient ', i), CONCAT('090', i), FLOOR(RAND()*100), 'Ho Chi Minh City');
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

-- 3. Nạp dữ liệu (Đợi khoảng 1-3 phút tùy máy)
CALL SeedPatients();

-- 4. KIỂM TRA KHI CHƯA CÓ INDEX
-- Chạy dòng này và nhìn cột "Duration" ở dưới cùng để xem mất bao nhiêu giây
SELECT * FROM Patients WHERE Phone = '090450000'; 

-- 5. TIẾN HÀNH ĐÁNH INDEX (Tạo "mục lục" cho cột Phone)
CREATE INDEX idx_phone ON Patients(Phone);

-- 6. KIỂM TRA SAU KHI CÓ INDEX
-- Chạy lại dòng này, bạn sẽ thấy nó hiện ra ngay lập tức (0.000s)
SELECT * FROM Patients WHERE Phone = '090450000';

-- Tạo Procedure để chèn thử 1000 dòng
DELIMITER //
CREATE PROCEDURE TestInsert1000()
BEGIN
    DECLARE j INT DEFAULT 1;
    WHILE j <= 1000 DO
        INSERT INTO Patients (Full_Name, Phone, Age, Address)
        VALUES (CONCAT('New Patient ', j), CONCAT('088', j), 30, 'Hanoi');
        SET j = j + 1;
    END WHILE;
END //
DELIMITER ;

-- ĐO TỐC ĐỘ GHI KHI ĐANG CÓ INDEX
-- (Ghi lại thời gian chạy lệnh này)
CALL TestInsert1000();

-- XÓA INDEX ĐỂ ĐO LẠI TỐC ĐỘ GHI KHI KHÔNG CÓ INDEX
DROP INDEX idx_phone ON Patients;

-- 4. ĐO TỐC ĐỘ GHI KHI KHÔNG CÓ INDEX
-- (Ghi lại thời gian chạy lệnh này để so sánh)
CALL TestInsert1000();