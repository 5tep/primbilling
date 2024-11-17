#!/usr/bin/php
<?php

$db = mysqli_connect("localhost", "bitfan", "***************", "prim_billing");

function convert2Array($array) {

    $content = '';
    foreach ($array as $line) { $content .= $line . PHP_EOL; }
    return $content;
}

$Query = "SELECT c.id, c.fio, ct.name as city_name, s.name as street_name, c.house, c.apartment FROM cms_operators c, streets s, city ct WHERE c.city=ct.id AND c.street = s.id LIMIT 1";
$Result = mysqli_query($db, $Query);
while ( $Row = mysqli_fetch_assoc($Result)) {

   extract($Row);

   $Array[] = $id."6;".$BEGIN_TIME."2022-04-01 00:00:00;".$END_TIME."2035-01-01 00:00:00;".$DESCRIPTION."ИП Шелухина Г.Л.;".$MCC.";".$MNC."".PHP_EOL;
}

file_put_contents('./result/REGIONS_20240919_0001.txt', $Array);

?>
