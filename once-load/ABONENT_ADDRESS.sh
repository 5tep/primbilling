# Получение текущей даты
current_date=$(date +%Y%m%d_%H%M)

# Формирование MySQL-запроса с выводом в файл

echo "SELECT 
    'ABONENT_ID',
    'REGION_ID',
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
    'BEGIN_TIME',
    'END_TIME',
    'INTERNAL_ID1',
    'INTERNAL_ID2'
UNION ALL
SELECT DISTINCT 
    u.id AS ABONENT_ID,
    6 AS REGION_ID,
    0 AS ADDRESS_TYPE_ID,  -- Фиксированное значение
    1 AS ADDRESS_TYPE,     -- Фиксированное значение
    '' AS ZIP,             -- Пустое поле, значение не указано
    '' AS COUNTRY,  -- Статическое значение для страны
    '' AS REGION,    -- Регион из таблицы улиц
    '' AS ZONE,            -- Пустое поле, значение не указано
    '' AS CITY,  -- Статическое значение для города
    '' AS STREET,  -- Название улицы из таблицы p_street
    '' AS BUILDING,  -- Номер здания из таблицы dopvalues
    '' AS BUILD_SECT,  -- Секция здания из таблицы dopvalues
    '' AS APARTMENT,  -- Номер квартиры из таблицы dopvalues
    u.propiska AS UNSTRUCT_INFO,  -- Адрес как неструктурированное поле
    s.datetime_start AS BEGIN_TIME,  
    '2049-12-31 23:59:00' AS END_TIME,    -- Фиксированное значение
    u.id AS INTERNAL_ID1,   -- Пустое поле
    u.id AS INTERNAL_ID2    -- Пустое поле
INTO OUTFILE '/var/lib/mysql-files/ABONENT_ADDRESS_$current_date.txt'
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
mv -f /var/lib/mysql-files/ABONENT_ADDRESS* /home/user/COPM/files
rm -f /var/lib/mysql-files/query.sql
