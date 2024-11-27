# Получение текущей даты
current_date=$(date +%Y%m%d_%H%M)

# Формирование MySQL-запроса с выводом в файл

echo "
SELECT 
    'ABONENT_ID', 
    'REGION_ID', 
    'ID', 
    'BEGIN_TIME', 
    'END_TIME', 
    'PARAMETER', 
    'INTERNAL_ID1', 
    'INTERNAL_ID2'
UNION ALL
SELECT 
    u.id AS ABONENT_ID, 
    6 AS REGION_ID, 
    s.id AS ID, 
    CONCAT(s.datetime_start, ' 00:00:00') AS BEGIN_TIME, 
    '2049-12-31 23:59:00' AS END_TIME, 
    s.summa AS PARAMETER, 
    u.id AS INTERNAL_ID1, 
    u.id AS INTERNAL_ID2
INTO OUTFILE '/var/lib/mysql-files/ABONENT_SERVICE_$current_date.txt'
FIELDS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY ''
LINES TERMINATED BY '\n'
FROM 
  services_used s, cms_operators u
WHERE u.id = s.user and s.datetime_stop = '0000-00-00' and s.packet not in (64, 27, 10);
" > /var/lib/mysql-files/query.sql

# Выполнение завроса в базе данных
mysql -u bitfan -p prim_billing < /var/lib/mysql-files/query.sql

# Перенос файлов, подчищаем за собой
mv -f /var/lib/mysql-files/ABONENT_SERVICE* /home/user/COPM/files
rm -f /var/lib/mysql-files/query.sql
