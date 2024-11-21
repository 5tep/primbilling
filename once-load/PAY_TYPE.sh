# Получение текущей даты
current_date=$(date +%Y%m%d_%H%M)

# Формирование MySQL-запроса с выводом в файл

echo "
SELECT 
    'ID',
    'BEGIN_TIME',
    'END_TIME',
    'DESCRIPTION',
    'REGION_ID'
UNION ALL
SELECT 
    id AS ID, 
    '2022-12-31 23:59:00' AS BEGIN_TIME, 
    '2049-12-31 23:59:00' AS END_TIME,
    name AS DESCRIPTION,
    6 AS REGION_ID    
INTO OUTFILE '/home/boss/COPM/files/PAY_TYPE_$current_date.txt'
FIELDS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY ''
LINES TERMINATED BY '\n'
FROM 
    kassa_type;
" > /var/lib/mysql-files/query.sql

# Выполнение завроса в базе данных
mysql -u bitfan -p prim_billing < /var/lib/mysql-files/query.sql

# Перенос файлов, подчищаем за собой
mv -f /var/lib/mysql-files/PAY_TYPE* /home/user/COPM/files
rm -f /var/lib/mysql-files/query.sql
