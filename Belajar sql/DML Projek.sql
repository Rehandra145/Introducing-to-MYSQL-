USE toko;

/*SOAL 1 : Tampilkan 2 barang termahal*/
SELECT * FROM MsProduct ORDER BY Harga DESC LIMIT 2;

/*SOAL 2 : Tampilkan detail toko yang sudah official diurutkan dari nama pemilik toko terbesar [A-Z]*/
/*NOTE 1 : Tidak boleh pake kolom isOfficial*/
/*NOTE 2 : Pake kolom IDShop digit terakhir
Y : Official
N : Tidak Official*/
SELECT * FROM TrShop WHERE RIGHT (IDShop, 1) = 'Y' ORDER BY  Pemilik ASC;

/*SOAL 3 : Buatlah view bernama 'vw_CreditCardDoneTransaction', menampilkan detail transaksi yang
sudah selesai dan menggunakan credit card*/
CREATE VIEW vw_CreditCardDoneTransaction AS SELECT * FROM TrTransaction WHERE Done = 1 AND PaymentMethod = 'Credit Card';
SELECT * FROM vw_CreditCardDoneTransaction;

/*SOAL 4 : Tampilkan nama pemilik toko official dengan format [kode toko + nama belakang pemilik toko]*/
SELECT CONCAT(IDShop, ' ', SUBSTRING(Pemilik, LOCATE(' ', Pemilik), LENGTH(Pemilik))) AS PemilikToko FROM TrShop WHERE isOfficial = 1;

/*SOAL 5 : Tampilkan kode product, nama product, stock product, price dengan format ['RP. ' + Price]
dari product yang memiliki stock lebih dari 50*/
SELECT IDProduk, NamaProduk, Stok, CONCAT('RP. ', Harga) AS Harga FROM MsProduct WHERE Stok > 50; 

/*SOAL 6 : Tampilkan kode toko, nama toko dengan format nama_toko + official/non-official, owner, alamat 
yang memiliki harga lebih dari 100000*/
SELECT DISTINCT a.IDShop, 
CONCAT(NamaToko, ' ', 
CASE WHEN isOfficial = '1' 
THEN '(Official)' 
ELSE '(Non-Official)' END) AS Toko, Pemilik, alamat 
FROM TrShop AS a 
JOIN MsProduct AS b ON a.IDShop = b.IDShop
WHERE Harga > 100000;

/*SOAL 7 : Tampilkan kode transaksi, kode produk, kode customer, transaction date dengan format dd mm yyyy
, qty, total price, payment methode dari transaksi yang terjadi di bulan september dan november*/
SELECT IDTransaction, IDProduk, IDCustomer, DATE_FORMAT(TransactionDate, '%d %M %Y') AS Tanggal, Qty,
TotalHarga, PaymentMethod FROM TrTransaction
WHERE MONTHNAME(TransactionDate) = 'September' OR MONTHNAME(TransactionDate) = 'November'; 

/*SOAL 8 : Tampilkan nama metode transaksi, jumlah transaksi yang menggunakan metode debit (payment count)
dari toko yang sudah official*/
SELECT a.PaymentMethod, COUNT(a.PaymentMethod) AS TotalTransaksi 
FROM TrTransaction AS a
JOIN MsProduct AS b ON a.IDProduk = b.IDProduk
JOIN TrShop AS c ON b.IDShop = c.IDShop
WHERE isOfficial = 1 AND PaymentMethod LIKE 'Debit'
GROUP BY a.PaymentMethod;

/* QUERY UNTUK CEK SOAL NOMOR 8 */
SELECT * 
FROM TrTransaction a
JOIN MsProduct b ON a.IDProduk = b.IDProduk
JOIN trshop c ON b.IDShop = c.IDShop
WHERE PaymentMethod = 'Debit';
/* ============================ */

/*SOAL 9 : Tampilkan kode customer, nama customer, phone number, dan email yang memiliki nama dengan minimal
3 kata*/
SELECT * FROM TrCustomer WHERE Nama LIKE '% % %';

/*SOAL 10 : Buatlah stored procedure dengan nama 'search_product' yang menerima input/parameter nama barang,
dan menampilkan nama toko yang menjual barang tersebut, kode barang, nama barang, stock, harga*/
DELIMITER $$
CREATE PROCEDURE search_product (IN input VARCHAR(100))
BEGIN
	SELECT NamaToko, IDProduk, NamaProduk, Stok, Harga
    FROM TrShop AS a 
    JOIN MsProduct AS b ON a.IDShop = b.IDShop
    WHERE NamaProduk LIKE CONCAT('%', input, '%');
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS search_product;
CALL search_product('Tooth brush');

/*SOAL 11 : Buatlah stored procedure dengan nama 'GetAverageReviewByProductName' yang menerima inputan/parameter 
nama produk, yang berfungsi untuk menampilkan nama produk, rata2 review star*/
DELIMITER $$
CREATE PROCEDURE GetAverageReviewByProductName (IN input VARCHAR (255))
BEGIN
	SELECT a.NamaProduk AS 'Nama Produk', AVG(Star) AS 'Review rata- rata'
    FROM MsProduct AS a 
    JOIN TrReview AS b ON a.IDProduk = b.IDProduk
    WHERE NamaProduk LIKE CONCAT('%', input, '%')
    GROUP BY a.NamaProduk;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS GetAverageReviewByProductName;

CALL GetAverageReviewByProductName ('Fidget Box');

/*SOAL 12 : Buatlah stored procedure dengan nama 'search_shop', menerima inputan/parameter nama toko atau nama owner
yang berfungsi untuk menampilkan data toko sesuai dengan toko/owner yang diinput*/

DELIMITER $$
CREATE PROCEDURE search_shop (IN input VARCHAR(255))
BEGIN
	SELECT * FROM TrShop WHERE NamaToko LIKE CONCAT('%', input, '%') OR Pemilik LIKE CONCAT('%', input, '%');
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS search_shop;

CALL search_shop('Nao');

/*SOAL 13 : Buatlah stored procedure yang bernama 'GetTotalStockAndSoldProduct', tidak menerima input/parameter 
yang berfungsi untuk menampikan seluruh detail produk dan [total stock + sold] = total stock product + jumlah produk 
tersebut yang telah dijual*/
DELIMITER $$
CREATE PROCEDURE GetTotalStockAndSoldProduct ()
BEGIN
	SELECT a.IDProduk, a.IDShop, a.NamaProduk, a.Harga, SUM(a.Stok + b.Qty) AS 'Total Stock + Sold' 
    FROM MsProduct AS a 
    JOIN TrTransaction AS b ON a.IDProduk = b.IDProduk
    GROUP BY a.IDProduk;
END$$
DELIMITER ;

DROP PROCEDURE GetTotalStockAndSoldProduct;

CALL GetTotalStockAndSoldProduct();

/*SOAL 14 : Buatlah  Stored Procedure dengan nama 'CountProductInCustomerCart' yang menerima parameter nama produk
dan [count customer] = jumlah customer yang menampilkan produk tersebut di cart customer*/
DELIMITER $$
CREATE PROCEDURE CountProductInCustomerCart(IN Name VARCHAR(255))
BEGIN
    SELECT b.NamaProduk, COALESCE(a.CountCustomer, 0) AS 'Count Customer'
    FROM (
        SELECT IDProduk, COUNT(IDCustomer) AS CountCustomer
        FROM TrCart
        GROUP BY IDProduk
    ) a
    RIGHT JOIN MsProduct b ON a.IDProduk = b.IDProduk
    WHERE b.NamaProduk = Name;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS CountProductInCustomerCart;

CALL CountProductInCustomerCart('Door');

SELECT * FROM msproduct WHERE IDProduk = 25;

SELECT IDProduk, COUNT(IDProduk)
FROM trcart
GROUP BY IDProduk
ORDER BY COUNT(IDProduk) DESC;

/*SOAL 15 : Buatlah stored procedure yang bernama 'CalculateCustomerPoint' yang menerima input/parameter nama customer
, yang berfungsi untuk memberikan point ke customer yang telah menghabiskan uang untuk berbelanja dengan ketentuan berikut :
NOTE : 1. Apabila customer menghabiskan < Rp. 100,000 maka dia mendapat 0 point
	   2. Apabila customer menghabiskan Rp. 100,000 - Rp. 499,000 maka mendapat poin 20
       3. Apabila customer menghabiskan Rp. 500,000 - Rp. 999,000 maka mendapat poin 50
       4. Apabila customer menghabiskan > Rp. 1,000,000 maka mendapat poin 100*/

DELIMITER $$
CREATE PROCEDURE CalculateCustomerPoint(IN Customer_Name VARCHAR(255))
BEGIN
DECLARE Total_Spending BIGINT;

SET Total_Spending = (SELECT SUM(TotalHarga) FROM TrTransaction a JOIN TrCustomer b ON a.IDCustomer = b.IDCustomer WHERE Nama = Customer_Name GROUP BY a.IDCustomer);

SELECT CASE
  WHEN Total_Spending < 100000 OR Total_Spending IS NULL THEN 0
  WHEN Total_Spending >= 100000 AND Total_Spending < 500000 THEN 20
  WHEN Total_Spending >= 500000 AND Total_Spending < 1000000 THEN 50 -- <= 999999
  ELSE 100
END AS Point;
END$$
DELIMITER ;

DROP PROCEDURE IF  EXISTS CalculateCustomerPoint;
SELECT * FROM trcustomer;

CALL CalculateCustomerPoint('Christiana Willis Cockle');

/* QUERY BUAT TESTING */
SELECT SUM(TotalHarga)
FROM TrCustomer a
JOIN TrTransaction b ON a.IDCustomer = b.IDCustomer
WHERE Nama = 'Christiana Willis Cockle'
GROUP BY Nama;

/* ================= */

SELECT * FROM TrTransaction;
SELECT * FROM TrCustomer;