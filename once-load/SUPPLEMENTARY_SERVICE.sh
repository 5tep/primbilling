# Получение текущей даты
current_date=$(date +%Y%m%d_%H%M)

# Формирование MySQL-запроса с выводом в файл

echo "
SELECT 
    'ID' AS ID,
    'MNEMONIC' AS MNEMONIC,
    'BEGIN_TIME' AS BEGIN_TIME,
    'END_TIME' AS END_TIME,
    'DESCRIPTION' AS DESCRIPTION,
    'REGION_ID' AS REGION_ID
UNION ALL
SELECT 
    s.id AS ID,
    s.packet_name AS MNEMONIC,
    s.datetime_start AS BEGIN_TIME,
    '2049-12-31 23:59:59' AS END_TIME,
    s.packet_name AS DESCRIPTION,
    6 AS REGION_ID2
INTO OUTFILE '/var/lib/mysql-files/SUPPLEMENTARY_SERVICE_$current_date.txt'
FIELDS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY ''
LINES TERMINATED BY '\n'
FROM 
  services_used s
WHERE s.datetime_stop = '0000-00-00' and s.paket not in (64, 27, 10);
" > /var/lib/mysql-files/query.sql

# Выполнение завроса в базе данных
mysql -u bitfan -p prim_billing < /var/lib/mysql-files/query.sql

# Перенос файлов, подчищаем за собой
mv -f /var/lib/mysql-files/SUPPLEMENTARY_SERVICE* /home/user/COPM/files
rm -f /var/lib/mysql-files/query.sql
