#!/usr/bin/php
<?php

$db = mysqli_connect("localhost", "bitfan", "ym8tRy286S1T5p[F", "prim_billing");
$Query = "SELECT 
    'ID', 'REGION_ID', 'CONTRACT_DATE', 'CONTRACT', 'ACTUAL_FROM', 'ACTUAL_TO', 'ABONENT_TYPE', 
    'NAME_INFO_TYPE', 'FAMILY_NAME', 'GIVEN_NAME', 'INITIAL_NAME', 'UNSTRUCT_NAME', 'BIRTH_DATE', 
    'IDENT_CARD_TYPE_ID', 'IDENT_CARD_TYPE', 'IDENT_CARD_SERIAL', 'IDENT_CARD_NUMBER', 
    'IDENT_CARD_DESCRIPTION', 'IDENT_CARD_UNSTRUCT', 'BANK', 'BANK_ACCOUNT', 'FULL_NAME', 'INN', 
    'CONTACT', 'PHONE_FAX', 'STATUS', 'ATTACH', 'DETACH', 'NETWORK_TYPE', 'INTERNAL_ID1', 
    'INTERNAL_ID2'
UNION ALL
SELECT DISTINCT
    u.id AS ID,
    6 AS REGION_ID, -- Статическое значение региона
    CONCAT(s.datetime_start, ' 00:00:00') AS CONTRACT_DATE, -- Преобразование UNIX времени в читаемый формат
    u.login AS CONTRACT,
    CONCAT(s.datetime_start, ' 00:00:00') AS ACTUAL_FROM, -- Дата заключения контракта
    '2049-12-31 23:59:59' AS ACTUAL_TO, -- Статическая дата окончания
    CASE 
        WHEN s.packet = 10 THEN 43
        ELSE 42
    END AS ABONENT_TYPE, -- Статическое значение типа абонента
    1 NAME_INFO_TYPE, -- Поле пустое
    '' AS FAMILY_NAME, -- Поле пустое
    '' AS GIVEN_NAME, -- Можно предположить, что FIO содержит полное имя
    '' AS INITIAL_NAME, -- Поле пустое
    u.fio AS UNSTRUCT_NAME, -- Используем FIO как неструктурированное имя
    u.birthday AS BIRTH_DATE, -- Поле Дата рождения
    1 AS IDENT_CARD_TYPE_ID, -- Поле ИД типа документа
    1 AS IDENT_CARD_TYPE, -- Поле Тип документа
    '' AS IDENT_CARD_SERIAL, -- Поле серия паспорта
    '' AS IDENT_CARD_NUMBER, -- Поле номер паспорта
    '' AS IDENT_CARD_DESCRIPTION, -- Поле Кем, когда выдан
    u.passport AS IDENT_CARD_UNSTRUCT, -- Поле пустое
    '' AS BANK, -- Статическое значение банка
    '' AS BANK_ACCOUNT, -- Статическое значение банковского счета
    '' AS FULL_NAME, -- Используем FIO как полное имя
    '' AS INN, -- Поле пустое
    '' AS CONTACT, -- Поле пустое
    '' AS PHONE_FAX, -- Поле пустое
    0 AS STATUS, -- Статическое значение статуса
    CONCAT(s.datetime_start, ' 00:00:00') AS ATTACH, -- Дата последнего изменения
    '2049-12-31 23:59:00' AS DETACH, -- Статическая дата отсоединения
    4 AS NETWORK_TYPE, -- Поле пустое
    u.id AS INTERNAL_ID1, -- Поле пустое
    u.id AS INTERNAL_ID2 -- Поле пустое
FROM 
   services_used s, cms_operators u
WHERE u.id = s.user and s.datetime_stop = '0000-00-00' and s.packet not in (64, 27, 10);";
$Result = mysqli_query($db, $Query);
while ($Row = mysqli_fetch_assoc($Result)) {
    $values = array_values($Row);
    $Array[] = implode(";", $values);
}
file_put_contents('./result/ABONENT_20240926_1622.txt', $Array);
