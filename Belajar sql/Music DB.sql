CREATE DATABASE musik; -- membuat db
USE musik; -- menggunakan db

CREATE TABLE MsBranch -- membuat TABLE
(
	BranchID VARCHAR(6) PRIMARY KEY, -- membuat variabel dan mengaturnya sebagai PRIMARY KEY
    BranchName VARCHAR(50) NOT NULL, -- mengatur variabel yang wajib diisi atau tidak boleh kosong
    Adress VARCHAR(100) NOT NULL,
    Phone VARCHAR(50),
    CONSTRAINT CheckBran1 CHECK(CHAR_LENGTH(BranchID)=5), -- metode untuk validasi atau pengecekan data, disini berarti datanya harus 5 digit
    CONSTRAINT Checkbran2 CHECK (BranchID REGEXP '^BR[0-9][0-9][0-9]$') -- metode pengecekan format dimana disini data yang masuk berformat diawali BR dan diikuti oleh tiga digit angka
); -- sebuah TABLE atau Metode harus diakhiri oleh semicolon (;)

CREATE TABLE MsMusicInsType
(
	MusicInsTypeID VARCHAR(6) PRIMARY KEY,
    MusicInsType VARCHAR(50) NOT NULL,
    CONSTRAINT CheckMsct1 CHECK(CHAR_LENGTH(MusicInsTypeID)=5), -- data yang masuk harus 5 digit
    CONSTRAINT CheckMsct2 CHECK(MusicInsTypeID REGEXP '^MT[0-9][0-9][0-9]')
);

DROP TABLE MsMusicInsType; -- menghapus TABLE, biasanya karena ada kesalahan penulisan ataupun logical eror

CREATE TABLE MsEmployee
(
	EmployeeID VARCHAR(6) PRIMARY KEY,
    EmployeeName VARCHAR(50) NOT NULL,
    Address VARCHAR(100) NOT NULL,
    Phone VARCHAR(50),
    Gender CHAR(1) NOT NULL, -- ini berarti isi dari variabel ini hanya bisa diisi oleh 1 digit saja dan tidak boleh kosong (fck lgbt shit)
    DateOfBirth DATETIME, -- tipe data DATETIME, sesuai namanya ini berarti tipe data yang digunakan untuk format tanggal format defaultnya yyyy mm dd 
    Salary DECIMAL(10,2), -- tipe data decimal, berarti tipe data yang berisikan bilangan berkoma. ini diatur dengan parameter (a,b): a berarti berapa digit angka yang bisa ditampung, b adalah berapa digit terakhir koma akan ditaruh
    BranchID VARCHAR(6),
    CONSTRAINT CheckEmpl1 CHECK(CHAR_LENGTH(EmployeeID)=5), -- data ini harus terdiri dari 5 digit
    CONSTRAINT CheckEmpl2 CHECK(EmployeeID REGEXP 'EM[0-9][0-9][0-9]'),
    CONSTRAINT CheckEmpl3 CHECK(Gender IN ('M','F')), -- validasi gender, data harus antara M atau F
    CONSTRAINT FK_MsEmployee_MsBranch FOREIGN KEY(BranchID) REFERENCES MsBranch(BranchID) ON UPDATE CASCADE ON DELETE SET NULL
    -- metode foreign key untuk menghubungkan antara TABLE
    -- ON UPDATE CASCADE ON DELETE SET NULL artinya jika nilai BranchID di MsBranch diubah maka nilai BranchID di MsEmployee juga diubah dan jika nilainya di MsBranch dihapus maka nilai di MsEmployee diatur ke NULL
);

CREATE TABLE MsMusicIns
(
	MusicInsID VARCHAR(6) PRIMARY KEY,
    MusicIns VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL, -- ini berarti nilainya harus lebih dari atau sama dengan 0
    MusicInsTypeID VARCHAR(6),
    CONSTRAINT CheckMsci1 CHECK(CHAR_LENGTH(MusicInsID)=5),
    CONSTRAINT CheckMsci2 CHECK(MusicInsID REGEXP 'MI[0-9][0-9][0-9]'),
    CONSTRAINT CheckMsci3 CHECK (Stock >= 0),
    CONSTRAINT FK_MsMusicIns_MsMusicInsType FOREIGN KEY (MusicInsTypeID) REFERENCES MsMusicInsType(MusicInsTypeID) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE HeaderTransaction
(
	TransactionID VARCHAR (6) PRIMARY KEY,
    TransactionDate DATETIME NOT NULL,
    EmployeeID VARCHAR(6) REFERENCES MsEmployee(EmployeeID) ON UPDATE CASCADE ON DELETE SET NULL,
    CustomerName VARCHAR(50),
    CHECK(CHAR_LENGTH(TransactionID)=5),
    CHECK(TransactionID REGEXP 'TR[0-9][0-9][0-9]')
);

DROP TABLE HeaderTransaction;

CREATE TABLE DetailTransaction
(
	TransactionID VARCHAR(6) REFERENCES HeaderTransaction(TransactionID) ON UPDATE CASCADE ON DELETE CASCADE,
    MusicInsID VARCHAR(6) REFERENCES MsMusicIns(MusicInsID) ON UPDATE CASCADE ON DELETE CASCADE,
    Qty INT NOT NULL,
    PRIMARY KEY(TransactionID, MusicInsID)
);

DROP TABLE MsMusicIns;

SELECT * FROM MsBranch; -- ini berarti memilih semua kolom yang ada di  table MsBranch
SELECT * FROM HeaderTransaction;
SELECT * FROM DetailTransaction;
SELECT * FROM MsEmployee;
SELECT * FROM MsMusicInsType;
SELECT * FROM MsMusicIns;

INSERT INTO MsBranch VALUE ('BR001', 'Cabang Agam', 'Jl. Gang Merdeka NO.17', '170-09878787');
-- line diatas artinya memsasukan value yang ada dalam parameter ke dalam TABLE, dengan catatan data yang masuk harus sesuai dengan kriteria
INSERT INTO MsBranch VALUE ('BR002', 'Cabang Panam', 'Jl. Garuda Sakti KM 9', '171-234534545');
INSERT INTO MsBranch VALUE ('BR003', 'Cabang Merak', 'Jl. Merak Sakti No. 14', '172-3563456');
INSERT INTO MsBranch VALUE ('BR004', 'Cabang Balam', 'Jl. Balam Sakti No.2', '173-546546346');
INSERT INTO MsBranch VALUE ('BR005', 'Cabang Payakumbuah', 'Simalanggang', '174-12344235');
INSERT INTO MsBranch VALUE ('BR006', 'Cabang Gobah', 'Jl. Arifin Ahmad NO.9', '175-09123434');

INSERT INTO HeaderTransaction VALUE ('TR001', '2024-06-12 09:30:45', 'EM001', 'Rehandra');
INSERT INTO HeaderTransaction VALUE ('TR002', '2024-06-12 08:34:40', 'EM001', 'Faiz');
INSERT INTO HeaderTransaction VALUE ('TR003', '2024-07-04 00:30:25', 'EM001', 'Ferry');
INSERT INTO HeaderTransaction VALUE ('TR004', '2024-08-10 02:52:39', 'EM001', 'Abul');
INSERT INTO HeaderTransaction VALUE ('TR005', '2024-08-21 09:28:31', 'EM001', 'Ridwan');
INSERT INTO HeaderTransaction VALUE ('TR006', '2024-09-30 12:35:42', 'EM001', 'Ridho');

UPDATE HeaderTransaction SET TransactionDate = '2024-06-16 09:30:45' WHERE TransactionID = 'TR002';
-- line diatas adalah contoh dari implementasi UPDATE untuk meng update kolom dari sebuah table dengan nilai tertentu
UPDATE HeaderTransaction SET EmployeeID = 'EM001' WHERE TransactionID = 'TR001';
UPDATE HeaderTransaction SET EmployeeID = 'EM002' WHERE TransactionID = 'TR002';
UPDATE HeaderTransaction SET EmployeeID = 'EM003' WHERE TransactionID = 'TR003';
UPDATE HeaderTransaction SET EmployeeID = 'EM004' WHERE TransactionID = 'TR004';
UPDATE HeaderTransaction SET EmployeeID = 'EM005' WHERE TransactionID = 'TR005';
UPDATE HeaderTransaction SET EmployeeID = 'EM006' WHERE TransactionID = 'TR006';

SELECT * FROM HeaderTransaction;

INSERT INTO MsEmployee VALUE ('EM001', 'Resa', 'Ghobah', '0812345678', 'F', '2004-01-20', '3500000', 'BR001');
INSERT INTO MsEmployee VALUE ('EM002', 'Rehan', 'Agam', '083181825998', 'M', '2004-09-05', '900000', 'BR001');
INSERT INTO MsEmployee VALUE ('EM003', 'Ibal', 'Rumbai', '08234345443', 'M', '2004-04-12', '400000', 'BR001');
INSERT INTO MsEmployee VALUE ('EM005', 'Abid', 'Merak', '08234345440', 'M', '2006-01-20', '15000000', 'BR006');
INSERT INTO MsEmployee VALUE ('EM006', 'Feri', 'Dabo', '08234345485', 'M', '2004-09-25', '10000000', 'BR005');
INSERT INTO MsEmployee VALUE ('EM007', 'Ipal', 'Lasi', '08234345455', 'M', '2004-08-10', '7500000', 'BR004');

UPDATE MsEmployee SET DateOfBirth  = '2004-12-12' WHERE EmployeeName = 'Rehan Agam UNRI';
SELECT * FROM MsEmployee;

SELECT EmployeeName, Address, BranchID FROM MsEmployee;

UPDATE MsEmployee SET EmployeeName = CASE -- mengupdate TABLE sesuai dengan kasus atau nilai yang ada
	WHEN EmployeeName = 'Resa' THEN 'Resa Ghobah UNRI'
    WHEN EmployeeName = 'Rehan' THEN 'Rehan Agam UNRI'
    WHEN EmployeeName = 'Ibal' THEN 'Ibal Rumbai UNRI'
    WHEN EmployeeName = 'Abid' THEN 'Abid Merak UNRI'
    WHEN EmployeeName = 'Feri' THEN 'Feri Dabo UNRI'
    WHEN EmployeeName = 'Ipal' THEN 'Ipal Lasi POLMAN'
    ELSE EmployeeName -- kondisi nama tetap sama 
END
WHERE EmployeeName IN ('Resa', 'Rehan', 'Ibal', 'Abid', 'Feri', 'Ipal');

INSERT INTO DetailTransaction VALUE ('TR001', 'MI001', '1');
INSERT INTO DetailTransaction VALUE ('TR002', 'MI002', '1');
INSERT INTO DetailTransaction VALUE ('TR003', 'MI003', '1');

INSERT INTO MsMusicInsType VALUE ('MT001', 'Gitar');
INSERT INTO MsMusicInsType VALUE ('MT002', 'Biola');
INSERT INTO MsMusicInsType VALUE ('MT003', 'Perkusi');

INSERT INTO MsMusicIns VALUE ('MI001', 'Ibanez 001', '2500000', '5', 'MT001');
INSERT INTO MsMusicIns VALUE ('MI002', 'Sweden', '5000000', '2', 'MT002');
INSERT INTO MsMusicIns VALUE ('MI003', 'YAMAHA 001', '8000000', '1', 'MT003');
INSERT INTO MsMusicIns VALUE ('MI004', 'YAMAHA 002', '7800000', '3', 'MT003');
INSERT INTO MsMusicIns VALUE ('MI005', 'YAMAHA 003', '9000000', '3', 'MT001');

SELECT MusicIns, Stock FROM MsMusicIns;
UPDATE MsMusicIns SET Stock = 3, MusicIns = 'YAMAHA 001' WHERE MusicInsID = 'MI003';
SELECT TransactionID, Qty FROM DetailTransaction WHERE TransactionID = 'TR002';

UPDATE DetailTransaction
SET Qty = 3
WHERE TransactionID = 'TR001';

DELETE FROM DetailTransaction WHERE TransactionID = 'TR001';

SELECT * FROM DetailTransaction;

SELECT EmployeeID, EmployeeName, Salary FROM MsEmployee;
UPDATE MsEmployee SET Salary = 9000000 WHERE EmployeeID = 'EM003';