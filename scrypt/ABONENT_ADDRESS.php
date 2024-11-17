#!/usr/bin/php
<?php

$db = mysqli_connect("localhost", "bitfan", "***************", "prim_billing");
function convert2Array($array) {
    $content = '';
    foreach ($array as $line) { $content .= $line . PHP_EOL; }
    return $content;
}

function get_first_start ( $db, $user ) {
        $result = null;
        $Row = mysqli_fetch_array(mysqli_query($db, "SELECT datetime_start FROM services_used WHERE user = $user ORDER BY id DESC LIMIT 1"));
        if( isset($Row['datetime_start']))  {
            $result = $Row['datetime_start'];
        }
        return $result;
}

$Query = "SELECT c.id, c.fio, c.propiska, ct.name as city_name, s.name as street_name, c.house, c.apartment FROM cms_operators c, streets s, city ct WHERE c.city=ct.id AND c.street = s.id";
$Result = mysqli_query($db, $Query);
while ( $Row = mysqli_fetch_assoc($Result)) {

    extract($Row);

    $first_start = get_first_start ($db, $id);

    $Array[] = $id.";".$REGION_ID."6;".$ADDRESS_TYPE_ID."0;".$ADDRESS_TYPE."1;".$ZIP.";".$COUNTRY."Российская Федерация;".$REGION."Запорожская область;".$ZONE."Приморский муниципальный округ;".$CITY.";".$STREET.";".$BUILDING.";".$BUILD_SECT.";".$APARTMENT.";".$propiska.";".$first_start." 00:00:00;".$END_TIME."2035-01-01 00:00:00;".$INTERNAL_ID1.";".$INTERNAL_ID2."".PHP_EOL;
    $Array[] = $id.";".$REGION_ID."6;".$ADDRESS_TYPE_ID."3;".$ADDRESS_TYPE."0;".$ZIP.";".$COUNTRY."Российская Федерация;".$REGION."Запорожская область;".$ZONE."Приморский муниципальный округ;".$city_name.";".$street_name.";".$house.";".$BUILD_SECT.";".$apartment.";".$UNSTRUCT_INFO.";".$first_start." 00:00:00;".$END_TIME."2035-01-01 00:00:00;".$INTERNAL_ID1.";".$INTERNAL_ID2."".PHP_EOL;
}

file_put_contents('./result/ABONENT_ADDRESS_20240926_1622.txt', $Array);

?>
