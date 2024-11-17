# Получение текущей даты
current_date=$(date +%Y%m%d_%H%M)

# Формирование пустые данные в файл
echo "DESCRIPTION;IP_TYPE;IPV4;IPV6;IP_MASK_TYPE;IPV4_MASK;IPV6_MASK;BEGIN_TIME;END_TIME;REGION_ID" > /home/boss/COPM/files/IP_PLAN_$current_date.txt

# Формирование MySQL-запроса с выводом в файл
echo "
SELECT 
    'DESCRIPTION',
    'IP_TYPE',
    'IPV4',
    'IPV6',
    'IP_MASK_TYPE',
    'IPV4_MASK',
    'IPV6_MASK',
    'BEGIN_TIME',
    'END_TIME',
    'REGION_ID'                        
UNION ALL
SELECT 
    n.name AS DESCRIPTION, 
    0 AS IP_TYPE,
    CONCAT(LPAD(HEX(SUBSTRING_INDEX(SUBSTRING_INDEX(n.mask_net, '/', 1), '.', 1)*1), 2, 0),
    LPAD(HEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(n.mask_net, '/', 1), '.', 2), '.', -1)*1), 2, 0),
    LPAD(HEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(n.mask_net, '/', 1), '.', 3), '.', 3), '.', -1)*1), 2, 0),
    LPAD(HEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(n.mask_net, '/', 1), '.', 4), '.', 4), '.', 4), '.', -1)*1), 2, 0)) AS IPV4,
    '' AS IPV6,
    0 AS IP_MASK_TYPE,                      
    'FFFFFF00' AS IPV4_MASK,                       
    '' AS IPV6_MASK,                   
    '2022-03-01 00:00:00' AS BEGIN_TIME,
    '2049-12-31 23:59:59' AS END_TIME,        
    6 AS REGION_ID
INTO OUTFILE '/home/boss/COPM/files/IP_PLAN_$current_date.txt'
FIELDS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY ''
LINES TERMINATED BY '\n'
FROM 
    networks n
;" > /home/user/COPM/query.sql

# Выполнение завроса в базе данных
mysql -u bitfan -p prim_billing < /var/lib/mysql-files/query.sql

# Перенос файлов, подчищаем за собой
mv -f /var/lib/mysql-files/IP_PLAN* /home/user/COPM/files
rm -f /var/lib/mysql-files/query.sql
