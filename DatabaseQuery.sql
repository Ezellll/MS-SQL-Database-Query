-- 1) Customers isimli bir veritaban� olu�turunuz.
CREATE DATABASE CUSTOMERS

-- Date bilgisi i�eren verilerden saat bilgisini ��kartma.
ALTER TABLE [dbo].[flo_data_20K]
ALTER COLUMN [first_order_date] DATE

ALTER TABLE [dbo].[flo_data_20K]
ALTER COLUMN [last_order_date] DATE

ALTER TABLE [dbo].[flo_data_20K]
ALTER COLUMN [last_order_date_online] DATE

ALTER TABLE [dbo].[flo_data_20K]
ALTER COLUMN [last_order_date_offline] DATE

SELECT * FROM [dbo].[flo_data_20K]

-- 2) Toplam yap�lan ciroyu gtericek sorguyu yap�n�z

SELECT 
SUM(customer_value_total_ever_offline+customer_value_total_ever_online) TOPLAM_CIRO
FROM [dbo].[flo_data_20K]

-- 3 ) Fatura ba��na yap�lan ortalama ciroyu getirecek sorguyu yaz�n�z

-- FATURA B�LG�S� OLMADI�I ���N HER S�PAR��� FATURA OLARAK ALARAK
-- FATURA BA�INA ORTALAMA C�RO HESAPLANDI
SELECT 
[master_id] KULLANICI_ID ,
(SUM([customer_value_total_ever_offline]+[customer_value_total_ever_online])/
(SUM([order_num_total_ever_online]+[order_num_total_ever_offline]))) FATURA_BASI_ORTALAMA_CIRO
FROM [dbo].[flo_data_20K]
GROUP BY [master_id]

-- 4) Son al��veri� platformlar� �zerinden yap�lan al��veri�lerin toplam ciro da��l�mlar�n� getirecek sorguyu yaz�n�z.

SELECT 
[last_order_channel] PLATFORM_,
SUM([customer_value_total_ever_offline]+[customer_value_total_ever_online]) CIRO
FROM [dbo].[flo_data_20K]
GROUP BY [last_order_channel]


-- 5)  Toplam yap�lan fatura adedini getirecek sorguyu yaz�n�z.

-- VER�SET� ��ER�S�NDE FATURA B�LG�S� BULUNMADI�I ���N
-- HERS�PAR��E FATURA OLU�TURULDU�U B�LG�S� �LE DEVAM ED�LD�
SELECT 
SUM([order_num_total_ever_online]+[order_num_total_ever_offline]) FATURA_ADEDI
FROM [dbo].[flo_data_20K]

-- 6) Al��veri� yapanlar�n son al��veri� yapt�klar� platform da��l�mlar�n� fatura cinsinden getirecek sorguyu yaz�n�z.

SELECT 
[last_order_channel] PLATFORM_,SUM([order_num_total_ever_online]+[order_num_total_ever_offline]) KACFATURAKESILDIGI
FROM [dbo].[flo_data_20K]
GROUP BY [last_order_channel]

-- 7) Toplam yap�lan �r�n sat�� miktar�n� getirecek sorguyu yaz�n�z.
SELECT 
SUM([order_num_total_ever_online]+[order_num_total_ever_online]) TOPLAM_YAPILAN_URUN_SATIS
FROM [dbo].[flo_data_20K]

-- 8)  Y�l k�r�l�m�nda �r�n adetlerini getirecek sorguyu yaz�n�z.
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

-- 9) Platform k�r�l�m�nda �r�n adedi ortalamas�n� getirecek sorguyu yaz�n�z.
--�R�N ADADED� B�LG�S� YOK
SELECT 
[order_channel] PLATFORM_,
AVG([order_num_total_ever_online]+[order_num_total_ever_online]) URUNADEDI_ORTALAMASI
FROM [dbo].[flo_data_20K]
GROUP BY [order_channel]

-- 10)  Ka� adet farkl� ki�inin al��veri� yapt���n� g�sterecek sorguyu yaz�n�z.

SELECT 
COUNT([master_id]) ESSIZ_KULLANICI_SAYISI
FROM [dbo].[flo_data_20K]

-- 11) Son 12 ayda en �ok ilgi g�ren kategoriyi getiren sorguyu yaz�n�z
-- S�PAR�� SAYILARI BAZ ALINARAK �LG� D�ZEY�NE G�RE SIRALANDI

SELECT TOP 1
[interested_in_categories_12] KATEGORILER,
COUNT([interested_in_categories_12]) EN_COK_ILGI
FROM [dbo].[flo_data_20K]
GROUP BY [interested_in_categories_12]
ORDER BY EN_COK_ILGI DESC


-- 12) Kanal k�r�l�m�nda en �ok ilgi g�ren kategorileri getiren sorguyu yaz�n�z.

SELECT TOP 10
[order_channel],[interested_in_categories_12],
COUNT([interested_in_categories_12]) EN_COK_ILGI_GOREN
FROM [dbo].[flo_data_20K]
GROUP BY [order_channel],[interested_in_categories_12]
ORDER BY EN_COK_ILGI_GOREN DESC


-- 13)En �ok tercih edilen store type�lar� getiren sorguyu yaz�n�z.
SELECT 
[store_type],
COUNT([store_type]) En_�ok_TerciH_Edilen_Store_Type
FROM [dbo].[flo_data_20K]
GROUP BY [store_type]
ORDER BY En_�ok_TerciH_Edilen_Store_Type DESC

-- 14)  Store type k�r�l�m�nda elde edilen toplam ciroyu getiren sorguyu yaz�n�z.

SELECT
[store_type],
SUM([customer_value_total_ever_offline]+[customer_value_total_ever_online]) CIRO
FROM [dbo].[flo_data_20K]
GROUP BY [store_type]
ORDER BY CIRO DESC

-- 15) Kanal k�r�l�m�nda en �ok ilgi g�ren strore type�� getiren sorguyu yaz�n�z.

SELECT TOP 4
[order_channel],[store_type],
COUNT([store_type]) En_Cok_TerciH_Edilen_Store_Type
FROM [dbo].[flo_data_20K]
GROUP BY [order_channel],[store_type]
ORDER BY En_Cok_TerciH_Edilen_Store_Type DESC



-- 16) En �ok al��veri� yapan ki�inin ID�sini getiren sorguyu yaz�n�z.

SELECT TOP 1
[master_id],
SUM([order_num_total_ever_online]+[order_num_total_ever_offline]) TOPLAMMUSTERISAYISI
FROM [dbo].[flo_data_20K]
GROUP BY [master_id]
ORDER BY TOPLAMMUSTERISAYISI DESC

-- 17) En �ok al��veri� yapan ki�inin fatura ba�� ortalamas�n� getiren sarguyu yaz�n�z.
-- Kullan�c� �zelinde fatura bilgisi bulumad��� i�in ortalama fatura hesaplanamaz

SELECT TOP 1
[master_id],
(SUM([customer_value_total_ever_offline]+[customer_value_total_ever_online])
/SUM([order_num_total_ever_online]+[order_num_total_ever_offline])) FATURA_BASI_ORTALAMA_HARCAMA
FROM [dbo].[flo_data_20K]
GROUP BY [master_id]
ORDER BY  SUM(order_num_total_ever_online + order_num_total_ever_offline) DESC


-- 18)En �ok al��veri� yapan ki�inin al��veri� yapma g�n ortalamas�n� getiren sorguyu yaz�n�z

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


-- 19) En �ok al��veri� yapan ilk 100 ki�inin (ciro baz�nda) al��veri� yapma g�n ortalamas�n� getiren sorguyu
-- yaz�n�z.
SELECT TOP 100
[master_id],
(SUM(order_num_total_ever_online + order_num_total_ever_offline)/DATEDIFF(DAY,first_order_date,last_order_date)) GUN_ORTALAMASI
FROM [dbo].[flo_data_20K]
GROUP BY master_id,DATEDIFF(DAY,first_order_date,last_order_date)
ORDER BY SUM([customer_value_total_ever_offline]+[customer_value_total_ever_online]) DESC


-- 20)  Platfrom k�r�l�m�nda en �ok al��veri� yapan m��teriyi getiren sorguyu yaz�n�z.

SELECT TOP 1
[master_id],[order_channel],
SUM([order_num_total_ever_online]+[order_num_total_ever_offline]) TOPLAM_MUSTERI_SAYISI
FROM [dbo].[flo_data_20K]
GROUP BY [master_id],[order_channel]
ORDER BY TOPLAM_MUSTERI_SAYISI DESC

-- 21) En son al��veri� yapan ki�inin ID�sini getiren sorguyu yaz�n�z. (Max son tarihte birden fazla al��veri� yapan ID 
--bulunmakta. Bunlar� da getiriniz.)

--1.y�ntem
SELECT 
[master_id],MAX([last_order_date]) 
FROM [dbo].[flo_data_20K]
GROUP BY [master_id]
HAVING MAX([last_order_date]) = '2021-05-30'

--2.y�ntem
SELECT [master_id], [last_order_date] 
FROM [dbo].[flo_data_20K] flo
WHERE flo.[last_order_date] = (SELECT MAX([last_order_date]) FROM [dbo].[flo_data_20K])



-- 22)  En son al��veri� yapan ki�inin al��veri� yapma g�n ortalamas�n� getiren sorguyu yaz�n�z.


SELECT TOP 1
[master_id],[last_order_date],
(SUM([order_num_total_ever_online] +[order_num_total_ever_offline] )/(DATEDIFF(DAY, first_order_date, last_order_date)+0.01)) ORTALAMA
FROM [dbo].[flo_data_20K] flo
WHERE flo.last_order_date = (SELECT MAX(last_order_date) FROM [dbo].[flo_data_20K])
GROUP BY master_id, last_order_date,DATEDIFF(DAY, first_order_date, last_order_date)
ORDER BY DATEDIFF(DAY, first_order_date, last_order_date) DESC


--23) Platform k�r�l�m�nda en son al��veri� yapan ki�ilerin fatura ba��na ortalamas�n� getiren sorguyu yaz�n�z.

SELECT TOP 4
[master_id],[order_channel],
(SUM([customer_value_total_ever_offline]+[customer_value_total_ever_online])/SUM([order_num_total_ever_online] +[order_num_total_ever_offline] )) FATURA_ORTALAMA
FROM [dbo].[flo_data_20K] flo
WHERE flo.last_order_date = (SELECT MAX(last_order_date) FROM [dbo].[flo_data_20K])
GROUP BY master_id, [order_channel]
ORDER BY FATURA_ORTALAMA DESC

--24)  �lk al��veri�ini yapan ki�inin ID�sini getiren sorguyu yaz�n�z.

SELECT [master_id],[first_order_date]  FROM [dbo].[flo_data_20K] flo
WHERE flo.[first_order_date]= (SELECT MIN([first_order_date]) FROM [dbo].[flo_data_20K])

-- 25) �lk al��veri� yapan ki�inin al��veri� yapma g�n ortalamas�n� getiren sorguyu yaz�n�z


SELECT [master_id], [first_order_date],
SUM([order_num_total_ever_online] + [order_num_total_ever_offline])/(DATEDIFF(DAY, [first_order_date], [last_order_date])+0.01) Al��veri�_Yapma_G�n_Ortalamas�
FROM [dbo].[flo_data_20K]
WHERE [first_order_date] = (SELECT MIN([first_order_date]) 
FROM [dbo].[flo_data_20K])
GROUP BY [master_id], [first_order_date],(DATEDIFF(DAY, [first_order_date], [last_order_date]))
ORDER BY Al��veri�_Yapma_G�n_Ortalamas� DESC