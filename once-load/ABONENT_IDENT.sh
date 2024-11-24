# Получение текущей даты
current_date=$(date +%Y%m%d_%H%M)

# Формирование MySQL-запроса с выводом в файл

echo "
SELECT 
    'ABONENT_ID', 'REGION_ID', 'IDENT_TYPE', 'PHONE', 'INTERNAL_NUMBER', 'IMSI', 'IMEI', 'ICC', 'MIN', 'ESN', 
    'EQUIPMENT_TYPE', 'MAC', 'VPI', 'VCI', 'LOGIN', 'E_MAIL', 'PIN', 'USER_DOMAIN', 'RESERVED', 
    'ORIGINATOR_NAME', 'IP_TYPE', 'IPV4', 'IPV6', 'IP_MASK_TYPE', 'IPV4_MASK', 'IPV6_MASK', 
    'IP_RANGE_START', 'IP_RANGE_END', 'INTERNAL_ID1', 'INTERNAL_ID2', 'BEGIN_TIME', 'END_TIME', 
    'LINE_OBJECT', 'LINE_CROSS', 'LINE_BLOCK', 'LINE_PAIR', 'LINE_RESERVED', 'LOC_TYPE', 
    'LOC_LAC', 'LOC_CELL', 'LOC_TA', 'LOC_CELL_WIRELESS', 'LOC_MAC', 'LOC_LATITUDE', 'LOC_LONGITUDE', 
    'LOC_PROJECTION_TYPE', 'LOC_IP_TYPE', 'LOC_IPV4', 'LOC_IPV6', 'LOC_IP_PORT'
UNION ALL
SELECT 
    u.id AS ABONENT_ID, 
    6 AS REGION_ID, -- Статическое значение региона
    5 AS IDENT_TYPE, -- Статическое значение идентификационного типа
    '' AS PHONE, -- Поле пустое
    '' AS INTERNAL_NUMBER, -- Поле пустое
    '' AS IMSI, -- Поле пустое
    '' AS IMEI, -- Поле пустое
    '' AS ICC, -- Поле пустое
    '' AS MIN, -- Поле пустое
    '' AS ESN, -- Поле пустое
    0 AS EQUIPMENT_TYPE, -- Поле пустое
    COALESCE(d.mac, '') AS MAC, -- MAC-адрес пользователя, если он есть
    '' AS VPI, -- Поле пустое
    '' AS VCI, -- Поле пустое
    u.login AS LOGIN, -- Логин пользователя
    '' AS E_MAIL, -- Поле пустое
    '' AS PIN, -- Поле пустое
    '' AS USER_DOMAIN, -- Поле пустое
    '' AS RESERVED, -- Поле пустое
    '' AS ORIGINATOR_NAME, -- Поле пустое
    '' AS IP_TYPE, -- Поле пустое
    h.ip AS IPV4, -- Преобразование IP-адреса из формата INT в строку
    '' AS IPV6, -- Поле пустое
    '' AS IP_MASK_TYPE, -- Поле пустое
    '' AS IPV4_MASK, -- Поле пустое
    '' AS IPV6_MASK, -- Поле пустое
    '' AS IP_RANGE_START, -- Поле пустое
    '' AS IP_RANGE_END, -- Поле пустое
    u.id AS INTERNAL_ID1, -- Используем ID пользователя как INTERNAL_ID1
    u.id AS INTERNAL_ID2, -- Используем ID пользователя как INTERNAL_ID2
    s.datetime_start AS BEGIN_TIME, -- Дата начала контракта
    '2049-12-12 23:59:00' AS END_TIME, -- Статическая дата окончания
    '' AS LINE_OBJECT, -- Поле пустое
    '' AS LINE_CROSS, -- Поле пустое
    '' AS LINE_BLOCK, -- Поле пустое
    '' AS LINE_PAIR, -- Поле пустое
    '' AS LINE_RESERVED, -- Поле пустое
    '' AS LOC_TYPE, -- Поле пустое
    '' AS LOC_LAC, -- Поле пустое
    '' AS LOC_CELL, -- Поле пустое
    '' AS LOC_TA, -- Поле пустое
    '' AS LOC_CELL_WIRELESS, -- Поле пустое
    '' AS LOC_MAC, -- Поле пустое
    '' AS LOC_LATITUDE, -- Поле пустое
    '' AS LOC_LONGITUDE, -- Поле пустое
    '' AS LOC_PROJECTION_TYPE, -- Поле пустое
    '' AS LOC_IP_TYPE, -- Поле пустое
    h.ip AS LOC_IPV4, -- Используем IP пользователя для LOC_IPV4
    '' AS LOC_IPV6, -- Поле пустое
    '' AS LOC_IP_PORT -- Поле пустое
INTO OUTFILE '/var/lib/mysql-files/ABONENT_IDENT_$current_date.txt'
FIELDS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY ''
LINES TERMINATED BY '\n'
FROM 
  hosts h, devices d, services_used s, cms_operators u
WHERE u.id = s.user and s.datetime_stop = '0000-00-00' and s.packet not in (64, 27, 10)  and u.id = h.user and d.id = h.device;
" > /var/lib/mysql-files/query.sql

# Выполнение завроса в базе данных
mysql -u bitfan -p prim_billing < /var/lib/mysql-files/query.sql

# Перенос файлов, подчищаем за собой
mv -f /var/lib/mysql-files/ABONENT_IDENT* /home/user/COPM/files
rm -f /var/lib/mysql-files/query.sql
