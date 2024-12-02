# Получение текущей даты
current_date=$(date +%Y%m%d_%H%M)

# Формирование MySQL-запроса с выводом в файл

echo "
SELECT 
    'PAYMENT_TYPE',
    'PAY_TYPE_ID',
    'PAYMENT_DATE',
    'AMOUNT',
    'AMOUNT_CURRENCY',
    'PHONE_NUMBER',
    'ACCOUNT',
    'INTERNAL_ID1',
    'INTERNAL_ID2',
    'BANK_ACCOUNT',
    'BANK_NAME',
    'EXPRESS_CARD_NUMBER',
    'TERMINAL_ID',
    'TERMINAL_NUMBER',
    'LATITUDE',
    'LONGITUDE',
    'PROJECTION_TYPE',
    'CENTER_ID',
    'DONATED_PHONE_NUMBER',
    'DONATED_ACCOUNT',
    'DONATED_INTERNAL_ID1',
    'DONATED_INTERNAL_ID2',
    'CARD_NUMBER',
    'PAY_PARAMS',
    'PERSON_RECIEVED',
    'BANK_DIVISION_NAME',
    'BANK_CARD_ID',
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
    83 AS PAYMENT_TYPE,  -- Задано статически
    mt.id AS PAY_TYPE_ID,
    m.datetime AS PAYMENT_DATE,
    m.summa AS AMOUNT,
    '' AS AMOUNT_CURRENCY,  -- Пустое поле
    '' AS PHONE_NUMBER,  -- Информация о номере телефона отсутствует в этой таблице
    m.user AS ACCOUNT,  -- Пример форматирования номера счета
    '' AS INTERNAL_ID1,
    '' AS INTERNAL_ID2,
    '' AS BANK_ACCOUNT,  -- Пустое поле
    '' AS BANK_NAME,  -- Пустое поле
    '' AS EXPRESS_CARD_NUMBER,  -- Пустое поле
    '' AS TERMINAL_ID,  -- Пустое поле
    '' AS TERMINAL_NUMBER,  -- Пустое поле
    '' AS LATITUDE,  -- Пустое поле
    '' AS LONGITUDE,  -- Пустое поле
    '' AS PROJECTION_TYPE,  -- Пустое поле
    1 AS CENTER_ID,  -- Пустое поле
    '' AS DONATED_PHONE_NUMBER,  -- Пустое поле
    '' AS DONATED_ACCOUNT,  -- Пустое поле
    '' AS DONATED_INTERNAL_ID1,  -- Пустое поле
    '' AS DONATED_INTERNAL_ID2,  -- Пустое поле
    '' AS CARD_NUMBER,  -- Пустое поле
    '' AS PAY_PARAMS,  -- Пустое поле
    '' AS PERSON_RECIEVED,  -- Пустое поле
    '' AS BANK_DIVISION_NAME,  -- Пустое поле
    '' AS BANK_CARD_ID,  -- Пустое поле
    0 AS ADDRESS_TYPE_ID,  -- Пустое поле
    1 AS ADDRESS_TYPE,  -- Пустое поле
    '' AS ZIP,  -- Пустое поле
    '' AS COUNTRY,  -- Пример статического значения
    '' AS REGION,  -- Пустое поле
    '' AS ZONE,  -- Пустое поле
    '' AS CITY,  -- Пустое поле
    '' AS STREET,  -- Пустое поле
    '' AS BUILDING,  -- Пустое поле
    '' AS BUILD_SECT,  -- Пустое поле
    '' AS APARTMENT,  -- Пустое поле
    'Российская Федерация' AS UNSTRUCT_INFO,  -- Пустое поле
    6 AS REGION_ID  -- Пример статического значения
INTO OUTFILE '/var/lib/mysql-files/PAYMENT_$current_date.txt'
FIELDS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY ''
LINES TERMINATED BY '\n'
FROM 
    money m, money_type mt
WHERE m.type = mt.name AND mt.active = 1 AND m.type = 'Пополнение счета';
" > /var/lib/mysql-files/query.sql

# Выполнение завроса в базе данных
mysql -u bitfan -p prim_billing < /var/lib/mysql-files/query.sql

# Перенос файлов, подчищаем за собой
mv -f /var/lib/mysql-files/PAYMENT* /home/user/COPM/files
rm -f /var/lib/mysql-files/query.sql
