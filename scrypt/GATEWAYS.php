#!/usr/bin/php
<?php

$db = mysqli_connect("localhost", "bitfan", "***************", "prim_billing");

function convert2Array($array) {

    $content = '';
    foreach ($array as $line) { $content .= $line . PHP_EOL; }
    return $content;
}

$Query = "SELECT id, description, unstruct_info FROM devices WHERE type IN (1, 2, 3, 10, 11, 12) LIMIT 1";
$Result = mysqli_query($db, $Query);
while ( $Row = mysqli_fetch_assoc($Result)) {

   extract($Row);

   $Array[] = $GATE_ID."1;".$BEGIN_TIME."2010-06-01 00:00:00;".$END_TIME."2035-01-01 00:00:00;".$DESCRIPTION."RADIUS-сервер;".$GATE_TYPE."7;".$ADDRESS_TYPE_ID."3;".$ADDRESS_TYPE."1;".$ZIP.";".$COUNTRY.";".$REGION.";".$ZONE.";".$CITY.";".$STREET.";".$BUILDING.";".$BUILD_SECT.";".$APARTMENT.";".$UNSTRUCT_INFO."Российская Федерация, Запорожская область, Приморский муниципальный округ, г. Приморск, ул. Морская д. 66 1б;".$REGION_ID."6".PHP_EOL;
}

file_put_contents('./result/GATEWAYS_20240919_0001.txt', $Array);

?>
