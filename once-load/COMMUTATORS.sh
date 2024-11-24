# Получение текущей даты
current_date=$(date +%Y%m%d_%H%M)

# Формирование MySQL-запроса с выводом в файл

echo "
SELECT
    'SWITCH_ID', 
    'BEGIN_TIME',      
    'END_TIME',        
    'DESCRIPTION',                    
    'NETWORK_TYPE',                      
    'SWITCH_TYPE',                       
    'ADDRESS_TYPE_ID',                   
    'ADDRESS_TYPE',                      
    'ZIP',                                
    'COUNTRY',        
    'REGION',             
    'ZONE',              
    'CITY',                   
    'STREET',                     
    'BUILDING',                        
    'BUILD_SECT',                    
    'APARTMENT',                        
    'UNSTRUCT_INFO',                    
    'SWITCH_SIGN',                       
    'REGION_ID'                        
UNION ALL
SELECT 
    d.id AS SWITCH_ID, 
    '2022-03-01 00:00:00' AS BEGIN_TIME,      -- Указанная дата начала
    '2049-12-31 23:59:00' AS END_TIME,        -- Указанная дата окончания
    d.description AS DESCRIPTION,                    -- Используем поле name для описания
    4 AS NETWORK_TYPE,                      
    d.description AS SWITCH_TYPE,                       
    0 AS ADDRESS_TYPE_ID,                   
    1 AS ADDRESS_TYPE,                      
    '' AS ZIP,                                -- Пустое значение для ZIP
    '' AS COUNTRY,        -- Статическое значение для страны
    '' AS REGION,             -- Статическое значение для региона
    '' AS ZONE,              -- Статическое значение для зоны
    '' AS CITY,                   -- Статическое значение для города
    '' AS STREET,                     -- Статическое значение для улицы
    '' AS BUILDING,                        -- Статическое значение для здания
    '' AS BUILD_SECT,                    -- Статическое значение для секции здания
    '' AS APARTMENT,                        -- Пустое значение для квартиры
    d.unstruct_info AS UNSTRUCT_INFO,                    -- Пустое значение для дополнительной информации
    '' AS SWITCH_SIGN,                       
    6 AS REGION_ID                        -- Статическое значение для региона
INTO OUTFILE '/var/lib/mysql-files/COMMUTATORS_$current_date.txt'
FIELDS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY ''
LINES TERMINATED BY '\n'
FROM 
  devices d
WHERE d.type IN (1, 2, 3, 10, 11, 12);
" > /var/lib/mysql-files/query.sql

# Выполнение завроса в базе данных
mysql -u bitfan -p prim_billing < /var/lib/mysql-files/query.sql

# Перенос файлов, подчищаем за собой
mv -f /var/lib/mysql-files/COMMUTATORS* /home/user/COPM/files
rm -f /var/lib/mysql-files/query.sql
