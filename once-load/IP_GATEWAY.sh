# Получение текущей даты
current_date=$(date +%Y%m%d_%H%M)

# Формирование MySQL-запроса с выводом в файл

echo "
SELECT 
   'GATE_ID',
   'IP_TYPE',
   'IPV4',
   'IPV6',
   'IP_PORT',
  'REGION_ID'                     
UNION ALL
SELECT 
    d.id AS GATE_ID, 
    0 AS IP_TYPE,
    CONCAT(LPAD(HEX(SUBSTRING_INDEX(h.ip, '.', 1)*1), 2, 0),
    LPAD(HEX(SUBSTRING_INDEX(SUBSTRING_INDEX(h.ip, '.', 2), '.', -1)*1), 2, 0),
    LPAD(HEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(h.ip, '.', 3), '.', 3), '.', -1)*1), 2, 0),
    LPAD(HEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(h.ip, '.', 4), '.', 4), '.', 4), '.', -1)*1), 2, 0)) AS IPV4,
    '' AS IPV6,
    h.port AS IP_PORT,
    6 AS REGION_ID                        -- Статическое значение для региона
INTO OUTFILE '/var/lib/mysql-files/IP_GATEWAY_$current_date.txt'
FIELDS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY ''
LINES TERMINATED BY '\n'
FROM 
  hosts h, devices d, device_type dt
WHERE h.device = d.id AND d.type = dt.id AND dt.id = 13;
" > /var/lib/mysql-files/query.sql

# Выполнение завроса в базе данных
mysql -u bitfan -p prim_billing < /var/lib/mysql-files/query.sql

# Перенос файлов, подчищаем за собой
mv -f /var/lib/mysql-files/IP_GATEWAY* /home/user/COPM/files
rm -f /var/lib/mysql-files/query.sql
