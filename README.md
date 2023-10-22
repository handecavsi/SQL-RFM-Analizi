# SQL-RFM-Analizi


**RFM Analizi:**

RFM; Recency, Frequency, Monetary kelimelerinin baş harflerinden oluşur.

- Recency; Müşterinin son alışveriş tarihinin üzerinden geçen gün sayısını ifade eder.
- Frequency; müşterinin ne sıklıkla alışveriş yaptığını ifade eder.
- Monetary; Müşterilerin yaptığı harcamaların toplam tutarını ifade eder.

- RFM Analizi belirli kriterlere göre müşteriye özel kampanyalar hazırlamak için kullanılır.

Bu projede; e-commerce dataset'i kullanılarak; PosrgreSQL üzerinde RFM analizi yapılmıştır.
İlgili SQL sorguları RFM.sql dosyası içerisindedir.

e-commerce dataset link: https://www.kaggle.com/datasets/carrie1/ecommerce-data

_Veri setini import etmek için kullanılan komut:_

    COPY ecommerce (invoice_no,stock_code,description,quantity,invoice_date,unit_price,customer_id,country)
    FROM '/Library/PostgreSQL/15/e-commerce.csv' WITH (FORMAT CSV, DELIMITER ',', ENCODING 'WIN1252', HEADER);

Not: RFM_example.sql dosyası travel veri tabanındaki booking tablosu üzerinden yapılmıştır.
Travel veri tabanındaki veri setlerine aşağıdaki linkten ulaşılabilir:

https://github.com/handecavsi/SQL-modul

