# Получение текущей даты
current_date=$(date +%Y%m%d_%H%M)

# Формирование MySQL-запроса с выводом в файл

echo "
SELECT 
  'GATE_ID',
  'BEGIN_TIME',
  'END_TIME',
  'DESCRIPTION',
  'GATE_TYPE',
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
  'REGION_ID'                     
UNION ALL
SELECT 
    d.id AS GATE_ID, 
    '2022-03-01 00:00:00' AS BEGIN_TIME,      -- Указанная дата начала
    '2049-12-31 23:59:00' AS END_TIME,        -- Указанная дата окончания
    d.description AS DESCRIPTION,                    -- Используем поле name для описания
    4 AS GATE_TYPE,                                     
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
    CASE WHEN d.unstruct_info = ''
      THEN d.address 
      ELSE d.unstruct_info
      END AS UNSTRUCT_INFO,           
    6 AS REGION_ID                        -- Статическое значение для региона
INTO OUTFILE '/var/lib/mysql-files/GATEWAYS_$current_date.txt'
FIELDS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY ''
LINES TERMINATED BY '\n'
FROM 
  devices d, devices dt
WHERE d.type = dt.id AND dt.id = 13;
" > /var/lib/mysql-files/query.sql

# Выполнение завроса в базе данных
mysql -u bitfan -p prim_billing < /var/lib/mysql-files/query.sql

# Перенос файлов, подчищаем за собой
mv -f /var/lib/mysql-files/GATEWAYS* /home/user/COPM/files
rm -f /var/lib/mysql-files/query.sql
