USE Musik;

-- Berikut adalah beberapa soal latihan yang terkait Data Manipulation Language (DML)

-- 1. Memilih dua orang teratas berdasarkan gender
SELECT EmployeeID, EmployeeName, Gender FROM MsEmployee WHERE Gender = 'M' LIMIT 2; -- mengatur batas data yang akan muncul

-- 2. Tampilkan tabel MsEmployee dimana digit terakhir dari phone adalah kelipatan 5 dan salary >= 3500000 (RIGHT)
SELECT * FROM MsEmployee WHERE Salary > 3500000 AND RIGHT (Phone, 1) % 5 = 0;
-- 3. Buatlah VIEW dengan nama view_1 lalu tampilkan tabel MsMusicIns dimana price
-- antara 1000000 dan 10000000, dengan MusicIns diawali dengan kata Yamaha.
-- Tampilkan view tersebut dan buat syntax untuk menghapus view tersebut
-- (create, view, between , like)

CREATE VIEW view_1 AS SELECT * FROM MsMusicIns WHERE Price BETWEEN 1000000 AND 10000000 AND MusicIns LIKE 'YAMAHA%';
SELECT * FROM view_1;

-- 4. Tampilkan BranchEmployee (didapat dari employeename dan nama depan employeename diganti dengan branchID)
-- dimana employeename memiliki minimal 3 kata (replace, substring, locate, like)

-- Concatenate --> menggabungkan data yang ada di parameter
SELECT CONCAT(SUBSTRING(EmployeeName, 1, LOCATE(' ', EmployeeName)-1), ' ', BranchID) AS BranchEmployee FROM MsEmployee
WHERE EmployeeName LIKE '% % %';

-- 5. Tampilkan Brand (didapat dari kata pertama MusicIns), Price (didapat dari price ditambahkan kata 'Rp. ' didepannya),
-- Stock, Instrument type (didapat dari MusicInsType) (substring, LOCATE)

SELECT SUBSTRING_INDEX(MusicIns, ' ', 1) AS Brand,
CONCAT('RP. ', Price) AS Price, Stock, MusicInsType
FROM MsMusicIns
JOIN MsMusicInsType ON MsMusicIns.MusicInsTypeID = MsMusicInsType.MusicInsTypeID;

-- 6. Tampilkan EmployeeName, Employee Gender (didapat dari gender), Tanggal dengan format dd mm yyyy, 
-- CustomerName dimana Gender merupakan 'Male' dan EmployeeName memiliki 2 kata atau lebih.
-- (convert, join ,like, order by)

SELECT EmployeeName,
		CASE WHEN Gender = 'M' THEN 'MALE'
ELSE 'FEMALE' END AS EmployeeGender,
		DATE_FORMAT (TransactionDate, '%d %M %Y') AS TransactionDate,
        CustomerName
FROM MsEmployee AS a
JOIN HeaderTransaction AS b ON a.EmployeeID = b.EmployeeID
WHERE EmployeeName LIKE '% %' AND Gender = 'M'
ORDER BY EmployeeName;

-- 7. Tampilkan EmployeeID, EmployeeName, DateOfBirth dengan format dd mm yyyy, CustomerName, TransactionDate dimana 
-- DateOfBirth adalah bulan Desember dan TransactionDate adalah 16. (DATE_FORMAT, JOIN, MONTHNAME, DAYOFMONTH)

SELECT MsEmployee.EmployeeID, EmployeeName, DATE_FORMAT(DateOFBirth, '%d-%M-%Y') AS DateOfBirth, CustomerName, TransactionDate
FROM MsEmployee AS MsEmployee JOIN HeaderTransaction AS HeaderTransaction ON MsEmployee.EmployeeID = HeaderTransaction.EmployeeID
WHERE MONTHNAME (DateOfBirth) = 'DECEMBER' AND DAYOFMONTH(TransactionDate) = 16;

-- 8. Tampilkan BranchName, EmployeeName dimana transaksi terjadi bulan Oktober dan Qty lebih sama dengan 5
-- (EXISTS, JOIN, MONTHNAME)

-- JOIN abuse
SELECT BranchName, EmployeeName FROM MsEmployee AS a
JOIN MsBranch AS b ON a.BranchID = b.BranchID
JOIN HeaderTransaction AS x ON a.EmployeeID = x.EmployeeID
JOIN DetailTransaction AS Y ON x.TransactionID = y.TransactionID
WHERE MONTHNAME(TransactionDate) = 'October' AND Qty >=5;

-- With Subquerry (EXISTS)
SELECT BranchName, EmployeeName FROM MsEmployee AS a 
JOIN MsBranch AS b ON a.BranchID = b.BranchID
WHERE EXISTS (
	SELECT * FROM HeaderTransaction AS x
    JOIN DetailTransaction AS y ON x.TransactionID = y.TransactionID
    WHERE MONTHNAME(TransactionDate) = 'October' AND Qty >=5
);
