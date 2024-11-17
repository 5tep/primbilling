#!/usr/bin/php
<?php

$db = mysqli_connect("localhost", "bitfan", "***************", "prim_billing");

function convert2Array($array) {

    $content = '';
    foreach ($array as $line) { $content .= $line . PHP_EOL; }
    return $content;
}

$Query = "SELECT id, description, unstruct_info FROM devices WHERE type IN (1, 2, 3, 10, 11, 12)";
$Result = mysqli_query($db, $Query);
while ( $Row = mysqli_fetch_assoc($Result)) {

   extract($Row);
   $Array[] = $id.";".$BEGIN_TIME."2010-06-01 00:00:00;".$END_TIME."2035-01-01 00:00:00;".$description.";".$NETWORK_TYPE."4;".$SWITCH_TYPE."0;".$ADDRESS_TYPE_ID."3;".$ADDRESS_TYPE."1;".$ZIP.";".$COUNTRY.";".$REGION.";".$ZONE.";".$CITY.";".$STREET.";".$BUILDING.";".$BUILD_SECT.";".$APARTMENT.";".$unstruct_info.";".$SWITCH_SIGN.";".$REGION_ID."6".PHP_EOL;
}

file_put_contents('./result/COMMUTATORS_20240919_0001.txt', $Array);

?>
