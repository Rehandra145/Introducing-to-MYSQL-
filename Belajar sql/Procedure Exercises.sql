USE musik;

-- Berikut adalah beberapa contoh soal mengenai stored procedure
-- 9. Buatlah store procedure untuk fungsi search degan nama search yang menampilkan EmployeeName,
-- Address, Phone, Gender. Fungsi ini akan mencari ke seluruh kolom sesuai inputan. (CREATE PROCEDURE, LIKE, CONCAT)

-- DELIMITER : Pengganti sintaks atau simbol tertentu menjadi apa yang diinginkan

DELIMITER $$

CREATE PROCEDURE search(IN input VARCHAR(255))
BEGIN
	SELECT EmployeeName, Address, Phone, Gender
    FROM MsEmployee
    WHERE EmployeeName LIKE CONCAT('%', input, '%')
		OR Address LIKE CONCAT('%', input, '%')
        OR Phone LIKE CONCAT('%', input, '%')
        OR Gender LIKE CONCAT('%', input, '%');
END$$

DELIMITER ;

SELECT * FROM MsEmployee;
CALL search("Re");

-- 10. Buatlah stored procedure dengan nama "Check_Transaction" yang menampilkan data CustomerName,
-- EmployeeName, BranchName, MusicIns, Price berdasarkan TransactionID yang diinput

DELIMITER $$

CREATE PROCEDURE Check_Transaction (IN input VARCHAR(255))
BEGIN
	SELECT CustomerName, BranchName, EmployeeName, MusicIns, Price
    FROM HeaderTransaction AS a 
    JOIN MsEmployee AS b ON a.EmployeeID = b.EmployeeID
    JOIN MsBranch AS x ON b.BranchID = x.BranchID
    JOIN DetailTransaction AS y ON a.TransactionID = y.TransactionID
    JOIN MsMusicIns AS z ON y.MusicInsID = z.MusicInsID
    WHERE a.TransactionID LIKE input;
END$$

DELIMITER ;

CALL Check_Transaction("TR001");

-- 11. Tampilkan data yang menunjukkan detail jumlah transaksi musicins per employee
-- JUmlahTransaksi, EmployeeName

SELECT COUNT(a.TransactionID) AS JumlahTransaksi, EmployeeName
FROM HeaderTransaction AS a 
JOIN MsEmployee AS b ON a.EmployeeID = b.EmployeeID
JOIN DetailTransaction AS c ON a.TransactionID = c.TransactionID
GROUP BY EmployeeName;

-- 12. Buatlah Stored PROCEDURE dengan nama "Add_Stock_MusicIns" untuk menambah stock MusicIns.
-- Jika stock yang diinput lebih kecil atau sama dengan 0, maka akan muncul pesan
-- "stock yang diinput harus besar dari 0"

DELIMITER $$
CREATE PROCEDURE AddStockMusicIns (IN inputID VARCHAR(255), IN inputStock INT)
BEGIN
	IF EXISTS (SELECT * FROM MsMusicIns WHERE MusicInsID = inputID) THEN
		IF inputStock <= 0 THEN
			SELECT 'Stock yang diinput harus lebih besar dari 0';
		ELSE 
			UPDATE MsMusicIns SET Stock = Stock + inputStock WHERE MusicInsID = inputID;
		END IF;
	ELSE 
		SELECT 'Data tidak ditemukan / kode yang dimasukkan salah';
	END IF;
END$$

DELIMITER ; 

CALL AddStockMusicIns ('MI005', 20);



-- 13. Buatlah Stored PROCEDURE dengan nama "Check_Sale" untuk melihat MusicInsType
-- apa saja yang terjual pada bulan tertentu beserta jumlah yang terjualnya 

DELIMITER $$

CREATE PROCEDURE CheckSale(IN input VARCHAR(255))
BEGIN
	SELECT a.MusicInsType , SUM(Qty) AS Qty
    FROM MsMusicInsType AS a
    JOIN MsMusicIns AS b ON a.MusicInsTypeID = b.MusicInsTypeID
    JOIN DetailTransaction AS c ON b.MusicInsID = c.MusicInsID
    JOIN HeaderTransaction AS d ON c.TransactionID = d.TransactionID
    WHERE MONTHNAME(TransactionDate) = input
    GROUP BY a.MusicInsType;
END$$

DELIMITER ;
CALL CheckSale ('July');

-- Jika ada Agregation (SUM, COUNT, MAX, MIN, AVG) maka harus
-- di GROUP BY sesuai dengan apa yang di SELECT

-- 14. Buatlah stored PROCEDURE dengan nama "Check_Employee"
-- yang berfungsi untuk memberikan informasi EmployeeName, address, phone, 
-- DateOfBirth, dan branchName berdasarkan TransactionID. Jika TransactionID
-- tidak dimasukkan, maka akan dimunculkan semua data employee yang ada 

DELIMITER $$
CREATE PROCEDURE Check_Employee(IN input VARCHAR(255))
BEGIN
	IF input != '' THEN
		SELECT a.EmployeeName, a.Address, a.Phone, DATE_FORMAT(a.DateOfBirth, '%d %M %Y') AS DateOfBirth, b.BranchName
        FROM MsEmployee AS a
        JOIN MsBranch AS b ON a.BranchID = b.BranchID
        JOIN HeaderTransaction AS c ON a.EmployeeID = c.EmployeeID
        WHERE c.TransactionID = input;
    ELSE 
		SELECT a.EmployeeName, a.Address, a.Phone, DATE_FORMAT(a.DateOfBirth, '%d %M %Y') AS DateOfBirth, b.BranchName
        FROM MsEmployee a
        JOIN MsBranch b ON a.BranchID = b.BranchID;
	END IF;
END$$
DELIMITER ; 

DROP PROCEDURE IF EXISTS Check_Employee;

CALL Check_Employee("TR001");