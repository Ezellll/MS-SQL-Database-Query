-- 1) Customers isimli bir veritabaný oluþturunuz.
CREATE DATABASE CUSTOMERS

-- Date bilgisi içeren verilerden saat bilgisini çýkartma.
ALTER TABLE [dbo].[flo_data_20K]
ALTER COLUMN [first_order_date] DATE

ALTER TABLE [dbo].[flo_data_20K]
ALTER COLUMN [last_order_date] DATE

ALTER TABLE [dbo].[flo_data_20K]
ALTER COLUMN [last_order_date_online] DATE

ALTER TABLE [dbo].[flo_data_20K]
ALTER COLUMN [last_order_date_offline] DATE

SELECT * FROM [dbo].[flo_data_20K]

-- 2) Toplam yapýlan ciroyu gtericek sorguyu yapýnýz

SELECT 
SUM(customer_value_total_ever_offline+customer_value_total_ever_online) TOPLAM_CIRO
FROM [dbo].[flo_data_20K]

-- 3 ) Fatura baþýna yapýlan ortalama ciroyu getirecek sorguyu yazýnýz

-- FATURA BÝLGÝSÝ OLMADIÐI ÝÇÝN HER SÝPARÝÞÝ FATURA OLARAK ALARAK
-- FATURA BAÞINA ORTALAMA CÝRO HESAPLANDI
SELECT 
[master_id] KULLANICI_ID ,
(SUM([customer_value_total_ever_offline]+[customer_value_total_ever_online])/
(SUM([order_num_total_ever_online]+[order_num_total_ever_offline]))) FATURA_BASI_ORTALAMA_CIRO
FROM [dbo].[flo_data_20K]
GROUP BY [master_id]

-- 4) Son alýþveriþ platformlarý üzerinden yapýlan alýþveriþlerin toplam ciro daðýlýmlarýný getirecek sorguyu yazýnýz.

SELECT 
[last_order_channel] PLATFORM_,
SUM([customer_value_total_ever_offline]+[customer_value_total_ever_online]) CIRO
FROM [dbo].[flo_data_20K]
GROUP BY [last_order_channel]


-- 5)  Toplam yapýlan fatura adedini getirecek sorguyu yazýnýz.

-- VERÝSETÝ ÝÇERÝSÝNDE FATURA BÝLGÝSÝ BULUNMADIÐI ÝÇÝN
-- HERSÝPARÝÞE FATURA OLUÞTURULDUÐU BÝLGÝSÝ ÝLE DEVAM EDÝLDÝ
SELECT 
SUM([order_num_total_ever_online]+[order_num_total_ever_offline]) FATURA_ADEDI
FROM [dbo].[flo_data_20K]

-- 6) Alýþveriþ yapanlarýn son alýþveriþ yaptýklarý platform daðýlýmlarýný fatura cinsinden getirecek sorguyu yazýnýz.

SELECT 
[last_order_channel] PLATFORM_,SUM([order_num_total_ever_online]+[order_num_total_ever_offline]) KACFATURAKESILDIGI
FROM [dbo].[flo_data_20K]
GROUP BY [last_order_channel]

-- 7) Toplam yapýlan ürün satýþ miktarýný getirecek sorguyu yazýnýz.
SELECT 
SUM([order_num_total_ever_online]+[order_num_total_ever_online]) TOPLAM_YAPILAN_URUN_SATIS
FROM [dbo].[flo_data_20K]

-- 8)  Yýl kýrýlýmýnda ürün adetlerini getirecek sorguyu yazýnýz.
SELECT 
DATEPART(YEAR,[first_order_date]) ILKALISVERIS,
SUM([order_num_total_ever_online]+[order_num_total_ever_online]) URUNADEDI
FROM [dbo].[flo_data_20K]
GROUP BY DATEPART(YEAR,[first_order_date])

SELECT
DATEPART(YEAR,[last_order_date]) SONALISVERIS,
SUM([order_num_total_ever_online]+[order_num_total_ever_online]) URUNADEDI
FROM [dbo].[flo_data_20K]
GROUP BY DATEPART(YEAR,[last_order_date])

-- 9) Platform kýrýlýmýnda ürün adedi ortalamasýný getirecek sorguyu yazýnýz.
--ÜRÜN ADADEDÝ BÝLGÝSÝ YOK
SELECT 
[order_channel] PLATFORM_,
AVG([order_num_total_ever_online]+[order_num_total_ever_online]) URUNADEDI_ORTALAMASI
FROM [dbo].[flo_data_20K]
GROUP BY [order_channel]

-- 10)  Kaç adet farklý kiþinin alýþveriþ yaptýðýný gösterecek sorguyu yazýnýz.

SELECT 
COUNT([master_id]) ESSIZ_KULLANICI_SAYISI
FROM [dbo].[flo_data_20K]

-- 11) Son 12 ayda en çok ilgi gören kategoriyi getiren sorguyu yazýnýz
-- SÝPARÝÞ SAYILARI BAZ ALINARAK ÝLGÝ DÜZEYÝNE GÖRE SIRALANDI

SELECT TOP 1
[interested_in_categories_12] KATEGORILER,
COUNT([interested_in_categories_12]) EN_COK_ILGI
FROM [dbo].[flo_data_20K]
GROUP BY [interested_in_categories_12]
ORDER BY EN_COK_ILGI DESC


-- 12) Kanal kýrýlýmýnda en çok ilgi gören kategorileri getiren sorguyu yazýnýz.

SELECT TOP 10
[order_channel],[interested_in_categories_12],
COUNT([interested_in_categories_12]) EN_COK_ILGI_GOREN
FROM [dbo].[flo_data_20K]
GROUP BY [order_channel],[interested_in_categories_12]
ORDER BY EN_COK_ILGI_GOREN DESC


-- 13)En çok tercih edilen store type’larý getiren sorguyu yazýnýz.
SELECT 
[store_type],
COUNT([store_type]) En_Çok_TerciH_Edilen_Store_Type
FROM [dbo].[flo_data_20K]
GROUP BY [store_type]
ORDER BY En_Çok_TerciH_Edilen_Store_Type DESC

-- 14)  Store type kýrýlýmýnda elde edilen toplam ciroyu getiren sorguyu yazýnýz.

SELECT
[store_type],
SUM([customer_value_total_ever_offline]+[customer_value_total_ever_online]) CIRO
FROM [dbo].[flo_data_20K]
GROUP BY [store_type]
ORDER BY CIRO DESC

-- 15) Kanal kýrýlýmýnda en çok ilgi gören strore type’ý getiren sorguyu yazýnýz.

SELECT TOP 4
[order_channel],[store_type],
COUNT([store_type]) En_Cok_TerciH_Edilen_Store_Type
FROM [dbo].[flo_data_20K]
GROUP BY [order_channel],[store_type]
ORDER BY En_Cok_TerciH_Edilen_Store_Type DESC



-- 16) En çok alýþveriþ yapan kiþinin ID’sini getiren sorguyu yazýnýz.

SELECT TOP 1
[master_id],
SUM([order_num_total_ever_online]+[order_num_total_ever_offline]) TOPLAMMUSTERISAYISI
FROM [dbo].[flo_data_20K]
GROUP BY [master_id]
ORDER BY TOPLAMMUSTERISAYISI DESC

-- 17) En çok alýþveriþ yapan kiþinin fatura baþý ortalamasýný getiren sarguyu yazýnýz.
-- Kullanýcý özelinde fatura bilgisi bulumadýðý için ortalama fatura hesaplanamaz

SELECT TOP 1
[master_id],
(SUM([customer_value_total_ever_offline]+[customer_value_total_ever_online])
/SUM([order_num_total_ever_online]+[order_num_total_ever_offline])) FATURA_BASI_ORTALAMA_HARCAMA
FROM [dbo].[flo_data_20K]
GROUP BY [master_id]
ORDER BY  SUM(order_num_total_ever_online + order_num_total_ever_offline) DESC


-- 18)En çok alýþveriþ yapan kiþinin alýþveriþ yapma gün ortalamasýný getiren sorguyu yazýnýz

SELECT TOP 1
[master_id],
(SUM([order_num_total_ever_online]+[order_num_total_ever_offline])/(DATEDIFF(DAY,first_order_date,last_order_date))) GUN_ORTALAMASI
FROM [dbo].[flo_data_20K]
GROUP BY [master_id],DATEPART(DAY,[first_order_date])
,DATEDIFF(DAY,first_order_date,last_order_date)
ORDER BY SUM(order_num_total_ever_online + order_num_total_ever_offline) DESC

SELECT TOP 1 master_id,
SUM(order_num_total_ever_online + order_num_total_ever_offline)/DATEDIFF(DAY,first_order_date,last_order_date) GUN_ORTALAMASI
FROM [dbo].[flo_data_20K]
GROUP BY master_id,DATEDIFF(DAY,first_order_date,last_order_date)
ORDER BY SUM(order_num_total_ever_online + order_num_total_ever_offline)


-- 19) En çok alýþveriþ yapan ilk 100 kiþinin (ciro bazýnda) alýþveriþ yapma gün ortalamasýný getiren sorguyu
-- yazýnýz.
SELECT TOP 100
[master_id],
(SUM(order_num_total_ever_online + order_num_total_ever_offline)/DATEDIFF(DAY,first_order_date,last_order_date)) GUN_ORTALAMASI
FROM [dbo].[flo_data_20K]
GROUP BY master_id,DATEDIFF(DAY,first_order_date,last_order_date)
ORDER BY SUM([customer_value_total_ever_offline]+[customer_value_total_ever_online]) DESC


-- 20)  Platfrom kýrýlýmýnda en çok alýþveriþ yapan müþteriyi getiren sorguyu yazýnýz.

SELECT TOP 1
[master_id],[order_channel],
SUM([order_num_total_ever_online]+[order_num_total_ever_offline]) TOPLAM_MUSTERI_SAYISI
FROM [dbo].[flo_data_20K]
GROUP BY [master_id],[order_channel]
ORDER BY TOPLAM_MUSTERI_SAYISI DESC

-- 21) En son alýþveriþ yapan kiþinin ID’sini getiren sorguyu yazýnýz. (Max son tarihte birden fazla alýþveriþ yapan ID 
--bulunmakta. Bunlarý da getiriniz.)

--1.yöntem
SELECT 
[master_id],MAX([last_order_date]) 
FROM [dbo].[flo_data_20K]
GROUP BY [master_id]
HAVING MAX([last_order_date]) = '2021-05-30'

--2.yöntem
SELECT [master_id], [last_order_date] 
FROM [dbo].[flo_data_20K] flo
WHERE flo.[last_order_date] = (SELECT MAX([last_order_date]) FROM [dbo].[flo_data_20K])



-- 22)  En son alýþveriþ yapan kiþinin alýþveriþ yapma gün ortalamasýný getiren sorguyu yazýnýz.


SELECT TOP 1
[master_id],[last_order_date],
(SUM([order_num_total_ever_online] +[order_num_total_ever_offline] )/(DATEDIFF(DAY, first_order_date, last_order_date)+0.01)) ORTALAMA
FROM [dbo].[flo_data_20K] flo
WHERE flo.last_order_date = (SELECT MAX(last_order_date) FROM [dbo].[flo_data_20K])
GROUP BY master_id, last_order_date,DATEDIFF(DAY, first_order_date, last_order_date)
ORDER BY DATEDIFF(DAY, first_order_date, last_order_date) DESC


--23) Platform kýrýlýmýnda en son alýþveriþ yapan kiþilerin fatura baþýna ortalamasýný getiren sorguyu yazýnýz.

SELECT TOP 4
[master_id],[order_channel],
(SUM([customer_value_total_ever_offline]+[customer_value_total_ever_online])/SUM([order_num_total_ever_online] +[order_num_total_ever_offline] )) FATURA_ORTALAMA
FROM [dbo].[flo_data_20K] flo
WHERE flo.last_order_date = (SELECT MAX(last_order_date) FROM [dbo].[flo_data_20K])
GROUP BY master_id, [order_channel]
ORDER BY FATURA_ORTALAMA DESC

--24)  Ýlk alýþveriþini yapan kiþinin ID’sini getiren sorguyu yazýnýz.

SELECT [master_id],[first_order_date]  FROM [dbo].[flo_data_20K] flo
WHERE flo.[first_order_date]= (SELECT MIN([first_order_date]) FROM [dbo].[flo_data_20K])

-- 25) Ýlk alýþveriþ yapan kiþinin alýþveriþ yapma gün ortalamasýný getiren sorguyu yazýnýz


SELECT [master_id], [first_order_date],
SUM([order_num_total_ever_online] + [order_num_total_ever_offline])/(DATEDIFF(DAY, [first_order_date], [last_order_date])+0.01) Alýþveriþ_Yapma_Gün_Ortalamasý
FROM [dbo].[flo_data_20K]
WHERE [first_order_date] = (SELECT MIN([first_order_date]) 
FROM [dbo].[flo_data_20K])
GROUP BY [master_id], [first_order_date],(DATEDIFF(DAY, [first_order_date], [last_order_date]))
ORDER BY Alýþveriþ_Yapma_Gün_Ortalamasý DESC